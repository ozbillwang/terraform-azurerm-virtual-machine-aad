Write-Host "### Disable Network Level Authentication (NLA)  ### "

# Import the Group Policy module
# Import-Module GroupPolicy

# Download Group Policy Settings Reference for Windows and Windows Server
# https://www.microsoft.com/en-us/download/confirmation.aspx?id=25250
# https://download.microsoft.com/download/8/F/B/8FBD2E85-8852-45EC-8465-92756EBD9365/Windows10andWindowsServer2016PolicySettings.xlsx
#
# HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services!SecurityLayer
# HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services!UserAuthentication

# Group Policy File Editor
# https://github.com/dlwyatt/PolicyFileEditor

# Function to configure policies on Terminal Server
function Configure-TerminalServerPolicies {

    $UserDir = "$env:windir\system32\GroupPolicy\Machine\registry.pol"
    # Navigate to the specified path in the registry
    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"

    # Enable specific security layer for RDP connections
    $RegPath = 'Software\Policies\Microsoft\Windows NT\Terminal Services'
    $RegName = 'SecurityLayer'
    $RegData = '0'
    $RegType = 'DWORD'
    Set-PolicyFileEntry -Path $UserDir -Key $RegPath -ValueName $RegName -Data $RegData -Type $RegType

    # Disable Network Level Authentication (NLA)
    $RegPath = 'Software\Policies\Microsoft\Windows NT\Terminal Services'
    $RegName = 'UserAuthentication'
    $RegData = '0'
    $RegType = 'DWORD'
    Set-PolicyFileEntry -Path $UserDir -Key $RegPath -ValueName $RegName -Data $RegData -Type $RegType
}

Install-Module -Name PolicyFileEditor -Force

# Configure policies on Terminal Server
Configure-TerminalServerPolicies

# Force update Group Policies
gpupdate /force

Write-Host "Check the values, both should be 0"

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"

Get-ItemProperty -Path $registryPath  -Name "securitylayer"

Get-ItemProperty -Path $registryPath  -Name "UserAuthentication"

Write-Host "### Disable Network Level Authentication (NLA)  - Done ### "
