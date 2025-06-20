import ballerina/http;
import ballerina/sql;
import ballerina/log;
import user_crud_service.database;

# Service for managing user CRUD operations.
#
# + service - HTTP listener on port 8080
service /users on new http:Listener(8080) {

    # Add a new user to the system.
    #
    # + caller - HTTP caller object
    # + req - HTTP request containing user data
    # + return - Error if operation fails
    resource function post addUser(http:Caller caller, http:Request req) returns error? {
        json newUserJson = check req.getJsonPayload();
        http:Response res = new;

        int id;
        if newUserJson.id is int {
            id = <int> check newUserJson.id;
            if id <= 0 {
                res.statusCode = http:STATUS_BAD_REQUEST;
                res.setPayload({ message: "'id' must be a positive integer" });
                check caller->respond(res);
                return;
            }
        } else {
            res.statusCode = http:STATUS_BAD_REQUEST;
            res.setPayload({ message: "'id' must be a valid integer" });
            check caller->respond(res);
            return;
        }

        string name;
        string email;
        if newUserJson.name is string && newUserJson.email is string {
            name = check newUserJson.name;
            email = check newUserJson.email;

            if name == "" || email == "" {
                res.statusCode = http:STATUS_BAD_REQUEST;
                res.setPayload({ message: "'name' and 'email' cannot be empty" });
                check caller->respond(res);
                return;
            }

            if !string:includes(email, "@") || !string:includes(email, ".") || email.length() < 5 {
                res.statusCode = http:STATUS_BAD_REQUEST;
                res.setPayload({ message: "'email' format is invalid" });
                check caller->respond(res);
                return;
            }

        } else {
            res.statusCode = http:STATUS_BAD_REQUEST;
            res.setPayload({ message: "'name' and 'email' must be valid strings" });
            check caller->respond(res);
            return;
        }

        sql:ParameterizedQuery checkQuery = 
        `SELECT 
            COUNT(CASE WHEN id = ${id} THEN 1 END) AS id_count,
            COUNT(CASE WHEN email = ${email} THEN 1 END) AS email_count
        FROM users`;

        stream<record { int id_count; int email_count; }, sql:Error?> resultStream = database:dbClient->query(checkQuery);
        var cresult = resultStream.next();

        if cresult is record { record { int id_count; int email_count; } value; } {
            int icount = cresult.value.id_count;
            if icount > 0 {
                res.statusCode = http:STATUS_CONFLICT;
                res.setPayload({ message: "User with this 'id' already exists" });
                check caller->respond(res);
                return;
            }

            int ecount = cresult.value.email_count;
            if ecount > 0 {
                res.statusCode = http:STATUS_CONFLICT;
                res.setPayload({ message: "User with this 'email' already exists" });
                check caller->respond(res);
                return;
            }
        }

        sql:ExecutionResult | error result = check database:insertUser(id, name, email);

        if result is error {
            res.statusCode = http:STATUS_BAD_REQUEST;
            res.setPayload({ message: "Not updated" });
            return;
        }

        database:User newUser = { id, name, email };
        res.statusCode = http:STATUS_CREATED;
        res.setPayload({ message: "User added successfully", user: newUser });
        check caller->respond(res);
    }

    # Retrieve all users from the system.
    #
    # + caller - HTTP caller object
    # + return - Error if operation fails
    resource function get .(http:Caller caller) returns error? {
        stream <database:User, sql:Error?> resultStream = database:getAllUsers();

        database:User[] userList = [];

        error? e = resultStream.forEach(function(database:User user){
            userList.push(user);
        });

        if e is error{
            return e;
        }

        http:Response res = new;
        if userList.length() == 0 {
            res.statusCode = http:STATUS_OK;
            res.setPayload({
                message: "No users found",
                users: []
            });
        } else {
            res.statusCode = http:STATUS_OK;
            res.setPayload({
                message: "All users retrieved successfully",
                users: userList
            });
        }

        check caller->respond(res);
    }

    # Retrieve a specific user by ID.
    #
    # + id - User ID to retrieve
    # + caller - HTTP caller object
    # + return - Error if operation fails
    resource function get [int id](http:Caller caller) returns error? {
        database:User|sql:Error result = database:getUserById(id);

        http:Response res = new;
        if result is sql:NoRowsError {
            res.statusCode = http:STATUS_NOT_FOUND;
            res.setPayload("User not found");
        } else if result is sql:Error {
            return error("Database error", result);
        } else {
            res.statusCode = http:STATUS_OK;
            res.setPayload(result);
        }

        check caller->respond(res);
    }

    # Update an existing user's information.
    #
    # + id - User ID to update
    # + caller - HTTP caller object
    # + req - HTTP request containing updated user data
    # + return - Error if operation fails
    resource function put updateUser/[int id](http:Caller caller, http:Request req) returns error? {
        json|error userJson = req.getJsonPayload();
        http:Response res = new;

        if userJson is json {
            string? name = userJson.name is string ? <string> check userJson.name : ();
            string? email = userJson.email is string ? <string> check userJson.email : ();

            if name is () || email is () {
                res.statusCode = http:STATUS_BAD_REQUEST;
                res.setPayload({ message: "Both 'name' and 'email' are required and must be strings." });
                check caller->respond(res);
                return;
            }

            sql:ExecutionResult result = check database:updateUser( id, name , email);
            
            // Check if any rows were affected
            if result.affectedRowCount == 0 {
                res.setPayload("User not found");
                res.statusCode = http:STATUS_NOT_FOUND;
                check caller->respond(res);
            } else {
                check caller->respond("User updated");
            }

        } else {
            res.statusCode = http:STATUS_BAD_REQUEST;
            res.setPayload({ message: "Invalid JSON payload." });
            check caller->respond(res);
        }
    }

    # Delete a user from the system.
    #
    # + id - User ID to delete
    # + caller - HTTP caller object
    # + req - HTTP request
    # + return - Error if operation fails
    resource function delete deleteUser/[int id](http:Caller caller, http:Request req) returns error? {
        sql:ExecutionResult result = check database:deleteUser(id);

        http:Response res = new;
        if result.affectedRowCount == 0 {
            res.statusCode = http:STATUS_NOT_FOUND;
            res.setPayload({ message: "User not found" });
        } else {
            res.statusCode = http:STATUS_OK;
            res.setPayload({ message: "User deleted successfully" });
        }
        check caller->respond(res);
    }

    # Search users by name.
    #
    # + caller - HTTP caller object
    # + req - HTTP request containing search query
    # + return - Error if operation fails
    resource function get searchUsers(http:Caller caller, http:Request req) returns error? {
        // Get 'name' query param
        string nameParam = req.getQueryParamValue("name").toString();

        log:printInfo("Searching for name: " + nameParam);

        // SQL query with parameterized input
        stream<database:User, sql:Error?> result = database:searchUsersByName(nameParam);

        // Manually collect stream values into an array
        database:User[] users = [];
        error? e = result.forEach(function(database:User user) {
            users.push(user);
        });
        if e is error {
            return e;
        }

        // Return the list of users as HTTP response
        http:Response res = new;
        res.setPayload(users);
        check caller->respond(res);
    }
}

# Main function to start the service.
#
# + return - Error if service fails to start
public function main() returns error? {
    log:printInfo("User service started on port 8080");
}