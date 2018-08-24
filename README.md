<a href="https://drone.fpfis.eu/ec-europa/cloud9">
  <img src="https://drone.fpfis.eu/api/badges/ec-europa/cloud9/status.svg?branch=lambda/resizeEC2Volume" alt="build status">
</a>

# AWS Cloud9

Lambda scripts to manage cloud9 instances

## Instructions:


Python scripts 2.7 without dependances.

lambdaFunction.py: enlarge EC2 volume of Cloud9 environement. Skip resize if 'noEBSresize' present on C9 description.

Script triggered by [CloudWatch Event](./cloudWatch.event)

## Developement

Script can be developed and tested on AWS Console > Lambda.


## Deployement 

Script can be deployed on AWS Console > Lambda or using AWS CLI:
```
zip -r my_app.zip lambda_function.py
aws lambda update-function-code --function-name "MyLambdaFunctionName" --zip-file fileb://my_app.zip
```

Using scripts:
```
# Create package
./lambdaPackageCreate.sh
# Upload package
./lambdaPackageUpload.sh resizeEC2Volume
```
