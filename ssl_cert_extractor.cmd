@echo off
echo ----------------------------------------------------------------------------------------
echo  Open SSL Based SSL Certificate Extractor For Windows x64 - For HTTPS Domains(Port 443)
echo ----------------------------------------------------------------------------------------
echo. 
echo  1. Please specify the hostname. Eg. google.com
echo  2. You may then specify the format in which the SSL cert. is to be extracted.
echo  	2.1 The default format is CER which is a binary format. The filename will be hostname.cer 
:: CER = DER, CER is the file extension, DER is the x509 binary format
echo  	2.2 But you can specify TXT as well for a readable ASCII file. The filename will be hostname.txt  
:: TXT = PEM, TXT is the file extension, PEM is the x509 binary format
echo  3. Wait for the command to execute. This window will auto-close after the export has finished. 
echo  4. You will find the hostname.cer or hostname.txt file in the same directory as this batch file.
echo.
echo ----------------------------------------------------------------------------------------
::---------------------------------------------------------------
:get_hostname
set /p hostname=Specify the hostname: 
::---------------------------------------------------------------
:: check hostname
if "%hostname%"=="" (
	echo Hostname cannot be empty...
	echo.
	goto get_hostname
)
::---------------------------------------------------------------
:get_format
echo.
set /p format=Specify the export format(Default=CER): 
::---------------------------------------------------------------
::set default format
if "%format%"=="" (
	set "format=DER"
)
if "%format%"=="CER" (
	set "format=DER"
)
if "%format%"=="TXT" (
	set "format=PEM"
)
::---------------------------------------------------------------
:: check format
if "%format%"=="DER" (
	set "format_ok=Y"
)
if "%format%"=="PEM" (
	set "format_ok=Y"
)

if not defined format_ok ( 
	echo Invalid format. Allowed formats: CER or TXT
	echo.
	goto get_format
)

::---------------------------------------------------------------
:: set file extension
if "%format%"=="DER" (
	set "ext=cer"
)

if "%format%"=="PEM" (
	set "ext=txt"
)
::---------------------------------------------------------------
:: ssl extraction usin open ssl
:: Usage of "Q" to immediately exit the interactive session after command execution(Refer following link)
:: https://stackoverflow.com/questions/25760596/how-to-terminate-openssl-s-client-after-connection
echo.
echo Retrieving and exporting %hostname%.%ext%...
echo "Q" | openssl s_client -connect %hostname%:443 2>nul | openssl x509 -outform %format% >%hostname%.%ext%
timeout 2 >nul

@echo on
