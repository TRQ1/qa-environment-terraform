# Terraform
### Code for the provision of AWS infra with Terraform

### Directories

```
.
├── README.md
├── env                     // 실제 Provision될 환경들
└── modules                 // AWS modules
    ├── compute             // AWS Compute modules  
    │   ├── alb             // ALB modules
    │   ├── asg             // ASG modules
    │   ├── lt              // Launch Template modules
    │   └── sg              // Security Group modules
    ├── database            // AWS database modules
    │   ├── ec              // Elastic Cache Redis modules
    │   ├── rds             // RDS modules  
    │   └── rds-aurora      // RDS Aurora modules
    ├── iam                 // IAM modules
    ├── mq                  // AWS MQ modules
    └── network             // Network modules
        └── route53         // Route53 modules
```

### Pipeline Architecture
<img src="./resources/infra_pipeline.svg">
