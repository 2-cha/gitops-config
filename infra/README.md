# Infra Provisioning with kOps

kOps를 이용해, CSP에 k8s 클러스터 구성을 위한 인프라를 프로비저닝합니다.  
AWS를 대상으로 작성된 템플릿이며,  
`values.yaml` 을 수정하여 Region, Instance Type 등을 설정할 수 있습니다.  

# Prerequisites

- kOps 설치
- 적절한 IAM Role 생성
- State / OIDC 설정 저장을 위한 S3 생성


# Usage

## IAM Role 생성
```bash
./create-iam-role.sh
```

## S3 생성
```bash
./create-s3.sh <aws-region> <cluster-name> <state-bucket-name> <oidc-bucket-name>
``` 

## kOps Cluster 생성
```
kops toolbox template --template cluster.tmpl.yaml --values values.yaml --output cluster.yaml --fail-on-missing=false;
kops create -f cluster.yaml;
```
