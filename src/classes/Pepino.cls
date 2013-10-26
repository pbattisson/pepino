public with sharing class Pepino
{
	private String feature;
	private Map<String, List<String>> steps;
	private	BehaviourDefinitions definitionCls;
	private FunctionRetriever retriever;

	public Pepino(String featureName, Map<String, List<String>> scenarioSteps, BehaviourDefinitions definitionClass) 
	{
		feature = featureName;
		steps = scenarioSteps;
		definitionCls = definitionClass;

		retriever = new FunctionRetriever(definitionCls.functionDeclarationMap());
	}


	public Blob createTestClassForFeature()
	{
		Set<String> allSteps = new Set<String>();
		for(String scenario : steps.keySet())
		{
			allSteps.addAll(steps.get(scenario));
		}


		Map<String, String> definitions = retriever.retrieveCorrectStepDefinition(allSteps);
		Map<String, List<Object>> functionsWithParameters = retriever.retrieveFunctionsWithParameters(definitions);

		GenerateTestClass gtc = new GenerateTestClass(feature, definitionCls);
		gtc.buildTestSteps(definitions, functionsWithParameters, steps);
		
		String returnClass = gtc.returnClass();
		System.debug(returnClass);

		return Blob.valueOf(returnClass);
	}
}