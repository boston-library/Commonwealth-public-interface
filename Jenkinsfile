pipeline {
    agent any
       
    environment {
        RAILS_ENV = 'test'
    } 

    // These parameters come from Jenkins job configurations. 
    // We need manually provide them for every time. .
    parameters {
        // string(name: 'branch', defaultValue: 'jenkinsfile', description: 'checkout branch')
        string(name: 'OAUTH_APP_URL', defaultValue: 'http://localhost:3000', description: 'OAUTH_APP_URL')
        string(name: 'OAUTH_USER_APP_ID', defaultValue: 'xY_D****Q', description: 'OAUTH_USER_APP_ID')
        string(name: 'OAUTH_USER_APP_SECRET', defaultValue: '6f40***1a54', description: 'OAUTH_USER_APP_SECRET')
    }
    
    stages {
        stage('Show parameters') {
            steps {
                // echo "branch: ${params.branch}"
                echo "OAUTH_APP_URL: ${params.OAUTH_APP_URL}"
                echo "OAUTH_USER_APP_ID: ${params.OAUTH_USER_APP_ID}"
                echo "OAUTH_USER_APP_SECRET: ${params.OAUTH_USER_APP_SECRET}"
                // echo "credentialsId: ${params.}"
                echo "WORKSPACE_TMP: ${env.WORKSPACE_TMP}"
                echo "JOB_DISPLAY_URL: ${env.JOB_DISPLAY_URL}"
                echo "RUN_ARTIFACTS_DISPLAY_URL: ${env.RUN_ARTIFACTS_DISPLAY_URL}"
                echo "fullDisplayName: ${currentBuild.fullDisplayName}"
                echo "externalizableId: ${currentBuild.externalizableId}"
                echo "absoluteUrl: ${currentBuild.absoluteUrl}"
                echo "buildVariables: ${currentBuild.buildVariables}"
                echo "JOB_BASE_NAME: ${env.JOB_BASE_NAME}"
                echo "JOB_NAME: ${env.JOB_NAME}"
            }
        }
   
        // stage('CheckoutCode') {
        //     steps {
        //         checkout([$class: 'GitSCM', 
        //             branches: [[name: '*/${BRANCH_NAME}']], 
        //             userRemoteConfigs: [[
        //                 url: "https://github.com/boston-library/Commonwealth_3.git",
        //                 credentialsId: 'bplwebmaster'
        //                 ]]
        //         ])
        //     }
        // }

        stage('Checkout') {
            steps {
                git credentialsId: 'bplwebmaster',
                    url: 'https://github.com/boston-library/Commonwealth-public-interface.git',
                    // branch: [[name: '*/${BRANCH_NAME}']]
                    branch: "jenkinsfile"
            }
        }

                
        stage ('Install new ruby'){
            steps {
                sh '''#!/bin/bash --login
                    set +x
   
                    if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
                        source /var/lib/jenkins/.rvm/bin/rvm
                    else 
                        exit
                    fi
                    
                    EXPECTED_RUBY=`cat .ruby-version`
                                ## /var/lib/jenkins/.rvm/bin/rvm list
                    echo "EXPECTED_RUBY is $EXPECTED_RUBY"
                    set -x
                    rvm list
                    rvm use ${EXPECTED_RUBY} --default
                    ruby --version
                    
                '''
            }
        }
        
        stage('Preparation') {
            steps {
                sh '''#!/bin/bash --login
  
                    sudo sed -i 's/port = 5433/port = 5432/' /etc/postgresql/15/main/postgresql.conf
                    #sudo cp /etc/postgresql/{9.3,15}/main/pg_hba.conf
                    sudo pg_ctlcluster 15 main restart
                    
                    export RAILS_ENV=test
                    
                    export PGVER=15
                    export PGHOST=127.0.0.1
                    export PGUSER=postgres
                    export PGPASSWORD=postgres
                    export PGPORT=5432
                    export NOKOGIRI_USE_SYSTEM_LIBRARIES=true
                    export RAILS_VERSION=6.0.5
    
                    EXPECTED_RUBY=`cat .ruby-version`
                    BUNDLE_VER=$(tail -1 ./Gemfile.lock | xargs)
    
                    if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
                        source /var/lib/jenkins/.rvm/bin/rvm
                    else 
                        exit
                    fi
    
                    set -e
    
                    rvm use ${EXPECTED_RUBY} --default
                    ruby --version

                    echo "and bundle version is ${BUNDLE_VER}"

                    export LD_PRELOAD=/lib/x86_64-linux-gnu/libjemalloc.so.2
                    export BUNDLE_GEMFILE=$PWD/Gemfile                
                    gem update --system --no-document
                    gem install bundler:${BUNDLE_VER} --force --no-document
                    
                    ## Because previous capistrano deployment creates a new production.rb that
                    ## cannot pass the CI tests. Remove it if we are in test/staging environment
                    ## If in production environment, it should be passed by CI.
                    if [[ -f ./config/deploy/production.rb ]]; then 
                        ls -alt ./config/deploy/production.rb
                        git clean -f config/deploy/production.rb
                    else 
                        echo "There is NO ./config/deploy/production.rb yet"
                    fi 

                '''
            }
        }
        
        stage('bundle install') {
            steps {
                sh '''#!/bin/bash --login
                    set +x
                    
                    EXPECTED_RUBY=`cat .ruby-version`
    
                    if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
                        source /var/lib/jenkins/.rvm/bin/rvm
                    else 
                        exit
                    fi    
                    
                    rvm use ${EXPECTED_RUBY} --default
                    
                    bundle install --jobs=3 --retry=3
                    
                '''
            }
        }

        stage('DB preparation') {
            steps {
                sh '''#!/bin/bash --login
                    set +x
                    
                    ls -alt
                    EXPECTED_RUBY=`cat .ruby-version`
                
                    if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
                        source /var/lib/jenkins/.rvm/bin/rvm
                    else 
                        exit
                    fi    
                    
                    rvm use ${EXPECTED_RUBY} --default
                    set -x
                    
                    RAILS_ENV=${RAILS_ENV} bundle exec rails db:prepare
                    RAILS_ENV=${RAILS_ENV} bundle exec rails db:migrate
                    
                '''
            }
        }

        stage('CI') {
            // When JOB_NAME doesn't contain "deploy"
            when {
                expression {
                    // Only trigger following CI steps if JOB_NAME DOES NOT contain "deploy"
                    // That means if in deployment job, don't do CI tests.
                    return !env.JOB_NAME.contains('deploy')
                }
            }
            steps {
                sh '''#!/bin/bash --login
                    set +x

                    EXPECTED_RUBY=`cat .ruby-version`
    
                    if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
                        source /var/lib/jenkins/.rvm/bin/rvm
                    else 
                        exit
                    fi    
                    
                    rvm use ${EXPECTED_RUBY} --default
                    
                    RAILS_ENV=test bundle exec rake
                '''
            }
        }
        
        stage('Deploy') {
            when {
                expression {
                    // Only trigger if JOB_NAME contains "deploy"
                    return env.JOB_NAME.contains('deploy')
                }
            } 
            // steps {               
            //     script {
            //         sh """#!/bin/bash --login
            //             set -x
                        
            //             # STAGE_NAME=\$stage_name_password
            //             # SERVER_IP=\$server_ip_password
            //             # DEPLOY_USER=\$deploy_user_password
            //             # SSH_KEY=\$ssh_key_password
            //             # TESTING_SUDO_PASSWORD=\$sudo_pass_password
            //             # GIT_HTTP_USERNAME=\$GIT_HTTP_USERNAME_password
            //             # GIT_HTTP_PASSWORD=\$GIT_HTTP_PASSWORD_password
    

            //             EXPECTED_RUBY=`cat .ruby-version`
            //             echo "EXPECTED_RUBY is \$EXPECTED_RUBY"
                            
            //             set +x
                        
            //             if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
            //                 source /var/lib/jenkins/.rvm/bin/rvm
            //             else 
            //                 exit
            //             fi    
                        

            //             rvm list
            //             rvm install "\$EXPECTED_RUBY"
            //             rvm use "\$EXPECTED_RUBY" --default
            //             whereis ruby
            //             ruby --version

            //             RAILS_ENV=staging cap staging install --trace
            //             RAILS_ENV=staging cap -T
                        
                        
            //             ## If using GIT_HTTP_USERNAME/PASSWORD from Jenkins level, 
            //             ## Capistrano breaks here!
            //             RAILS_ENV=staging cap staging deploy:check
            //             RAILS_ENV=staging cap staging deploy --dry-run --trace
            //             RAILS_ENV=staging cap staging deploy --trace
                        
            //             if [[ -f ./config/deploy/production.rb ]]; then 
            //                 echo "There is ./config/deploy/production.rb created!"
            //                 ls -alt ./config/deploy/production.rb
            //             else 
            //                 echo "There is NO ./config/deploy/production.rb yet"
            //             fi   
            //         """
            //     }            
            // }
        }
    }

    post {
        // success {
        //     script {
        //         if (!env.JOB_NAME.contains('deploy')) {
        //             echo 'Triggering other projects...'
        //             build job: 'Commonwealth_3_jenkinsfile_deploy_test_capistrano', wait: false
        //             build job: 'Commonwealth_3_jenkinsfile_deploy_STAGING_capistrano', wait: false
        //         }
        //     }
        // }

        failure {
            emailext (
                subject: "Build failed in Jenkins: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>Build failed in Jenkins:</p>
                        <p>Job: ${env.JOB_NAME}</p>
                        <p>Build Number: ${env.BUILD_NUMBER}</p>
                        <p>Build URL: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>""",
                recipientProviders: [[$class: 'DevelopersRecipientProvider']],
                to: 'rmiao@bpl.org'
            )
        }
    }

}    
