AWS Certified Solutions Architect
===================================

### Exam
130 min, 60 questions, multi choice, 70% to pass

### Overview
AWS Global structure is made up of compute, storage, and database components

2018: 19 regions, 57 availability zones

Region is a geographical area with 2+ availability zones.

Core exam areas: Network and content delivery; security, identity, compliance; compute; storage; databases

AZ consists of 1 or more data centers in different facilities.

Edge locations are endpoints for AWS used for caching content.

### Identity Access Management (IAM) 101

manage users and their access to the AWS console; granular control and permissions

Identity Federation (e.g., AD, FB, Linked in, etc)

Multifactor auth

Password compliance and rotation

Key Terms:

 1. Users 
 2. Groups
 3. Policies (docs in JSON which give permissions to users/groups)
 4. Roles

users are created from aws console on a global basis, not per AZ

Users have an access key ID and secret access key when first created; they are not the same as password; they are just used for programmatic access; you only get to view these once, so they should be stored safely

access key and secret access key allows for interaction with AWS but they do NOT allow for console login

### S3 101

object storage
files are in a bucket (a folder with universal namespace, so they must be unique)

files  are up to 5TB and can be 0 bytes

read after write consistency for PUTS of NEW objects (i.e., you see new contents of new files right away)

eventual consistency for overwrite PUTS and deletes (i.e., changes take time to propagate)

S3 is a key-value store

version ID and metadata, ACLs per file, torrenting.

SLA: 99.99% availability
11 9s durability

tiered storage
 1. Standard: 99.99% availability, 11 9s durability, sustains loss of 2 facilities
 2. IA (Infrequently accessed) - lower fee but are charged a retrieval fee
 3. One Zone -IA : lower cost, does not have multiple availability zone resiliance
 4. Glacier - very cheap for archival, very long retrieval time

Payment: Charged for storage, requests, storage management, transfers between regions, transfer accelerations

lifecycle management (e.g. after 30 days -> archive)

encryption

versioning

ACLs and bucket policies

READ THE S3 FAQ BEFORE THE EXAM***


### CloudFront CDN

Cloudfront caches content (website, images, media, application, etc.) at edge locations around the world.  This is faster b/c the distance travelled is closer instead of having to go all the way to the origin server.

How to host your website from a cloudfront distribution:                                
aws console -> Create Distribution -> Select an origin domain (should be your website endpoint URL) -> select protocol options and caching options -> Create certificate for SSL, it will also create a route53 record for you -> You can now paste the CDN domain name into a browser 

### EC2

#### EC2 101

Elastic Compute Cloud (Ec2)

Resizable compute capacity in the cloud.  Provision in minutes.  Pay for what you will use.

Pricing:

 * On demand: pay by some unit of time.  Low cost, little commitment.  Use if unclear about usage will be.
 * Reserved - a discounted long term contract.  Typically for steady/predictable usage.  Up front payments to reduce total computing costs
 * Spot - You place a bid on a price.  Variable pricing.
 * Dedicated Hosts - physical servers that we can use, that we can use our application licenses on.  Good to use if you're required not to have multi tenant virtualization.

EC2 Instance Types

Lots of them.  T2 is "lowest cost, general purpose".  I3 is "high speed storage" for databases.


EBS Elastic Block Storage - A virtual disk 

Allows virtual storage and attach them to ec2 instances.

SSD EBS Volume Types

 * General purpose SSD (GP2) - balances price and performance
 * Provisioned IPOS SSD (IO1) - DBs lots of IOPS

Magnetic EBS Volumne Types

 * Throughput Optimized HDD (ST1) - big data apps
 * Cold HDD (SC1) - Lowest cost storage for infreq. accessed workoads
 * Magnetic (Standard) - Legacy, cheapest cost per GB

#### Launch an EC2 instance

EC2 dashboard -> Launch Instance.  Choose AMI, hardware type, VPC, subnet/AZ,  storage type (eg SSD/magnetic), tags, security groups (open up ports to particular IP ranges), key pair.

Make sure to download the key so you can SSH into it later.

Security group is like a virtual firewall

Delete on termination is the default.  When you terminate an instance, the storage is also deleted.

One subnet kind of equates to one AZ.  Subnets cannot span multiple AZs.

Amazon Machine Image (AMI) - snapshots of machines that u can boot up.

