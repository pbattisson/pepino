@isTest
private class FileReaderControllerTest {
	
	static testMethod void validateReadFile() 
	{
		FileReaderController con =  new FileReaderController();
		
		Blob myFile = createFile();
		con.file = myFile;
		con.selectedApexClass = 'CalculatorBehaviourDefinitions';
		
		List<UserFeed> feedsBefore = [Select Id From UserFeed ];
		
		System.assertEquals(null,con.ReadFile());
		
		List<UserFeed> feedsAfter = [Select Id From UserFeed ];
		System.assertEquals(feedsBefore.size()+1, feedsAfter.size());
		
	}
	
	static testMethod void testSetFeatureName()
	{
		FileReaderController con = new FileReaderController();
		
		Blob myFile = createFile();
		con.file = myFile;
		con.contentFile=myfile.toString();
		
		con.setFeatureName();
		
		System.AssertEquals('Addition', con.featureName);
	}
	
	static testMethod void testGetScenarioName( )
	{
		FileReaderController con = new FileReaderController();
		
		Blob myFile = createFile();
		con.file = myFile;
		con.contentFile=myfile.toString();
		
		String scenarioName = con.getScenarioName(createScenario());
		System.assertEquals('Add two numbers',scenarioName);
	
	}
	
	static testmethod void testGetNumberOfScenarios()
	{
		FileReaderController con = new FileReaderController();
		
		Blob myFile = createFile();
		con.file = myFile;
		con.contentFile=myfile.toString();
		
		Integer totalScenarios = con.getNumberOfScenarios();
		System.assertEquals(1,totalScenarios);
	} 
	
	static testmethod void testBuildScenariosMap()
	{
		FileReaderController con = new FileReaderController();
		
		Blob myFile = createFile();
		con.file = myFile;
		con.contentFile=myfile.toString();
		
		con.buildScenariosMap();
		
		System.assertEquals(con.scenarioNameAndListSteps.get('Add two numbers').size(), createScenarioMap().get('Add two numbers').size());
	}
	
	private static Map<String, List<String>> createScenarioMap()
	{
		Map<String, List<String>>  scenarios = new Map<String, List<String>> ();
		
		List<String> steps = new List<String>() ;
		steps.add('I have entered 50 into the calculator');
		steps.add('I have entered 70 into the calculator');
		steps.add('I have entered 5 into the calculator ');
		steps.add('I press add');
		steps.add('the result should be 120');
		
		scenarios.put('Add two numbers', steps);
		
		return scenarios;
	}
	
	private static String createScenario()
	{
		String scenario = 'Add two numbers Given I have entered 50 into the calculator '+
							  'And I have entered 70 into the calculator '+
							  'And I have entered 5 into the calculator '+
							  'When I press add Then the result should be 120';
							  
		return scenario;
	}
	private static Blob createFile()
	{
		String contentFile = 'Feature: Addition '+
							  'In order to avoid silly mistakes '+ 
							  'As a math idiot I want to be told the sum of two numbers '+
							  'Scenario: Add two numbers Given I have entered 50 into the calculator '+
							  'And I have entered 70 into the calculator '+
							  'And I have entered 5 into the calculator '+
							  'When I press add Then the result should be 120';
							  
		return Blob.valueOf(contentFile);
	}

}