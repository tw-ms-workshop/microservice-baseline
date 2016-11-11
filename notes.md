# AirPlus Microservices Workshop

## TODO
* Write installation instructions
* dry run on windows VM
* Have everyone register their own GitHub account
* use AMI with java 8
* create snap ci AWS user
* let snap do an update-stack and s3 upload (install aws client)
* excercise elements in templates/scripts

## Background
* snowflake stack: VPC with EC2 instance and manual deployment
* phoenix stack: VPC with auto scaling and launch configuration and S3 deployment

## Preparation
* Get list of names
* Create AWS Users for each participant
* Generate key-pair for snap
* Set up policies for cloudformation operations
* Log in via: https://777112267569.signin.aws.amazon.com/console
* Configure AWS CLI client with proper AWS credentials

## Technical Excercise

### Project setup
1. Make sure everyone has a GitHub account
2. Let *one* person of each team fork the hello world application starter: https://github.com/tw-ms-workshop/microservice-baseline
3. Add teammates to the repository: repository settings -> collaborators
4. Everyone clone the repo, make it run with idea: `./gradlew idea`
4. open the application in idea and take a look around
5. start the application server:
  * idea: run the main method
  * gradle: `./gradlew bootRun`

### Setup a deployment pipeline
1. Go to snap-ci.com
2. Log in using your github account
3. add your forked repo
4. define the first stage: give it a name and let it `gradle build` the project
5. define second stage using deploy.sh

# Build a "Hello World" endpoint

## Create AWS infrastructure
1. define set of policies required for AWS stuff
1. install aws cli client
1. configure aws client
1. provide cloudformation template
1. Run CloudFormation to create the initial AWS infrastructure

## Automate deployments

````
aws cloudformation update-stack --stack-name mystack --template-body file:///Users/hvocke/dev/airplus/aws-provisioning/VPC_Single_Instance_In_Subnet.template --parameters ParameterKey=KeyName,ParameterValue=snap-ci

````


Cloud formation policy
````
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1478857799000",
            "Effect": "Allow",
            "Action": [
                "cloudformation:*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
````
