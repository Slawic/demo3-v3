<?xml version='1.1' encoding='UTF-8'?>
<project>
  <actions/>
  <description>Frontend</description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <hudson.plugins.disk__usage.DiskUsageProperty plugin="disk-usage@0.28"/>
    <com.dabsquared.gitlabjenkins.connection.GitLabConnectionProperty plugin="gitlab-plugin@1.5.12">
      <gitLabConnection></gitLabConnection>
    </com.dabsquared.gitlabjenkins.connection.GitLabConnectionProperty>
    <hudson.plugins.throttleconcurrents.ThrottleJobProperty plugin="throttle-concurrents@2.0.1">
      <maxConcurrentPerNode>0</maxConcurrentPerNode>
      <maxConcurrentTotal>0</maxConcurrentTotal>
      <categories class="java.util.concurrent.CopyOnWriteArrayList"/>
      <throttleEnabled>false</throttleEnabled>
      <throttleOption>project</throttleOption>
      <limitOneJobWithMatchingParams>false</limitOneJobWithMatchingParams>
      <paramsToUseForLimit></paramsToUseForLimit>
    </hudson.plugins.throttleconcurrents.ThrottleJobProperty>
  </properties>
  <scm class="hudson.plugins.git.GitSCM" plugin="git@3.10.0">
    <configVersion>2</configVersion>
    <userRemoteConfigs>
      <hudson.plugins.git.UserRemoteConfig>
        <url>https://github.com/IF-092-UI/final_project.git</url>
      </hudson.plugins.git.UserRemoteConfig>
    </userRemoteConfigs>
    <branches>
      <hudson.plugins.git.BranchSpec>
        <name>*/master</name>
      </hudson.plugins.git.BranchSpec>
    </branches>
    <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
    <submoduleCfg class="list"/>
    <extensions/>
  </scm>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.plugins.sonar.SonarRunnerBuilder plugin="sonar@2.8.1">
      <project></project>
      <properties>sonar.projectKey=my:frontend
sonar.projectName=My frontend
sonar.projectVersion=1.0
sonar.sources=.</properties>
      <javaOpts></javaOpts>
      <additionalArguments></additionalArguments>
      <jdk>(Inherit From Job)</jdk>
      <task></task>
    </hudson.plugins.sonar.SonarRunnerBuilder>
    <hudson.tasks.Shell>
      <command>cp -r /tmp/ansible/frontend $WORKSPACE/
cp -r /tmp/ansible/kubernetes $WORKSPACE/</command>
    </hudson.tasks.Shell>
    <hudson.tasks.Shell>
      <command>sed -i -e s+https://fierce-shore-32592.herokuapp.com+http://${lb_backend}+g /var/lib/jenkins/workspace/job_frontend/src/app/services/token-interceptor.service.ts
yarn install
ng build --prod
</command>
    </hudson.tasks.Shell>
    <jenkins.plugins.publish__over__ssh.BapSshBuilderPlugin plugin="publish-over-ssh@1.20.1">
      <delegate>
        <consolePrefix>SSH: </consolePrefix>
        <delegate plugin="publish-over@0.22">
          <publishers>
            <jenkins.plugins.publish__over__ssh.BapSshPublisher plugin="publish-over-ssh@1.20.1">
              <configName>docker_server</configName>
              <verbose>false</verbose>
              <transfers>
                <jenkins.plugins.publish__over__ssh.BapSshTransfer>
                  <remoteDirectory>frontend</remoteDirectory>
                  <sourceFiles>**/frontend/*</sourceFiles>
                  <excludes></excludes>
                  <removePrefix>/frontend</removePrefix>
                  <remoteDirectorySDF>false</remoteDirectorySDF>
                  <flatten>false</flatten>
                  <cleanRemote>false</cleanRemote>
                  <noDefaultExcludes>false</noDefaultExcludes>
                  <makeEmptyDirs>false</makeEmptyDirs>
                  <patternSeparator>[, ]+</patternSeparator>
                  <execCommand></execCommand>
                  <execTimeout>120000</execTimeout>
                  <usePty>false</usePty>
                  <useAgentForwarding>false</useAgentForwarding>
                </jenkins.plugins.publish__over__ssh.BapSshTransfer>
                <jenkins.plugins.publish__over__ssh.BapSshTransfer>
                  <remoteDirectory>kubernetes</remoteDirectory>
                  <sourceFiles>**/kubernetes/*</sourceFiles>
                  <excludes></excludes>
                  <removePrefix>/kubernetes</removePrefix>
                  <remoteDirectorySDF>false</remoteDirectorySDF>
                  <flatten>false</flatten>
                  <cleanRemote>false</cleanRemote>
                  <noDefaultExcludes>false</noDefaultExcludes>
                  <makeEmptyDirs>false</makeEmptyDirs>
                  <patternSeparator>[, ]+</patternSeparator>
                  <execCommand></execCommand>
                  <execTimeout>120000</execTimeout>
                  <usePty>false</usePty>
                  <useAgentForwarding>false</useAgentForwarding>
                </jenkins.plugins.publish__over__ssh.BapSshTransfer>
                <jenkins.plugins.publish__over__ssh.BapSshTransfer>
                  <remoteDirectory>frontend</remoteDirectory>
                  <sourceFiles>**/dist/eSchool/**</sourceFiles>
                  <excludes></excludes>
                  <removePrefix>/dist</removePrefix>
                  <remoteDirectorySDF>false</remoteDirectorySDF>
                  <flatten>false</flatten>
                  <cleanRemote>false</cleanRemote>
                  <noDefaultExcludes>false</noDefaultExcludes>
                  <makeEmptyDirs>false</makeEmptyDirs>
                  <patternSeparator>[, ]+</patternSeparator>
                  <execCommand>docker build -t eschool-frontend -f frontend/Dockerfile .
docker tag eschool-frontend gcr.io/${project}/eschool-frontend:0.0.1
gcloud auth activate-service-account --key-file /tmp/ansible/.ssh/gcp_devops.json
gcloud docker -- push gcr.io/${project}/eschool-frontend
gcloud beta container clusters get-credentials eschool-claster --region us-central1 --project ${project}
kubectl create secret docker-registry gcr-json-key --docker-server=gcr.io --docker-username=_json_key --docker-password="$(cat /tmp/ansible/.ssh/gcp-viewer.json)" --docker-email=postexampl12356@gmail.com
kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "gcr-json-key"}]}'
kubectl apply -f kubernetes/deployment-frontend.yml
kubectl apply -f kubernetes/service-frontend.yml
kubectl apply -f kubernetes/ingress-eschool.yml
</execCommand>
                  <execTimeout>120000</execTimeout>
                  <usePty>false</usePty>
                  <useAgentForwarding>false</useAgentForwarding>
                </jenkins.plugins.publish__over__ssh.BapSshTransfer>
              </transfers>
              <useWorkspaceInPromotion>false</useWorkspaceInPromotion>
              <usePromotionTimestamp>false</usePromotionTimestamp>
            </jenkins.plugins.publish__over__ssh.BapSshPublisher>
          </publishers>
          <continueOnError>false</continueOnError>
          <failOnError>false</failOnError>
          <alwaysPublishFromMaster>false</alwaysPublishFromMaster>
          <hostConfigurationAccess class="jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin" reference="../.."/>
        </delegate>
      </delegate>
    </jenkins.plugins.publish__over__ssh.BapSshBuilderPlugin>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>