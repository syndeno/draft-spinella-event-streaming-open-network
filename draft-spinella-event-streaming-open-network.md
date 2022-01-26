---
title: "Event Streaming Open Network"
abbrev: "ESON"
category: info

docname: draft-spinella-event-streaming-open-network-latest
ipr: trust200902
area: TBD
workgroup: TBD
keyword: Internet-Draft
venue:
  group: TBD
  type: TBD
  mail: TBD
  arch: TBD
  github: syndeno/draft-spinella-event-streaming-open-network
  latest: https://example.com/LATEST

stand_alone: yes
smart_quotes: no
pi: [toc, sortrefs, symrefs]

author:
 -
    name: "Emiliano Spinella"
    organization: Syndeno
    email: "emilianofs@gmail.com"

normative:

informative:


--- abstract

This document describes an architecture and network protocol for an Event Streaming Open Network.

--- middle

# Introduction

According to Urquhart (Urquhart, 2021), Event Streaming plays a key role in how the economic system evolves. Society is rapidly digitalizing and automating the exchanges of value that constitute the economy. Also, considerable time and energy is spent to assure that key transactions can be executed with reduced human involvement with better, faster, and more accurate results.

However, most of the integrations executed today across organizational boundaries are not in real time and they currently require employing mostly proprietary formats and protocols. On the other hand, some industries have adopted data formats for exchanging information between organizations, such as Electronic Data Interchange (EDI). However, those integrations are limited to specific use cases and represent a small fraction of all needed organizational integrations. 

Even when application programming interfaces exist for event streaming, these are largely proprietary. For instance, Twitter offers an API for consuming social media streams, but it is not implemented by other parties. Thus, there is no consistent and common consensus on a mechanism for the exchange of events across organizations. This results in a completely custom landscape for real-time cross-organization integration. In this scenario, development teams must invest plenty of time into understanding and defining a common interface for data exchange.

In this context, we can now introduce how this landscape would radically change with the adoption of an Event Streaming Open Network. When needing to integrate real-time information across organizations, developers would have a common basis for finding, publishing, and subscribing to event streams. Also, given a set of standard formats to encode and transmit events, developers could use the programming language of their choice. 

Overall, this set of standards would drastically reduce the cost of real-time integration, which would also enable experimentation by users. This experimentation can create an innovation space for new uses of event streaming. 

# Conventions and Definitions

{::boilerplate bcp14-tagged}

## 1. Necessities for broad Event Streaming adoption
In this section, we will describe the main needs for the broad adoption of Event Streaming. The focus will be made on detecting and describing the missing capabilities that could not only enable but also accelerate the event data integration among different organizations. The different necessities detailed in this section will serve as input for an architecture design.

### 1.1. Necessity 1: Availability of an Events Public Registry
A public registry of an organization’s available event streams does not exist. We will argue in this section why this is the core component that an Event Streaming Open Network can provide.

Nowadays, when an organization needs to publish an event stream or event flow, they usually follow some form of the following steps:

1. Develop and deploy a producer application that writes events to a queue.
2. Create all necessary networking permissions for external public access to the queue.
3. Inform the remote user the access information (i.e., Hostname/IP, protocol, and port) together with the required client details and technology for accessing the stream (i.e., Apache Kafka Protocol, RabbitMQ API, etc.).
4. Create credentials for consumer authentication and authorization access to the queue.
5.Develop and deploy a consumer application that reads the queue.

Now, we can compare this process to a simple email interaction:
1. Sender opens a graphical Mail User Agent application and sends an email to an email address formatted as user@domain.
2. The message is sent to an SMTP server that routes it to the destination SMTP servers for the given domain. Once received, the message is put into the user mailbox.
3. When the recipient checks its mailbox by IMAP or POP3, the new email is transferred to the Mail User Agent.

In these two scenarios, we can see that the information needed to be exchanged offline by the actors is completely different in size and content. 

First, in the case of email, there is a shared naming space given by the Domain Name Service (DNS). The email format has been standardized by the IETF in RFC 5321, section 2.3.11. Thus, there is a common naming space that is used for referencing mailboxes in the format user@domain. Thus, the offline details communicated by the peers is only the recipient email address. There is no analogous standard nor an open alternative for Event Streaming.

Therefore, in the case of Event Streaming, users need to perform plenty of offline communication to agree not only on the technology to use but also on the queue to use. For instance, two organizations may be currently using Apache Kafka and need to share an event stream among themselves. The organization having the source of the stream should provide the following details to the consumer organization:
* Bootstrap servers: Fully Qualified Domain Name list of the Apache Kafka brokers to start the connection to the Apache Kafka Brokers. Example: tcp://kf1.cluster.emiliano.ar:9092, tcp://kf2.cluster.emiliano.ar:9092, tcp://kf3.cluster.emiliano.ar:9092
* Topic or Queue name: name of the topic resource in the Apache Kafka Cluster
* Authentication information: User and password, TLS Certificate, etc.

