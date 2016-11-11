# Microservices Workshop

## TODO
* Have everyone register their own GitHub account
* use AMI with java 8
* excercise elements in templates/scripts
* add s3 download to stack.json

## Background
* snowflake stack: VPC with EC2 instance and manual deployment
* phoenix stack: VPC with auto scaling and launch configuration and S3 deployment

## Preparation
* Get list of names
* Create AWS Users for each participant
* Generate key-pair for snap
* Set up policies for cloudformation operations
  * cloudformation
  * AmazonVPCFullAccess
  * AmazonEC2FullAccess
  * AmazonS3FullAccess
* Log in via: https://777112267569.signin.aws.amazon.com/console
* Configure AWS CLI client with proper AWS credentials
* set up s3 buckets?

## Technical Excercise

### Project setup
1. Make sure everyone has a GitHub account
2. Let *one* person of each team fork the hello world application starter: https://github.com/tw-ms-workshop/microservice-baseline
3. Add teammates to the repository: repository settings -> collaborators
4. Everyone clone the repo, make it run with idea: `./gradlew idea`
4. open the application in idea and take a look around
5. give the service a dedicated team name ?
5. start the application server:
  * idea: run the main method
  * gradle: `./gradlew bootRun`

### Create AWS infrastructure
  1. define set of policies required for AWS stuff
  1. install aws cli client
  1. configure aws client
  1. provide cloudformation template
  1. Run CloudFormation to create the initial AWS infrastructure (`aws cloudformation create-stack`)

### Setup a deployment pipeline
1. Go to snap-ci.com
2. Log in using your github account
3. add your forked repo
4. define the first stage: give it a name and let it `gradle build` the project
5. define second stage using deploy.sh
  * enter IP address from AWS dashboard

### Build a "Hello World" endpoint
* Create a new Controller that prints "Hello World"
* Deploy
* Look at pipeline and check live result

### Use rolling updates
1. Go to snap-ci.com
2. Re-define deploy stage
  * use s3 upload archetype

````
aws s3 cp build/libs/*.jar s3://ms-workshop-testbucket/snap/deployments --acl private --region eu-central-1
````

**Environment Variables**:
`AWS_ACCESS_KEY`
`AWS_SECRET_ACCESS_KEY`

**Secure Files**: snap pem file

## Automate deployments

**Creating a stack**
````
aws cloudformation create-stack --stack-name mystack --region eu-central-1 --template-body file://./deploy/snowflake-stack.json --parameters ParameterKey=KeyName,ParameterValue=snap
````

**Updating a stack**
````
aws cloudformation update-stack --stack-name mystack --region eu-central-1 --template-body file://./deploy/snowflake-stack.json --parameters ParameterKey=KeyName,ParameterValue=snap
````

**Listing all stacks**
````
aws cloudformation describe-stacks
````

**Deleting a stack**
````
aws cloudformation delete-stack --stack-name [stackName]
````

**Cloud formation policy**
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

## Snap CI Configuration

### Build and test
````
./gradlew build
````
* **Artifacts**: `build/`

### Deploy (simple)
````
eval `ssh-agent`
ssh-add /var/snap-ci/repo/snap-ci.pem
sh deploy/deploy.sh
````

* **Secure files**: AWS pem file (*make sure that this has the same name as the ssh-add command*)
* **Environment Variables**: `SERVER_IP`: [IP Address of AWS Server]

### Deploy (aws)
````
aws s3 cp build/libs/*.jar s3://ms-workshop-testbucket/snap/deployments --acl private --region eu-central-1
aws cloudformation update-stack --stack-name mystack --region eu-central-1 --template-body file://./deploy/phoenix-stack.json --parameters ParameterKey=KeyName,ParameterValue=snap ParameterKey=Version,ParameterValue=$SNAP_PIPELINE_COUNTER
````

Make sure to include version parameter and new stack file.

**Environment Variables**: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
**Secure Files**: snap.pem file
