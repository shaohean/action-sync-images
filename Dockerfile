FROM jenkins/jenkins:lts-slim-jdk17
RUN jenkins-plugin-cli --plugins ssh-slaves blueocean kubernetes ace-editor ant antisamy-markup-formatter apache-httpcomponents-client-4-api apache-httpcomponents-client-5-api artifactory authentication-tokens bootstrap5-api bouncycastle-api branch-api build-timeout caffeine-api checks-api cloudbees-folder command-launcher commons-lang3-api commons-text-api config-file-provider credentials credentials-binding data-tables-api dependency-check-jenkins-plugin display-url-api docker-build-step docker-commons docker-java-api docker-workflow durable-task echarts-api email-ext external-monitor-job font-awesome-api git git-client git-server golang gradle handlebars htmlpublisher instance-identity ionicons-api ivy jackson2-api jakarta-activation-api jakarta-mail-api javadoc javax-activation-api javax-mail-api jaxb jdk-tool jquery3-api jquery-detached jsch junit kpp-management-plugin kubernetes kubernetes-client-api kubernetes-credentials ldap localization-support localization-zh-cn lockable-resources mailer mapdb-api mask-passwords matrix-auth matrix-project maven-plugin metrics mina-sshd-api-common mina-sshd-api-core momentjs okhttp-api pam-auth pipeline-build-step pipeline-graph-analysis  pipeline-input-step pipeline-github-lib pipeline-milestone-step pipeline-model-api pipeline-model-declarative-agent pipeline-model-definition pipeline-model-extensions pipeline-rest-api pipeline-stage-step pipeline-stage-tags-metadata pipeline-stage-view plain-credentials plugin-util-api publish-over publish-over-ftp publish-over-ssh quality-gates resource-disposer scm-api script-security snakeyaml-api sonar sonar-quality-gates ssh-agent ssh-credentials sshd structs subversion svncompat14 token-macro trilead-api variant workflow-aggregator workflow-api workflow-basic-steps workflow-cps workflow-cps-global-lib workflow-durable-task-step workflow-job workflow-multibranch workflow-scm-step workflow-step-api workflow-support ws-cleanup xcode-plugin theme-manager dark-theme