In the case these organizations were not both using Apache Kafka, the use case cannot be simply solved without incurring in development or complex configurations as well as adopting proprietary components.

We can conclude that an Event Streaming Open Network should provide a global accessible URI for streams in a similar fashion than email, to reduce offline developers’ interactions. This means being able to name event streams in a common naming space like DNS, as well as providing a mechanism for users to discover the location and connections requirements.

### 1.2. Necessity 2: Establishment of a User Space for Events
Another need for broad adoption is due to the inexistence of a common and agreed user convention. In the general literature, we cannot find reference to the types of users that would consume or produce events to and from an event stream. 

In this sense, it is also appropriate to consider the email use case. Basically, an email user only needs to know the email address, the password, the URL of a web mail client or the details of IMAP/POP3 server connection. Once the user has this information, it’s possible to access an email space or mailbox where the user can navigate the emails in it. Also, IMAP provides the possibility for the user to create folders and optionally share them with other users.

There is no analogous service currently available for Event Streaming analogous to the email case. This means that the user concept in Event Streaming is limited to authentication and authorization. Thus, the user does not have access to a “streambox”. The result is the impossibility for a person or an application to possess a home directory containing all the streams owned by the user.

As a conclusion for this section, we can mention that it is necessary to embrace a user space resource for Event Streaming. This resource should not only solve the users’ motivations and requirements but also reduce the offline verbal communications and custom development dependencies. In the next sections, we will refer to this component as the Event User Space Service.


### 1.3. Necessity 3: An Agnostic Subscription Protocol
A third need for wide adoption is an agnostic protocol to manage subscriptions to event streams. For this need to be solved, it would be necessary first to count with an Event User Space Service. Then, in case a user has created a stream and wants to enable public subscriptions by other users, there is no general protocol to inform other parties of this subscription intention nor its confirmation. 

The result is the inability for the users to seamlessly subscribe to an event stream. They either must employ protocols like MQTT or, in the need of employing other application protocols like Apache Kafka, hardcode the subscription details in the different software implementations. This means that there is no general subscription protocol for Event Streaming that is agnostic of the application protocol employed. This protocol implements both the Metadata Payload Format and Payload Format.

A good example to illustrate the difference between a control protocol that implements a Metadata Payload Format from a payload protocol that implements a Payload Format is how SIP (Session Initiation Protocol) works with RTP (Real Time Protocol) to provide VoIP capabilities. The former is a control protocol that initiates and maintains a session or call while the latter is the one responsible for carrying the payloads, which in the case of VoIP it would be coded audio.

Consequently, a similar definition of protocols could potentially mitigate this limitation for Event Streaming. If a protocol can be used to establish and maintain the subscriptions relationships while another different protocol is used for the events payload, all the current application protocols implementations could be supported. 

Additionally, by counting also with an Event Streaming Public Registry, it would be possible to provide URI for streams in a similar way as email works with the “mailto” URI. For instance, in web pages one can find that email addresses are linked to mailto URIs which, when clicked, open the default email user application (i.e., Microsoft Outlook) to send an email to the referenced email address.

If a user counts with a user space or streambox, then a user application like an email client could provide access to it. Then, if the user clicks on a link of a stream URI (i.e. “stream:myeventflow”), the streambox application would open and subscribe to the given stream.

Currently, the Metadata Payload Format as well as the Payload Format are both provided by the queue or log application protocol. In the case of Apache Kafka, both formats are implemented within the Apache Kafka Protocol. This introduces a barrier for interoperability among different technologies, meaning that flows of event data cannot be seamlessly connected, without relying on custom development or proprietary software licensing.

We can conclude that there is an actual need for an open specification of an Event Subscription Service for event streams, which implements what Urquhart calls Metadata Payload Format. This specification could be materialized in a network protocol that introduces an abstraction for the event queue or log technologies implemented by different organizations. 

### 1.4. Necessity 4: An Open Cross-sector Payload Format
Currently, the different implementations of Event Streaming combine both the Payload Format with the Metadata Format. This means that the same protocol utilized for payload transport is used for subscription management.

When a producer intends to publish events to a queue or, using Apache Kafka terminology, when a producer intends to write records to a topic, first it needs to initiate a connection to at least one of the Apache Kafka Brokers. In that initial exchange of TCP packages, the producer is authenticated, authorized, and informed with topic details. This set of transactions would belong to a protocol that implements a Metadata Payload Format. Afterwards, when the Producer starts writing the events to the topic, it encapsulates the event payload in a Kafka Protocol message. This latter behavior makes use of a Payload Format. Thus, we can observe how both theoretical formats are coupled in a single protocol. Similar behavior of a coupled Metadata and Payload Format in one single protocol happens also in AMQP, MQTT and RabbitMQ.

