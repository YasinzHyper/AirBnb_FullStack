# Full Stack Airbnb Clone

This is a full stack Airbnb clone built using Next.js 13, App router, React, Tailwind CSS, Prisma, MongoDB, and NextAuth. It provides a platform for users to browse and book vacation rentals as well as list their own rental properties.

## Screenshots
![Home Page](https://i.ibb.co/rkXdF5V/Airbnb-Home.jpg)

## Features
* User authentication and authorization using NextAuth
* User profile management
* Property listing management
* Search functionality to filter rental properties based on location, date range, and number of guests
* Responsive design Using Tailwind CSS

## Technologies Used
* [Next.js](https://next.js.org) - A React framework for server-side rendering and static site generation
* [React](https://reactjs.org) - A JavaScript library for building user interfaces
* [Tailwind CSS](https://tailwindcss.com) - A utility-first CSS framework
* [Zustand](https://zustand.surge.sh) - A state management library for React
* [Axios](https://axios-http.com) - A promise-based HTTP client
* [React-hot-toast](https://react-hot-toast.com) - A React library for toast notifications
* [Prisma](https://prisma.io) - An open-source ORM for Node.js
* [MongoDB](https://mongodb.com) - A document-based, NoSQL database
* [NextAuth](https://next-auth.js.org) - Authentication for Next.js
* [Next-Cloudinary](https://next-cloudinary.spacejelly.dev) - A Next.js library for image and video upload and storage

## Getting Started

### Option 1: Using Docker (Recommended)

This is the easiest way to run the application in development mode without installing any dependencies locally.

#### Prerequisites
- [Docker](https://www.docker.com/products/docker-desktop/)
- [Docker Compose](https://docs.docker.com/compose/install/) (usually included with Docker Desktop)

#### Quick Start
1. Clone the repository
```bash
git clone https://github.com/your-username/full-stack-airbnb-clone.git
cd AirBnb_FullStack
```

2. Copy the environment file and configure your settings
```bash
cp .env.example .env.local
```

3. Update the `.env.local` file with your OAuth and Cloudinary credentials (optional for basic functionality):
```env
# OAuth Providers (Optional)
GITHUB_ID="your-github-client-id"
GITHUB_SECRET="your-github-client-secret"
GOOGLE_CLIENT_ID="your-google-client-id"
GOOGLE_CLIENT_SECRET="your-google-client-secret"

# Cloudinary (Optional - for image uploads)
NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME="your-cloudinary-cloud-name"
```

4. Start the application with Docker Compose
```bash
docker-compose up --build
```

**Alternative: Use the helper scripts for easier management**
```bash
# On Linux/Mac
chmod +x dev.sh
./dev.sh start-bg    # Start in background
./dev.sh logs        # View logs
./dev.sh stop        # Stop application

# On Windows
dev.bat start-bg     # Start in background
dev.bat logs         # View logs
dev.bat stop         # Stop application
```

5. Open [http://localhost:3000](http://localhost:3000) to view the application
6. Access MongoDB Express (database admin interface) at [http://localhost:8081](http://localhost:8081)
   - Username: `admin`
   - Password: `admin123`

#### Docker Commands

**Using Docker Compose directly:**
- **Start the application**: `docker-compose up`
- **Start in detached mode**: `docker-compose up -d`
- **Rebuild and start**: `docker-compose up --build`
- **Stop the application**: `docker-compose down`
- **View logs**: `docker-compose logs app`
- **Clean up volumes and containers**: `docker-compose down -v --remove-orphans`

**Using helper scripts (recommended):**
```bash
# Linux/Mac
./dev.sh start        # Start interactively
./dev.sh start-bg     # Start in background
./dev.sh stop         # Stop application
./dev.sh restart      # Restart application
./dev.sh logs         # View logs
./dev.sh status       # Check service status
./dev.sh reset-db     # Reset database
./dev.sh cleanup      # Full cleanup
./dev.sh help         # Show all commands

# Windows
dev.bat start-bg      # Start in background
dev.bat stop          # Stop application
dev.bat logs          # View logs
dev.bat help          # Show all commands
```

#### Services Included
- **Next.js Application**: Runs on port 3000 with hot reload enabled
- **MongoDB Database**: Runs on port 27017 with persistent data storage (configured as replica set for Prisma transactions)
- **MongoDB Setup**: One-time initialization service that configures the replica set
- **MongoDB Express**: Web-based MongoDB admin interface on port 8081

### Option 2: Local Development (Manual Setup)

1. Clone the repository
```bash
git clone https://github.com/your-username/full-stack-airbnb-clone.git
cd AirBnb_FullStack
```

2. Install dependencies
```bash
npm install
```

3. Set up MongoDB locally or use a cloud instance

4. Create a `.env.local` file in the root directory and add the following environment variables:
```env
DATABASE_URL="mongodb://your-mongodb-connection-string"
NEXTAUTH_SECRET="your-nextauth-secret-key"
NEXTAUTH_URL="http://localhost:3000"
# Add other environment variables as needed
```

5. Generate Prisma client and push the database schema
```bash
npx prisma generate
npx prisma db push
```

6. Start the development server
```bash
npm run dev
```

7. Open [http://localhost:3000](http://localhost:3000) with your browser to view the app.

## Docker Development Notes

### Environment Variables
The Docker setup uses the following default configuration:
- **MongoDB**: `mongodb://admin:password123@mongodb:27017/airbnb?authSource=admin`
- **NextAuth Secret**: `your-nextauth-secret-key-here-change-this-in-production`
- **NextAuth URL**: `http://localhost:3000`

### Data Persistence
- MongoDB data is persisted in a Docker volume named `mongodb_data`
- Your application code is mounted as a volume for hot reload during development
- Database changes will persist between container restarts

### Troubleshooting

#### Common Issues
1. **OpenSSL/Prisma compatibility warnings**: 
   ```
   prisma:warn Prisma failed to detect the libssl/openssl version to use
   ```
   This is a warning that can be safely ignored. The Docker configuration includes the correct OpenSSL version for Alpine Linux.

2. **MongoDB Replica Set requirement**:
   ```
   Prisma needs to perform transactions, which requires your MongoDB server to be run as a replica set
   ```
   This is automatically handled by the Docker setup. MongoDB is configured as a single-node replica set to support Prisma transactions. The mongo-setup service initializes this automatically.

3. **Port conflicts**: If ports 3000, 27017, or 8081 are already in use:
   ```bash
   # Check what's using the ports
   netstat -tulpn | grep :3000
   
   # Modify ports in docker-compose.yml if needed
   ```

3. **Permission issues on Linux/Mac**:
   ```bash
   sudo chown -R $USER:$USER .
   ```

4. **Database connection issues**:
   ```bash
   # Check if MongoDB container is running
   docker-compose ps
   
   # View MongoDB logs
   docker-compose logs mongodb
   ```

5. **Node modules issues**:
   ```bash
   # Rebuild the containers
   docker-compose down
   docker-compose build --no-cache
   docker-compose up
   ```

#### Resetting the Database
To start with a fresh database:
```bash
docker-compose down -v
docker-compose up --build
```

#### Accessing the Database Directly
```bash
# Connect to MongoDB container
docker-compose exec mongodb mongosh -u admin -p password123 --authenticationDatabase admin

# Use the airbnb database
use airbnb

# List collections
show collections
```

## Contributing
Contributions are welcome! Please open an issue or pull request for any changes.

## License
This project is licensed under the [MIT License](License.txt)