Now we can ssh into our instance after it is provisioned.

#### Putty

AWS gives key pair as pem file.  Putty only accepts ppks.  We need to convert the pem to ppk.  Just open puttygen, open the pem file.  Then save the private key as ppk.

How to use the ppk in putty: Open putty, use the public dns or  public IP to connect.  Go into connections -> SSH -> Auth -> Specify the private key ppk file for auth.

#### Security Groups

ec2 dashboard -> network & security , security groups 

security group rules take effect immediately

What is the difference between a SG and a NACL?

* SGs are stateful, NACLs are stateless.  
* You cannot block specific IPs with SGs but NACLs can.  
* SGs specify allow rules, but not deny rules

Summary

* SG inbound traffic is blocked by default; outbound traffic is allowed by default
* Changes to SGs take effect immediately
* Can have any number of EC2 instances within a sec. group
* Can have multiple security groups attached to EC2 instances
* Security Groups are stateful (if you create an inbound rule allowing traffic in, that traffic is automatically allowed back out again)

#### EBS Volumes Lab

Instance and volume MUST be in the same AZ (or else the latency is too slow).

If you want to move a volume to another AZ, you need to create a snapshot and create a volume from the snapshot.

You can also create an image from an EBS snapshot.

Can create AMIs from instances or snapshots.

Summary

 * Volumes exist on EBS
 * Snapshots exist on S3
 * Snapshots are point in time copies of volumes
 * Snapshots are incremental (only changes since last snapshot are moved to S3)
 * should stop device before taking a snapshot of root volume even though you can take a snapshot while the instance is running
 * can create AMIs from EBS-backed instances and snapshots
 * can change EBS volume sizes on the fly including size and storage type
 * volumes will always be in the same AZ as the instance
 * to move a volume from one az to another, take a snapshot of an image of it, then copy it to the new AZ

##### Encrypt root device volume

Stop instance, create snapshot of the root volume

Now to create an ecrypted snapshot go to EC2 Dashboard -> Snapshots -> Create snapshot.  In the popup choose the encryption option and the appropriate AZ.

Now we can also create an image from this.  Go to the AZ.  Create snapshot -> Select snapshot -> Create image from snapshot.

Now the root device will be encrypted for this image.

Summary

* Should stop instance before snapshot
* Snapshots of encrypted volumes are automatically encrypted
* Volumes restored from encrypted snapshots are also encrypted
* Can share snapshots if they are unencrypted

#### AMIs - EBS Root Device Volumes vs. Instance Store

Two AMI types: EBS backed and Instance store backed. 

Instance store is also called emphemeral storage.  It is not as durable as EBS.

Can't attach additional instance store volumes AFTER creation of the ec2 instance.

You cannot actually stop an instance store instance.  But you can stop an EBS store instance.

EBS vs Instance Store

* All AMIs are either backed by EBS or instance store
* Root devices for an instance launched from the AMI is an EBS volume created from an EBS snapshot
* Root devices for an instance launched from the AMI is an instance store volume created from a template stored in S3.  This is why it takes longer to provision an instance store volume

Summary:

* Instance store volumes are called ephemeral storage
* instance store volumes cannot be stopped and if their underlying host fails, then the data is also lost
* EBS backed instances can be stopped and won't be lost
* You can reboot both and not lose your data
* By default root volumes are deleted on termination (whether ebs or instance store).  However, with EBS, you can tell AWS to keep the root volume.

#### Load Balancer

Types

* Application load balancer
* Network load balancers
* Classic Load Balancers (Referred to as ELBs??? These are being deprecated)

Application load balancers are for http/s traffic.

Network load balancers balance TCP (layer 4) traffic for extreme performance.

Classic Load balancers are legacy balancers.  They balance http/s applications and layer 4 tcp balancing.  So both.

Load Balancing Errors 504: application has stopped responding

X-Forwarded-For header: Because the load balancer will forwarded on the request, it still has to remember the client's IP, maybe the application needs the client's IP for tracking or some other purposes.  So this value is the public IP of the client.

Load balancers will never get public IPs - only DNS names, b/c their IPs are not static.

##### Load balancers and Health Checks

Create load balancer: Ec2 dashboard -> Load balancers -> Create an application load balancer.

When you get to a "configure health check" page in the create wizard, just point it to a html page (using HTTP/80) such as a newly created /healthcheck.html.  It can have anything in it.  

