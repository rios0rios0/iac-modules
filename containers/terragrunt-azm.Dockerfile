FROM mcr.microsoft.com/azurestack/powershell:ubuntu-18.04
LABEL name=terragrunt-azm maintainer="rios0rios0 <rios0rios0@outlook.com>" description="Terraform + Terragrunt with Azure CLI"

RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf && \
    echo "nameserver 1.1.1.1" >> /etc/resolv.conf

RUN curl -L "https://aka.ms/InstallAzureCLIDeb" | bash

RUN apt-get update && apt-get install --yes --no-install-recommends git unzip \
    && apt-get clean autoclean && apt-get autoremove --yes \
    && bash -c 'rm -rf /var/lib/apt/lists/* && rm -rf /var/lib/{apt,dpkg,cache,log}'

ENV TERRAFORM_VER 1.6.3
ADD "https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip" /tmp/terra.zip
RUN unzip /tmp/terra.zip -d /bin && chmod u+x /bin/terraform

ENV TERRAGRUNT_VER 0.53.2
ADD "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VER}/terragrunt_linux_amd64" /bin/terragrunt
RUN chmod u+x /bin/terragrunt

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
