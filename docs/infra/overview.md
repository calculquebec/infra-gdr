# Overview

## Providers

### Openstack

#### Quotas

Deploying a single instance of the cluster requires at least having these resources available up front in the target Openstack project:

|Resource|Amount|
|:-------|:----:|
|instances|5|
|vcpus|12|
|ram|23Go|
|volumes SSD|130Go|
|volumes HDD|🤔|

Here's the breakdown:

|Server|VCPUs|RAM|SSD|HDD|
|:-----|:---:|:-:|:-:|:-:|
|apps|8|15Gb|32Gb (+32Gb snapshot)|150Gb|
|psql-0|1|2Gb|16gb|0|
|psql-1|1|2Gb|16gb|0|
|psql-2|1|2Gb|16gb|0|
|psql-3|1|2Gb|16gb|0|

## LXD Containers

LXD stands for [Linux Container Daemon](https://linuxcontainers.org). It is an open-source container management system that provides a user-friendly interface and command-line tools to manage Linux containers. 

LXD allows users to create and manage lightweight, secure, and fast virtualized environments that can be used for a wide range of purposes, such as development, testing, and production workloads. 

### Images

A container image registry is a centralized location where container images can be stored, managed, and distributed. 

In this case, a publicly available container image registry is hosted at https://images.opsocket.com. Users can access this registry to download and launch public container images that are stored on it.

These public images are maintained by the registry owners and are available for anyone to use. To launch a public image, users can simply pull the image from the registry and run it in their own container environment. 

For example, we might use these commands to start an instance of [nextcloud](https://nextcloud.com):

```shell
lxc init --auto
lxc remote add opimgs https://images.opsocket.com
lxc launch opimgs:nextcloud n1
```
