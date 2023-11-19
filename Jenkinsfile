pipeline {

  environment {
    PROJECT = "intrepid-league-397203"
    APP_NAME = "shippingservice"
    FE_SVC_NAME = "${APP_NAME}-svc"
    CLUSTER = "k8s-cluster-dev"
    CLUSTER_ZONE = "europe-west2-a"
    IMAGE_TAG = "gcr.io/${PROJECT}/${APP_NAME}"
    JENKINS_CRED = "${PROJECT}"
  }

  agent {
    kubernetes {
      inheritFrom 'hipster'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  # Use service account that can deploy to all namespaces
  # serviceAccountName: cd-jenkins
  containers:
  - name: gradle-bld
    image: openjdk:latest
    command:
    - cat
    tty: true
  - name: gcloud
    image: gcr.io/google.com/cloudsdktool/cloud-sdk
    command:
    - cat
    tty: true
  - name: kubectl
    image: google/cloud-sdk
    command:
    - cat
    tty: true
"""
}
  }
  stages {
    stage('codebuild') {
      steps {
        container('gradle-bld') {
          sh """
             ls -a && pwd 
          """
        }
      }
    }
    stage('Deploy Dev') {
      steps {
        container('kubectl') {
          sh "pwd"
          sh "chmod -R 777 ."
          sh "./startup.sh"
          sh "gcloud container clusters get-credentials hipster-dev --region europe-west2 --project intrepid-league-397203"
          sh "kubectl apply -f k8s-service-account.yaml"
          sh "kubectl apply -f lightstep-configmap.yaml"
          sh "kubectl apply -f otel-collector-config.yaml"
          sh "kubectl apply -f otel-collector.yaml"   
          sh "kubectl apply -f redis.yaml"       
        }
      }
    }
  }
}
