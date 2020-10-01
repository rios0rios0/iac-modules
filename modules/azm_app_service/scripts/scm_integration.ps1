Param (
    [Parameter(Mandatory = $true)]
    [string]$resourceGroupName,
    [String]$appServiceName,
    [string]$repository,
    [string]$branch
)

az login --service-principal -u $env:ARM_CLIENT_NAME -p $env:ARM_CLIENT_SECRET --tenant $env:ARM_TENANT_ID
$adTokenRegistry = (az account get-access-token | ConvertFrom-Json)
$accessToken = $adTokenRegistry.accessToken
Login-AzAccount -AccessToken $accessToken -tenantid $env:ARM_TENANT_ID -accountid $env:ARM_SUBSCRIPTION_ID

az webapp deployment source show --resource-group $resourceGroupName --name $appServiceName

$PropertiesObject = @{
    repoUrl = "$repository";
    branch = "$branch";
}
Set-AzResource -PropertyObject $PropertiesObject -ResourceGroupName $resourceGroupName `
-ResourceType Microsoft.Web/sites/sourcecontrols -ResourceName $appServiceName/web `
-ApiVersion 2015-08-01 -Force
