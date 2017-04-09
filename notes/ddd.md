Domains
==========

Sit on top of a persistence layer, but don't care about it, because another persistence layer may be used or it may not be persisted at all.

Domain Model Patterns (Revisit this)
=======================

### Domain Model
Obj oriented model incorporating behavior and data

### Transaction Script
Some kind of business transaction that groups domain related actions into a single atomic unit.  Typically this transaction procedure is put into a service class.

### Table Module
Maps object model to db model
Object responsible for persistence, along with business logic and behavior

### Active Record
Maps objects ot rows of a table.  

Application Architecture Ch 8
=================================

* Separate technical complexities from the complexities of the domain
* Separate presentation, persistence, and domain logic
* Application layer protects the domain layer from all the other layers and services such as persistence layer, presentation layer, web serices layer, messaging, etc.  It's allows the application to do the business logic on the domains.
* Application layer depends only on the domain layer and delegates to it.
* Application layer talks with the persistence layer to allow domain objects to be hydrated and persisted.
* Operate at a higher level of abstraction that exposes some services but hides the domain layer
* Can be thought of an anti-corruption layer - everyone must work with the application layer to keep the system in a consistent state.
* Application layer should be the central entity that notifies other entities of domain events.
* Data Transfer Objects (DTOs) are passed between Application layer and other layers/services so that unsolicited data is not exposed.
* Application layers are not simply just CRUD implementations.  They will reveal the capabilities of the system and implement use cases and user intents.
