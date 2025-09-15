// MongoDB Replica Set Setup Script
print('Starting replica set initialization...');

try {
  // Check if replica set is already initialized
  var status = rs.status();
  print('Replica set already initialized');
  print('Current status: ' + status.myState);
} catch (e) {
  print('Initializing replica set...');
  
  // Initialize replica set
  var config = {
    _id: 'rs0',
    members: [
      { _id: 0, host: 'mongodb:27017' }
    ]
  };
  
  rs.initiate(config);
  
  // Wait for replica set to be ready
  var maxAttempts = 30;
  var attempts = 0;
  
  while (attempts < maxAttempts) {
    try {
      var status = rs.status();
      if (status.myState === 1) {
        print('Replica set is now PRIMARY and ready!');
        break;
      }
      print('Waiting for replica set to be ready... State: ' + status.myState);
    } catch (e) {
      print('Waiting for replica set initialization... Attempt: ' + (attempts + 1));
    }
    
    sleep(2000);
    attempts++;
  }
  
  if (attempts >= maxAttempts) {
    print('ERROR: Replica set failed to initialize within timeout');
    quit(1);
  }
}

// Switch to application database
db = db.getSiblingDB('airbnb');

print('Application database setup completed successfully!');