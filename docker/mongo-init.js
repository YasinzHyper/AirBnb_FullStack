// MongoDB initialization script
// This script creates the application database, user, and initializes replica set

// Initialize replica set
try {
  rs.status();
  print('Replica set already initialized');
} catch (e) {
  print('Initializing replica set...');
  rs.initiate({
    _id: 'rs0',
    members: [
      { _id: 0, host: 'localhost:27017' }
    ]
  });
  
  // Wait for replica set to be ready
  while (rs.status().myState !== 1) {
    print('Waiting for replica set to be ready...');
    sleep(1000);
  }
  print('Replica set initialized successfully');
}

// Switch to the application database
db = db.getSiblingDB('airbnb');

// Create a user for the application
try {
  db.createUser({
    user: 'airbnb_user',
    pwd: 'airbnb_password',
    roles: [
      {
        role: 'readWrite',
        db: 'airbnb'
      }
    ]
  });
  print('Application user created successfully');
} catch (e) {
  print('User already exists or error creating user: ' + e.message);
}

// Create some indexes for better performance
try {
  db.users.createIndex({ "email": 1 }, { unique: true });
  db.listings.createIndex({ "userId": 1 });
  db.reservations.createIndex({ "userId": 1 });
  db.reservations.createIndex({ "listingId": 1 });
  print('Indexes created successfully');
} catch (e) {
  print('Error creating indexes: ' + e.message);
}

print('Database initialization completed');