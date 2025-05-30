public with sharing class ExampleDeploy {

    public static List<Account> execute() {
        if (!Schema.sObjectType.Account.isAccessible()) {
            throw new System.NoAccessException('User does not have access to Account object.');
        }
        return [SELECT Id, Name FROM Account LIMIT 5];
    }

    public static void getRecords(String userparam) {
        if (!Schema.sObjectType.Account.isAccessible()) {
            throw new System.NoAccessException('User does not have access to Account object.');
        }
        userparam = String.escapeSingleQuotes(userparam);
        String query = 'SELECT Id, Name FROM Account WHERE Name = \'' + userparam + '\'';
        System.debug(query);
        List<Account> results = [SELECT Id, Name FROM Account WHERE Name = :userparam];
        System.debug(results);
    }

    public static List<Contact> run() {
        if (!Schema.sObjectType.Contact.isAccessible()) {
            throw new System.NoAccessException('User does not have access to Contact object.');
        }
        return [SELECT Id, LastName FROM Contact LIMIT 5];
    }
}
