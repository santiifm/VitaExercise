# README

This is my little wallet API with user creation and transactions between BTC and USD for Vita Wallet.

The project was done in Ruby 3.3.3 and rails 7.1.3.4 and deployed in Render (https://vitaexercise.onrender.com/api-docs) for easy access.

How it works:
First you have to make a client user with a request to POST api/v1/clients and note down your ID, then you can request to POST api/v1/transactions
and include in the body params like:{ "source_currency": "USD", "target_currency": "BTC", "source_amount": 100, "client_id": 2 }. This will create a transaction for that client.
Then you can consult all transactions by id in GET api/v1/transactions/:id and a specific client's transactions in GET api/v1/clients/:id/transactions.

Things to take into account:
 - As the render instance is free it may spin-down and the first request may take a minute or return a time-out.
 - When creating a user it will have 200 of whatever currency you choose to trade in by default.
 - Rspec suite can be run with the 'rspec' command.
 - The API documentation has been done with Swagger/OpenApi and is located in /api-docs.

I hope this project has been satisfactory and I'm looking forward to working with you :)
