# Monitoring Solution Setup

This setup provides a complete monitoring solution using Prometheus, Grafana, and Alertmanager for MongoDB. The solution uses Docker and Docker Compose to deploy the services.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [Usage](#usage)
- [Services](#services)
- [Volumes](#volumes)
- [Additional Configuration](#additional-configuration)
- [Troubleshooting](#troubleshooting)

## Prerequisites

- Docker installed on your machine. Follow the installation guide [here](https://docs.docker.com/get-docker/).
- Docker Compose installed. Follow the installation guide [here](https://docs.docker.com/compose/install/).

## Configuration

1. **Prometheus Configuration**:
   - The Prometheus configuration file `prometheus.yml` should be placed in the `infra/monitoring` directory.
   - Example `prometheus.yml`:
     ```yaml
     global:
       scrape_interval: 15s

     scrape_configs:
       - job_name: 'mongodb'
         static_configs:
           - targets: ['mongodb_exporter:9216']
     rule_files:
       - "alert_rules.yml"
     ```

2. **Alertmanager Configuration**:
   - The Alertmanager configuration file `alertmanager.yml` should be placed in the `infra/monitoring` directory.
   - Example `alertmanager.yml`:
     ```yaml
     global:
       resolve_timeout: 5m

     route:
       receiver: 'email_notifications'

     receivers:
       - name: 'email_notifications'
         email_configs:
           - to: 'your-email@example.com'
             from: 'alertmanager@example.com'
             smarthost: 'smtp.example.com:587'
             auth_username: 'username'
             auth_password: 'password'
     ```

3. **Grafana Configuration**:
   - Preconfigure Grafana data sources and dashboards.
   - Place your configuration files and directories in the `infra/monitoring` directory:
     ```
     infra/monitoring/
     ├── grafana-datasource.yml
     ├── grafana-dashboard.yml
     ├── dashboards/
     │   └── example-dashboard.json
     ├── prometheus.yml
     ├── alert_rules.yml
     ├── alertmanager.yml
     └── docker-compose.yml
     ```

   - **grafana-datasource.yml**:
     ```yaml
     apiVersion: 1
     datasources:
       - name: Prometheus
         type: prometheus
         access: proxy
         url: http://prometheus:9090
         isDefault: true
         editable: true
     ```

   - **grafana-dashboard.yml**:
     ```yaml
     apiVersion: 1
     providers:
       - name: 'default'
         orgId: 1
         folder: ''
         type: file
         options:
           path: /var/lib/grafana/dashboards
     ```

   - **example-dashboard.json**: Place any JSON formatted Grafana dashboards in the `dashboards/` directory.

## Usage

1. Clone the repository:
   ```bash
   git clone <repository-url>
    ```

2. Navigate to the `infra/monitoring` directory:
    ```bash
    cd infra/monitoring
    ```

3. Start the monitoring services:
    ```bash
    docker-compose -f docker-compose.monitor.yml up -d
    ```

4. Access the services:
    - Prometheus: [http://localhost:9090](http://localhost:9090)
    - Grafana: [http://localhost:3002](http://localhost:3002)
    - Alertmanager: [http://localhost:9093](http://localhost:9093)

## Services

The monitoring solution consists of the following services:

- **MongoDB Exporter**: Exports MongoDB metrics in Prometheus format.
- **Prometheus**: A monitoring and alerting toolkit.
- **Grafana**: A multi-platform open-source analytics and interactive visualization web application.
- **Alertmanager**: Handles alerts sent by client applications such as the Prometheus server.

## Volumes

The monitoring solution uses the following volumes:

- **Prometheus Data**: `/prometheus`
- **Grafana Data**: `/var/lib/grafana`
- **Alertmanager Data**: `/alertmanager`

## Additional Configuration

- **Custom Dashboards**: Add custom Grafana dashboards to the `dashboards/` directory.
- **Alert Rules**: Define alert rules in the `alert_rules.yml` file.

## Troubleshooting

- **Prometheus Configuration**: Check the `prometheus.yml` file for any configuration errors.
- **Grafana Data Sources**: Verify the data source configuration in `grafana-datasource.yml`.
- **Grafana Dashboards**: Check the dashboard configuration in `grafana-dashboard.yml`.
- **Alertmanager Configuration**: Verify the configuration in `alertmanager.yml`.

If you encounter any issues, check the logs of the individual services using the following command:
```bash
docker-compose -f docker-compose.monitor.yml logs -f <service-name>
```


