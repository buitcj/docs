Spring
===========

### Dependency Injection

We want loose coupling so that in the future we can easily swap out components.  So we want to work with interfaces and also have some other service give us (inject) the dependencies for us.

In JAVA we have Spring framework.  If someone is asking for an object that implements an interface, then let's give it to them.

@Autowired

Also, for testing, if the classes are loosely coupled, then we can set up mock objects more easily since we won't want to necessarily have to create every dependency just to test it.

### Spring Autowire

JVMs have Spring Containers.  Each spring container has objects that whose lifetimes are maintained called spring beans.  Use the @Component annotation.

Spring beans have two scopes: Singleton and prototype.  By default, spring uses singletons and if you request two beans of class A, it will give you the same instance of A.

Singletons are created at startup

Prototypes are created only when the bean is asked for.

### Spring Boot

Focus on convention over configuration by setting up the boilerplate and common configs for you

Embedded server with jar file and embedded tomcat so you dont need to run an app server
Auto configuration
spring-boot-starter-*

