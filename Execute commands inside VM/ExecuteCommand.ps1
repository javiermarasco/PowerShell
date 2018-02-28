
$SubscriptionName = ""
$ResourceGroup = "" #Where the machine is located
$VMName = "" 
$ExtensionName = "" #The name we want to show in the portal
$StorageAccountName = "" #Where we will upload the script to execute in the VM
$Container = "" # Name of the container in the storage account
$PathToFile = ""  # Path in our machine to the file we want to execute
$FileToExecute = "Command.ps1" # Name of the file to execute
$SASToken = "" # SAS Token for the storage account with permission to upload blobs in the container
Select-AzureRmSubscription -subscriptionName $SubscriptionName
$storageContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -SasToken $SASToken
Set-AzureStorageBlobContent -File $($PathToFile +"\" + $FileToExecute) -Blob $FileToExecute -Container $Container -Context $storageContext -Force
$VM = Get-AzureRmVM -ResourceGroupName $ResourceGroup -Name $VMName
Set-AzureRmVMCustomScriptExtension -ResourceGroupName $ResourceGroup -VMName $VMName -Name $ExtensionName -ContainerName $Container -FileName $FileToExecute -StorageAccountName $StorageAccountName -Location $VM.Location 
start-sleep -Seconds 15 #Delay added to grant the extension fully executes inside the VM, if the command is time demanding, consider adjusting this delay
$output = Get-AzureRmVMDiagnosticsExtension -ResourceGroupName $ResourceGroup -VMName $VMName -Name $ExtensionName -Status
write-output $($Output.SubStatuses | where-object -property Code -like "*StdOut*").Message
Remove-AzureRmVMCustomScriptExtension -ResourceGroupName $ResourceGroup -VMName $VMName -Name $ExtensionName -Force