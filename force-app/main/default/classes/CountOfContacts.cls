public class CountOfContacts {
    public static void UpdateCountOfContacts(List<Contact> newList,Map<Id,Contact>oldMap){
       Set<Id> accountIds=new Set<id>();
        if (newList !=Null){
            for (Contact c:newList){
            if (c.AccountId!=Null){
                accountIds.add(c.AccountId);
            }
        }
        }
        if (oldMap != null) {
            for (Contact c : oldMap.values()) {
                if (c.AccountId != null) {
                    accountIds.add(c.AccountId);
                }
            }
        }
        Map<Id, Integer> contactCounts = new Map<Id, Integer>();
        for (AggregateResult ar : [
            SELECT AccountId, COUNT(Id) contactCount
            FROM Contact
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            contactCounts.put((Id) ar.get('AccountId'), (Integer) ar.get('contactCount'));
        }
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountIds) {
            Account acc = new Account(
                Id = accId,
                Contact_Count__c = contactCounts.containsKey(accId) ? contactCounts.get(accId) : 0
            );
            accountsToUpdate.add(acc);
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
                
    }

}