As for the consumer, the behavior is the same with the difference that the initial intention is to subscribe to a queue or, in Apache Kafka terminology, to consume records of a topic. Then, a set of TCP packages encapsulating the Apache Kafka protocol authenticates, authorizes, and informs the Consumer with topic details for consumption. Afterwards, the consumer can start polling for new records in the different partitions of the topic. It is worth mentioning that the consumer needs to implement more queue management logic than the Producer, especially when multiple replicas of a consumer type are deployed.

If we focus on the Payload Format, there is the need for an implementation-agnostic payload format suitable for Event Streaming. In this sense, CloudEvents project of the CNCF proposes a specification and a set of libraries for this purpose. The goal is to use CloudEvents specification as a Payload Format regardless of the Payload Protocol being used. For instance, we could transmit events in the CloudEvents format using the Kafka or AMQP Protocol. 

The general structure of the CloudEvents Payload Format includes a standardized methodology to include event data in an event message. For instance, instead of defining a customized JSON structure for sending the events of temperature changes measured by a device, a CloudEvent object could be used. Temperature could be included as an attribute in the CloudEvent object. 

We can then conclude that while there is no current protocol candidate that implements the Metadata Format, CloudEvents is a good candidate for the Payload Format needed in an Event Streaming Open Network. In this way, the different CloudEvents libraries made available in several programming could be leveraged.

## 2.	Event Streaming Open Network Architecture
In this section, we will describe the overall architectural proposal for an Event Streaming Open Network. This description will include the different actors in play, the software components required, as well as the network protocols that should be specificized.

### 2.1. Architecture overview
In Figure 7 we illustrate a high-level overview of an architecture proposal for the Open Network.
  
#####FIGURE######
  
We can identify different Network Participant (NP) in Figure 7 represented by different colors. The different NPs act as equals when consuming or producing events as part of the Flows they own. All of NPs implement the Event Streaming Open Network Protocol, which Is described in the next chapter.

In the diagram, an initial flow starts on the orange NP to which a user in the blue NP is subscribed. After processing the events received in the first flow, the results are published to a new flow in NP blue, to which the orange NP is subscribed as well. Now, the green participant is subscribed to the same flow, enabling downstream activities across the rest of the network participants.

It is possible to observe how the high-level architecture allows sharing the streaming of events across different network participants and their users. Also, there is also the need for security, in order to allow or deny the access to write to and read from flows.

  #####FIGURE######

Regarding security, the architecture considers the integration with an Identity & Access Management service, which could implement popular protocols such as OAuth, SAML or SASL. However, the network should also enable anonymous access in the same way FTP does. This means that a given NP could publicly publish flow and allow any party to subscribe to it.

For example, nowadays the Network Time Protocol (NTP) is used to synchronize the day and time on servers. There are many NTP servers available that allow anonymous access, meaning that the service is openly available. The same must be considered for the Event Streaming Open Network.

Additionally, the NP must be able to expand the capacity to support any number of flows, as well as extending the network with new services. Not only NP must be able to include any given set of data within events but also, they must be able to build applications and services on top of the network by employing the architecture primitives.

Now, we provide a brief description of all the components that appear in the diagram of Figure 8. In the next sections further details of the components are provided.

* Flow Events Broker (FEB): a high-available and fault-tolerant service that provide queues to be consumed by network services, by users, and their applications. An example of an Event Queue Broker can be Apache Kafka, AWS SQS or Google Cloud PubSub. The payload format implemented by these tools are what in 3.1.4 we called Event Streaming Payload Format.

* Flow Name Service (FNS): a DNS-based registry that acts as an authoritative server for a set of domain names, which are used to represent flow addresses in a flow namespace. These domains contain all the necessary information to resolve flow names into flow network locations. This component refers to what in 3.1.1 we named Event Streaming Registry.

* Flow Namespace User Agent (FNUA): an application similar to User Mail Agents like Microsoft Outlook or Gmail. This application provides access to flow namespaces to users of the network. 
The definition of this component implies the specification of a dedicated protocol. We will refer to this protocol as FNAP (Flow Namespace Accessing Protocol).

* Flow Namespace Accessing Agent (FNAA): the server-side of the Flow Namespace User Agent. This component is the one that must provide convenient integration methods for GUI. This component refers to what in 3.1.2 we named Event User Space Service.
This component must implement the same protocol selected for the Flow Namespace User Agent: FNAP (Flow Namespace Accessing Protocol).

* Flow Processor (FP): a flow processing instance used to set up subscriptions that connect local or remote flows on demand. This component implements the processing part of what in 3.1.3 we called Event Subscription Service. This component will be created and managed by a FNAA instance, and the communication is held through an Inter-process Communications (IPC) interface. Also, this service must implement an Event Payload Format, for which we will mainly consider CNCF’s CloudEvents and Protobuf.

