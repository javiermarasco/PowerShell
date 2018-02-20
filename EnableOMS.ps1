$SubscriptionId = ""
$WorkSpaceName = "your workspace name"
$VMResourceGroup = ""
$VMName = ""


Login-AzureRMAccount
Select-AzureSubscription -SubscriptionId $SubscriptionId
$workspace = (Get-AzureRmOperationalInsightsWorkspace).Where({$_.Name -eq $WorkSpaceName})

if ($workspace.Name -ne $WorkSpaceName)
{
    Write-Error "Unable to find OMS Workspace $WorkSpaceName. Do you need to run Select-AzureRMSubscription?"
}

$workspaceId = $workspace.CustomerId
$workspaceKey = (Get-AzureRmOperationalInsightsWorkspaceSharedKeys -ResourceGroupName $workspace.ResourceGroupName -Name $workspace.Name).PrimarySharedKey

$vm = Get-AzureRmVM -ResourceGroupName $VMResourceGroup -Name $VMName
$location = $vm.Location


if($VMs.StorageProfile.OsDisk.OsType -eq "Linux"){
    Set-AzureRmVMExtension -ResourceGroupName $VMResourceGroup -VMName $VMName -Name 'OmsAgentForLinux' -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionType 'OmsAgentForLinux' -TypeHandlerVersion '1.0' -Location $location -SettingString "{'workspaceId': '$workspaceId'}" -ProtectedSettingString "{'workspaceKey': '$workspaceKey'}"
}else{
    Set-AzureRmVMExtension -ResourceGroupName $VMResourceGroup -VMName $VMName -Name 'MicrosoftMonitoringAgent' -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionType 'MicrosoftMonitoringAgent' -TypeHandlerVersion '1.0' -Location $location -SettingString "{'workspaceId': '$workspaceId'}" -ProtectedSettingString "{'workspaceKey': '$workspaceKey'}"
}