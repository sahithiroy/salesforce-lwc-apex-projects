public with sharing class PublicAccountController {
    public class PublicAccountException extends Exception{}
    
   public static List<Account> getAccounts(String industryFilter) {
        try {
           
            List<Account> results = [
                SELECT Id, Name, Phone, AnnualRevenue 
                FROM Account 
                WHERE Industry = :industryFilter
            ];
            SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, results);
            System.debug(decision);
            return (List<Account>) decision.getRecords();
        } catch (Exception e) {
            //Logger.log('Error in getAccounts: ' + e.getMessage());
            throw new PublicAccountException('Unable to fetch accounts.');
        }
    }

    public static void createAccount(String name, Decimal revenue) {
        try{
        Account acc = new Account(Name = name, AnnualRevenue = revenue);
        insert acc;
        }
        catch(Exception e){
            throw new PublicAccountException('Unable to create records');
        }
    }

    public static void updateAccountPhone(Id accId, String newPhone) {
        Account acc = [SELECT Id, Phone FROM Account WHERE Id = :accId];
        acc.Phone = newPhone;
        update acc;
    }
}