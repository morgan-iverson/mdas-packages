# RabbitMQ

The setup/dsetup.sh script will create a container that is runnning a RabbitMQ management server on port 15672. In order to use this in an Educates workshop complete the following steps.

1. Enable Docker
    1. Open workshop defintion, `resources/workshop.yaml` 
    2. Add the following 
        ```
        session: 
            ...
            applications:
                docker:
                    enabled: true
        ```
2. Expose Port 15672
    1. Open workshop defintion, `resources/workshop.yaml` 
    2. Add the following 
        ```
        session: 
            ...
            ingresses:
            - name: application
              port: 15672
        ```

3. (Optional) Add a Dashboard/Tab
    1. Open workshop defintion, `resources/workshop.yaml` 
    2. Add the following 
        ```
        dashboards: 
            ...
            - name: RabbitMQ
              url: http://application-$(session_namespace).$(ingress_domain)
        ```