#!groovy

library "github.com/melt-umn/jenkins-lib"

melt.setProperties(silverBase: true)

melt.trynode("ableP") {

  def newenv

  stage ("Checkout") {
    // Clean Silver-generated files from previous builds in this workspace
    melt.clearGenerated()
    
    // Get Silver
    def silver_base = silver.resolveSilver()

    // Get AbleC
    def ablec_base = ablec.resolveAbleC()
    
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

    newenv = silver.getSilverEnv(silver_base) + [
      "ABLEC_BASE=${ablec_base}",
      // libcord, libgc, cilk headers:
      "C_INCLUDE_PATH=/project/melt/Software/ext-libs/usr/local/include",
      "LIBRARY_PATH=/project/melt/Software/ext-libs/usr/local/lib"
    ]
    if (params.ABLEC_GEN != 'no') {
    echo "Using existing ableC generated files: ${params.ABLEC_GEN}"
      newenv << "SILVER_HOST_GEN=${params.ABLEC_GEN}"
    }
  }

  stage ("Build") {
    // For this project, re-using 'generated' gains as much as parallelism, so don't bother
    withEnv(newenv) {
      dir("ableP") {
        sh "./build-all"
        // clean up
        sh "rm *.jar"
      }
    }
  }

  /* If we've gotten all this way with a successful build, don't take up disk space */
  melt.clearGenerated()
}
