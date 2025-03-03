# ClickHouse Cluster on EKS with Terraform

With this pattern, you can deploy a ClickHouse cluster on AWS EKS (Elastic Kubernetes Service) with a single Terraform file. This module sets up the EKS cluster and node groups with all the tooling required to run ClickHouse clusters on Kubernetes.

> 🌅 DIAGRAM HERE

The module uses opinionated defaults for the EKS cluster and node groups, including the EBS CSI driver, Kubernetes autoscaler, and IAM roles and policies. It also includes configurations for VPCs, public subnets, route tables, and internet gateways, which are essential for the network infrastructure of the EKS cluster.

The deployment experience is simple but flexible. You can customize several settings about the EKS cluster and node groups, such as scaling configurations, disk size, and instance types.

We recommend keeping the defaults if you are new to EKS and ClickHouse. However, if you are familiar with EKS and ClickHouse, feel free to use this template as a starting point and customize it to your needs.

> ⚠️ There are some configurations/resources that could not be considered "production-ready". Use these examples with caution and as a starting point for your learning and development process.

## Components

This architecture provides a scalable, secure, and efficient environment for running a ClickHouse database on Kubernetes within AWS EKS. The focus on autoscaling, storage management, and proper IAM configurations ensures its suitability for enterprise-level deployments using the following resources:

- **EKS Cluster**: Utilizes AWS Elastic Kubernetes Service to manage Kubernetes clusters. Configuration specifies version, node groups, and IAM roles for cluster operations.

- **VPC and Networking**: Sets up a VPC with subnets, internet gateway, and route tables for network isolation and internet access. Public subnets and an S3 VPC endpoint are created for external and internal communications, respectively.

- **IAM Roles and Policies**: Defines roles and policies for EKS cluster, node groups, and service accounts, facilitating secure interaction with AWS services.

- **ClickHouse Deployment**:
  - **Operator and Cluster**: Deploys ClickHouse using a custom Kubernetes operator, with configurations for namespace, user, and password.
  - **Zookeeper Integration**: Configures a Zookeeper cluster for ClickHouse coordination, deployed in its namespace.

- **Storage**:
  - **EBS CSI Driver**: Implements the Container Storage Interface (CSI) for EBS, enabling dynamic provisioning of block storage for stateful applications.
  - **Storage Classes**: Defines storage classes for gp3 encrypted EBS volumes, supporting dynamic volume provisioning.

- **Cluster Autoscaler**: Implements autoscaling for EKS node groups based on workload demands, ensuring efficient resource utilization.

## Deploying the Solution

### Pre-requisites

- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [clickhouse client](https://clickhouse.com/docs/en/integrations/sql-clients/clickhouse-client-local)

### Steps

1. **Clone the repository**

```bash
git clone https://github.com/awslabs/data-on-eks.git
```

2. Navigate into the example directory and run `install.sh` to initialize Terraform and apply the changes.

```bash
cd data-on-eks/analytics/terraform/clickhouse-eks
chmod +x install.sh
./install.sh
```

> This will take a few minutes to complete. Once it's done, you will see the output of the `terraform apply` command, including the `kubeconfig` file for the EKS cluster.

### Verify

Let's verify that the EKS cluster and ClickHouse deployment are running as expected.

```bash
aws eks describe-cluster --name clickhouse-cluster --region us-east-1
```

Verify that the EKS cluster is active and the nodes are ready.

```bash
aws eks update-kubeconfig --name clickhouse-cluster --region us-east-1

kubectl get pods -n kube-system
kubectl get pods -n clickhouse
kubectl get pods -n zoo1ns
```

## Create your first ClickHouse table

Clickhouse uses a SQL-like language to interact with the database. You can use the `clickhouse-client` to connect to the database and create your first table.

### Connect to the ClickHouse cluster
Retrieve the ClickHouse cluster credentials and connect using the `clickhouse-client`.

```bash
password=$(terraform  output clickhouse_cluster_password | tr -d '"')
host=$(terraform  output clickhouse_cluster_url | tr -d '"')

clickhouse client --host=$host --user=test --password=$password
```

### Create a database
> I stole these sql examples from clickhoue docs. I will replace them with something more meaningful. Maybe using an s3 bucket as a source?

Create a new database named `helloworld` if it doesn't already exist.

```sql
CREATE DATABASE IF NOT EXISTS helloworld
```

### Create a table
Define a new table `my_first_table` in the `helloworld` database, specifying its schema.
```sql
CREATE TABLE helloworld.my_first_table
(
    user_id UInt32,
    message String,
    timestamp DateTime,
    metric Float32
)
ENGINE = MergeTree()
PRIMARY KEY (user_id, timestamp)
```

### Add some data
Insert sample data into `my_first_table` demonstrating basic usage.

```sql
INSERT INTO helloworld.my_first_table (user_id, message, timestamp, metric) VALUES
    (101, 'Hello, ClickHouse!',                                 now(),       -1.0    ),
    (102, 'Insert a lot of rows per batch',                     yesterday(), 1.41421 ),
    (102, 'Sort your data based on your commonly-used queries', today(),     2.718   ),
    (101, 'Granules are the smallest chunks of data read',      now() + 5,   3.14159 )
```

### Query the data
Retrieve and display all records from `my_first_table`, ordered by `timestamp`.


```sql
SELECT *
FROM helloworld.my_first_table
ORDER BY timestamp
```

## Next Steps
> Is this ok? Should we add more detail here or consider other topics?

- Explore options for deploying Multi Node Clusters for higher availability and scalability.
- Implement Monitoring & Observability solutions for in-depth performance and health insights.
- Consider additional security measures, backup strategies, and disaster recovery plans.
- Investigate advanced networking configurations, focusing on the use of private subnets and NAT gateways to enhance security and control traffic flow within your EKS environment.

## Cleanup

When you are done with the ClickHouse cluster, you can remove it by running the `uninstall.sh` script. This will delete the EKS cluster and all the resources created by the Terraform script.

```bash
cd data-on-eks/analytics/terraform/clickhouse-eks && terraform destroy
```

## Altinity

> Add a section about Altinity and how they can help with ClickHouse deployments.

[Altinity](https://altinity.cloud) offers enterprise-grade support for ClickHouse, including optimized builds and consultancy services.

>

