public with sharing class FunctionRetriever
{
	private Map<String, String> stepDefinitionFunctionMap;

	public FunctionRetriever(Map<String, String> functionDeclarationMap)
	{
		stepDefinitionFunctionMap = functionDeclarationMap == null ? new Map<String, String>() : functionDeclarationMap; 
	}

	public Map<String, String> retrieveCorrectFunctions(Set<String> testSteps)
	{
		Map<String, String> bestMatches = new Map<String, String>();

		for(String step : testSteps)
		{
			Integer bestValue = 100;
			bestMatches.put(step, null);

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

	public Map<String, List<Object>> retrieveFunctionsWithParameters(Map<String, String> matches)
	{
		Map<String, List<Object>> functionsWithParameters = new Map<String, List<Object>>();

		for(String step : matches.keySet())
		{
			functionsWithParameters.put(step, new List<Object>());

			Pattern p = Pattern.compile(matches.get(step));
			Matcher m = p.matcher(step);

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