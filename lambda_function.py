def lambda_handler(event, context):
    
    tag_volumes();
    return 'Done'

def tag_volumes():
    import copy
    import logging
    import os
    
    import boto3
    
    logging.basicConfig(level='INFO')
    ec2 = boto3.client('ec2')
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.INFO)
    volumes = {}
    for response in ec2.get_paginator('describe_volumes').paginate():
        volumes.update([(volume['VolumeId'], volume) for volume in response['Volumes']])

    for response in ec2.get_paginator('describe_instances').paginate():
        for reservation in response['Reservations']:
            for instance in reservation['Instances']:
                tags = boto3_tag_list_to_ansible_dict(instance.get('Tags', []))
                for device in instance['BlockDeviceMappings']:
                    volume = volumes[device['Ebs']['VolumeId']]
                    volume['Used'] = True
                    cur_tags = boto3_tag_list_to_ansible_dict(volume.get('Tags', []))
                    new_tags = copy.deepcopy(cur_tags)
                    new_tags.update(tags)
                    if new_tags != cur_tags:
                        logger.info('{0} Tags changed to {1}'.format(volume['VolumeId'], new_tags))
                        ec2.create_tags(Resources=[volume['VolumeId']], Tags=ansible_dict_to_boto3_tag_list(new_tags))
                        

    for volume in volumes.values():
        if 'Used' not in volume:
            cur_tags = boto3_tag_list_to_ansible_dict(volume.get('Tags', []))
            name = cur_tags.get('Name', volume['VolumeId'])
            if not name.startswith('UNUSED'):
                logger.warning('{0} Unused!'.format(volume['VolumeId']))
                cur_tags['Name'] = 'UNUSED ' + name
                ec2.create_tags(Resources=[volume['VolumeId']], Tags=ansible_dict_to_boto3_tag_list(cur_tags))

def boto3_tag_list_to_ansible_dict(tags_list):
    tags_dict = {}
    for tag in tags_list:
        if 'key' in tag and not tag['key'].startswith('aws:'):
            tags_dict[tag['key']] = tag['value']
        elif 'Key' in tag and not tag['Key'].startswith('aws:'):
            tags_dict[tag['Key']] = tag['Value']

    return tags_dict


def ansible_dict_to_boto3_tag_list(tags_dict):
    tags_list = []
    for k, v in tags_dict.items():
        tags_list.append({'Key': k, 'Value': v})

    return tags_list
