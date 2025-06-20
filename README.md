# Ballerina CRUD Application

A simple CRUD (Create, Read, Update, Delete) REST API built with [Ballerina](https://ballerina.io/) that manages user records in a MySQL database.

## Features

- RESTful API for user management
- Search users by name
- Patch support for updates
- Error handling with appropriate HTTP status codes

## Project Structure

```
user_crud_service/
├── .gitignore
├── Ballerina.toml
├── Config.toml
├── Dependencies.toml
├── service.bal
├── lib/
│   └── mysql-connector-j-8.0.33.jar
├── modules/
│   └── database/
│       ├── client.bal
│       ├── db_functions.bal
│       ├── db_queries.bal
│       ├── types.bal
│  
├── resources/
│   └── db_scripts.sql
│       
└── target/
```

## Getting Started

### Prerequisites

- [Ballerina](https://ballerina.io/downloads/) 2201.12.6 or compatible
- MySQL server
- Java (for MySQL connector)

### Setup

1. **Clone the repository:**
   ```sh
   git clone https://github.com/nisal206/Ballerina-Rest-API.git
   cd Ballerina-REST-API
   ```

2. **Set Up the MySQL Database:**

- Create a MySQL database (e.g., user_db).
- Execute the following SQL to create the user table:

    sql
    ```
    CREATE TABLE user (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        age INT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    ```

3. **Configure database connection:**
   - Copy `Config.toml` and set your MySQL credentials:
     ```toml
     [my_crud_service.database]
     user = "<db_user>"
     password = "<db_password>"
     database = "<db_name>"
     host = "localhost"
     port = 3306
     ```

4. **Add MySQL Connector:**
   - Ensure `lib/mysql-connector-j-8.0.33.jar` exists. If not, download from [MySQL](https://dev.mysql.com/downloads/connector/j/).

5. **Build the project:**
   ```sh
   bal build
   ```

6. **Run the service:**
   ```sh
   bal run
   ```

## API Endpoints

| Method | Endpoint                | Description                |
|--------|------------------------ |----------------------------|
| GET    | `/users/{id}`           | Get user by ID             |
| GET    | `/users`           | Get all users
| POST   | `/users`                | Create a new user          |
| DELETE | `/users/deleteUser/{id}`| Delete user by ID          |
| PUT    | `/users/updateUser/{id}`           | Update user       |
| GET    | `/users/searchUsers?name=xx` | Search users by name       |

## License

This project is licensed for educational and demonstration purposes.

## Copyright

&copy; 2025 Nisal Rukshan All rights reserved.

---

*Powered by [Ballerina](https://ballerina.io/)*