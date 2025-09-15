#!/bin/bash

# AirBnb FullStack Docker Development Helper Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker Desktop and try again."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to setup environment file
setup_env() {
    if [ ! -f ".env.local" ]; then
        print_status "Creating .env.local from .env.example..."
        cp .env.example .env.local
        print_warning "Please edit .env.local with your OAuth and Cloudinary credentials"
        print_status "Environment file created at .env.local"
    else
        print_status ".env.local already exists"
    fi
}

# Function to start the application
start_app() {
    print_status "Starting AirBnb FullStack application..."
    docker-compose up --build
}

# Function to start the application in detached mode
start_app_detached() {
    print_status "Starting AirBnb FullStack application in detached mode..."
    docker-compose up -d --build
    print_success "Application started successfully!"
    print_status "Access the application at: http://localhost:3000"
    print_status "Access MongoDB Express at: http://localhost:8081"
    print_status "Use 'docker-compose logs -f app' to view logs"
}

# Function to stop the application
stop_app() {
    print_status "Stopping AirBnb FullStack application..."
    docker-compose down
    print_success "Application stopped"
}

# Function to restart the application
restart_app() {
    print_status "Restarting AirBnb FullStack application..."
    docker-compose down
    docker-compose up -d --build
    print_success "Application restarted successfully!"
}

# Function to view logs
view_logs() {
    print_status "Viewing application logs..."
    docker-compose logs -f app
}

# Function to clean up everything
cleanup() {
    print_status "Cleaning up containers, networks, and volumes..."
    docker-compose down -v --remove-orphans
    docker system prune -f
    print_success "Cleanup completed"
}

# Function to reset database
reset_db() {
    print_warning "This will delete all data in the database. Are you sure? (y/N)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        print_status "Resetting database..."
        docker-compose down -v
        docker-compose up -d --build
        print_success "Database reset completed"
    else
        print_status "Database reset cancelled"
    fi
}

# Function to show status
show_status() {
    print_status "Docker Compose Services Status:"
    docker-compose ps
}

# Function to show help
show_help() {
    echo "AirBnb FullStack Docker Development Helper"
    echo ""
    echo "Usage: ./dev.sh [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start         Start the application (interactive mode)"
    echo "  start-bg      Start the application in background"
    echo "  stop          Stop the application"
    echo "  restart       Restart the application"
    echo "  logs          View application logs"
    echo "  status        Show services status"
    echo "  reset-db      Reset the database (removes all data)"
    echo "  cleanup       Clean up containers, networks, and volumes"
    echo "  setup         Setup environment file"
    echo "  help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./dev.sh setup        # Setup environment file"
    echo "  ./dev.sh start-bg     # Start in background"
    echo "  ./dev.sh logs         # View logs"
    echo "  ./dev.sh stop         # Stop application"
}

# Main script logic
case "${1:-start}" in
    "start")
        check_docker
        setup_env
        start_app
        ;;
    "start-bg")
        check_docker
        setup_env
        start_app_detached
        ;;
    "stop")
        check_docker
        stop_app
        ;;
    "restart")
        check_docker
        restart_app
        ;;
    "logs")
        check_docker
        view_logs
        ;;
    "status")
        check_docker
        show_status
        ;;
    "reset-db")
        check_docker
        reset_db
        ;;
    "cleanup")
        check_docker
        cleanup
        ;;
    "setup")
        setup_env
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac