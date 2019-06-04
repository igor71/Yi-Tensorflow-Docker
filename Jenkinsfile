pipeline {
  agent {label 'yi-tflow-vnc'}
    stages {
        stage('Import yi/tflow-gui Docker Image') {
            steps {
                sh '''#!/bin/bash -xe
                   # Bacic Docker Image For Tensorflow Version 1.13 & Horovod
                      image_id="$(docker images -q nvidia/cuda:9.0-devel-ubuntu16.04)"
                      echo "Basic Docker Image For Current Branch Is: $image_id"
                   
                      # Check If Docker Image Exist On Desired Server
                      if [[ "$(docker images -q yi/tflow-gui:1.12 2> /dev/null)" == "" ]]; then
                         docker pull nvidia/cuda:9.0-devel-ubuntu16.04
                      else
                         echo "Docker Image Already Exist"
                      fi
		            ''' 
            }
        }
        stage('Build Docker Image ') {
            steps {
                sh '''#!/bin/bash -xe
                        SRV=$(echo ${target_server} | awk -F [-] '{print $2}')
                        curl -OSL ftp://jenkins-cloud/pub/map.csv -o map.csv
                        FTP_PATH=$(awk -F [,] -v srv="$SRV" '$6==srv' map.csv |  awk -F [,] -v python_version="$python_version" '$5==python_version' | awk -F [,] -v tf_version="$tensorflow_version" '$7~tf_version' | awk -F, '{print $4}')
                        FILE_NAME=$(echo $FTP_PATH | awk -F [/] '{print $6}')
	       		docker build --build-arg FILE_NAME=${FILE_NAME} --build-arg FTP_PATH=${FTP_PATH} -f Dockerfile-tf-${python_version} -t yi/tflow-vnc:${tensorflow_version}-python-${python_version}-horovod .
		            ''' 
            }
        }
	    stage('Test Docker Image') { 
            steps {
                sh '''#!/bin/bash -xe
		   echo 'Hello, Tensorflow_Docker'
                    image_id="$(docker images -q yi/tflow-vnc:${tensorflow_version}-python-${python_version}-horovod)"
                      if [[ "$(docker images -q yi/tflow-vnc:${tensorflow_version}-python-${python_version}-horovod 2> /dev/null)" == "$image_id" ]]; then
                          docker inspect --format='{{range $p, $conf := .RootFS.Layers}} {{$p}} {{end}}' $image_id
                      else
                          echo "It appears that current docker image corrapted!!!"
                          exit 1
                      fi 
                   ''' 
		    }
		}
		stage('Save & Load Docker Image') { 
            steps {
                sh '''#!/bin/bash -xe
		        echo 'Saving Docker image into tar archive'
                        docker save yi/tflow-vnc:${tensorflow_version}-python-${python_version}-horovod | pv | cat > $WORKSPACE/yi-tflow-vnc-${tensorflow_version}-python-${python_version}-horovod.tar
			
                        echo 'Remove Original Docker Images' 
			CURRENT_ID=$(docker images | grep -E '^yi/tflow-vnc.*'${tensorflow_version}-python-${python_version}-horovod'' | awk -e '{print $3}')
			docker rmi -f yi/tflow-vnc:${tensorflow_version}-python-${python_version}-horovod
			docker rmi -f nvidia/cuda:9.0-devel-ubuntu16.04
			
                        echo 'Loading Docker Image'
                        pv -f $WORKSPACE/yi-tflow-vnc-${tensorflow_version}-python-${python_version}-horovod.tar | docker load
			docker tag $CURRENT_ID yi/tflow-vnc:${tensorflow_version}-python-${python_version}-horovod 
                        
                        echo 'Removing temp archive.'  
                        rm $WORKSPACE/yi-tflow-vnc-${tensorflow_version}-python-${python_version}-horovod.tar
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
