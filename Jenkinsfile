pipeline {
  agent {label 'tflow-gpu-3.6'}
    stages {
        stage('Create Docker-Build Image For Tensorflow-GPU-MKL') {
            steps {
	              sh 'docker build -t yi/tflow-vnc:1.8.0-python-3.6.3-test .'  
            }
        }
	      stage('Test Docker-Build Image') { 
            steps {
                sh '''#!/bin/bash -xe
		              echo 'Hello, YI-TFLOW!!'
                    image_id="$(docker images -q yi/tflow-vnc:1.8.0-python-3.6.3-test)"
                      if [[ "$(docker images -q yi/tflow-vnc:1.8.0-python-3.6.3-test 2> /dev/null)" == "$image_id" ]]; then
                          docker inspect --format='{{range $p, $conf := .RootFS.Layers}} {{$p}} {{end}}' $image_id
                      else
                          echo "It appears that current docker image corrapted!!!"
                          exit 1
                      fi 
                   ''' 
            }
        }
    }
	post {
            always {
               script {
                  if (currentBuild.result == null) {
                     currentBuild.result = 'SUCCESS' 
                  }
               }
               step([$class: 'Mailer',
                     notifyEveryUnstableBuild: true,
                     recipients: "igor.rabkin@xiaoyi.com",
                     sendToIndividuals: true])
            }
         } 
}
