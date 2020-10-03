FROM hashicorp/terraform:0.12.18
LABEL name=terraform-aws maintainer="rios0rios0 <rios0rios0@outlook.com>" description="Terraform with AWS CLI"

RUN apk add python py-pip \
    && pip install awscli
