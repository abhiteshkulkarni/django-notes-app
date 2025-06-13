pipeline{
    agent{
        label 'slave'
    }
    stages{
        stage('Git Checkout'){
            steps{
                git url: 'https://github.com/abhiteshkulkarni/django-notes-app.git', branch:'main'
                echo 'successfully cloned the git Repository!!!'
            }
        }
        stage('Build'){
            steps{
                sh 'docker build -t notes-app:latesh .'
                echo 'Build Complete successfully'
            }
        }
         stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerHubCreds',
                    usernameVariable: 'dockerHubUser',
                    passwordVariable: 'dockerHubPass'
                )]) {
                sh 'docker login -u $dockerHubUser -p $dockerHubPass'
                sh 'docker tag notes-app:latesh abhitesh003/myrepo:djangonotes-app'
                sh 'docker push abhitesh003/myrepo:djangonotes-app'
                echo 'Successfully pushed the image'
                }
            }
        }
        stage('Deployment'){
            steps{
                sh 'docker compose up -d'
                }
            }    
        }
}
