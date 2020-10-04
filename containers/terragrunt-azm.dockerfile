FROM mcr.microsoft.com/azurestack/powershell:ubuntu-18.04
LABEL name=terragrunt-azm maintainer="rios0rios0 <rios0rios0@outlook.com>" description="Terraform + Terragrunt with Azure CLI"

RUN apt update && apt install -y --no-install-recommends unzip wget git
RUN wget https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip && \
    wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.25.2/terragrunt_linux_amd64 && \
    unzip terraform_0.12.18_linux_amd64.zip && mv terraform /usr/local/bin/ && \
    chmod u+x terragrunt_linux_amd64 && mv terragrunt_linux_amd64 /usr/local/bin/terragrunt

RUN apt install -y --no-install-recommends ca-certificates curl apt-transport-https lsb-release gnupg
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null && \
    AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list
RUN apt update && apt install -y azure-cli

COPY entrypoint.sh /
ENTRYPOINT ["./entrypoint.sh"]
