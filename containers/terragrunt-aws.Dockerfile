FROM hashicorp/terraform:1.6.3
LABEL name=terragrunt-aws maintainer="rios0rios0 <rios0rios0@outlook.com>" description="Terraform + Terragrunt with AWS CLI"

ENV TERRAGRUNT_VER 0.53.2
ADD "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VER}/terragrunt_linux_amd64" /bin/terragrunt
RUN chmod u+x /bin/terragrunt

RUN apk add git py-pip \
    && apk cache clean \
    && rm -rf /var/cache/apk/*

RUN pip install awscli

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
