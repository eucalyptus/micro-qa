def str_view = "QA Mainline"
def view = Hudson.instance.getView(str_view)
 
//copy all projects of a view
for(item in view.getItems())
{ 
  //Get all properties of the project
  prop = item.getProperty(ParametersDefinitionProperty.class)
  item.description = '<a href="http://jenkins.qa1.eucalyptus-systems.com/job/' + item.getName() + '/lastBuild/downstreambuildview/?">Latest Result</a><br>'
  item.description += '<a href="http://jenkins.qa1.eucalyptus-systems.com/job/' + item.getName() + '/lastFailedBuild/downstreambuildview/?">Latest Failed</a><br>'
  item.description += '<a href="http://jenkins.qa1.eucalyptus-systems.com/job/' + item.getName() + '/lastStableBuild/downstreambuildview/?">Latest Stable</a><br>'
  item.description += '<a href="http://jenkins.qa1.eucalyptus-systems.com/job/qa-free-machines/buildWithParameters?test_name=' + prop.getParameterDefinition("test_name").getDefaultParameterValue().value + '">Free Machines</a><br>'
    
  println item.description    
}
