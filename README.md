# AWS Cloud9

Lambda scripts to manage cloud9 instances

## Instructions:


Python scripts 2.7 without dependances.

lambda_function.py: tag EC2 volume with the name of the attached instance.


## Developement

Script can be developed and tested on AWS Console > Lambda.


## Deployement 

Script can be deployed on AWS Console > Lambda or using AWS CLI:
```
zip -r my_app.zip lambda_function.py
aws lambda update-function-code --function-name "MyLambdaFunctionName" --zip-file fileb://my_app.zip
```