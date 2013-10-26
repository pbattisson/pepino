public interface BehaviourDefinitions
{
	Map<String, String> functionDeclarationMap();
	String getStepCodeForFunctionWithParameters(String functionName, List<Object> parameters);
}