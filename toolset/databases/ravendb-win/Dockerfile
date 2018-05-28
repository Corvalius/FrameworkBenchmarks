FROM microsoft/dotnet:runtime-nanoserver

ENV RAVEN_ARGS='' RAVEN_Setup_Mode='None' RAVEN_ServerUrl='http://localhost:8080' RAVEN_Security_UnsecuredAccessAllowed='PrivateNetwork' RAVEN_SETTINGS='' RAVEN_Setup_Mode='Initial' RAVEN_DataDir='RavenData' RAVEN_ServerUrl_Tcp='38888' RAVEN_AUTO_INSTALL_CA='true' RAVEN_IN_DOCKER='true'

ADD install-raven.ps1 install-raven.ps1
ADD run-raven.ps1 run-raven.ps1
ADD TechEmpower-Fortunes.ravendbdump TechEmpower-Fortunes.ravendbdump
ADD TechEmpower-World.ravendbdump TechEmpower-World.ravendbdump
ADD settings.json settings.json

EXPOSE 8080 38888 161

ADD https://daily-builds.s3.amazonaws.com/RavenDB-4.0.4-patch-40038-windows-x64.zip C:/RavenDB.zip

COPY install-raven.ps1 c:/
RUN powershell -c 'C:\install-raven.ps1'

COPY C:/settings.json C:/RavenDB/Server

VOLUME C:/RavenDB/Server/RavenData C:/RavenDB/Config

WORKDIR C:/ravendb/Server

ADD https://ravendb-docker.s3.amazonaws.com/vcruntime140.dll C:/RavenDB/Server

COPY run-raven.ps1 c:/
CMD [ "powershell", "-File", "C:\\run-raven.ps1" ]