You will need to add EC2 instances to the load balancer.

When the instance's health check fails, the LB will stop sending load to that instance.

#### Cloudwatch

You can use cloudwatch to create a dashboard, alarms, and view metrics.  You can also set monitored events to help you perform actions that trigger lambda functions.

There is standard (every 5 min) and detailed monitoring (every 1 min).

Cloudwatch vs. Cloudtrail.  Cloudwatch is for logging, cloudtrail is for auditing the aws system. (??? Auditing is logging)

#### AWS CLI

Amazon Linux AMI already has the AWS CLI installed.

"aws" tool is the binary you will use from CLI.

eg: aws s3 ls // s3 is the service, ls is the command

To use aws, you need to `aws configure`.  You will need your access key and secret access key and also provide your region.

`aws <service> help` for help

vim ~/.aws/credentials // your access key and secret access key

#### IAM Roles with EC2

Roles are global! They are not particular to a region.

Problem to solve: Storing your credentials in the aws config directory of an EC2 instance is bad because if the machine is compromised u have to change your credentials.  Further, if you have many instances, you have to change the credentials on all the machines.  It's easier to manage if your instances just all use a role and then the credentials won't need to be stored on each instance.

#### S3 CLI & Regions

If you use the CLI to download a file from an S3 bucket, it will download the file if it's in the same region as the ec2 instance.  If it's not, you simply have to  add a --region argument.

Buckets are private by default. You should add an role to it. 

Basically the lab is to create a bash script that updates yum, runs httpd, and downloads a file from s3 and put it in the /var/www/html dir.  The host then checks that the new file is publically accessible on the internet.

The bash script is created in the "3. configure instance" step of the ec2 creation wizard under "advanced details"

#### EC2 Instance Metadata

Can access ec2 metadata from the command line.  

ssh into the ec2 instance.  Then "curl http://169.254.169.254/latest/meta-data" to get the metadata you can get via commands

E.g. "curl http://169.254.169.254/latest/meta-data/public-ipv4" for instance will return the ip address and u can write it out to a file.

#### Autoscaling Groups Lab (Should review this)

autoscaling will put a different instance in a different AZ.

scaling policies: scales the number of instances in your autoscaling group.  For example, if CPU usage is too high for a certain amt of time.  These can be configured as alarms.  Increasing group size can be triggered upon alarm.

Load balancer tells which instances are alive in the  autoscaling group by using the health checks.

If you terminate an instance within the AG, the  alarm will cause an another instance to be brought up.

#### EC2 Placement Groups

Two types:

 1. Clustered placement group (cluster in single AZ; need low latency and high throughput)
 2. Spread Placement group (instances on distinct hardware and AZs)

"Placement group" without distinguishing which type means the clustered placement group because that's the oldest.

#### Elastic File System Lab

Amazon Elastic File storage (EFS) service is for EC2 instances

***Need to fill this out***

#### Lambda

#### Serverless webpage

#### Serverless Courses on ACG


#### Autoscaling Groups

### Route53

Route53 is Amazon's DNS service.  Port 53 is a DNS port.

NS Record: Name server record used by TLD to direct traffic to content DNS server which contains the authoritatiive DNS record

Start of Authority Record (SOA):  Info stored in a DNS zone about that zone.  DNS zone is the part of a domain for which an individual DNS server is responsible (A records, CNAMEs, etc.).  Each zone has a single SOA record. Contains name of server, administrator of the zone, current version of data file, TTL of resource records

A (Address) record: fundamental type of DNS record.  A = Address.  Domain -> IP mapping

CNAME: Canonical name: Resolve one domain name to another.  E.g., http://m.domain.com -> http://mobile.domain.com to resolve to the same address.  CNAMEs can't be naked domain names (ie domains that are basically www.domain.com or http://domain.com)

"A CNAME record assigns an alias name to a canonical name"

Alias Record (Unique to Route53): map resource record sets in your hosted zone to Elastic Load Balancers, CloudFront distributions, or S3 buckets that are configured as websites.  You can map one DNS to another, like CNAME records: e.g., example.com -> elb1234.elb.amazonaws.com.  Key difference: CNAMEs can't be used for naked domain names (zone apex record).  You can't have a CNAME for http://acloud.guru, it must either be an A record or an Alias.

