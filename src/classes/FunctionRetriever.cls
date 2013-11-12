/**
  * @description This class is used to take a map of step definitions and given a bunch of test steps can then retrieve 
  * the correct function to call and the parameters from the test step to pass into the function.
  */
public with sharing class FunctionRetriever
{
	//This map holds the mappings from the step definition to the function a step should call. 
	private Map<String, String> stepDefinitionFunctionMap;

	/**
	  * @description Constructor for the class that takes in the map from step definition to function for use.
	  * @param functionDeclarationMap The map from step definition to function.
	  */
	public FunctionRetriever(Map<String, String> functionDeclarationMap)
	{
		//If passed in null then we will just instantiate a blank map.
		stepDefinitionFunctionMap = functionDeclarationMap == null ? new Map<String, String>() : functionDeclarationMap; 
	}

	/**
	  * @description This method is used to retrieve a map of test steps to step definitions for use. It matches the entry
	  * against a step definition using the Levenshtein distance rather than using regular expressions to match straight
	  * away. This has been done for speed and efficiency but could be changed in the future for increased accuracy if required.
	  * @param testSteps The test steps to retrieve the correct step definitions for.
	  * @return A map of the test steps to the correct step definition.
	  */
	public Map<String, String> retrieveCorrectStepDefinition(List<String> testSteps)
	{
		Map<String, String> bestMatches = new Map<String, String>();

		//Loop through all of our test steps
		for(String step : testSteps)
		{
			//Set a preliminary high watermark level that should easily be beaten and place the step into the map whatever
			Integer bestValue = 100;
			bestMatches.put(step, null);

			//Loop through all the available step definitions and determine whether or not the step is closer to this or 
			//not, updating the map as required
			for(String stepDefinition : stepDefinitionFunctionMap.keySet())
			{
				if(step.getLevenshteinDistance(stepDefinition) < bestValue)
				{
					bestMatches.put(step, stepDefinition);
					bestValue = step.getLevenshteinDistance(stepDefinition);
				}
			}
		}

		return bestMatches;
	}

	/**
	  * @description This method retrieves a list of parameters from the steps using the defined regex patterns in the 
	  * step definition. It can handle multiple patterns and needs them marked as a goup to retrieve them correctly.
	  * @param matches The map of steps to step definitions for use in retrueving the parameters.
	  * @return A map of the test step content to the list of parameters we have retrieved from it using the step definition regex.
	  */
	public Map<String, List<Object>> retrieveFunctionsWithParameters(Map<String, String> matches)
	{
		Map<String, List<Object>> functionsWithParameters = new Map<String, List<Object>>();

		for(String step : matches.keySet())
		{
			functionsWithParameters.put(step, new List<Object>());

			Pattern p = Pattern.compile(matches.get(step));
			Matcher m = p.matcher(step);
			System.debug('We are processing step ' + step + '  ' + m.matches());

			if(m.matches())
			{
				for(Integer i = 1; i <= m.groupCount(); i++)
			    {
			    	functionsWithParameters.get(step).add(m.group(i));
			        System.debug('Group ' + i + ' : ' + m.group(i));
			    }
			}
		}

		return functionsWithParameters;
	}
}