/**
  * @description This class is used to 
  * 
  */
public with sharing class FileReaderController 
{
    public Blob file{get;set;} // File comming from UI
    public String nameFile{get;set;} // File already converted to String
    public String contentFile{get;set;}
    public Boolean hasUploaded{get;set;}
    public String selectedApexClass{get;set;}
    
    @TestVisible private List<ApexClass> apexClasses{get;set;}
    @TestVisible private String featureName;
    @TestVisible private Map<String,List<String>> scenarioNameAndListSteps = new Map<String, List<String>>();
     
    @TestVisible private Pepino pepino;
    
    /**
      * @description Constructor for the class 
      * @param 
      */
    public FileReaderController()
    {
        hasUploaded=false;
        
        apexClasses= [SELECT Name FROM ApexClass WHERE (Name LIKE '%BehaviourDefinition%' OR Name Like '%BehaviorDefinition%' )AND Name!='BehaviourDefinitions' ];
            
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Please select', 'Please select', true));
        for(ApexClass apexClass:apexClasses)
        {
            options.add(new SelectOption(apexClass.Name,apexClass.Name));
        }

        return options; 
    }
    
    /**
      * @description 
      * @param 
      */
    public Pagereference ReadFile()
    {
        contentFile=file.toString();
        
        //buildTestStepsSet();
        
        
        buildScenariosMap();
        if(!scenarioNameAndListSteps.isEmpty())
        {
        	setFeatureName();
        	
            Type t = Type.ForName(selectedApexClass);
            BehaviourDefinitions bd = (BehaviourDefinitions) t.newInstance();
        
            pepino = new Pepino(featureName, scenarioNameAndListSteps, bd);
           
            Blob createdClass = pepino.createTestClassForFeature();
    
            //LETS UPDATE CHATTER POST
            hasUploaded= true;
          
            addingContentPost( UserInfo.getUserId(), createdClass, featureName+'.cls');
        }
        else
        {
            //post error message
            addingErrorPost(UserInfo.getUserId());
            
        }
            
        
        return null; // might be redirect home page --- in MicroMoment refresh feed :)
    }
    
    
    @TestVisible private void setFeatureName()
    {
        if(String.isNotBlank(contentFile))
        {
            featureName = contentFile.substringAfter('Feature:');
            featureName= featureName.substringBefore('In order to');
            featureName = featureName.trim();
            featureName = featureName.replaceAll(' ','_');
            
        } 
    }
    
    @TestVisible private String getScenarioName( String scenario)
    {
        String scenarioName;
        
        if(String.isNotBlank(contentFile))
        {
           // scenarioName = contentFile.substringAfter('Scenario:');
            scenarioName = scenario.substringBefore('Given');
            scenarioName = scenarioName.trim();
        }
        
        return scenarioName;
    }
    
    @TestVisible private Integer getNumberOfScenarios()
    {
        return contentFile.countMatches('Scenario:');
    }
    
    @TestVisible private void buildScenariosMap()
    {
        //add more validations for determinate format
        if(String.isNotBlank(contentFile))
        {
            Integer totalScenarios = getNumberOfScenarios(); 
            String contentFileAux = contentFile;
            
            
            while(totalScenarios > 0)
            {
            
                //remove feature Name 
                String scenario = contentFileAux.substringAfter('Scenario:');
                 //process 1 scenario
                String scenarioName = getScenarioName(scenario);
              
                if(totalScenarios > 1)
                {
                    contentFileAux = scenario;
                    scenario = scenario.substringBefore('Scenario:');
                }
               
              
                if(String.isNotBlank(scenarioName))
                {
                    List<String> testSteps = getTestStepsForScenario(scenario);
                    if(testSteps!=null && !testSteps.isEmpty())
                        scenarioNameAndListSteps.put(scenarioName, testSteps);
                }
                
                totalScenarios--; 
             
            }
            
        }
    }
    
    @TestVisible private List<String> getTestStepsForScenario(String scenario)
    {
        List<String> testSteps= new List<String>();
        
        if(String.isNotBlank(scenario)) 
        {
            String testStep;
            
            scenario = scenario.substringAfter('Given'); 
            testStep = scenario.subStringBefore('And');
            testSteps.add(testStep.trim());
            scenario= scenario.subStringAfter('And');
    
            while(scenario.contains('And'))
            {
                testStep = scenario.subStringBefore('And');
                testSteps.add(testStep.trim());
                scenario = scenario.subStringAfter('And');
            }
            
            testStep = scenario.subStringBefore('When');
            testSteps.add(testStep.trim());
            scenario = scenario.subStringAfter('When');
            
            testStep = scenario.subStringBefore('Then');
            testSteps.add(testStep.trim());
            scenario= scenario.subStringAfter('Then');
            
            //if only have one scenario
            testSteps.add(scenario.trim());
            
        }
        return testSteps;
        
    }
    
    //adding error post
    @TestVisible private static void addingErrorPost(Id parentId)
    {
        FeedItem post = new FeedItem();
        post.ParentId = parentId; //eg. Opportunity id, custom object id.. // user id
        post.Body = 'We can not create the class. Review your selection, might be the file is not formated correctly';
        
        insert post;
    }
    
      //Adding a Content post
    @TestVisible private static void addingContentPost(Id parentId, Blob fileBody, String fileName)
    {   
        FeedItem post = new FeedItem();
        post.ParentId = parentId; //eg. Opportunity id, custom object id.. // user id
        post.Body = 'New class has been created for your scenario.';
        post.ContentData = fileBody;
        post.ContentFileName = fileName;
        insert post;
    }
    


}