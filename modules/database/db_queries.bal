import ballerina/sql;

isolated  function getAllRecords() returns sql:ParameterizedQuery {
    sql:ParameterizedQuery query = `SELECT id, name, email FROM users`;
    return query;
}

isolated  function getRecord(int id) returns sql:ParameterizedQuery {
    sql:ParameterizedQuery query = `SELECT id, name, email FROM users WHERE id = ${id}`;
    return query;
}

isolated function deleteRecord(int id) returns sql:ParameterizedQuery {
    sql:ParameterizedQuery query = `DELETE FROM users WHERE id = ${id}`;
    return query;
}
isolated  function insertRecord(int id, string name, string email) returns sql:ParameterizedQuery {
    return `INSERT INTO users (id, name, email) VALUES (${id}, ${name}, ${email})`;
}

// public function checkDuplicateRecord(int id, string email) returns sql:ParameterizedQuery {
//     sql:ParameterizedQuery checkQuery = 
//     `SELECT 
//         COUNT(CASE WHEN id = ${id} THEN 1 END) AS id_count,
//         COUNT(CASE WHEN email = ${email} THEN 1 END) AS email_count
//      FROM users`;
//     return checkQuery;
// }

isolated  function updateRecord(string name, string email, int id) returns sql:ParameterizedQuery {
    return `UPDATE users SET name = ${name}, email = ${email} WHERE id = ${id}`;
};

isolated function searchRecords(string name) returns sql:ParameterizedQuery {
    return `SELECT id, name, email FROM users WHERE name = ${name}`;
};