import boto3
ec2R = boto3.resource('ec2')
ec2 = boto3.client('ec2')
from botocore.exceptions import ClientError

import logging
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

debugMode = False

DRYRUN = False
if (debugMode):
  logger.setLevel(logging.DEBUG)
  DRYRUN = True

EBS_SIZE = 20

def lambda_handler(event, context):
  if (event['detail']['event'] == "createVolume" ):
    if (event['detail']['result'] != "available"):
      logger.error("Volume not ready")
    else:
      ressources = event['resources'][0]
      arn,volumeID = ressources.split(":volume/")
      
      # Get volume from event
      volume = ec2R.Volume(volumeID)
      logger.info("Volume {0} start resize".format(volumeID) )
      
      # Get EC2 attached instance ID 
      if  len(volume.attachments) == 0:
        logger.info("Volume {0} skipped, not attached to an EC2 instance".format(volumeID))
        return False
      else:
        EC2Id=volume.attachments[0]['InstanceId']
        ec2instance = ec2R.Instance(EC2Id)
      
      # Ensure it's volume of cloud9 environment
      isC9=False
      for tags in ec2instance.tags:
        if tags["Key"] == 'aws:cloud9:environment':
          isC9 = True
          break;
          
      if isC9:
        curSize = volume.size
        if curSize >= EBS_SIZE:
        # Size Ok, skip
          logger.info("Volume {0} skipped: size OK: {1}Go".format(volumeID, curSize) )
        else:
        # Edit Volume
          response = False
          try:
            response = ec2.modify_volume(
                DryRun=DRYRUN,
                VolumeId=volumeID,
                Size=EBS_SIZE
            )
          except ClientError as e:
            logger.debug(e)
            #An error occurred (VolumeModificationRateExceeded) when calling the ModifyVolume operation: You've reached the maximum modification rate per volume limit. Wait at least 6 hours between modifications per EBS volume.
            logger.error("Volume {0} failed: ClientError Exception: {1}".format(volumeID, e))
            return False
          if response['ResponseMetadata']['HTTPStatusCode'] == 200:
            logger.info("Volume {0} updated: size changed from {1}Go to {2}Go".format(volumeID, curSize, EBS_SIZE))
            return True
          else:
            logger.error("Volume {0} failed: Target {1}Go, Current Size: {2}. Responde: {3}".format(volumeID, EBS_SIZE,curSize, response))
  return False
