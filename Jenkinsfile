#!groovy

library "github.com/melt-umn/jenkins-lib"

melt.setProperties(silverBase: true)

node {
try {

  def newenv = melt.getSilverEnv()

  stage ("Checkout") {
    // Checkout AbleC
    checkout([$class: 'GitSCM',
              branches: [[name: '*/develop']], // Right now we always checkout develop, because this repo uses 'master' and we don't want to always checkout 'master'
              doGenerateSubmoduleConfigurations: false,
              extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'ableC'],
                           [$class: 'CleanCheckout']],
              submoduleCfg: [],
              userRemoteConfigs: [[url: 'https://github.com/melt-umn/ableC.git']]])
    // Checkout AbleP
    checkout([$class: 'GitSCM',
              branches: scm.branches,
              doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
              extensions: [
                [$class: 'RelativeTargetDirectory', relativeTargetDir: "ableP"],
                [$class: 'CleanCheckout']
              ],
              submoduleCfg: scm.submoduleCfg,
              userRemoteConfigs: scm.userRemoteConfigs
              ])

    melt.clearGenerated()
  }

  stage ("Build") {
    // For this project, re-using 'generated' gains as much as parallelism, so don't bother
    withEnv(newenv) {
      dir("ableP") {
        sh "./build-all"
      }
    }
  }

  /* If we've gotten all this way with a successful build, don't take up disk space */
  melt.clearGenerated()
}
catch (e) {
  melt.handle(e)
}
finally {
  melt.notify(job: 'ableP')
}
} // node

