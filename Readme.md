#PEPINO

Pepino is a Behaviour Driven Development framework designed to work on Salesforce.com Platform and announced/released at the Dreamforce 2013 DevZone session "Behaviour Driven Development on Force.com With Apex" (slides and possibly recording to follow).

Please let us knwo your experiences of using Pepino (or even if you are using it) as this will help its development in the future.

##How to Use Pepino

Pepino requires you to have a couple of items in order to correctly function:
1. A file implementing the BehaviourDefinition interface. In this file you must define your steps and clarify what code should be returned from calling each step.
2. A feature file that utilises the steps defined above to describe a feature with a particular set of scenarios.

The BehaviourDefinition interface contains 2 methods that must be implemented for the system to correctly retrieve and return the code needed:

```java
Map<String, String> functionDeclarationMap();
String getStepCodeForFunctionWithParameters(String functionName, List<Object> parameters);
```

The first method returns a maps a step definition to a function call for the system to correctly retrieve the code. The step definition can/should contain regex to retrieve parameters as necessary so these can be passed through to your code. For examples see the CalculatorBehaviourDefinition file.

The second method takes in a function name from the previously defined map, along with a list of parameters and returns the code to be added to the test step as a string. This is required currently as there is no way of calling a method in a class dynamically (relfection) in apex currently (please upvote this idea to try and get this done https://success.salesforce.com/ideaView?id=08730000000BrVaAAK ). Should this support arrive - we will refactor and improve :-)

Your feature file should use the Gherkin syntax https://github.com/cucumber/cucumber/wiki/Gherkin to define your feature and scenarios for turning into a code test. An example feature file would contain:
```gherkin
   Feature: Addition
	   In order to avoid silly mistakes
	   As a math idiot
	   I want to be told the sum of 2 numbers
 
	   Scenario: Add two numbers
		   Given I have a calculator
		   And I have entered 50 into the calculator
		   And I have entered 70 into the calculator
		   When I press add
		   Then the result should be 120
```
##Future Plans for Pepino

1. Auto-upload of class to org
2. Auto-run tests
3. Build actions/ANT commands
4. Batch/bulkification - based upon feedback from real world usage
5. Packageable distribution

##Licensing

Pepino is released under the MIT License http://opensource.org/licenses/mit-license.php.

