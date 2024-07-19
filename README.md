# My Tips 19.07.2024 - version 1.6

## 1. Pipeline upgrades
#### 1.1 Emergency Hotfix Pipeline for production
- Custom Separate emergency hotfix pipeline for production deployments
- Separate stage that can be triggered by an Environment variable

#### 1.2 Shift Left IaaC Security Concept (** new **)
Check for security problems earlyer in the pipeline with tools like
  - checkov (https://www.checkov.io/) - perhaps you arealy have it in the terraform validate section
  - kicks (https://kics.io/index.html) //free open source
Disadvantage is that it will take longer to deploy something but it will catch
security infrastructure and docker container issues or open security holes.
- implement on test branches first

#### 1.3 Faster Pipelines
- Speed is not always the answer..
- Separate pipeline for a "BaseImage" / "GoldenImage" type of scenario can be usefull to speed up where frameorks can be already setup.
- These images get built automatically on a weekly basis.
- Prebuilt images or perhaps caching docker images might be a solution..
- Goes nicely hand in hand with `point 4.7` below.

## 2. AWS Shield / WAF in the alb
If not already implemented.

## 3. Cloudflare implementation
As I understood, already in discussion to be implemented.

## 4. ECS IDEAS
#### 4.1 HealthCheck in ECS at the task level 
- unlocks the use / potential of circuit breaker
- https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ecs-taskdefinition-healthcheck.html
- More info in files/healthcheck-examples.json
#### 4.2 Deployment circuit breaker
Turn on, rollback on failures turned on for circuit breaker
#### 4.3 CloudWatch configuration
Turn on, rollback on failures from CloudWatch alarms
#### 4.4 Transform some light services into Lambda
- Use lambda's feature to starting up from containers.
- Helpuful to cut some more costs but needs work & testing in stage.
- Big disadvantage is the option to just "turn off"
- Put Cloudwatch alarms to lambda! + quick pipeline to set concurrency to zero in case of issues.

#### 4.5 Stop/Start Stage Cluster at need Afterworking Hours & over the weekend
- AWS EventBridge
  - Stop-Start ECS Task 
  - or use to invoke a lambda with some parameters for stop / start (DesiredTasks set to 0 or 1)
- Use AWSCLI to just just run a script in the destination account.
- Or perhaphs my favorite: use a pipeline in gitlab to run awscli against the target aws account with the scripts in files/ecs/stop-start-restart
Usage: 
- https://docs.aws.amazon.com/cli/latest/topic/config-vars.html#the-shared-credentials-file
- example: files/gitlab/AWS_SHARED_CREDENTIALS_FILE.txt
#### 4.6 Create also a test environment
- Use it to test features without stress
- Stage becomes "pre-production"
- Test Stays mostly stopped.
#### 4.7 A Template Service
- have a service that is like a "template" for all the others
- based on this template you standardize the others and you have expected behaviour and easier to upgrade/maintain/test

## 5. Database to Aurora
- https://aws.amazon.com/rds/aurora/features/
- Space increases/updates do not have downtime
- A bit more expensive but maybe worth it
- Read Replica
- Other features
- Test disaster recovery and restore in stage of the DB using awscli or other
- Check examples is files/rds folder.

## 6. Migrate Stage to a different AWS account
Reasoning - isolation and better cost control

## 7. IaaC: break into parts
- Break infrastructure as a code in parts in terraform.
- Easyer said then done, in cloudformation I use a simple ideea: Stateless and statefull
  Stateless:
    - ECS Tasks, Cluster, etc.
    - LoadBalancer
  Statefull:
    - S3 / EBS
    - Database

## 8. AWS Systems Manager: Cloudwatch Dashboards
- If you don't have already this implemented.
- For no additional costs, you can configure widgets that check metrics or logs and even setup alarms nicely in one place
- Go to AWS System Manager, Cloudwatch Dashboard, Create a dashboad. 
- Add widget for Metrics, Logs or even Alarms.
- You can even add other data sources like S3, lambda, etc..
- Ex: Monitor simple very important KPI's like Database connections, 502's from the ALB, etc.
- **Disadvantages**: sometimes buggy interface.

## 9. Logs Management
- Big topic, but Cloudwatch is ok - but sometimes searching can be hard and you feel like it would use more versatility to parse them.
- Just use all available tools built in AWS to leverage the power of live logging, searching for certain strings, errors, etc.

- Push to S3 and querry with Athena or just check some more best practices. Everyone does it in some different way. 

- Datadog has the posibility of ingesting logs and has prediction capability in the APM section. But it requires log sending from ECS/task definition level and service.

- Check: 
  - files/ecs/log-configuration.json 
  - files/ecs/log-router.json 
of how I used them for dotnet.
- Logs ingestion in datadog is expensive if not reduced significally but the prediction and instant error tracking is worth it.
- Implementation is not that easy but more details here: https://docs.datadoghq.com/integrations/ecs_fargate/?tab=webui


## 10. Well archited tool
- You aready have a bewautiful infra, but there's always room for improvement
- AWS offers great Free great ideas based on the well-architected concept.
  - go to AWS Services, type "Well-Architected Tool" -> define workload -> fill in .
  - it takes a while to answer all the questions but the resulting report is very good

## 11. Have dedicated 1st Level Operations Team
- Troubleshoot and Investigate based on Dashboards
- Incident response: quick commands & rights to restart ECS or perform basic ops where needed.