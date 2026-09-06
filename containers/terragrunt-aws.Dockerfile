FROM hashicorp/terraform:1.16.1
LABEL name=terragrunt-aws maintainer="rios0rios0 <rios0rios0@outlook.com>" description="Terraform + Terragrunt with AWS CLI"

ENV TERRAGRUNT_VER 0.53.2
ADD "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VER}/terragrunt_linux_amd64" /bin/terragrunt
RUN chmod u+x /bin/terragrunt

RUN apk add git py-pip \
    && apk cache clean \
    && rm -rf /var/cache/apk/*

# Hash-verified, exact-version wheels only (see requirements.txt): no sdist setup
# script runs at build time. --break-system-packages is required because the
# Alpine 3.19 base marks its system Python as externally managed (PEP 668).
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir --break-system-packages --only-binary :all: --require-hashes -r /tmp/requirements.txt \
    && rm -f /tmp/requirements.txt

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
