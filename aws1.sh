#!/bin/bash
#
# Author: Eric Tang @TYO Lab
#         twitter.com/_e_tang

if [ "x$1" == "x" ]
    then
    echo "A bucket name must be provided".
    echo "Usage: $0 [bucket_name]"
    exit
fi

if [ "x$2" == "x" ]
then 
    command=-1
else
    command=`expr $2 / 1`
fi    

bucket=$1

rm -f /tmp/s3policy.json
cat << EOF >> /tmp/s3policy.json
{
    "Version": "2012-10-17",
    "Id": "Policy1565157422787",
    "Statement": [
        {
            "Sid": "Stmt1565157417996",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::$1/*"
        }
    ]
}
EOF

rm -f /tmp/s3website.json
cat << EOF >> /tmp/s3website.json
{
    "IndexDocument": {
        "Suffix": "index.html"
    },
    "ErrorDocument": {
        "Key": "error.html"
    }
}
EOF

#
#
# Can add routing rules

# ,
#   "RoutingRules": [
#     {
#       "Condition": {
#         "HttpErrorCodeReturnedEquals": "string",
#         "KeyPrefixEquals": "string"
#       },
#       "Redirect": {
#         "HostName": "string",
#         "HttpRedirectCode": "string",
#         "Protocol": "http"|"https",
#         "ReplaceKeyPrefixWith": "string",
#         "ReplaceKeyWith": "string"
#       }
#     }
#   ]
#

rm -f /tmp/s3website-redict.json
cat << EOF >> /tmp/s3website-redict.json
{
  "RedirectAllRequestsTo": {
    "HostName": "www.$bucket",
    "Protocol": "https"
  }
}
EOF

if [ "x$AWS_REGION" == "x" ]
then
    # sydnet: region="ap-southeast-2";
    echo "AWS region needs to be set, use: export AWS_REGION=xxxxxx"
    exit
else
    region=$AWS_REGION
fi

echo $bucket; 
if [ $command -eq 0 ] || [ $command -eq -1 ] || [ $command -eq -2 ]
then
	echo "Creating bucket: $bucket"
aws s3api create-bucket --bucket $bucket --region $AWS_REGION --create-bucket-configuration LocationConstraint=$region
fi

if [ $command -eq 1 ] || [ $command -eq -1 ] || [ $command -eq -2 ]
then
	echo "Making the bucket public readable"
aws s3api put-bucket-acl --bucket $bucket --acl public-read  --region $AWS_REGION
fi

if [ $command -eq 2 ] || [ $command -eq -1 ] || [ $command -eq -2 ]
then
	echo "Applying the bucket policy"
aws s3api put-bucket-policy --bucket $bucket --policy file:///tmp/s3policy.json  --region $AWS_REGION
fi

if [ $command -eq 3 ] || [ $command -eq -1 ]
then
#aws s3 website s3://$bucket/  --index-document index.html
	echo "Making the bucket serve static website"
aws s3api put-bucket-website --bucket $bucket  --website-configuration file:///tmp/s3website.json  --region $AWS_REGION
fi

if [ $command -eq 4 ] || [ $command -eq -2 ]
then
	echo "Making the bucket redirect to another bucket"
aws s3api put-bucket-website --bucket $bucket  --website-configuration file:///tmp/s3website-redict.json  --region $AWS_REGION
fi

