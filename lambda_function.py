import boto3
import requests
import ConfigParser
import os.path

import logging
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
  cloud9 = boto3.client('cloud9')
  cloud9All = {}
  Cloud9ByOwners = {}
  hasNextToken  = True
  nextTokenValue = ''
  while hasNextToken == True:
    result = cloud9.list_environments(nextToken=nextTokenValue)
    if 'nextToken' in result:
      nextTokenValue = result['nextToken']
    else:
      hasNextToken = False
     
    # Get Environements descriptions
    environmentsDescribe = cloud9.describe_environments(environmentIds=result['environmentIds'])

    # Loop on each environement
    for environmentDescribe in environmentsDescribe['environments']:
      ownerArn=environmentDescribe['ownerArn']
      cloud9Id=environmentDescribe['id']
      cloud9All[cloud9Id] = environmentDescribe
      
      # Create list by owner
      if Cloud9ByOwners.get(ownerArn, 0) == 0:
          Cloud9ByOwners[ownerArn]=[]
      Cloud9ByOwners[ownerArn].append(cloud9Id)
  
  # Check for multiple env by User
  message=""
  for Cloud9ByOwner in Cloud9ByOwners: 
      if len(Cloud9ByOwners[Cloud9ByOwner]) > 1:
        import re
        m = re.search(r'arn:aws:iam:.*:user/(.*)', Cloud9ByOwner)
        username=m.group(1)
        env=[]
        for cloud9ID in Cloud9ByOwners[Cloud9ByOwner]: 
          env.append (cloud9All[cloud9ID]["name"])
        
        message += unichr(8226) + " User '%s' have %s environements: %s\n" % (username,len(Cloud9ByOwners[Cloud9ByOwner]),', '.join(env))
        logger.info ("User '{0}' have multiple environments: {1}".format(username,', '.join(env)))
  message = "Only 1 Cloud9 environment is allowed by user. Please clean up your environments:\n" + message
  message += "Environement will be deleted automatically."
  logger.debug ("Message: {0}".format(message))
  logger.info ("Send slack message...")
  result = sendSlackMessage(message)
  
  if result == 200:
    logger.info ("Slack notification sent.")
  else:
    logger.error ("Slack notification error, return code: %d" % (result))
  

def sendSlackMessage (message) :
  CONFIGFILE=  os.path.dirname(__file__) + "/lambda_config.ini"
  if not os.path.isfile(CONFIGFILE):
    logger.error("Config file not fount at '{0}'".format(CONFIGFILE))
    return False
  config = ConfigParser.ConfigParser()
  config.read(CONFIGFILE)
  try:
    SLACK_URL=config.get('slack', 'webhook_URL')
    SLACK_CHANNEL=config.get('slack', 'channel')
    SLACK_USERNAME=config.get('slack', 'username')
    SLACK_ICON = config.get('slack', 'icon_emoji')
    response = { "text" : message, "channel": SLACK_CHANNEL, "username": SLACK_USERNAME, "icon_emoji": SLACK_ICON}
    slack_response = requests.post(SLACK_URL,json=response, headers={'Content-Type': 'application/json'})
    return slack_response.status_code
  except Exception as inst:
    logger.error ("Slack Callout Failed.Message: '%s'" % (inst))
    return 0
        
