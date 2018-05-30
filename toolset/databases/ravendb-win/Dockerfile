FROM ravendb/ravendb:windows-nanoserver-latest 

ENV RAVEN_ARGS='' RAVEN_SETTINGS='{}' RAVEN_Setup_Mode='None' RAVEN_ServerUrl='http://0.0.0.0:8080' RAVEN_Security_UnsecuredAccessAllowed='PrivateNetwork' RAVEN_DataDir='RavenData' RAVEN_ServerUrl_Tcp='38888' RAVEN_AUTO_INSTALL_CA='true' RAVEN_IN_DOCKER='true' RAVEN_License_Eula_Accepted='true'

COPY TechEmpower-World.ravendbdump TechEmpower-Fortunes.ravendbdump C:/datadumps/
COPY settings.json C:/RavenDB/Server

COPY run-raven.ps1 C:/
CMD [ "powershell", "-File", "C:\\run-raven.ps1" ]

