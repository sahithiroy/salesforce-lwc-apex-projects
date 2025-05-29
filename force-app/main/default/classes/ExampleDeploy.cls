public with sharing class ExampleDeploy {
    public static List<Account> execute() {
    

        return [SELECT ID,Name FROM Account limit 5];
    }
    public static List<Contact> run() {
    

        return [SELECT ID,Name FROM Contact limit 5];
    }
    public static void getRecords(String userparam){
        userparam =String.escapeSingleQuotes(userparam);
		String query = 'SELECT Id, Name FROM Account WHERE Name = \'' + userparam + '\'';
        System.debug(query);
		//List<Account> results = Database.query(query);
		List<Account> results = [SELECT Id, Name FROM Account WHERE Name = :userparam];
        System.debug(results);

    }

}