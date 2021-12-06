FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY weathersamplesdotnetpipeline/*.csproj ./weathersamplesdotnetpipeline/
RUN dotnet restore

# copy everything else and build app
COPY weathersamplesdotnetpipeline/. ./weathersamplesdotnetpipeline/
WORKDIR /app/weathersamplesdotnetpipeline
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=build /app/weathersamplesdotnetpipeline/out ./
ENTRYPOINT ["dotnet", "weathersamplesdotnetpipeline.dll"]