ELBs don't have IP4 addresses, you resolve to them via DNS name

MX Records: Mail server records

PTR Records: Reverse lookups, verify that you own the domain name (?)

Can manage up to 50 domain names with Route53 before needing to upgrade

#### Registering a Domain Name

AWS Console -> Route 53 -> Regisiter Domain Name

Hosted Zones page will let you see the record sets.

Example:

    Create EC2 instances.  In the EC2 instances page, you will see the IP4 public IP of your instances.  Assuming you're running apache httpd, then you can use this to view your website.

#### Routing Policies

 1. Simple
 2. Weighted
 3. Latency
 4. Failover
 5. Geolocation

##### Simple Routing
This is the default, commonly used for a single resource/web server

Client hits route53 which routes the request to the ec2 instance in your region

Example: Create alias record set that points the naked domain name to your ELB which can later point to the two instances in your zone

Simple routing will cause the ELB (?) to do a round robin on the EC2 instances that it points to, if there are multiple EC2 instances in your zone (?)

Does not (?) do health checks.  For health checks use multi value answers

##### Weighted Routing

Route53 can make, for example, 20% of traffic go to US-EAST-1 and 80% of the traffic to US-WEST-1

##### Latency Based Routing

User will hit the region with the lowest response time

Create a record set with latency based routing for each zone.  You can test that it will route you to the lowest latency (closest) ec2 by using a VPN to pretend to be anywhere in the world to experience different response times for each zone

#### Failover Routing

For active-passive setups

Health check may determine a site is down and route you to the secondary backup, called the passive AZ

First need to create a health check (e.g., check 3 times that it's up)

Then create an alias with the hostname and the health check you created as well as the failover routing and mark the Ec2 instance (?) as the active.  Then create another alias for the passive.

##### Geolocation Routing policy

Looks at the originating geographic location of the request

Policy routes to the nearest AZ

##### Multivalue answers

Random routing to multiple record sets that are healthy.  Route53 can respond with up to 8 DNS servers per DNS query

### Databases

Aurora: Amazon's RDBMS w/ mysql and postgres flavors

Data warehousing for large complex data sets and business intelligence.  Has tools e.g., cognos, jaspersoft, sql server reporting services, oracle hyperion, sap netweaver

OLTP: Online transaction processing.  E.g., Pull up a row of data.

OLAP: Online analytics processing.  E.g., Answers a lot of analytic questions.  Like sales per region, prices per region, etc.

Elasticache - In memory cache in the cloud.  
Supports two caching engines:

 1. Memcached
 2. Redis

RDS - OLTP database types supported by Amazon:

 1. sql server 
 2. mysql
 3. postgresql
 4. oracle
 5. aurora
 6. mariadb

NoSQL:

 1. DynamoDB

OLAP

 1. RedShift

#### RDS

RDS -> dashboard -> launch instance -> choose DB engine (eg mysql) -> choose the DB instance class (hardware profile) -> set options -> make sure to create a new VPC security group -> select DB name, backup schedule.  Create EC2 instance with apache HTTPD running.  Now we can configure the EC2 instance to use a DB connect string to point to the RDS instance.

At this point the EC2 instance still can't talk w/ the RDS instance.  We need to add the EC2 instance's security group to the RDS's inbound rule and allow it (whitelist it).

RDS -> security group -> inbound rules -> mysql/aurora rules -> add the security group of the EC2 instance to whitelist the EC2 instance.

#### RDS - Backups, Multi-AZ, and Read Replicas

##### Automated backups

Enabled by default

Done automatically during some window

##### Snapshot backup

Manually initiated

##### Restoring Backups

Backups do not appear to be  files, rather restoring an automatic backup or manual snapshot causes there to be a new RDS instance with a new DNS endpoint.]

original.eu-west-1...

restored.eu-west-1...

##### Encrypted Backups

RDS dashboard -> instances -> restore to point in time

RDS dashboard -> instances -> take DB snapshot

RDS dashboard -> snapshots -> Make a copy -> In the options choose enable encryption

##### Multi-AZ

Multi-AZ is for disaster recovery

Imagine we have multiple EC2 instances pointing to a single RDS database in US-EAST-1A.  These changes are replicated to US-EAST-1B for recovery purposes.

If your RDS fails over, just know that the RDS endpoint is always a logical endpoint and not an IP, so it can begin pointing to a new RDS instance after failover.

