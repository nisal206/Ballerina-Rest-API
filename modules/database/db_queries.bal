import ballerina/sql;

# Build query to retrieve all user records.
#
# + return - sql:ParameterizedQuery - Select query for all users
isolated function getAllRecords() returns sql:ParameterizedQuery {
    sql:ParameterizedQuery query = `SELECT id, name, email FROM users`;
    return query;
}

# Build query to retrieve a specific user by ID.
#
# + id - User ID to retrieve
# + return - sql:ParameterizedQuery - Select query for the specified user
isolated function getRecord(int id) returns sql:ParameterizedQuery {
    sql:ParameterizedQuery query = `SELECT id, name, email FROM users WHERE id = ${id}`;
    return query;
}

# Build query to delete a user record.
#
# + id - User ID to delete
# + return - sql:ParameterizedQuery - Delete query for the specified user
isolated function deleteRecord(int id) returns sql:ParameterizedQuery {
    sql:ParameterizedQuery query = `DELETE FROM users WHERE id = ${id}`;
    return query;
}

# Build query to insert a new user record.
#
# + id - Unique identifier for the new user
# + name - Name of the new user
# + email - Email address of the new user
# + return - sql:ParameterizedQuery - Insert query for new user
isolated function insertRecord(int id, string name, string email) returns sql:ParameterizedQuery {
    return `INSERT INTO users (id, name, email) VALUES (${id}, ${name}, ${email})`;
}

# Build query to update an existing user record.
#
# + name - Updated name for the user
# + email - Updated email for the user
# + id - User ID to update
# + return - sql:ParameterizedQuery - Update query for the specified user
isolated function updateRecord(string name, string email, int id) returns sql:ParameterizedQuery {
    return `UPDATE users SET name = ${name}, email = ${email} WHERE id = ${id}`;
};

# Build query to search users by name.
#
# + name - Name to search for (exact match)
# + return - sql:ParameterizedQuery - Select query for matching users
isolated function searchRecords(string name) returns sql:ParameterizedQuery {
    return `SELECT id, name, email FROM users WHERE name = ${name}`;
};

// Commented out as per original code
// # Build query to check for duplicate records.
// #
// # + id - User ID to check
// # + email - Email address to check
// # + return - sql:ParameterizedQuery - Query to count matching IDs and emails
// isolated function checkDuplicateRecord(int id, string email) returns sql:ParameterizedQuery {
//     sql:ParameterizedQuery checkQuery = 
//     `SELECT 
//         COUNT(CASE WHEN id = ${id} THEN 1 END) AS id_count,
//         COUNT(CASE WHEN email = ${email} THEN 1 END) AS email_count
//      FROM users`;
//     return checkQuery;
// }