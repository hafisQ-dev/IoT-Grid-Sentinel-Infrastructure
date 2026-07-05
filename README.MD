\# IoT Grid Sentinel: Transformer Infrastructure \& Monitoring Stack



A production-ready, containerized IoT monitoring infrastructure designed to track the dynamic health metrics (such as temperature, loading capacity, and asset health) of distribution transformers in real-time. 



This repository encapsulates the entire DevOps pipeline, from cloud infrastructure provisioning to automated deployment and multi-service orchestration.



\## 🏗️System Architecture



The core infrastructure operates as an isolated data pipeline leveraging 5 interconnected services:



1\. \*\*Simulated Grid Node (`transformer-simulation`):\*\* A custom Python application generating synthetic electrical and thermal metrics for distribution assets.

2\. \*\*MQTT Broker (`mosquitto`):\*\* The ingestion layer acting as a lightweight message broker for incoming telemetry data.

3\. \*\*Data Bridge (`bridge-mqtt-influxdb`):\*\* A custom Python consumer bridging the MQTT broker and the time-series database.

4\. \*\*Time-Series Database (`influxdb 2.7`):\*\* High-performance storage engineered to maintain chronological telemetry data.

5\. \*\*Visualization Engine (`grafana`):\*\* An analytics platform mapping out dynamic metrics onto interactive dashboards.



\## 🛠️Technology Stack



\* \*\*Infrastructure as Code:\*\* Terraform (AWS EC2 provisioning)

\* \*\*Configuration Management:\*\* Ansible (Automated server provisioning and Docker setup)

\* \*\*Containerization \& Orchestration:\*\* Docker \& Docker Compose

\* \*\*Data Layer:\*\* Eclipse Mosquitto (MQTT) \& InfluxDB 2.x

\* \*\*Frontend Analytics:\*\* Grafana 10.2.0

\* \*\*Data Pipelines:\*\* Python 3.10 (Paho-MQTT, InfluxDB-Client)



\##  Deployment Guide



\### Prerequisites

Ensure you have the following installed on your control node:

\* Terraform

\* Ansible

\* SSH Access to your targeted remote node



\### 1. Provisioning Cloud Resources

Navigate to the Terraform directory and spin up the target AWS EC2 instances:

```bash

terraform init

terraform apply -auto-approve

2\. Automated Configuration \& Deployment

Once the host IP is fetched, update your hosts.ini inventory file and execute the Ansible playbook to configure Docker, deploy configuration files, and fire up the containers:



Bash

ansible-playbook -i hosts.ini deploy.yml

3\. Verification

Verify that the services are actively running on the remote instance:



Bash

docker compose ps

 Monitoring Dashboard

Access the Grafana UI at http://<your-server-ip>:3000.



Connect InfluxDB using the Flux query language.



Apply the following visualization filter to monitor live temperature readings:



Kod snippet'i

from(bucket: "${INFLUXDB\_NAME}")

&#x20; |> range(start: v.timeRangeStart, stop: v.timeRangeStop)

&#x20; |> filter(fn: (r) => r\["\_measurement"] == "transformer\_telemetry")

&#x20; |> filter(fn: (r) => r\["\_field"] == "temperature")

&#x20; |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)

&#x20; |> yield(name: "mean")

 Roadmap \& Ongoing Work

\[ ] Implement an explicit retry/reconnection mechanism in the Python simulation pipeline to mitigate initial container startup race conditions (ConnectionRefusedError).



\[ ] Secure internal bridge communication utilizing native Mosquitto ACLs and dedicated network abstraction layers.

