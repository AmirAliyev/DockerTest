# build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# copy sln and projects (adjust paths to match your layout)
COPY *.sln .
COPY DockerN8N/*.csproj ./DockerN8N/
RUN dotnet restore

COPY . .
WORKDIR /src/DockerN8N
RUN dotnet publish -c Release -o /app/publish

# runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80
ENTRYPOINT ["dotnet", "DockerN8N.dll"]