Multi_AZ RDS: has a copy of the DB in another AZ.  AWS handles the replication and synchronization.  AWS handles automatic failover to the slave.

##### Read replicas

Read replicas are for performance improvements.

Multiple EC2 instances are pointing to a single RDS instance and the RDS instance is connected to other read replicas.  Now the other EC2 instances can talk with the read replicas in other to distribute the load.  These read replicas are read-only to scale out.

You can put RRs in other AZs

RRs used for scaling not for DR.

Automatic backups must be turned on in order to use RR.

Each RR has its own DNS endpoint.

Creating a RR:

rds dashboard -> instances -> Create read replica -> Choose options (AZ, encryption, etc)

Another way to create multi-az: instances -> modify DB instance -> Enable multi-az deployment


#### Dynamo DB

Amazon's NoSQL DB.  Supports docs and key-value.  Single-digit millisecond latency.

SSD Storage; Spread across 3 facilitie; Eventual Consistent Reads; Strongly Consistent Reads.

Dynamo DB appears to be distinct from RDS!!!

Easy to scale because it has push-button-scaling.  You can monitor your provisioned and consumed read/write units.  You can adjust your provisioning with a push of a button without downtown.  RDS will experience downtown when you change instance size classes. 

Has two consistency options:

 1. Eventual Consistent Reads (default) : Consistency across all copies of data w/i one second
 2. Strongly Consistent Reads : returns result that reflects all writes that were received prior to the read.

##### Pricing

Based on write and read throughput.

Storage costs per GB too.

#### Redshift

data warehouse service in the cloud.  Keyword: OLAP transactions and data warehousing!

data warehousing adds up tons of columns, so it uses a diff. architecture.  Columnar data storage for aggregates

Advanced compression, similar data is sequential

Doesn't require indexes or materialized views, so uses less space

Configurations

 * Single node 160 GB
 * Multi-Node : Leader node (handles connections and queries), Compute Node (workers, slave to the leader)

#### Elasticache

Caches things in an in-memory DB.  Good for read-heavy workloads.

Engines:

 1. Memcached
 2. Redis (key-value w/ sorted states and lists)

#### Aurora

Amazon's RDBMS

Scaling: 2 copies of data stored in each AZ, with minimum of 3 AZs.  This means you have at least 6 copies of your data.

highly redundant for availability.  

can create aurora DBs from the RDS dashboard.  You can also select an aurora instance and go to instance actions -> create replica for replicas.  The options screen allows selection of multi-AZ options.

#### Summary

RDS for OLTP

DynamoDB for No SQL

RedShift for OLAP

Elasticache for in-memory caching

Multi-AZ allows an RDS instance to failover to an RDS instance to a synchronous replicated to another RDS instance in another AZ.

Read replicas of your production database allow it so that your EC2 instances read from the read replicas of the primary.

DynamoDB has push button scaling whereas RDS requires downtime to scale.


### VPC

Amazon virtual private cloud (VPC) lets you provision a logically isolated section of the AWS cloud where u can launch resources in a virtual network that you define.  You control the network, IP range, creation of subnets, routing tables, and gateways.

Can choose which subnets in your VPC can access internet (public) and which are private.

Internet gateway provides internet access.  Virtual Private Gateway is like our VPN.

Actions on VPCs:

 1. launch an instance on a subnet
 2. assign IP ranges to subnets
 3. config route tables between subnets
 4. attach internet gatewayys to VPCs
 5. NACLs for security

You can create a hardware virtual private network (VPN) connection between corporate datacenter and your VPC to extend your corporate data center.  (???)

VPC consists of IGWs (or virtual private gateways), route tables, network access control lists, subnets, and security groups

1 subnet is for 1 AZ.  In AWS, subnets cannot be used across AZs.

Two types of VPCs:

 1. Default VPC - subnets are publicly available to internet, each ec2 instance has public and a private IP addr.
 2. Custom VPC - private subnets have private IPs

VPC Peering

 * VPCs can connect to other VPCs in other AZs or with other AWS accounts
 * Instance inside one subnet of VPC_a can talk w/ another instance inside a subnet of another VPC_b
 * No transitive peering! Need a direct connection to the VPC you want to "peer" with.

#### Build a custom VPC

