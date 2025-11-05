# DevOps Exam App Deployment Plan

## Step 1: Prerequisites Check
- [ ] Check if Git is installed locally
- [ ] Check if AWS CLI is installed (optional, for automated EC2 launch)
- [ ] Ensure Docker Hub account is logged in locally (for pushing images)

## Step 2: Launch AWS EC2 Instance
- [ ] Launch Ubuntu 24.04 t2.large EC2 instance with 30GB storage
- [ ] Open required ports: All TCP (0-65535), ICMP, SSH (22), 3000, 8081, 8080, 443, 6443, 80
- [ ] Note down the public IP and key pair for SSH access

## Step 3: Connect to EC2 and Install Tools
- [ ] SSH into EC2 instance
- [ ] Update packages: sudo apt update
- [ ] Install Jenkins using provided script
- [ ] Install Docker using provided script
- [ ] Install Trivy using provided script
- [ ] Install Docker Scout
- [ ] Install and run SonarQube container

## Step 4: Configure Jenkins
- [ ] Access Jenkins dashboard and install required plugins (SonarQube scanner, Docker plugins, etc.)
- [ ] Configure tools: SonarQube Scanner, Docker
- [ ] Set up credentials: Docker Hub, SonarQube token
- [ ] Configure SonarQube server in Jenkins

## Step 5: Create GitHub Repository
- [ ] Create a new GitHub repository (e.g., devops-exam-app)
- [ ] Initialize Git in the project folder
- [ ] Add remote origin to GitHub repo
- [ ] Push the current code to GitHub

## Step 6: Set Up Jenkins Pipeline Job
- [ ] Create a new Jenkins pipeline job
- [ ] Configure it to use the provided Jenkinsfile from the repo
- [ ] Set up webhook or poll SCM for automatic builds

## Step 7: Run the Pipeline
- [ ] Trigger the Jenkins pipeline manually or via push
- [ ] Monitor the build: Git checkout, Trivy scan, SonarQube analysis, Docker build/push, Scout analysis, Deploy with Docker Compose

## Step 8: Verify Deployment
- [ ] Check container status on EC2
- [ ] Test backend endpoint (e.g., http://<EC2-IP>:5000)
- [ ] Access frontend via browser
- [ ] Verify database connectivity

## Followup Steps
- [ ] Monitor Jenkins and SonarQube for issues
- [ ] Test full app functionality
- [ ] Clean up if needed (stop instances to avoid costs)
