# Instagram For Animals

This is a web service build for the subject Web Services on the HSZG.  
It allows You to register a user, add photos and also comment those.  
Everything is controlled by REST-API.

In case You want to start this Application (is a Phoenix server on port 4000):

  * Install Elixir: [instructions](https://elixir-lang.org/install.html).
  * Install Phoenix: [instructions](https://hexdocs.pm/phoenix/installation.html).
  * Install PostgreSQL 12 [here](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads).
  * Configure PostgresSQL. Needed configuration: `user: postgres (should be by default)`, `password: postgres`. [Instructions](http://www.homebrewandtechnology.com/blog/graphicallychangepostgresadminpassword).
  * In any command-prompt step if asked `Y/n` just accept with `Y` and confirm with enter.
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`. Can throw errors if PostgreSQL wrong configured or not working.
  * Install Node.js dependencies with `cd assets && npm install`
  * Don't forget to go back to project root directory with `cd ..`
  * Start Phoenix endpoint with `mix phx.server` (probably fails if port 4000 is already in use)

Now You can test the REST-API. The recommended way is to use Postman.  
Available routes with `mix phx.routes`.

Example:   

HTTP-POST on `localhost:4000/api/registration` with form-data:  

`user[email] : example@example.com`  
`user[password] : password`  
`user[confirm_password] : password`  

After sending this request You can log-in with Your credentials (if registration was successfully done).

HTTP-POST on `localhost:4000/session` with form-data:  

`user[email] : example@example.com`  
`user[password] : password`

As response You become a token to verify Your identity. 
Every time You want access some restricted paths You have to authorize Yourself with this token.  

In order to do this add the header:  
`Authorization : paste_here_your_valid_token`