VPC dashboard -> Your VPCs -> Create VPC.  Give it a tag and IP range (eg 10.0.0.0/16 which is the biggest available (from aws?)). 

Creating a VPC will create a default network ACL, a default VPC security group, and a new route table.  It will not create new subnets.

##### Add subnets

VPC Dashboard -> Subnets -> Create subnet.  Give it a name (tag), choose the VPC, AZ, IP range (eg 10.0.1.0/24 public and 10.0.2.0/24 private)

Creating an address range will not give u the full range.  AWS actually reserves ~5 IPs.

##### Add Internet Gateway for internet connectivity

VPC Dashboard -> Internet Gateways -> Create internet gateway

Give it a name and attach it to a VPC.

You cannot have multiple IGWs per VPC.

Default subnets (???) are connected to the main route table, so we don't want to provide internet accessibility to our main route table because our private subnets shouldn't get access to the internet.  Therefore, we will create a new route table and individually assign subnets to this route table.

VPC Dashboard -> Route tables -> Create route table.  Give it a name and select the VPC to associate it with.  Enable internet access by going to t he Routes tab.  Add a destination IP range (eg 0.0.0.0/0 to indicate all outbound traffic) and select the target which should be the IGW so select the IGW.  For ipv6 use the destination IP range "::/0" and select the IGW.

Now assign our public subnet to the new public route table.  VPC Dashboard -> Route tables -> Subnet Associations tab.  Just select the multiple subnets you want to associate with this route table and hit save.

Now we need to make it so our public subnet has EC2 instances that are automatically assigned public IP addresses.  VPC Dashboard -> Subnets -> select the public subnet you want -> subnet actions -> Modify auto assign IP settings -> enable auto assign public ipv4 addresses.

Now we can provision EC2 instances for the public subnet.  EC2 Dashboard -> Launch Instance.  Make sure to choose your custom VPC for the network and also the correct public subnet.  Security groups don't span VPCs so you will need to create a new security group. 

Now you should be able to remote in from the internet to your ec2 instance on the public subnet.

Now let's turn the private EC2 instance into a private database server.  

Create a new security group for the private database server: Security Groups -> Create Security Groups -> Add inbound rules for ssh, mysql, http, https, all icmp ipv4 (for pinging) and change the source of these rules to the public subnet (eg 10.0.1.0/24).

Now put the private EC2 instance on the RDS private security group we just created. To SSH into here, you'll need to put the private key on the EC2 instance on the public subnet.  Then from the public EC2 instance, SSH into the private instance.

#### NAT instances & NAT gateways

// NEED TO REVIEW AND GO IN DEPTH

NAT is to provide internet traffice to an EC2 instances in private subnets

NAT instance must be able to send and receive traffic when the source or destination is not iteslf.  Therefore you must disable source/destination checks on the NAT instance. EC2 instances -> actions -> disable source/destination checks (???)

NAT gateway was created to automate scaling, get rid of nat instances that only work in single availability zones.

NAT Gateways are much more preferred

NAT Instances Summary

 * Disable src/dest checks on nat instance
 * must be on public subnet
 * Must be a route out of the private subnet to the NAT instance in order for private instances to talk with the NAT
 * amount of traffic that NAT instances can support depends on the instance size (hardware profile) so incr hardware specs if bottlenecking
 *  High availability using autoscaling groups, multiple subnets in different AZs and a script to automate failover
 *  NAT instances are behind a security group

NAT Gateways Summary

 * Preferred over NAT instances
 * Scale automatically to 10Gbps
 * No need to patch
 * Not assoc. with security groups
 * Automatically assigned a public IP addr
 * Update your route tables to point to all the NAT gateways of the multiple AZs
 * No need to disable src/dest checks
 * More secure than NAT instances

#### Network access control lists (NACLs)

// NEED REVIEW AND TO GO IN DEPTH

We had a default NACL created when we created the VPC.  

Create a new NACL: VPC Dashboard -> NACLs -> Create NACL.  Give it a tag name and assign a VPC.  Since this is a private custom NACL, it DENYs everything by default.

Now lets customize our NACL.  Allow http, https, ssh. Deny everything else and to specific IPs.

NACLs can block specific IPs, but SGs cannot.

