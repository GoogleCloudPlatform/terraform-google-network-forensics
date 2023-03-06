# VPC Network

A [Virtual Private Cloud (VPC) network](https://cloud.google.com/vpc/docs/vpc) or "network" is a private, isolated
section of your cloud infrastructure. Networks are a virtual version of a physically segregated network that control
connections between your resources and services both on Google Cloud and outside of it.

Networks are global, and a single network can be used for all of your GCP resources across all regions. Subnetworks,
ranges of IP addresses within a single region, can be used to usefully partition your private network IP space.


# Network Subnets

Each VPC network consists of one or more useful IP range partitions called subnets. Each subnet is associated with a region.
VPC networks do not have any IP address ranges associated with them. IP ranges are [defined for the subnets](https://cloud.google.com/vpc/docs/vpc#manually_created_subnet_ip_ranges).

A network must have at least one subnet before you can use it. Auto mode VPC networks create subnets in each region automatically.
Custom mode VPC networks start with no subnets, giving you full control over subnet creation. You can create more than one subnet per region.
For information about the differences between auto mode and custom mode VPC networks, see [types of VPC networks](https://cloud.google.com/vpc/docs/vpc#subnet-ranges).


# Network Firewall

The Network Firewall module is used to configure a standard set of [firewall rules](https://cloud.google.com/vpc/docs/firewalls)
for your network.

Firewall rules on Google Cloud Platform (GCP) are created at the network level but act on each instance; if traffic is
restricted between instances by the rule, they will be unable to communicate even if they're in the same network or
subnetwork.

The default firewall rules on GCP block inbound traffic and allow outbound traffic. Firewall rules are stateful; if a
connection is allowed between a source and a target or a target and a destination, all subsequent traffic in either
direction will be allowed as long as the connection is active.


# VPC Network Peering

The Network Peering module creates [VPC network peering connections](https://cloud.google.com/vpc/docs/vpc-peering)
between networks.

VPC Network Peering enables you to connect VPC networks so that workloads in different VPC networks can communicate internally.
Traffic stays within Google's network and doesn't traverse the public internet.


# Instance Template

An [instance template](https://cloud.google.com/compute/docs/instance-templates) is a resource that you can use to
create virtual machine (VM) instances and managed instance groups (MIGs).

Instance templates define the machine type, boot disk image or container image, labels, and other instance properties.
You can then use an instance template to create a MIG or to create individual VMs. Instance templates are a convenient
way to save a VM instance's configuration so you can use it later to create VMs or groups of VMs.


# Managed Instance Group

An [instance group](https://cloud.google.com/compute/docs/instance-groups) is a collection of virtual machine (VM) instances that you can manage as a single entity.

Compute Engine offers two kinds of VM instance groups, managed and unmanaged:
- [Managed instance groups (MIGs)](https://cloud.google.com/compute/docs/instance-groups#managed_instance_groups) let you operate apps on multiple identical VMs. You can make your workloads scalable and highly available by taking advantage of automated MIG services, including: autoscaling, autohealing, regional (multiple zone) deployment, and automatic updating.
- [Unmanaged instance groups](https://cloud.google.com/compute/docs/instance-groups#unmanaged_instance_groups) let you load balance across a fleet of VMs that you manage yourself.


# Internal Load Balancer

[Cloud Load Balancing](https://cloud.google.com/load-balancing/docs/load-balancing-overview) is a fully distributed, software-defined, managed service for all your traffic.
It is not an instance or device based solution, so you won’t be locked into physical load balancing infrastructure or face the HA, scale and
management challenges inherent in instance based LBs. Cloud Load Balancing features include:

[Internal TCP/UDP Load Balancing](https://cloud.google.com/load-balancing/docs/internal) is a regional load balancer that enables you to run and
scale your services behind an internal load balancing IP address that is accessible only to your internal virtual machine (VM) instances. Internal
TCP/UDP Load Balancing distributes traffic among VM instances in the same region in a Virtual Private Cloud (VPC) network by using an internal IP
address. An Internal TCP/UDP Load Balancing service has a frontend (the forwarding rule) and a backend (the backend service).


# Packet Mirroring

[Packet Mirroring](https://cloud.google.com/vpc/docs/packet-mirroring) clones the traffic of specified instances in your Virtual Private Cloud (VPC) network and forwards it for examination.
Packet Mirroring captures all traffic and packet data, including payloads and headers. The capture can be configured for both egress and
ingress traffic, only ingress traffic, or only egress traffic.

The mirroring happens on the virtual machine (VM) instances, not on the network. Consequently, Packet Mirroring consumes additional
bandwidth on the VMs.

Packet Mirroring is useful when you need to monitor and analyze your security status. It exports all traffic, not only the traffic between
sampling periods. For example, you can use security software that analyzes mirrored traffic to detect all threats or anomalies. Additionally,
you can inspect the full traffic flow to detect application performance issues.
