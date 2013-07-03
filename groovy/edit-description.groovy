def str_view = "QA Maint"
def view = Hudson.instance.getView(str_view)
 
//copy all projects of a view
for(item in view.getItems())
{

  //create the new project name
  item.description = '<a href="http://jenkins.qa1.eucalyptus-systems.com/job/' + item.getName() + '/lastBuild/downstreambuildview/?">Latest Result</a><br><a href="http://jenkins.qa1.eucalyptus-systems.com/job/' + item.getName() + '/lastFailedBuild/downstreambuildview/?">Latest Failed</a><br><a href="http://jenkins.qa1.eucalyptus-systems.com/job/' + item.getName() + '/lastStableBuild/downstreambuildview/?">Latest Stable</a><br>'
  print item.description    

}
