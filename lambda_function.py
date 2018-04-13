import boto3
ec2 = boto3.resource('ec2')
import logging
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
  logger.info("Stopping EC2 instance of Cloud9...")
  totalStopped = 0
  totalSkipped = 0
  totalFailed = 0
  
  filters = [{
      'Name': 'tag:Name',
      'Values': ['aws-cloud9*']
    },
    {
        'Name': 'instance-state-name', 
        'Values': ['running']
    }
  ]
  #Get instances
  instances = ec2.instances.filter(Filters=filters)
 
  for instance in instances:
    tagNeverStop = ['lambda:neverstop', 'lambda:Never Stop']
    lambdaNeverStop = [tag['Value'] for tag in instance.tags if tag['Key'].lower() in tagNeverStop ]
    if lambdaNeverStop:
      totalSkipped += 1;
    else :
      result = stopEC2Instance(instance)
      if result:
        totalStopped += 1;
      else:
        totalFailed += 1;
    
  logger.info("EC2 instance of Cloud9 stopped. totalStopped: {0}. totalFailed: {1}. totalSkipped: {2}.".format(totalStopped, totalFailed, totalSkipped))

  return 'Done'


def stopEC2Instance(instance):
  #0  : pending       #16 : running   #32 : shutting-down
  #48 : terminated    #64 : stopping  #80 : stopped
  if instance.state.get('Code') == 16:
    logger.debug("Instance {0} waiting to be stopped state...".format(instance.id) )
    instance.stop()
    instance.wait_until_stopped()
    logger.debug("Instance {0} stopped: {1}".format(instance.id,instance.state['Name']))
    return True
    
  return False
