# Contacts iOS

A mobile app client for <a href="https://github.com/justinetabin/contacts-service#contacts-rest-api">**Contacts REST API**</a>.

# Architecture Overview
This project's architecture highlights separation of concerns.

### Service Layer
- Encapsulates the interaction between 3rd party service or API. 

### Worker Layer
- Encapsulates the complex business or presentation logic and make them reusable.

### Scene Layer
- The UI that can be easily added or swapped in and out without changing any business logic.
