$ErrorActionPreference='Stop'
$ProgressPreference = "SilentlyContinue";

function SetAclOnServerDirectory($dir) {
    $acl = Get-Acl $dir
    $permissions = "LocalService", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"
    $rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permissions
    $acl.SetAccessRuleProtection($False, $False)
    $acl.AddAccessRule($rule)
    Set-Acl -Path $dir -AclObject $acl
}

$rvn = "rvn.exe";
$serverDir = "C:\RavenDB\Server"

SetAclOnServerDirectory $serverDir
$name = 'RavenDB'

Push-Location $serverDir;

Try
{
    Write-Host "Starting RavenDB Service"
    Invoke-Expression -Command ".\$rvn windows-service register --service-name $name";
    Start-Service -Name $name

    Start-Sleep -s 1

    # TODO: We need to create the database "World" 

    # TODO: We need to create the database "Fortune"
    
    # TODO: Import using the http://localhost:8080/databases/{database}/smuggler/import-dir?dir={directory} both databases.    

    Write-Host "Stopping RavenDB Service"
    Stop-Service -Name $name    
}
catch
{
    write-error $_.Exception
    exit 4
}

Invoke-Expression "./Raven.Server.exe"
