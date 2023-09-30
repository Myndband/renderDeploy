# Author: Shilratna Dharmarakshak Chawhan
FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine-amd64 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine-amd64
WORKDIR /app
RUN apk --no-cache add curl
COPY --from=build-env /app/out .
#EXPOSE 8090
#ENTRYPOINT ["dotnet", "renderDotnetCore.dll"]
CMD ASPNETCORE_URLS=http://*:$PORT dotnet renderDotnetCore.dll

# Build
#FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
#WORKDIR /app
#COPY . .
#RUN dotnet restore
#RUN dotnet publish -c Release -o out

# Run
#FROM mcr.microsoft.com/dotnet/aspnet:6.0
#WORKDIR /app
#COPY --from=build /app/out .
#ENV ASPNETCORE_URLS=http://*:$PORT
#CMD dotnet renderDotnetCore.dll
