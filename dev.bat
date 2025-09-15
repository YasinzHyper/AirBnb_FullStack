@echo off
setlocal enabledelayedexpansion

:: AirBnb FullStack Docker Development Helper Script for Windows

if "%1"=="" (
    set COMMAND=start
) else (
    set COMMAND=%1
)

if "%COMMAND%"=="start" goto start
if "%COMMAND%"=="start-bg" goto start_bg
if "%COMMAND%"=="stop" goto stop
if "%COMMAND%"=="restart" goto restart
if "%COMMAND%"=="logs" goto logs
if "%COMMAND%"=="status" goto status
if "%COMMAND%"=="reset-db" goto reset_db
if "%COMMAND%"=="cleanup" goto cleanup
if "%COMMAND%"=="setup" goto setup
if "%COMMAND%"=="help" goto help
if "%COMMAND%"=="-h" goto help
if "%COMMAND%"=="--help" goto help

echo [ERROR] Unknown command: %COMMAND%
goto help

:check_docker
echo [INFO] Checking if Docker is running...
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not running. Please start Docker Desktop and try again.
    exit /b 1
)
echo [SUCCESS] Docker is running
goto :eof

:setup_env
if not exist ".env.local" (
    echo [INFO] Creating .env.local from .env.example...
    copy .env.example .env.local >nul
    echo [WARNING] Please edit .env.local with your OAuth and Cloudinary credentials
    echo [INFO] Environment file created at .env.local
) else (
    echo [INFO] .env.local already exists
)
goto :eof

:start
call :check_docker
if errorlevel 1 exit /b 1
call :setup_env
echo [INFO] Starting AirBnb FullStack application...
docker-compose up --build
goto end

:start_bg
call :check_docker
if errorlevel 1 exit /b 1
call :setup_env
echo [INFO] Starting AirBnb FullStack application in detached mode...
docker-compose up -d --build
echo [SUCCESS] Application started successfully!
echo [INFO] Access the application at: http://localhost:3000
echo [INFO] Access MongoDB Express at: http://localhost:8081
echo [INFO] Use 'docker-compose logs -f app' to view logs
goto end

:stop
call :check_docker
if errorlevel 1 exit /b 1
echo [INFO] Stopping AirBnb FullStack application...
docker-compose down
echo [SUCCESS] Application stopped
goto end

:restart
call :check_docker
if errorlevel 1 exit /b 1
echo [INFO] Restarting AirBnb FullStack application...
docker-compose down
docker-compose up -d --build
echo [SUCCESS] Application restarted successfully!
goto end

:logs
call :check_docker
if errorlevel 1 exit /b 1
echo [INFO] Viewing application logs...
docker-compose logs -f app
goto end

:status
call :check_docker
if errorlevel 1 exit /b 1
echo [INFO] Docker Compose Services Status:
docker-compose ps
goto end

:reset_db
call :check_docker
if errorlevel 1 exit /b 1
echo [WARNING] This will delete all data in the database. Are you sure? (y/N)
set /p response=
if /i "!response!"=="y" (
    echo [INFO] Resetting database...
    docker-compose down -v
    docker-compose up -d --build
    echo [SUCCESS] Database reset completed
) else (
    echo [INFO] Database reset cancelled
)
goto end

:cleanup
call :check_docker
if errorlevel 1 exit /b 1
echo [INFO] Cleaning up containers, networks, and volumes...
docker-compose down -v --remove-orphans
docker system prune -f
echo [SUCCESS] Cleanup completed
goto end

:help
echo AirBnb FullStack Docker Development Helper
echo.
echo Usage: dev.bat [COMMAND]
echo.
echo Commands:
echo   start         Start the application (interactive mode)
echo   start-bg      Start the application in background
echo   stop          Stop the application
echo   restart       Restart the application
echo   logs          View application logs
echo   status        Show services status
echo   reset-db      Reset the database (removes all data)
echo   cleanup       Clean up containers, networks, and volumes
echo   setup         Setup environment file
echo   help          Show this help message
echo.
echo Examples:
echo   dev.bat setup        # Setup environment file
echo   dev.bat start-bg     # Start in background
echo   dev.bat logs         # View logs
echo   dev.bat stop         # Stop application
goto end

:end