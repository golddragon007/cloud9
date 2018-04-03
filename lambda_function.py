import paramiko
import os.path
import boto3
import logging
import botocore
from botocore.exceptions import ClientError

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

ec2Ress = boto3.resource('ec2')
ec2 = boto3.client('ec2')

def lambda_handler(event, context):
  
  EBS_SIZE = 20
  DRYRUN = False
  
  totalDone = 0
  totalError = 0
  totalSkipped = 0
  totalFSDone = 0
  totalFSError = 0
  
  volumes = {}
  for response in ec2.get_paginator('describe_volumes').paginate():
    volumes.update([(volume['VolumeId'], volume) for volume in response['Volumes']])

  for volume in volumes.values():
    curTags = boto3_tag_list_to_ansible_dict(volume.get('Tags', []))
    curSize = volume.get('Size')
    name = curTags.get('Name', volume.get('VolumeId'))
    
    sizeFixed = curTags.get('Size Fixed', curTags.get('SizeFixed', False))
    
    if "aws-cloud9" in name and "UNUSED aws-cloud9" not in name:
    #if "b5b64f4ad6b5747b1eb02d4ee" in name:
      if sizeFixed != False:
        # Size fixed manually, skipped
        logger.info("Volume {0} skipped: size fixed manually: {1}Go".format(name, curSize) )
        totalSkipped += 1;
      else:
        if curSize >= EBS_SIZE:
        # Size Ok, skip
          logger.info("Volume {0} skipped: size OK: {1}Go".format(name, curSize) )
          totalSkipped += 1
        else:
        # Edit Volume
          response = False
          try:
            response = ec2.modify_volume(
                DryRun=DRYRUN,
                VolumeId=volume.get('VolumeId'),
                Size=EBS_SIZE
            )
          except ClientError as e:
            logger.debug(e)
            #An error occurred (VolumeModificationRateExceeded) when calling the ModifyVolume operation: You've reached the maximum modification rate per volume limit. Wait at least 6 hours between modifications per EBS volume.
            logger.error("Volume {0} failed: Target {1}Go, Current Size: {1}. ClientError Exception: {1}".format(name, e))
            totalError += 1
            continue
  
          if response['ResponseMetadata']['HTTPStatusCode'] == 200:
            logger.info("Volume {0} updated: size changed from {1}Go to {2}Go".format(name, curSize, EBS_SIZE))
            totalDone += 1
            # Filesystem is now automatically increased after Cloud9 EC2 reboot...
            #result = increaseEC2FS(volume)
            #if (result == 0):
            #  logger.info("Volume {0} filesystem of EC2 Instance updated".format(name) )
            #  totalFSDone += 1
            #else:
            #  logger.error("Volume {0} filesystem of EC2 Instance failed".format(name) )
            #  totalFSError += 1
          else:
            logger.error("Volume {0} failed: Target {1}Go, Current Size: {2}. Responde: {3}".format(name, EBS_SIZE,curSize, response))
  
  logger.info("Volume resizing Finished. totalVolumeDone: {0}. totalVolumeError: {1}. totalVolumeSkipped: {2},totalFSDone: {3},totalFSError: {4}".format(totalDone, totalError, totalSkipped,totalFSDone,totalFSError) )

# Increase file system of EC2 instance attached to the volume
def increaseEC2FS(volume):
  iStarted=False
  oldState=False
  curTags = boto3_tag_list_to_ansible_dict(volume.get('Tags', []))
  vname=curTags.get('Name', volume.get('VolumeId'))
  attachments = volume.get('Attachments')
  if (len(attachments) > 1):
    logger.info("Volume {0} extend filesystem skipped: more than 1 EC2 instance attached".format(vname))
    return 1
  else:
      instance = ec2Ress.Instance(attachments[0].get('InstanceId'))
      logger.debug("Volume {0} extend filesystem of instance {1}...".format(vname,instance.id))
      #0  : pending       #16 : running   #32 : shutting-down
      #48 : terminated    #64 : stopping  #80 : stopped
      if instance.state.get('Code') == 80:
          iStarted=True
          logger.debug("Instance {0} waiting to be running state...".format(instance.id) )
          instance.start()
          instance.wait_until_running()
          logger.debug("Instance {0} started: {1}".format(instance.id,instance.state['Name']))
         
      # Instance running, SSH connection and extend FS
      if instance.state.get('Code') == 16:
        # Run commands to extend FS
        result = SSHExtendFSCommands(instance.private_ip_address)

        # Stop instance if started by script
        if (iStarted):
          logger.debug("Instance {0} waiting to be stopped state...".format(instance.id) )
          instance.stop()
          instance.wait_until_stopped()
          logger.debug("Instance {0} stopped: {1}".format(instance.id,instance.state['Name']))
        return result
      else:
        logger.debug("Instance {0} not running: {1}".format(instance.id,instance.state['Name']))
        return 1      

# SSH connexion to host and run command to extend filesystem
def SSHExtendFSCommands(host):
  SSH_KEY='/tmp/Cloud9Lambda.pem'
  if (os.path.exists(SSH_KEY) == False):
    BUCKET_NAME = 'lambdasshtest' # replace with your bucket name
    BUCKET_KEY = 'certs/key.pem' # replace with your object key
    s3 = boto3.resource('s3')
    try:
      s3.Bucket(BUCKET_NAME).download_file(BUCKET_KEY, SSH_KEY)
    except botocore.exceptions.ClientError as e:
      logger.warning("Private SSH key '{0}' cannot be downoad from bucket '{1}': {2}".format(BUCKET_KEY,BUCKET_NAME,e.response['Error']['Code'] ))
      return 1

  key = paramiko.RSAKey.from_private_key_file(SSH_KEY)
  client = paramiko.SSHClient()
  client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
  
  try:
    logger.debug("Connecting to ec2-user@{0}".format(host))
    client.connect( hostname = host, username = "ec2-user", pkey = key,timeout=10 )
    print "Connected to " + host
  except paramiko.SSHException as e:
    logger.warning("SSH Connection failed to ec2-user@{0}: {1}".format(host,e))
    return 1
    
  commands = [
      "sudo growpart /dev/xvda 1",
      "sudo resize2fs /dev/xvda1"
      "df -h"
     # "aws s3 cp s3://s3-bucket/scripts/HelloWorld.sh /home/ec2-user/HelloWorld.sh",
     # "chmod 700 /home/ec2-user/HelloWorld.sh",
     # "/home/ec2-user/HelloWorld.sh"
      ]
  try:
    for command in commands:
        logger.debug("{0} Executing {1}...".format(host,command))
        stdin , stdout, stderr = client.exec_command(command)
        logger.debug("{0} stdout: {1}".format(host,stdout.read()))
        logger.debug("{0} stderr: {1}".format(host,stderr.read()))
        
        if (stdout.channel.recv_exit_status() != 0):
          logger.warning("COMMAND '{0}' error on host {1}: {2}".format(command,host,stdout.channel.recv_exit_status()))
          return 1
  except Exception as e:
        logger.warning("Operation error: {0}".format(e))
        return 1

  client.close()
  return 0

def boto3_tag_list_to_ansible_dict(tags_list):
  tags_dict = {}
  for tag in tags_list:
    if 'key' in tag and not tag['key'].startswith('aws:'):
      tags_dict[tag['key']] = tag['value']
    elif 'Key' in tag and not tag['Key'].startswith('aws:'):
      tags_dict[tag['Key']] = tag['Value']
  return tags_dict