* Flow Namespace Accessing Protocol (FNAP): the protocol implemented in the Flow Namespace Accessing Agent as well as in the Flow Namespace User Agent. The former will act both as a server and a client while the latter only as a client. This protocol is described in the next chapter.

#### 2.1.1. Flow Events Broker (FEB)
The FEB implementation that we will mostly consider is Apache Kafka. This open-source project is quickly becoming a commodity platform, and major cloud providers are building utilities for it. However, as a design decision, it should be possible to use the same protocols to support other applications, such as RabbitMQ, Apache Pulsar or the cloud-based options like AWS SQS or Azure Events Hub.

Apache Kafka is the ecosystem leader in the Event Streaming space, considering mainly adoption. There is a growing set of tools and vendors supporting its installation, operation, and consumption. This fact makes Apache Kafka much more appealing to enterprise developers. However, the broker should provide a common set of functionalities which can be seen in the diagram of Figure 9.

######FIGURE#########

The selection of the Events Broker will impact on the implementation of the Flow Namespace Accessing Agent. This last component will be responsible for knowing how to set up and manage flows on top of different Events Brokers.

#### 2.1.2. Flow Name Service (FNS)
FNS is a core component for the overall proposed architecture. This component provides all needed functionalities for obtaining Flow connection details based on a Flow URI (Uniform Resource Identifier). Thus, it is required to define a URI format for Flow resources and to specify mechanisms for resource location resolution.

In this section, we will focus on describing both the URI for Flow as well as the DNS mechanism for obtaining Flow network location details.

##### 2.1.2.1. Leveraging DNS infrastructure
As mentioned previously, this component must maximize its leverage on the existing Internet DNS infrastructure. The reason for this requirement is to avoid defining new protocols and services that prevent broad adoption. Currently, DNS is the de facto name resolution protocol for the Internet, and there exist libraries for its usage on every programming language. 

Whereas DNS is mainly used to resolve FQDN (Fully Qualified Domain Names) into IP addresses, there are many other functionalities provided by the global DNS infrastructure. Theoretically, DNS is an open network of a distributed database. Individuals and organizations that want to participate in the network need to register a domain name and set up Authoritative DNS servers for domains.

It is not in the scope of this work to detail the different available usages of DNS functionalities, but we can mention that it provides special Resource Records (i.e., types of information for a FQDN) that are solely used by special protocols. For instance, the MX Resource Records are used by SMTP servers to exchange email messages.

For the Flow Open Network, it will be required to define a URI format for flows as well as the mechanism to resolve an URI into all the needed information to connect to a flow. In the case of email, a URI is the email address while the connection details will be the SMTP server responsible for receiving emails for that account. For instance, an email URI could be user@domain.com while its connection details could be smtp://mail.domain.com. The way in which the connection details are obtained is by resolving the MX DNS Resource Records of domain.com, which in this example is mail.domain.com.

##### 2.1.2.2. Flow URI
As we mentioned previously, the first needed element is a URI definition for flow resources. These resources identification must capture the following details:
* Domain, a registered domain in which create flow resources references. For example, airport.com.
* Flow Namespace, a subdomain which is solely used by users to host flow names. This subdomain must be delegated to the Flow Name Server component and desirable should not be used for any other purpose other than flow.
* Flow Name, a name for each flow that must be unique within its domain. The combination of flow name and flow domain results in an FQDN. For instance, we could have a flow named arrivals of the domain flow.airport.com. Thus, the FQDN of the flow would be arrivals.flow.airport.com. Also, the name can contain dots so that the following FQDN could be also used: airline.arrivals.flow.airport.com.

Thus, the general syntax of a flow URI would be:
	
flow://<flow_name>.<flow_namespace>.<domain>

This URI has the advantage that is similar to “mailto” URI and could be implemented in HTML to refer to flow resources. Some examples: 

* flow://entrances.building.company.com
* flow://exits.building.company.com
* flow://temperature.house.mydomain.com
* flow://pressure.room1.office.mydomain.com

The flow URI must unequivocally identify a flow resource and provide, by means of DNS resolution mechanisms, all the information required to use the flow. Among these parameters, at least the following should be resolvable:

* Event Queue Broker protocol utilized by the flow. For instance, if Apache Kafka is used, the protocol would be “kafka”; In case RabbitMQ is used by the flow, “amqp”. Also, it must be informed if the protocol is protected by TLS.
* Event Queue Broker FQDN or list of FQDNs that resolve to the IP address of one or a set of the Event Queue Brokers. For instance, kafka-1.mycompany.com, kafka-2.mycompany.com.
* Event Queue Broker Port used by the Event Queue Brokers. For instance, in the case of Kafka: 9092, 9093.
* Event Queue Broker Transport Security Layer can be implemented. Thus, it is needed to know if the connection uses TLS before establishing it.
* Queue Name hosted in the Event Queue Broker, which must be equal to that of the corresponding flow name.

