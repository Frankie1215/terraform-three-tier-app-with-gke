# Learn Terraform - Provision a GKE Cluster

This repo is a companion repo to the [Provision a GKE Cluster tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke), containing Terraform configuration files to provision an GKE cluster on GCP.

This sample repo also creates a VPC and subnet for the GKE cluster. This is not
required but highly recommended to keep your GKE cluster isolated.

## Structure
![Alt text](infrastructure.png)

## Environment variables

In **terraform.tfvars**:

**project_id** - (Required) GCP Project id

**region** - (Required) GCP Region

**db_api_username** - (Required) Cloud SQL Username for API

**db_api_password** - (Required) Cloud SQL Password for API
