public with sharing class ExampleDeploy {
    public static List<Account> execute() {
    

        return [SELECT ID,Name FROM Account limit 5];
    }
    public static List<Contact> run() {
    

        return [SELECT ID,Name FROM Contact limit 5];
    }

}