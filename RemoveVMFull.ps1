
$SubscriptionId = ""
$ResourceGroupName = ""
$VMName = ""
$TenantId = ""

Select-AzureRmSubscription -Subscriptionid $SubscriptionId -TenantId $TenantId
$VM = Get-AzureRmVM -Name $VMName -ResourceGroupName $ResourceGroupName
$NICName = $VM.NetworkProfile.NetworkInterfaces.id.Split('/')[8]
$NICRG = $VM.NetworkProfile.NetworkInterfaces.id.Split('/')[4]
Remove-AzureRmVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName -Force
Remove-AzureRmNetworkInterface -Name $NICName -ResourceGroupName $NICRG -Force
foreach ($disk in $VM.StorageProfile.DataDisks){
    Remove-AzureRmDisk -ResourceGroupName $VM.ResourceGroupName -DiskName $disk.Name -Force
}
Remove-AzureRmDisk -ResourceGroupName $VM.ResourceGroupName -DiskName $VM.StorageProfile.OsDisk.Name -Force
if ($VM.AvailabilitySetReference -ne $null){
    Remove-AzureRmAvailabilitySet -ResourceGroupName $VM.AvailabilitySetReference.Id.split('/')[4] -Name $VM.AvailabilitySetReference.Id.split('/')[8] -Force
}