# Author: Shilratna Dharmarakshak Chawhan
#FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine-amd64 AS build-env
#WORKDIR /app

# Copy csproj and restore as distinct layers
#COPY *.csproj ./
#RUN dotnet restore

# Copy everything else and build
#COPY . ./
#RUN dotnet publish -c Release -o out

# Build runtime image
#FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine-amd64
#WORKDIR /app
#RUN apk --no-cache add curl
3COPY --from=build-env /app/out .
3EXPOSE 8090
#ENTRYPOINT ["dotnet", "renderDotnetCore.dll"]

# NuGet restore
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY *.sln .
COPY renderDotnetCore/*.csproj renderDotnetCore/
RUN dotnet restore
COPY . .

# publish
FROM build AS publish
WORKDIR /src/renderDotnetCore
RUN dotnet publish -c Release -o /src/publish

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=publish /src/publish .
# ENTRYPOINT ["dotnet", "renderDotnetCore.dll"]
# heroku uses the following
CMD ASPNETCORE_URLS=http://*:$PORT dotnet renderDotnetCore.dll
