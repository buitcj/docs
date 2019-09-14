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

### Common annotations

@Component marks class as a bean for component scanning
@Repository is a speicalized version of @Component that marks something as a DAO
@Service is the same as @Component but it also specifies intent
@Controller marks a class as a Spring Web MVC controller.  Allows us to use @RequestMapping

@Bean is different from @Component in that @Bean is a method-level annotation whereas @Component is a class-level annotation.  Generally you use @Bean for methods that will return an object that you want spring to register as a bean in application context.  You would do this if you component scanning is not an option, for example, wiring components from 3rd party libraries that you cannot annotate.

### Spring Boot

Focus on convention over configuration by setting up the boilerplate and common configs for you

Embedded server with jar file and embedded tomcat so you dont need to run an app server
Auto configuration
spring-boot-starter-*

