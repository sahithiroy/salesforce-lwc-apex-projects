public with sharing class ExampleDeploy {
    public static void execute() {
    

        return [SELECT ID,Name FROM Account limit 5];
    }
    public static void run() {
    

        return [SELECT ID,Name FROM Account limit 5];
    }

}