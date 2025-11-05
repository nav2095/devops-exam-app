#!/bin/bash

# Jenkins Configuration Script

# Variables
JENKINS_URL="http://localhost:8080"
JENKINS_CLI_JAR="/tmp/jenkins-cli.jar"
INITIAL_PASSWORD="e12823452c434a90be8c1b6ba5461844"
SONARQUBE_URL="http://localhost:9000"
SONARQUBE_ADMIN_TOKEN=""

# Download Jenkins CLI
wget -O $JENKINS_CLI_JAR $JENKINS_URL/jnlpJars/jenkins-cli.jar

# Function to run Jenkins CLI commands
jenkins_cli() {
    java -jar $JENKINS_CLI_JAR -s $JENKINS_URL -auth admin:$INITIAL_PASSWORD "$@"
}

# Function to run Jenkins CLI commands with auth
jenkins_cli_auth() {
    java -jar $JENKINS_CLI_JAR -s $JENKINS_URL -auth admin:$INITIAL_PASSWORD "$@"
}

# Install required plugins
echo "Installing Jenkins plugins..."
jenkins_cli install-plugin sonar
jenkins_cli install-plugin docker-workflow
jenkins_cli install-plugin docker-plugin
jenkins_cli install-plugin pipeline-stage-view
jenkins_cli install-plugin blueocean
jenkins_cli install-plugin credentials-binding

# Restart Jenkins to apply plugins
jenkins_cli safe-restart

# Wait for restart
sleep 30

# Generate SonarQube token
echo "Generating SonarQube token..."
# Login to SonarQube and generate token
SONARQUBE_ADMIN_TOKEN=$(curl -s -u admin:admin -X POST "$SONARQUBE_URL/api/user_tokens/generate" -d "name=JenkinsToken" | jq -r '.token')

if [ -z "$SONARQUBE_ADMIN_TOKEN" ]; then
    echo "Failed to generate SonarQube token. Please generate it manually."
    exit 1
fi

echo "SonarQube token generated: $SONARQUBE_ADMIN_TOKEN"

# Configure SonarQube server in Jenkins
echo "Configuring SonarQube server in Jenkins..."
jenkins_cli groovy = <<EOF
import hudson.plugins.sonar.SonarGlobalConfiguration
import hudson.plugins.sonar.SonarInstallation

def sonarConf = SonarGlobalConfiguration.get()
def sonarInst = new SonarInstallation(
    "SonarQube",
    "$SONARQUBE_URL",
    "$SONARQUBE_ADMIN_TOKEN",
    null,
    null,
    null,
    null,
    null,
    null,
    null
)
sonarConf.setInstallations(sonarInst)
sonarConf.save()
EOF

# Add Docker Hub credentials (you need to provide username and password)
# Note: Replace 'your-docker-username' and 'your-docker-password' with actual values
echo "Adding Docker Hub credentials..."
jenkins_cli create-credentials-by-xml system::system::jenkins _ \
<<EOF
<com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
  <scope>GLOBAL</scope>
  <id>docker</id>
  <description>Docker Hub Credentials</description>
  <username>your-docker-username</username>
  <password>your-docker-password</password>
</com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
EOF

# Add SonarQube token credentials
echo "Adding SonarQube token credentials..."
jenkins_cli create-credentials-by-xml system::system::jenkins _ \
<<EOF
<org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl>
  <scope>GLOBAL</scope>
  <id>sonar-token</id>
  <description>SonarQube Token</description>
  <secret>$SONARQUBE_ADMIN_TOKEN</secret>
</org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl>
EOF

# Create Jenkins pipeline job
echo "Creating Jenkins pipeline job..."
jenkins_cli create-job devops-exam-app < /tmp/Jenkinsfile.xml

# Note: You need to create Jenkinsfile.xml from the Jenkinsfile
# For now, we'll assume the job is created manually or via web interface

echo "Jenkins configuration completed. Please update Docker Hub credentials manually if needed."