The general syntax of the Flow URI would be as follows:
  
flow://flowName.flowCategory.myNameSpace.domain.tld
  
* Flow Namespace FQDN: myNameSpace.domain.tld
* Flow Name: flowName.flowCategory
* Flow FQDN: flowName.flowCategory.myNameSpace.domain.tld

The following are examples of this URI Syntax:

flow://notifications.calendar.people.syndeno.com

* Flow Namespace FQDN: people.syndeno.com
* Flow Name: notifications.calendar
* Flow FQDN: notifications.calendar.people.syndeno.com

flow://created.invoice.finance.syndeno.com:
	
* Flow Namespace FQDN: finance.syndeno.com
* Flow Name: created.invoice
* Flow FQDN: created.invoice.finance.syndeno.com

##### 2.1.2.2. Flow name resolution

In Figure 10, we can see how a Flow FQDN can be resolved by means of the Flow Name Service.

  #####FIGURE####
  
In order to illustrate the Flow Name resolution procedure by the FNAA (Flow Namespace Accessing Agent), we can consider the following flow URI:

flow://notifications.calendar.people.syndeno.com

First, the FNAA will perform a query to the DNS resolvers. These will perform a recursive DNS query to obtain the authoritative name servers for the Flow Namespace: people.syndeno.com. Thus, the authoritative name servers for syndeno.com will reply with one or more NS Resource Record containing the FQDN for the authoritative name servers of people.syndeno.com.

Secondly, once these name servers are obtained, the FNUA will perform a PTR query on the Flow FQDN adding a service discovery prefix. The response of the PTR query will return another FQDN compliant with SRV DNS Resource Records (RFC-2782) and DNS Service Discovery (RFC-6763). 

In this case, the query for PTR records would be as follows:

	;; QUESTION SECTION:
	;notifications.calendar.people.syndeno.com.		IN	PTR

The response would be in the following form:

	;; ANSWER SECTION:
	notifications.calendar.people.syndeno.com. 21600 IN	PTR _flow._tcp.notifications.calendar.people.syndeno.com.

Using the FQDN returned by this query, an additional query asking for SRV records is made:

	;; QUESTION SECTION:
	;_flow._tcp.notifications.calendar.people.syndeno.com.		IN	SRV

	;; ANSWER SECTION:
	_flow._tcp.notifications.calendar.people.syndeno.com. 875 IN 	SRV	30 30 65432 fnaa.syndeno.com.
	_flow._tcp.notifications.calendar.people.syndeno.com. 875 IN TXT “tls”

	_queue._flow._tcp.notifications.calendar.people.syndeno.com. 875 IN 	SRV	30 30 9092 kafka.syndeno.com.
	_queue._flow._tcp.notifications.calendar.people.syndeno.com. 875 IN TXT “broker-type=kafka tls”

First, the response informs the network location of the FNAA server, in this case a connection should be opened to TCP port 65432 of the IP resulting of resolving fnaa.syndeno.com:

	;; QUESTION SECTION:
	;fnaa.syndeno.com.		IN	A

	;; ANSWER SECTION:
	fnaa.syndeno.com.	21600	IN	A	208.68.163.200

Secondly, this response offers other relevant information, like the TCP port where the queue service is located (9092). It also includes a TXT Resource Record that establishes the protocol of the Event Queue Broker, defined in the variable “broker-type=kafka”. 

Now, using the returned FQDN for the queue, kafka.syndeno.com, the resolver can perform an additional query:

	;; QUESTION SECTION:
	;kafka.syndeno.com.		IN	A

	;; ANSWER SECTION:
	kafka.syndeno.com.	21600	IN	A	208.68.163.218

	
#### 2.1.3. Flow Namespace Accessing Agent (FNAA)

The Flow Namespace Accessing Agent is the core component of a Network Participant. This server application implements the Flow Namespace Accessing Protocol that allows client connections.

In the diagram of Figure 11 we can see the different methods that the FNAA must support. 

####FIGURE####
	
The clients connecting to a FNAA server can be remote FNAA servers as well as FNUA. The rationale is that users of a NP connect to the FNAA by means of a FNUA. On the other hand, when a user triggers a new subscription creation, the FNAA of his NP must connect as client to a remote FNAA server.
	
#### 2.1.4. Flow Processor (FP)

Whenever a new subscription creation is triggered and all remote flow connection details are obtained, the FNAA needs to set up a Processor for it. The communications of the FNAA to and from the FP is by means of an IPC interface. This means that there can be different implementations of Processors, one of which will be the Subscription Processor. 

In the diagram of Figure 12, we can see the initial interface methods that should be implemented in a Flow Processor. 

#####FIGURE#####
	
