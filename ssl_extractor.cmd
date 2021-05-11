@echo off
set /p hostname=Specify the hostname:
openssl s_client -connect %hostname%:443 2>nul | openssl x509 -outform DER >%hostname%.cer 
@echo on