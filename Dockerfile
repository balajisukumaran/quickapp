# Stage 1: Build the Angular application
FROM node:19 AS angular-build

# Set the working directory
WORKDIR /app

# Copy the Angular project files
COPY quickapp.client/package*.json ./quickapp.client/
RUN npm install --prefix ./quickapp.client
COPY quickapp.client/ ./quickapp.client/

# Build the Angular application
RUN npm run build --prod --prefix ./quickapp.client

# Stage 2: Build the .NET Core application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS dotnet-build

# Set the working directory
WORKDIR /src

# Copy the .NET Core project files
COPY quickapp.server/*.csproj ./quickapp.server/
RUN dotnet restore ./quickapp.server/*.csproj

# Copy the rest of the .NET Core project files and build
COPY quickapp.server/ ./quickapp.server/
WORKDIR /src/quickapp.server
RUN dotnet publish -c Release -o /app/publish

# Stage 3: Serve the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Copy the Angular build output to the .NET Core static files directory
COPY --from=angular-build /app/quickapp.client/dist/quickapp.client /app/wwwroot

# Copy the .NET Core publish output
COPY --from=dotnet-build /app/publish .

# Set environment variables
ENV ASPNETCORE_URLS=http://+:80

# Start the application
ENTRYPOINT ["dotnet", "quickapp.server.dll"]
