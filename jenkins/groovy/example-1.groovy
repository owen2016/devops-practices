--保留`10`条构建历史记录
def numberOfBuildsToKeep = 10
Jenkins.instance.getAllItems(AbstractItem.class).each {
    if( it.class.toString() != "class com.cloudbees.hudson.plugins.folder.Folder" && it.class.toString() != "class org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject") {
        builds = it.getBuilds()
        println "total builds: " + builds.size()
        def j = 0
        for(int i = numberOfBuildsToKeep; i < builds.size()-j; i++) {
            builds.get(i).delete()
            i--
            j++
            println "Deleted: " + builds.get(i)
        }
    }
}