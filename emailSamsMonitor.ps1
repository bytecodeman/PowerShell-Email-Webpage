param([string]$uri)

# "http://dinnerplanet.dyndns.org/saleslog.asp?ok2continue=true"
# "http://dinnerplanet.dyndns.org/monitor/?ok2continue=true"

# Invoke with
# powershell -ExecutionPolicy Bypass .\emailSamsMonitor.ps1 http://localhost/monitor/?ok2continue=true


function InvokeWebRequest ([string]$url)
{
    try
    {
        $webrequest = [System.Net.WebRequest]::Create($url)
        $response = $webrequest.GetResponse()
        $stream = $response.GetResponseStream()
        $sr = new-object System.IO.StreamReader($stream)
        $content = $sr.ReadToEnd();
        return $content
    }  
    catch { Write-Error $_.Exception.Message }
    finally
    {
        if($sr -ne $null) { $sr.Close(); }
        if($response -ne $null) { $response.Close(); }
    }
}

$htmlBody = InvokeWebRequest($uri)

$EmailTo = "silvestri@stcc.edu"  
$EmailFrom = "samuelstaproom@gmail.com"
$Subject = "Samuel's Sales Data for " + (Get-Date -Format g)
$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$htmlBody)
$SMTPMessage.IsBodyHtml = $True

$SMTPClient = New-Object Net.Mail.SmtpClient("smtp.gmail.com", 587) 
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("samuelstaproom@gmail.com", 'Hello$World'); 
$SMTPClient.Send($SMTPMessage)
