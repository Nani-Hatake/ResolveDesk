# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy everything from the root
COPY . .

# Restore and publish pointing inside the ResolveDesk folder 
# (Replace 'ResolveDesk.csproj' with your actual .NET project file name if it's different)
RUN dotnet restore "ResolveDesk/ResolveDesk.csproj"
RUN dotnet publish "ResolveDesk/ResolveDesk.csproj" -c Release -o /app/publish

# Final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Expose port and start app
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
ENTRYPOINT ["dotnet", "ResolveDesk.dll"]
