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

    # Starting the service
    Start-Service -Name $name

    $serviceInstance = Get-Service -Name $name
    
    # We are waiting to ensure that the service is up.
    $tries = 0
    while ($serviceInstance.Status -ne 'Running')
    {
        if ($tries > 10)
        {
            Write-Error "Service couldn't start in 20 seconds."
            exit 5
        }
        Start-Sleep -seconds 2  
        $tries = $tries + 1
    }    

    # TODO: We need to create the database "World" 

    # TODO: We need to create the database "Fortune"
    
    # TODO: Import using the http://localhost:8080/databases/{database}/smuggler/import-dir?dir={directory} both databases.    


    # We will wait forever or the service goes down, whatever happens first :D
    while ($serviceInstance.Status -eq 'Running')
    {
        Write-Host 'Service is running.'
        Start-Sleep -seconds 10    
        $serviceInstance.Refresh()
    }
}
catch
{
    write-error $_.Exception
    exit 4
}
