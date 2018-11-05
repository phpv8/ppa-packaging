pipeline {
    agent {
        dockerfile { filename 'Dockerfile' }
    }
    environment {
        HOME = pwd()
        GH_TOKEN = credentials('GH_TOKEN')
        GPG_PRIVATE_KEY = credentials('GPG_PRIVATE_KEY')
        DEBFULLNAME = "Stefan Siegl (Automatic Signing Key)"
        DEBEMAIL = "stesie+buildbot@brokenpipe.de"
        USER = "stesie"
    }
    stages {
        stage('Prepare') {
            steps {
                sh 'echo $GPG_PRIVATE_KEY | base64 -d | gpg --import || true'
                sh 'echo "E5B2C7C056E926CD28F71FCE8B0CD97010C3F747:6:" | gpg --import-ownertrust'
                sh 'gpg -k'
            }
        }

        stage('Build') {
            steps {
                sh 'cd packaging/libv8 && make dput'
            }
        }
    }
}
