public class HighValueOpportunity {
    public static void updateAccount(List<Opportunity> newList){
        List<High_Value_Opportunity_Log__c> logs = new List<High_Value_Opportunity_Log__c>();
        set<Id> accountsIdstoUpdate=new set<Id>();
        if (newList!=null){
            for(Opportunity opp :newList){
                if(opp.amount>50000){
            		accountsIdstoUpdate.add(opp.AccountId);
                    System.debug('accountsIdstoUpdate'+accountsIdstoUpdate);
                    High_Value_Opportunity_Log__c log =new High_Value_Opportunity_Log__c(
                         Opportunity_Id__c=opp.Id,
                         Opportunity_Name__c=opp.Name,
                         Account__c=opp.AccountId,
                         OwnerId=opp.OwnerId,
                         Amount__c=opp.Amount,
                         Time_Stamp__c=System.now()
                    );
                    logs.add(log);
          
                }
            }
        }
        if (!accountsIdstoUpdate.isEmpty()) {
        	List<Account> accountsToUpdate = [SELECT Id, High_Value_Customer__c FROM Account WHERE Id IN :accountsIdstoUpdate];
        	for (Account acc : accountsToUpdate) {
            	acc.High_Value_Customer__c = true;
        	}
        	update accountsToUpdate;
    	}
        if(!logs.isEmpty()){
            insert logs;
        }
        
    }

}