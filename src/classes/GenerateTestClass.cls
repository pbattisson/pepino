/**
  * @description This class takes in a feature name and a eries of scenarios to generate a test class from them using the matched steps etc
  * that have been supplied to it.
  */
public with sharing class GenerateTestClass 
{
	private String contentString = '';
	private Map<String, String> functionMap;
	private String typeName = '';

	public GenerateTestClass(String featureName, Map<String, String> funcMap, String defTypeName)
	{
		if(featureName == null || featureName.length() < 10)
		{
			//Throw exception here!
		}

		if(funcMap == null || funcMap.keySet().size() == 0)
		{
			//Throw exception here
		}

		contentString += '@isTest\npublic with sharing class ' + featureName.replaceAll(' ', '_') + '\n{\n';
		functionMap = funcMap;
		typeName = defTypeName;

		System.debug(contentString);
	}

	public void buildTestSteps(Map<String, String> definitions, Map<String, List<Object>> stepsWithParameters, Map<String, List<String>> scenariosWithSteps)
	{
		for(String scenario : scenariosWithSteps.keySet())
		{
			String testContent = '@isTest\nprivate static void ' + scenario.replaceAll(' ', '_') + '()\n{\n';

			for(String testStep : scenariosWithSteps.get(scenario))
			{
				BehaviourDefinitions def = (BehaviourDefinitions)Type.forName(typeName).newInstance();

				System.debug('PAUL 1 STEP DEF : ' + functionMap.get(definitions.get(testStep)) + ' : ' + testStep);
				System.debug('PAUL 2 STEP PARAMS : ' + stepsWithParameters.get(testStep));
				testContent += def.getStepCodeForFunctionWithParameters(functionMap.get(definitions.get(testStep)), stepsWithParameters.get(testStep));
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