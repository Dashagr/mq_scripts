# here is the prerequisits for aws cli
# https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-instances.html

# then

aws configure


# run instances command in AWS CLI
# run means create

#aws ec2 run-instances --image-id ami-****** --count 1 --instance-type ***t2.micro*** --key-name ***MyKeyPair*** --security-group-ids sg-****** --subnet-id subnet-****


# to create a name tag under the cli 

#aws ec2 create-tags --resoutces ***instance-id*** --tags Key=Name, Value=AJVM



# to start an existent instance we should

aws ec2 start-instances --instance-ids 



# to stop instance

aws ec2 stop-instances --instance-ids i-***********

