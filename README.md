# Vpc CloudFormation Template
*CloudFormation template to create a VPC*

## Resources Created
This template creates the following resources:

- VPC, plus:
    - Internet Gateway (and respective association to this VPC and default route)
    - Route Table for Internet Gateway (and respective association to the public subnets)

- Public Subnet in AZ A, plus:
    - Elastic IP A
    - NAT Gateway A (and respective association to subnet A)
    - Route Table for NAT Gateway A (and route)

- Public Subnet in AZ B, plus:
    - Elastic IP B
    - NAT Gateway B (and respective association to subnet B)
    - Route Table for NAT Gateway B
    - Route for NAT Gateway B

- Private Subnet A, plus:
    - Route table association to NAT Gateway A

- Private Subnet B, plus:
    - Route table association to NAT Gateway B

- VPC Flow Log:
    - Flow log itself (and respective IAM Role/Policy)
    - S3 Bucket (and respective policy)

**Notes:**  
1) Security groups are not in scope of this template, but your VPC will have one created anyway, by default - and quite permissive.  
2) The S3 bucket will be protected against deletion when you tear down the stack. Beware of that if you need to recreate the stack - if the bucket is still up, your deployment will fail.

## How to deploy

You can either:
- Update the file `deploy-vpc.sh` with your stack info and run it, or 

- Run the following command with your relevant data: 

```bash
export STACK_NAME="<name must be lower case>"
export OWNER="<team responsible for this stack>"
export COMPLIANCE="<true || false>"
export AWS_DEFAULT_REGION="<region>"

export VPC_CIDR="<VPC CIDR>"
export PUB_SUBNET_A_CIDR="<public subnet A>"
export PUB_SUBNET_B_CIDR="<public subnet B>"
export PUB_SUBNET_A_CIDR="<private subnet A>"
export PUB_SUBNET_B_CIDR="<private subnet B>"
./deploy-vpc-abstracted.sh
```
