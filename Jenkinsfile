pipeline {
    agent any

    environment {
        PMD_HOME = "/opt/pmd-bin-7.0.0"  // Path where PMD is installed on your Jenkins agent
        REPORT_FILE = "pmd-report.xml"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/sahithiroy/salesforce-lwc-apex-project.git'
            }
        }

        stage('Run PMD for Apex') {
            steps {
                sh """
                ${PMD_HOME}/bin/pmd check \
                    -d force-app/main/default \
                    -R pmd-apex-rules.xml \
                    -f xml \
                    -r ${REPORT_FILE}
                """
            }
        }

        stage('Publish PMD Report') {
            steps {
                recordIssues(
                    tools: [pmdParser(pattern: REPORT_FILE)],
                    qualityGates: [[threshold: 1, type: 'TOTAL', unstable: true]]
                )
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: REPORT_FILE, allowEmptyArchive: true
        }
    }
}
