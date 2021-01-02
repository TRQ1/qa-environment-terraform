# Kurly Terraform
### 컬리에서 Infra 환경을 자동으로 생성하기 위한 코드 입니다.

### * 디렉토리 구조

```
.
├── README.md
├── env                             // 실제 Provision될 환경들
│   ├── dev                         // Dev 환경 코드 
│   ├── qa                          // qa 환경 코드 
│   ├── stage                       // stage 환경 코드 
│   ├── test                        // test 환경 코드 
└── modules                         // AWS modules
    ├── acm                         // AWS ACM module
    ├── compute                     // AWS Compute modules 
    │   ├── alb                     // ALB module
    │   ├── asg                     // ASG module
    │   ├── lt                      // Launch Template module
    │   └── sg                      // Security Group module
    ├── containers                  // AWS Container modules
    │   ├── eks-cluster             // EKS Cluster module
    │   ├── eks-fargate-profile     // EKS fargate profile module
    │   └── eks-node-group          // EKS Node Group module
    ├── database                    // AWS database modules
    │   ├── ec                      // Elastic Cache Redis modules
    │   ├── rds                     // RDS modules  
    │   └── rds-aurora              // RDS Aurora modules
    ├── developer_tool              // AWS Developer Tools modules
    │   ├── codebuild               // CodeBuild module
    │   └── codedeploy              // CodeDeploy module
    ├── iam                         // IAM modules
    ├── mq                          // AWS MQ modules
    └── network                     // Network modules
        └── route53                 // Route53 modules
```

### * Infra Pipeline 구성도
<img src="./resources/infra_pipeline.svg">
