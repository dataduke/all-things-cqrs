# All Things CQRS

A bunch of ways of doing [CQRS](https://martinfowler.com/bliki/CQRS.html) with various [Spring](https://spring.io) tools.

## Getting Started

These instructions will get you and overview of how to synchronize two different datasources. We will do so by separating command and queries in a simple CQRS app. Each module represents a different way of introducing this pattern. Also, each module is a standalone [Spring Boot](https://spring.io/projects/spring-boot) application.

### Prerequisites

What things you need to run the software:

* Java 11+
* [docker-compose](https://docs.docker.com/compose/)

## Overview

Sample applications are based on a simple domain that serves credit cards. There are two usecases:

*  Money can be withdrawn from a card (*Withdraw* **command**)
*  List of withdrawals from a card can be read (**query**)

The important is that:
```
After a successful Withdraw command, a withdrawal should be seen in a result from list of withdrawals query.
```

Hence there is a need for some **synchronization** that makes state for commands and queries consistent.

Let's agree on a color code for commands, queries and synchronization. It will make our drawings consistent.

![color code](https://github.com/ddd-by-examples/all-things-cqrs/blob/master/colorcode.jpg "Color code")

### Commands and queries handled in one class (no CQRS)

Code can be found under [in-one-class](https://github.com/ddd-by-examples/all-things-cqrs/tree/master/in-one-class) module.

Running the app:
```
mvn spring-boot:run
```

A sample *Withdraw* command:

```
curl localhost:8080/withdrawals -X POST --header 'Content-Type: application/json' -d '{"card":"3a3e99f0-5ad9-47fa-961d-d75fab32ef0e", "amount": 10.00}' --verbose
```
Verifed by a query:
```
curl http://localhost:8080/withdrawals?cardId=3a3e99f0-5ad9-47fa-961d-d75fab32ef0e --verbose
```
Expected result:
```
[{"amount":10.00}]
```

Architecture overview:

![in-one-class](https://github.com/ddd-by-examples/all-things-cqrs/blob/master/inoneclass.jpg)

Automatic E2E test for REST API can be found [here](https://github.com/ddd-by-examples/all-things-cqrs/blob/master/in-one-class/src/test/java/io/dddbyexamples/cqrs/CommandQuerySynchronizationTest.java):

```java
    @Test
    public void shouldSynchronizeQuerySideAfterSendingACommand() {
        // given
        UUID cardUUid = thereIsCreditCardWithLimit(new BigDecimal(100)); //HTTP POST
        // when
        clientWantsToWithdraw(TEN, cardUUid); //HTTP GET
        // then
        thereIsOneWithdrawalOf(TEN, cardUUid);
    }
```

### CQRS with application service as explicit synchronization

Code can be found under [explicit-with-dto](https://github.com/ddd-by-examples/all-things-cqrs/tree/master/explicit-with-dto) module. Same version, but with JPA entities as results of a query can be found [here](https://github.com/ddd-by-examples/all-things-cqrs/tree/master/explicit-with-entity).

Running the app:
```
mvn spring-boot:run
```

A sample *Withdraw* command:

```
curl localhost:8080/withdrawals -X POST --header 'Content-Type: application/json' -d '{"card":"3a3e99f0-5ad9-47fa-961d-d75fab32ef0e", "amount": 10.00}' --verbose
```
Verifed by a query:
```
curl http://localhost:8080/withdrawals?cardId=3a3e99f0-5ad9-47fa-961d-d75fab32ef0e --verbose
```
Expected result:
```
[{"amount":10.00}]
```

Architecture overview:

![application-process](https://github.com/ddd-by-examples/all-things-cqrs/blob/master/appprocess.jpg)

Automatic E2E test for REST API can be found [here](https://github.com/ddd-by-examples/all-things-cqrs/blob/master/explicit-with-dto/src/test/java/io/dddbyexamples/cqrs/CommandQuerySynchronizationTest.java):

```java
    @Test
    public void shouldSynchronizeQuerySideAfterSendingACommand() {
        // given
        UUID cardUUid = thereIsCreditCardWithLimit(new BigDecimal(100)); //HTTP POST
        // when
        clientWantsToWithdraw(TEN, cardUUid); //HTTP GET
        // then
        thereIsOneWithdrawalOf(TEN, cardUUid);
    }
```

### CQRS with spring application events as implicit synchronization

Code can be found under [with-application-events](https://github.com/ddd-by-examples/all-things-cqrs/tree/master/with-application-events) module.

There is also a version with immutable domain module which just returns events. It Can be found [here](https://github.com/ddd-by-examples/all-things-cqrs/tree/master/with-application-events-immutable).

Running the app:
```
mvn spring-boot:run
```

A sample *Withdraw* command:

```
curl localhost:8080/withdrawals -X POST --header 'Content-Type: application/json' -d '{"card":"3a3e99f0-5ad9-47fa-961d-d75fab32ef0e", "amount": 10.00}' --verbose
```
Verifed by a query:
```
curl http://localhost:8080/withdrawals?cardId=3a3e99f0-5ad9-47fa-961d-d75fab32ef0e --verbose
```
Expected result:
```
[{"amount":10.00}]
```

Architecture overview:

![appevents](https://github.com/ddd-by-examples/all-things-cqrs/blob/master/appevents.jpeg)

Automatic E2E test for REST API can be found [here](https://github.com/ddd-by-examples/all-things-cqrs/blob/master/with-application-events/src/test/java/io/dddbyexamples/cqrs/CommandQuerySynchronizationTest.java):

```java
    @Test
    public void shouldSynchronizeQuerySideAfterSendingACommand() {
        // given
        UUID cardUUid = thereIsCreditCardWithLimit(new BigDecimal(100)); //HTTP POST
        // when
        clientWantsToWithdraw(TEN, cardUUid); //HTTP GET
        // then
        thereIsOneWithdrawalOf(TEN, cardUUid);
    }
```

### CQRS with trigger as implicit synchronization

Code can be found under [trigger](https://github.com/ddd-by-examples/all-things-cqrs/tree/master/with-trigger) module.

Running the app:
```
mvn spring-boot:run
```

A sample *Withdraw* command:

```
curl localhost:8080/withdrawals -X POST --header 'Content-Type: application/json' -d '{"card":"3a3e99f0-5ad9-47fa-961d-d75fab32ef0e", "amount": 10.00}' --verbose
```
Verifed by a query:
```
curl http://localhost:8080/withdrawals?cardId=3a3e99f0-5ad9-47fa-961d-d75fab32ef0e --verbose
```
Expected result:
```
[{"amount":10.00}]
```

Architecture overview:

![trigger](https://github.com/ddd-by-examples/all-things-cqrs/blob/master/trigger.jpg)

Automatic E2E test for REST API can be found [here](https://github.com/ddd-by-examples/all-things-cqrs/blob/master/with-trigger/src/test/java/io/dddbyexamples/cqrs/CommandQuerySynchronizationTest.java):

```java
    @Test
    public void shouldSynchronizeQuerySideAfterSendingACommand() {
        // given
        UUID cardUUid = thereIsCreditCardWithLimit(new BigDecimal(100)); //HTTP POST
        // when
        clientWantsToWithdraw(TEN, cardUUid); //HTTP GET
        // then
        thereIsOneWithdrawalOf(TEN, cardUUid);
    }
```
