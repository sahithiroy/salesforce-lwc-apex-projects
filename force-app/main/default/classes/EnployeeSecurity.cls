public class EnployeeSecurity {
    public static void getRecords(String userparam){
        /*string query='SELECT First_Name__c,Salary__c FROM Employee__c';
        List<Employee__c> employee_details=Database.query(query,AccessLevel.SYSTEM_MODE);
        System.debug('******');
        System.debug(employee_details);
        System.debug('******');
        */
        string query='SELECT Id,Name,AnnualRevenue FROM Account';
        string whereClause=' WHERE Name=\'' +userparam+ '\'';
        query+=whereClause;
        System.debug(query);
        List<Account> lstAccount=Database.query(query);
        System.debug(lstAccount);
    }

}