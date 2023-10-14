# export KOPS_STATE_STORE=where2go-kops-state
# export KOPS_OIDC_STORE=where2go-kops-oidc
# export KOPS_CLUSTER_NAME=where2go.k8s.local
# export AWS_REGION=ap-northeast-2

export AWS_REGION=$1
export KOPS_CLUSTER_NAME=$2
export KOPS_STATE_STORE=$3
export KOPS_OIDC_STORE=$4

# create state store bucket
aws s3api create-bucket \
    --bucket $KOPS_STATE_STORE \
    --region $AWS_REGION \
    --create-bucket-configuration LocationConstraint=$AWS_REGION \
    --no-cli-pager

aws s3api put-bucket-versioning \
  --bucket $KOPS_STATE_STORE \
  --versioning-configuration Status=Enabled


# create OIDC store bucket for IRSA
aws s3api create-bucket \
    --bucket $KOPS_OIDC_STORE \
    --region $AWS_REGION \
    --create-bucket-configuration LocationConstraint=$AWS_REGION \
    --object-ownership BucketOwnerPreferred \
    --no-cli-pager


aws s3api put-public-access-block \
    --bucket $KOPS_OIDC_STORE \
    --public-access-block-configuration BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false
aws s3api put-bucket-acl \
    --bucket $KOPS_OIDC_STORE \
    --acl public-read