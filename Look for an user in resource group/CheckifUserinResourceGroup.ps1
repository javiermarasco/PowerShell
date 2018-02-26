$RG = "" #Resource Group where to check for the user
$User = "" #Name of the user to look for
$Assignments = Get-AzureRmRoleAssignment -ResourceGroupName  $RG
$MemOut = @()
foreach ($Line in $Assignments) {
    if($Line.ObjectType -eq "Group"){
        Get-AzureRmADGroupMember -GroupObjectId $Line.ObjectId -ErrorAction SilentlyContinue | ForEach-Object {$Element = New-Object -TypeName psobject; $Element | Add-Member -MemberType NoteProperty -Name "User" -Value $_.DisplayName; $Element | Add-Member -MemberType NoteProperty -Name "Role" -Value $Line.RoleDefinitionName;$MemOut += $Element }
    }else{
        Get-AzureRmADUser -ObjectId $Line.ObjectId | ForEach-Object {$Element = New-Object -TypeName psobject; $Element | Add-Member -MemberType NoteProperty -Name "User" -Value $_.DisplayName; $Element | Add-Member -MemberType NoteProperty -Name "Role" -Value $Line.RoleDefinitionName;$MemOut += $Element }
    }
}
$MemOut | where-object -Property User -like "*$User*"
