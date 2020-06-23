$subscription = "05aea7c9-25e9-4b5d-aeb5-fd0713992c6b"
$oid = "ecfc380a-1ab2-463c-bdd3-9550ce8f2bee"
$numbEnv = 3
$numbInNameToStartAt = 1
$environmentName = "bugbashloop"
$deploymentNamePrefix = $environmentName + "deployment"
$resourceGroupName = "powerShellTesting"
$pathToTemplate = "C:\Repos\TsiArmTemplates\WithIoTHub\deploy.json"
$pathToParams = "C:\Repos\TsiArmTemplates\WithIoTHub\params.json"

$tsID = @(
       [pscustomobject]@{name='iothub-connection-device-id';type='string'}
   )

Set-AzContext -SubscriptionId $subscription

For ($i=0; $i -le $numbEnv; $i++) {


$a = Get-Content $pathToParams | ConvertFrom-Json
$a.parameters.environmentTimeSeriesIdProperties.value = $tsID
$a.parameters.iotHubName.value = $environmentName + "hub" + $i
$a.parameters.environmentName.value = $environmentName + $i
$a.parameters.eventSourceName.value = $environmentName + $i + "eventSource"

$a | ConvertTo-Json -depth 32| set-content $pathToParams


New-AzResourceGroupDeployment -Name ($deploymentNamePrefix -join $i) -ResourceGroupName $resourceGroupName -TemplateFile  $pathToTemplate `
  -TemplateParameterFile $pathToParams `
  -AsJob
}





