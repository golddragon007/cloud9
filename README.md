<a href="https://drone.fpfis.eu/ec-europa/cloud9">
  <img src="https://drone.fpfis.eu/api/badges/ec-europa/cloud9/status.svg?branch=lambda/StopEC2Cloud9Instances" alt="build status">
</a>

# AWS Cloud9

Lambda scripts to manage cloud9 instances

## Instructions:


Python scripts 2.7 without dependances.

lambda_function.py: Stop all running EC2 instances of Cloud9 Environements.
Stop Instance with pattern: "aws-cloud9*"


## Developement

Script can be developed and tested on AWS Console > Lambda.


## Deployement 

Script can be deployed on AWS Console > Lambda or using AWS CLI:
```
zip -r my_app.zip lambda_function.py
aws lambda update-function-code --function-name "MyLambdaFunctionName" --zip-file fileb://my_app.zip
```

