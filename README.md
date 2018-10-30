<a href="https://drone.fpfis.eu/ec-europa/cloud9">
  <img src="https://drone.fpfis.eu/api/badges/ec-europa/cloud9/status.svg?branch=lambda/cloud9UnusedEC2" alt="build status">
</a>

# AWS Cloud9

Lambda scripts to manage cloud9 instances

## Instructions:


Python scripts 2.7 with dependances.

lambda_function.py: Check EC2 instances which are stopped since more than 60 days and send Slack message.


## Cloud9

Cloud9 can be used to develop and upload Lambda functions : https://docs.aws.amazon.com/cloud9/latest/user-guide/lambda-functions.html


## Manual Deployement 

Create zip package:

```
pip2.7 install -r requirements.txt -t build
cp lambda_function.py ./build/
cd build
zip -r my_app.zip .
```

Upload zip to lambda function:
```
aws lambda update-function-code --function-name "MyLambdaFunctionName" --zip-file fileb://my_app.zip
```
