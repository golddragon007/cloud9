import copy
import os
import boto3
ec2 = boto3.client('ec2')
 
import logging
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

debugMode = False
# Pattern used to rename EC2 Instance
EC2InstanceNamePattern = 'aws-cloud9-{Cloud9Name}-{Cloud9EnvId}'

if (debugMode):
  logger.setLevel(logging.DEBUG)
     
def lambda_handler(event, context):
  tagEC2Volumes(event, context);
  tagEC2Instances(event, context);
  return 'Done'

# Rename EC2 instance of cloud9 environements
def tagEC2Instances(event, context):
  totalDone = 0
  totalSkipped = 0
  
  cloud9 = boto3.client('cloud9')
  logger.info('Start tagEC2Instances...')
  #define the connection
  ec2 = boto3.resource('ec2')
   
  filters = [{
      'Name': 'tag:Name',
      'Values': ['aws-cloud9*']
    },
    {
        'Name': 'instance-state-name', 
        'Values': ['pending','running','shutting-down','stopping','stopped']
    }
  ]
  #Get instances
  instances = ec2.instances.filter(Filters=filters)
   
  for instance in instances:
    EC2_InstanceName = [tag['Value'] for tag in instance.tags if tag['Key'] == 'Name'][0]
    logger.debug("Start renaming for `" + EC2_InstanceName + "`")
    
    EC2_Cloud9EnvId = [tag['Value'] for tag in instance.tags if tag['Key'] == 'aws:cloud9:environment']
    
    if  len(EC2_Cloud9EnvId) > 0:
      EC2_Cloud9 = cloud9.describe_environments(environmentIds=[EC2_Cloud9EnvId[0]])["environments"][0]
      EC2_Cloud9Name = EC2_Cloud9['name']
      newName = EC2InstanceNamePattern.format(Cloud9Name=EC2_Cloud9Name, Cloud9EnvId=EC2_Cloud9EnvId)

      if EC2_InstanceName != newName:
        totalDone += 1;
        instance.create_tags(DryRun=debugMode, Tags=[{'Key': 'Name', 'Value': newName}])
        logger.debug("EC2 instance `" + EC2_InstanceName + "`: renamed to `" + newName + "`")
      else:
        totalSkipped += 1;
        logger.debug("EC2 instance `" + EC2_InstanceName + "`: name OK, renaming skipped" )
    else:
      totalSkipped += 1;
      logger.debug("EC2 instance `" + EC2_InstanceName + "`: not attached to cloud9 environment, renaming skipped" )
  logger.info("End of renameEC2Instances. totalRenameDone: {0}. totalRenameSkipped: {1}".format(totalDone, totalSkipped) )    

  return True
  
# Rename EC2 volume of cloud9 environements
def tagEC2Volumes(event, context):
  totalDone = 0
  totalSkipped = 0
  totalUnused = 0
 
  volumes = {}
  logger.info('Start tagEC2Volumes...')
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
            logger.debug('{0} Tags changed to {1}'.format(volume['VolumeId'], new_tags))
            ec2.create_tags(Resources=[volume['VolumeId']], Tags=ansible_dict_to_boto3_tag_list(new_tags))
            totalDone += 1;
          else:
            totalSkipped += 1;

  for volume in volumes.values():
    if 'Used' not in volume:
      cur_tags = boto3_tag_list_to_ansible_dict(volume.get('Tags', []))
      name = cur_tags.get('Name', volume['VolumeId'])
      if not name.startswith('UNUSED'):
        logger.debug('{0} Unused!'.format(volume['VolumeId']))
        cur_tags['Name'] = 'UNUSED ' + name
        ec2.create_tags(Resources=[volume['VolumeId']], Tags=ansible_dict_to_boto3_tag_list(cur_tags))
        totalUnused += 1;
  
  logger.info("End of tagEC2Volumes. totalRenameDone: {0}. totalRenameSkipped: {1},TotalUnused: {2}".format(totalDone, totalSkipped,totalUnused))
  return True

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
