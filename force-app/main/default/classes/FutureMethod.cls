public class FutureMethod {
    @future
    public static void countContacts(List<Id> accIds){
        List<Account> acclis=[SELECT Id,(SELECT Id FROM Contacts)
                             from Account where Id IN: accIds];
        for (Account acc:acclis){
            acc.Number_Of_Contacts__c=acc.Contacts.size();
        }
        if(!acclis.isEmpty()){
            update acclis;
        }
        
    }

}