Depending on the use of the processor, different data structures should be added to the different methods. In the case of a Subscription Processor, the minimum information will be the remote and local Flow connection details. Moreover, the interface also should include methods to update the Processor configuration and to destroy it, once a subscription is revoked. Finally, due to the nature of the stream communication, there could also be methods available to pause and to resume a Processor.
	
There can be different types of Processors, which we can see in Figure 13.
	
	####FIGURE####

In Figure 13, we can see that there are different types of Flow Processors:
* Bridge Processor: Consumes events from a Flow located in an Event Broker (i.e., Apache Kafka) and transcribes them to a single Flow (local or remote).
* Collector Processor: Consumes events from N Flows located in an Event Broker and transcribes the aggregate to a single Flow (local or remote).
* Distributor Processor: Consumes events from a single Flow and transcribes or broadcast to N Flows (local or remote).
* Signal Processor: Consumes events from N Flows and produces new events to N Flows (local or remote)

To implement the previously described Subscription Processor, we can utilize some form of the Bridge Processor. Although we are initially considering the basic use case of subscription, it must be possible for the network to extend the processor types supported. In any case, the different FNAA servers involved must be aware the supported processor types, with the goal of informing the users the capabilities available in the FNAA server. For instance, the fact that a FNAA supports the Bridge Processor should enable the subscription commands in the FNAA, for users to create subscriptions using the Bridge Processor.

In summary, the IPC interface should support all the possible processors that the network may need although we are initially considering the subscription use case.

#### 2.1.5. Flow Namespace User Agent (FNUA)
The FNUA is an application analogous to email clients such as Microsoft Office or Gmail. These applications implement either different network protocols to access mailboxes by means of IMAP and/or POP3. In the case of FNUA, the protocol implemented is the FNAP (Flow Namespace Accessing Protocol).

The FNUA is an application that acts as a client for the FNAA server. Only users that possess accounts in a Network Participant should be able to login to FNAA to manage Flow Namespaces. The FNUA could be any kind of user application: web application, desktop application, mobile application or even a cli tool.

In the Diagram of Figure 14 we can see the actions that the user can request to the FNUA.
	
####FIGURE####
	
The main goal of the FNUA is to provide the user with access to Flow Namespaces and the flows hosted in them. A user may have many Flow Namespace and many Flows in each of them. By means of the FNUA, the user can manage the Flow Namespaces and the Flows in them. Also, the FNUA will provide the capabilities required to subscribe to external Flows, whether local to the FNAA, local to the NP or remote (in a different NP FNAA server).

### 2.2. Communications Examples
In this section, two usage examples of Network Participants communications are provided. The first one, we call unidirectional, since one NP subscribes to a remote Flow of a different NP. The second one, we call it bidirectional, since now these NP have mutual subscriptions.

### 2.2.1. Unidirectional Subscription
		
####FIGURE####
	
In the diagram of Figure 15, we can see an integration between two NP. In this case, there is a FlowA hosted in the Orange NP to which the FlowB in the Blue NP is subscribed. Both FlowA and FlowB count with a queue hosted in the Flow Events Broker, which could be an Apache Kafka instance for example. However, it must be possible to employ any Flow Events Broker of the NP’s choice.

The steps followed to set up a subscription to a remote flow are:
1. A user of the Blue NP creates a new subscription to remote FlowA by means of the Flow Namespace User Agent (FNUA).
2. The FNUA connects to the Flow Namespace Accessing Agent (FNAA) of the Blue NP to inform the user request.
3. The FNAA in the Blue NP discovers the remote FNAA to which it must connect to obtain the flow connection parameters. First, it needs to authenticate and, if allowed, the connection parameters will be returned.
4. Once the FNAA in the Blue NP has all the necessary information, it will set up a new Processor that connects the flow in the Orange NP to a flow in the Blue NP.
5. Once the subscription is brought up, every time a Producer in the Orange NP writes an event to FlowA, the Flow Processor will receive it, since it is subscribed to it. Then, the Flow Processor will write that event to FlowB in the Blue NP.
6. From now on, every Consumer connected to FlowB will receive the events published on FlowA.

In case the user owner of FlowA in the Orange NP wishes to revoke the access, it must be able to do so by means of security credentials revoking against the Identity & Access Manager of the Orange NP.

### 2.2.2. Bidirectional Subscription
	
####FIGURE####
	
In Figure 16 we can see an example of all the components needed to set up a flow integration between two different NP. In this case, there are two flows being connected:
* FlowA of the Orange NP with FlowB of the Blue NP
* FlowC of the Blue NP with FlowD of the Orange NP

Each Flow has its corresponding Queue hosted in the NP Flow Events Broker. Also, there is one Flow Processor for each connection, meaning that these components are in charge of reading new events on source flows to write them to the destination flows as soon as received.

