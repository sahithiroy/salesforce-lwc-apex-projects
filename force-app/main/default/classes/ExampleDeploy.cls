public with sharing class ExampleDeploy {
    public static List<Account> execute() {
        if (Schema.sObjectType.Account.isAccessible()) {
            return [SELECT ID, Name FROM Account LIMIT 5];
        }
        return new List<Account>();
    }

    public static void getRecords(String userparam){
        userparam = String.escapeSingleQuotes(userparam);
        if (Schema.sObjectType.Account.isAccessible()) {
            String query = 'SELECT Id, Name FROM Account WHERE Name = \'' + userparam + '\'';
            System.debug(query);
            List<Account> results = [SELECT Id, Name FROM Account WHERE Name = :userparam];
            System.debug(results);
        }
    }

    public static List<Contact> run() {
        if (Schema.sObjectType.Contact.isAccessible()) {
            return [SELECT ID, LastName FROM Contact LIMIT 5];
        }
        return new List<Contact>();
    }
}