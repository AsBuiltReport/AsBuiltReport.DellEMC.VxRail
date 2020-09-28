function Get-VxRailApi {

    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String] $Uri
    )

    Begin {
    #region Workaround for SelfSigned Cert an force TLS 1.2
    if (-not ([System.Management.Automation.PSTypeName]'ServerCertificateValidationCallback').Type) {
        $certCallback = @"
        using System;
        using System.Net;
        using System.Net.Security;
        using System.Security.Cryptography.X509Certificates;
        public class ServerCertificateValidationCallback
        {
            public static void Ignore()
            {
                if(ServicePointManager.ServerCertificateValidationCallback ==null)
                {
                    ServicePointManager.ServerCertificateValidationCallback += 
                        delegate
                        (
                            Object obj, 
                            X509Certificate certificate, 
                            X509Chain chain, 
                            SslPolicyErrors errors
                        )
                        {
                            return true;
                        };
                }
            }
        }
"@
        Add-Type $certCallback
    }
    [ServerCertificateValidationCallback]::Ignore()
    [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
    #endregion Workaround for SelfSigned Cert an force TLS 1.2
    
        $username = $Credential.UserName
        $password = $Credential.GetNetworkCredential().Password
        $auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($username + ":" + $password ))
        $api = "https://" + $($VxRailMgr.Name) + "/rest/vxm/v1"
        $headers = @{
            'Accept'        = 'application/json'
            'Authorization' = "Basic $auth" 
            'Content-Type'  = 'application/json'
        }
    }

    Process {
        Try {
            Invoke-RestMethod -Method Get -Uri ($api + $uri) -Headers $headers
        } Catch {
            Write-Verbose -Message "Error with API reference call to $(($URI).TrimStart('/'))"
            Write-Verbose -Message $_
        }
    }

    End {}
}