Summary

 * VPCs have a default NACL which allows all out/in bound traffic
 * Only custom NACLs deny all in/out bound traffic until you add rules
 * Each subnet in the VPC must be associated with a NACL and if you don't manually assoc. one, then the subnet is automatically  associated with the default NACL
 * You can assoc. a NACL with multiple subnets however a subnet can only be assoced with one NACL at a time.
 * NACL rules are evaluated in order from lowest numbered rule
 * NACL rules can either allow or deny rules
 * Make sure to allow ephemeral ports on outbound ports 

#### Custom VPCs and ELBs

AWS Services -> EC2 -> Load Balancing -> Load Balancers

3 types of load balancers to create

 1. http/s (application load balancer)
 2. tcp (network load balancer)
 3. prev. generation

Choose an application load balancer.  Select a VPC and at least two public subnets in different AZs.

#### VPC Flow Logs

Capture info about IP traffic going to/from VPC

Stored using **amazon cloudwatch logs**

Can be created at 3 levels:

 1. VPC
 2. Subnet
 3. Network interface level

First need to create a log group
AWS Console -> CloudWatch -> Logs -> Log groups.  Create a log group (just name it, and that's it)

Next create the flow log: VPC Dashboard -> Your VPCs -> actions -> Create Flow Log.  Create filter and IAM role (allows logging to cloud watch) and then choose a log group (the one we just created)

Summary:

 * Cannot enable flow logs for VPCs peered with your VPC
 * can't tag a flow log
 * can't change a config of a flow log after it's created
 * Not all IP traffic is monitored

#### NAT vs. Bastion Server

Bastian is also called a jump server.  The idea is that you don't need to harden a bunch of instances just to be able to ssh into it and then ssh into a private subnet instance.

Summary

 * NAT is to provide internet traffice to an EC2 instances in private subnets
 * Bastion is used to securely administer EC2 instances (eg ssh or rdp) in private subnets


#### VPC Endpoints

// REVIEW

Scenario: S3 is outside the VPC and our data must traverse the internet.  We want to put an S3 service in our VPC so we don't have to traverse the internet.

IAM -> Roles -> Ec2.  Create a role.  Create a role for Ec2 and allow them to communicate with S3 on our behalf, so select a S3FullAccess policy.

Go to EC2 dashboard -> instances.  Actions -> Instance settings -> attach/replace IAM Role.  Select our S3 role.

VPC Dashboard -> NACLs -> Go to default NACL and associate the subnet with the default NACL

Endpoints come in two varieties

 1. Interface: Elastic network interface (ENI) serves as entry point for traffic destined to a service
 2. Gateway: Similar to nat gateway. (???)

Create endpoint: Endpoints -> Create Endpoint.  Select AWS S3 gateway endpoint.  Associate it with the main route table for the private subnet.

Now we've successfully replaced our NAT gateway with a VPC endpoint gateway for our private network.  So now traffic only goes to our private network to get to S3, not the internet.

#### VPC Cleanup

delete instances, internet gateways, nat gateways, endpoints

detach them as well.

delete vpc.

#### VPC Summary

What we built: Custom VPC with pub and private subnets.  The private subnet accessed the internet via a NAT gateway found in the public subnet.  We had an internet gateway for the public subnet to communicate to the internet.  We had  NACLs and routing tables.

NAT instances:

 * disable src/dest check
 * must be on pub SN
 * increase instance size if bottlenecking
 * High availability (HA) using autoscaling groups, multiple subnets in different AZs, scripts to automate failover.
 * always behind a security group

NAT gateways:

 * preferred over instances
 * auto scaling
 * no need to patch
 * not assoc with sec. groups (SGs)
 * auto assigned pub ip address
 * must update route tables
 * no need to disable src/dest checks
 * more secure than NAT instances

NACLs

 * default allows all traffic
 * custom NACL denies all traffic
 * each subnet must be assoc'ed with a NACL, else assoc'ed with the default NACL
 * NACL has rules executed in order
 * Block IP addresses using NACLs. You cannot do this using Security Groups

Application Load Balancers

 * Need 2 public subnets to deploy an application load balancer

VPC Flow Logs

 * Cannot enable flow logs for VPCs peered with your VPC unless the peer VPC is in your acct
 * cannot tag a flow log
 * after creating a flow log u can't change its config
 * Not all IP traffic is monitored


### Application Services

#### SQS

#### SWF

#### SNS

#### Elastic Transcoder

#### API Gateway

#### Kinesis

