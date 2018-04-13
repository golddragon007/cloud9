<a href="https://drone.fpfis.eu/ec-europa/cloud9">
  <img src="https://drone.fpfis.eu/api/badges/ec-europa/cloud9/status.svg?branch=lambda/tagEC2InstancesAndVolumes" alt="build status">
</a>

# AWS Cloud9

Lambda scripts to manage cloud9 instances

## Instructions:


Python scripts 2.7 without dependances.

lambda_function.py: tag EC2 Instances and volumes with the name of the cloud9 instance.
Pattern: aws-cloud9-{Cloud9Name}-{Cloud9EnvId}


## Developement

Script can be developed and tested on AWS Console > Lambda.


## Deployement 

Script can be deployed on AWS Console > Lambda or using AWS CLI:
```
zip -r my_app.zip lambda_function.py
aws lambda update-function-code --function-name "MyLambdaFunctionName" --zip-file fileb://my_app.zip
```

