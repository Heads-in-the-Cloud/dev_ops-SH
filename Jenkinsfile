pipeline {
  agent {
      node {
          label "aws-ready"
      }
  }

  stages {

    stage('Setup parameters') {
      steps {
        script {
          properties([
            parameters([
              [$class: 'ChoiceParameter', 
                choiceType: 'PT_SINGLE_SELECT', 
                description: 'Starting or stopping the cluster?', 
                filterLength: 1, 
                filterable: false, 
                name: 'action', 
                script: [
                  $class: 'GroovyScript', 
                  fallbackScript: [
                      classpath: [], 
                      sandbox: false, 
                      script: 
                          "return['Could not load actions']"
                  ], 
                  script: [
                      classpath: [], 
                      sandbox: false, 
                      script: 
                          "return['start','stop']"
                  ]
                ]
              ],
              [$class: 'CascadeChoiceParameter', 
                choiceType: 'PT_SINGLE_SELECT', 
                description: 'Development or Production environment?',
                name: 'environment', 
                referencedParameters: 'action', 
                script: [
                  $class: 'GroovyScript', 
                  fallbackScript: [
                    classpath: [], 
                    sandbox: false, 
                    script: "return['Couldn't get operational environment from parameters']"
                  ], 
                  script: [
                    classpath: [], 
                    sandbox: false, 
                    script: '''
                    if(action.equals("start")){
                        return["dev","prod"]
                    }
                    '''
                  ] 
                ]
              ]
            ])
          ])
        }
      }
    }

    stage("Terraform Initialization") {
      when {
        expression {
          return params.action =='start'
        }
      }
      steps {
        echo "Initializing Terraform Deployment..."
        sh "terraform init"
      }
    }

    stage("Terraform Plan") {
      when {
        expression {
          return params.action =='start'
        }
      }
      steps {
        echo "Planning Terraform Deployment..."
        sh "terraform plan"
      }
    }
    
    stage("Terraform Deployment") {
      when {
        expression {
          return params.action =='start'
        }
      }
      steps {
        echo "Bringing infrastructure online..."
        sh "terraform apply -auto-approve"
      }
    }

    stage("Terraform Destroy") {
      steps {
        when {
          expression { 
            return params.action == 'stop'
          }
        }
        echo "Bringing infrastructure down..."
        sh "terraform destroy -auto-approve"
      }
    }
  }
}