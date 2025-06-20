import ballerina/sql;

# Insert a new user record into the database.
#
# + id - Unique identifier for the user
# + name - Name of the user
# + email - Email address of the user
# + return - Execution result or error
public function insertUser(int id, string name, string email) returns sql:ExecutionResult|error {
    return dbClient->execute(
        insertRecord(id, name, email));
}

# Retrieve all user records from the database.
#
# + return - Stream of User records or SQL error
public function getAllUsers() returns stream <User , sql:Error?>{
    return dbClient->query(getAllRecords(), User);
}

# Retrieve a specific user by their ID.
#
# + id - User ID to retrieve
# + return - User record or SQL error
public function getUserById(int id) returns User|sql:Error {
    return dbClient->queryRow(getRecord(id));
}

# Search for users by name (partial match).
#
# + name - Name or partial name to search for
# + return - Stream of matching User records or SQL error
public function searchUsersByName(string name) returns stream<User, sql:Error?> {
    return dbClient->query(searchRecords(name), User);
}

# Update an existing user's information.
#
# + id - ID of the user to update
# + name - New name for the user
# + email - New email for the user
# + return - Execution result or error
public function updateUser(int id, string name, string email) returns sql:ExecutionResult|error {
    return dbClient->execute(
        updateRecord(name, email,id)
    );
}

# Delete a user from the database.
#
# + id - ID of the user to delete
# + return - Execution result or error
public function deleteUser(int id) returns sql:ExecutionResult|error {
    return dbClient->execute(deleteRecord(id));
}