Also, we can see that in order to connect FlowB to FlowA, a connection from the Blue NP’s FNAA has been initiated against the Orange NP’s FNAA. This connection uses the FNAP to interchange the flow connection details. Analogously, the FNAA connection to set up the integration of FlowC with FlowD has been initiated by the Orange NP’s FNAA.

After the flow connection details are obtained, the different Flow Processors are set up to consume and produce events from and to the corresponding Queue in the different NPs.

Once the two processors are initialized, all the events produced to FlowA in the Orange NP will be forwarded to FlowB in the Blue NP; and all the events produced to FlowC in the Blue NP will be forwarder to FlowD in the Orange NP.

## 3. Event Streaming Open Network Protocol 
The protocol to be used in an Event Streaming Open Network is a key component of the overall architecture and design. This chapter is dedicated to thoroughly describe this protocol.

## 3.1. Protocol definition methodology
It is now necessary to specify the protocol needed for the Flow Namespace Accessing Agent or FNAA, which we have named the Flow Namespace Accessing Protocol or FNAP. In the diagram of Figure 17 we can see how an FNAA client connects with a FNAA server by means of the FNAP.
	
####FIGURE####
	
In order to define a finite state machine for the protocol and the different stimuli that cause a change of state, the model presented by M.Wild (Wild, 2013) in her paper “Guided Merging of Sequence Diagrams” will be employed. This model is beneficial since it provides an integrated method both for client and server maintaining the stimuli relationship that trigger a change of state in each component.

####FIGURE####
	
In Figure 18 we have the method proposed by Wild for SMTP, in which there are boxes representing states and arrows representing transitions. Each transition has a label composed of the originating stimulus that triggers the transition and a subsequent stimulus effect triggered by the transition itself. For instance, when a client connects to an SMTP Server, the client goes from “idle” state to “conPend” state. The label of this transition includes “uCon” as the stimulus triggering the transition, which triggers the effect “sCon”. Then, on the diagram for the server we can see that the “sCon” triggers the transition from “waiting” state to “accepting” state in the server. 

This method will be used to define the states and transitions for the Flow Namespace Accessing Protocol both for client and server.	

## 3.2. Flow Namespace Accessing Protocol (FNAP)
Using the model proposed by Wild described previously, we define the finite-state machine for the FNAA Server, which we can see in Figure 19.

####FIGURE####

The model in right side of Figure 19 shows that the FNAA server starts in a “waiting” state, which basically means that the server has successfully set up the networking requirements to accept client connections. Then, when a client connects, a transition is made to “accepting” state, in which internally the authentication procedure is made. If the authentication is successful, a transition is made to “ready” state, meaning that the client can now execute commands on the FNAA server. 

The commands that the client can execute are specified in Figure 11. For each command that the client executes, a transition is made to “cmdRecvd” state. Then, a response is returned to the client, transitioning again to “waiting” state. When the client executes the “Quit” command, a transition is made to the “waiting” state and the server must free all used networking resources for the now closed connection.

On the left side of Figure 19, we also have the client state machine with its corresponding transitions. The client triggers a connection to the server and once established, an authentication is needed. Once the authentication is correctly done, the client can start requesting commands to the server. For each command executed by the client, a transition is made to “cmdPend” state, until a response is returned by the server.

Eventually, a “Quit” command will be executed by the client and the connection will be closed. 

## 4. Implementation
In this section, we provide an approach for the overall implementation of the proposed Event Streaming Open Network. Considering the components defined previously for the architecture, we will define which existing tools can be leveraged and those that require development.

#### 4.1. Objectives
The objective of this implementation is to provide specifications for an initial implementation of the overall architecture for the Event Streaming Open Network. Whenever it is possible, existing tools should be leveraged. For those components that need development, a thorough specification is to be provided.
	
#### 4.2. Implementation overview
In Figure 20, we have a diagram of the overall implementation proposal. The components that have the Kubernetes Deployment icon are the ones to be managed by the FNAA server instance. Then, we have a Kafka Cluster that provides a Topic instance for each flow. Finally, the DNS Infrastructure is leveraged.
	
####FIGURE####

#### 4.3. Existing components	
In this section, we describe the existing software components that can be leveraged for implementation. 

##### 4.3.1. Flow Events Broker (FEB)
Since there are currently many implementations for this component, it is necessary to develop the needed integrations of other components of the architecture to the main market leaders. Thus, we will consider the following Flow Events Broker for the implementation: Apache Kafka, AWS SQS and Google Compute PubSub.

In summary, this component does not need to be developed from scratch. However, the FNAA will need to be able to communicate with the different Flow Events Broker, meaning that it must implement their APIs as a client.
	
##### 4.3.2. Flow Name Service (FN)	
This component can be completely implemented by leveraging on the ISC Bind9 software component, which is the de facto leader for DNS servers. A given NP will need to deploy a Bind9 Nameserver and enable both DNSSEC and DNS Dynamic Update.

