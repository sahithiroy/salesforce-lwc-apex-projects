public class EmployeeSecurity {
    public static void getRecords(String userparam){
        userparam =String.escapeSingleQuotes(userparam);
		String query = 'SELECT Id, Name FROM Account WHERE Name = \'' + userparam + '\'';
        System.debug(query);
		//List<Account> results = Database.query(query);
		List<Account> results = [SELECT Id, Name FROM Account WHERE Name = :userparam];
        System.debug(results);

    }

}