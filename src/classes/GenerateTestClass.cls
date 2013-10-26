/**
  * @description This class takes in a feature name and a eries of scenarios to generate a test class from them using the matched steps etc
  * that have been supplied to it.
  */
public with sharing class GenerateTestClass 
{
	private String contentString = '';
	private Map<String, String> functionMap;
	private BehaviourDefinitions defClass;

	public GenerateTestClass(String featureName, BehaviourDefinitions definitionClass)
	{
		if(featureName == null || featureName.length() < 10)
		{
			//Throw exception here!
		}

		contentString += '@isTest\npublic with sharing class ' + featureName.replaceAll(' ', '_') + '\n{\n';
		
		defClass = definitionClass;
		functionMap = defClass.functionDeclarationMap();
		System.debug(contentString);
	}

	public void buildTestSteps(Map<String, String> definitions, Map<String, List<Object>> stepsWithParameters, Map<String, List<String>> scenariosWithSteps)
	{
		for(String scenario : scenariosWithSteps.keySet())
		{
			String testContent = '@isTest\nprivate static void ' + scenario.replaceAll(' ', '_') + '()\n{\n';

			for(String testStep : scenariosWithSteps.get(scenario))
			{
				testContent += defClass.getStepCodeForFunctionWithParameters(functionMap.get(definitions.get(testStep)), stepsWithParameters.get(testStep)) + '\n';
			}

			testContent += '\n}\n';

			contentString += testContent;
		}
		
	}

	public String returnClass()
	{
		return contentString + '\n}';
	}
}