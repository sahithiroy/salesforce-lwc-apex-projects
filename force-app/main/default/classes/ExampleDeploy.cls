public with sharing class ExampleDeploy {
    public static void execute() {
        System.debug('This is execute');
        return [SELECT ID,Name FROM Account limit 5];
    }
}