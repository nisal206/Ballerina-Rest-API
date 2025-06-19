import ballerina/sql;

public function insertUser(int id, string name, string email) returns sql:ExecutionResult|error {
    return dbClient->execute(
        insertRecord(id, name, email));
}

public function getAllUsers() returns stream <User , sql:Error?>{
    return dbClient->query(getAllRecords(), User);
}

public function getUserById(int id) returns User|sql:Error {
    return dbClient->queryRow(getRecord(id));
}

public function searchUsersByName(string name) returns stream<User, sql:Error?> {
    return dbClient->query(searchRecords(name), User);
}

public function updateUser(int id, string name, string email) returns sql:ExecutionResult|error {
    return dbClient->execute(
        updateRecord(name, email,id)
    );
}

public function deleteUser(int id) returns sql:ExecutionResult|error {
    return dbClient->execute(deleteRecord(id));
}