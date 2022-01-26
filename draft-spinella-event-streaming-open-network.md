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

## Section

# Security Considerations

TODO Security


# IANA Considerations

This document has no IANA actions.


--- back

# Acknowledgments
{:numbered="false"}

TODO acknowledge.
