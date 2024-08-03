# Stage 1: Build Angular and ASP.NET Core application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Install Node.js 18.19.1
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs=18.19.1-1nodesource1

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . .

# Install project dependencies for Angular
RUN cd quickapp.client && npm install && cd ..

# Publish the .NET Core application
RUN dotnet publish QuickApp.Server/QuickApp.Server.csproj -c Release -o ./publish

# Stage 2: Build the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Install AWS CLI
RUN apt-get update && apt-get install -y awscli

# Set the working directory
WORKDIR /app

# Copy the build output from the build stage
COPY --from=build /app/publish .

# Expose the application port
EXPOSE 8080

# Set the entry point to run the application
ENTRYPOINT ["dotnet", "QuickApp.Server.dll"]