The impact of adopting Bind9 for the implementation means that the FNAA component needs to be able to use a remote DNS Server to manage the Flow URI registration, deregistration and execute recursive DNS resolution.
	
#### 4.4. Components to be developed
In this section, we describe a set of tools that require development. These components, especially the FNAA, are the core components of every Network Participant. Moreover, these are the components that implement the network protocol FNAP.

Since these are the core components of the network, they are the natural candidates for validation. In the next chapter, we will show the feasibility of the core network components in the form of a Proof of Concept.

##### 4.4.1. Flow Namespace Accessing Agent (FNAA)
The Flow Namespace Accessing Agent is a server component that triggers the creation of child processes that implement the different Flow Processors. This means that the instance running the FNAA will bring up new processes for each processor. One way of implementing this functionality can be a parent process that creates new child processes for each processor. However, this would imply the need of creating and managing different threads in a single FNAA instance.

The problem with the approach of a parent process and child processes for the FNAA is on the infrastructure level. The more processor a FNAA needs to manage, the more compute resources the FNAA would need. In the current cloud infrastructure context, this is problem because it means that additional compute resources should be assigned to the FNAA, depending on the quantity of processors and the required resources for each of them. In summary, this approach would be vertically scalable but not horizontally scalable.

Then, to avoid the scalability issue, the approach we propose is by implementing a Cloud Native application. By leveraging on Kubernetes, it is possible to trigger the creation of Deployments, which are composed of Pods. Each Pod can contain a given quantity of containers, which are processes running in a GNU/Linux Operating System. In this way, we can dedicate a Pod to run the FNAA server and different Pods to run the Processors. This approach provides a convenient process isolation and enables both horizontal and vertical scalability.

Moreover, the way in which the FNAA would bring up and manage Processor instances would be though an integration with the underlaying Kubernetes instance, by means of the Kubernetes API. The result is a Cloud Native application that leverages the power and flexibility of Kubernetes to manage the Processor instances.

On the other hand, the programming language for the FNAA must also be defined. For this, we consider that it must be possible to implement the FNAA and the Flow Processors in different programming languages. For the FNAP it is recommended to employ Golang, since Kubernetes CLI tool is implemented in this language and there are several libraries available for integration. As for the Flow Processors, it must be possible to use any programming language as long as the IPC interface is correctly implemented.

Regarding the IPC interface for the communications between the FNAA and the Flow Processors, the recommendation is to employ gRPC together with Protobuf. The rationale for choosing this this technology is the fact that gRPC enables binary communications, which are the desired type of communication for systems integration. Then, both the FNAA and the Flow Processors must share this Protobuf interface definition and implement it accordingly through gRPC. 

Finally, the FNAA must implement the protocol we have named FNAP, which provides the main set of functionalities for the Event Streaming Open Network. The implementation of FNAP must be stateful, in the sense that it is connection-based. Additionally, the implementation must be text-based, with the goal that humans can interact with FNAA servers in the same way that it is possible for SMTP servers. The transport protocol must be TCP with no special definition for a port number, since the port should be able to be discovered by means of DNS SRV Resource Records.

Regarding security for the FNAA servers, TLS must be supported. This means that any client can start a TLS handshake with the FNAA servers before issuing any command.  

In conclusion, the implementation of the FNAA over Kubernetes provides the needed flexibility and set of capabilities required for this component. It is recommended to implement the FNAA in Golang and enable the implementation of Flow Processors in any programming language as long as the Protobuf interface is correctly implemented. Finally, the FNAA must implement the protocol FNAP in a connection-based and text-based manner.

##### 4.4.2. Flow Namespace User Agent (FNUA)
The Flow Namespace User Agent (FNUA) can have different implementations as long as they comply with the protocol FNAP. 

We propose the initial availability of a CLI tool that acts as a Flow Namespace User Agent. This CLI tool must provide a client implementation of all the functionalities available in the FNAA server. Among the functionalities to be implemented as a must, we can mention:
* Discover the FNAA server for a given Flow URI.
* Connect to the FNAA server to manage Flow Namespaces and Flows, as exemplified in Figure 14:

Additionally, the FNUA should be able to discover the Authoritative FNAA server for a given Flow Namespace. This discovery shall be performed by leveraging on the DNS-SD specification. Refer to Annex D to review the discovery process.

Regarding the implementation of the CLI tool, it is recommended to employ Golang together with Cobra, a library specialized to create CLI tools. In Figure 21, we have a diagram that shows the different functionalities that the CLI tool should implement.
	
####FIGURE####
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
# Security Considerations

TODO Security


# IANA Considerations

This document has no IANA actions.


--- back

# Acknowledgments
{:numbered="false"}

TODO acknowledge.
