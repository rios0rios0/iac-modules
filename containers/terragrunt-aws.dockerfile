FROM hashicorp/terraform:0.12.18
LABEL name=terragrunt-aws maintainer="rios0rios0 <rios0rios0@outlook.com>" description="Terraform + Terragrunt with AWS CLI"

RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.25.2/terragrunt_linux_amd64 && \
    chmod u+x terragrunt_linux_amd64 && mv terragrunt_linux_amd64 /usr/local/bin/terragrunt

RUN apk add git py-pip && pip install awscli

COPY entrypoint.sh /
ENTRYPOINT ["./entrypoint.sh"]
