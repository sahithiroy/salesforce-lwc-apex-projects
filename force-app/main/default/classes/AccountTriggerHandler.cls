public class AccountTriggerHandler {
    public static void beforeInsert(List<Account> newList){
        for(Account acc :newList){
            if(acc.Industry!=Null && acc.Industry!='Media'){
                acc.Rating='Hot';
            }
            else{
                acc.Rating='Cold';
            }
        }
    }
    public static void afterInsert(List<Account> newList){
        List<Opportunity> oppListInsert=new List<Opportunity>();
        for(Account acc :newList){
            Opportunity opp=new Opportunity();
            opp.Name=acc.Name;
            opp.AccountId=acc.Id;
            opp.StageName='Prospecting';
            opp.CloseDate=System.today();
            oppListInsert.add(opp);
        }
        if (!oppListInsert.isEmpty()){
            insert oppListInsert;
        }
    }
    public static void beforeUpdate(List<Account> newList,Map<Id,Account>oldMap){
        for(Account acc :newList){
            if(oldMap!=null && acc.Phone!=oldMap.get(acc.Id).Phone){
                acc.Description='Phone is modified in account';
            }
        }
    }
    public static void afterUpdate(List<Account>newList,Map<Id,Account>oldMap){
        Map<Id,Account> accIdtoAccountMap=new Map<Id,Account>();
        List<Opportunity> oppToUpdated=new list<Opportunity>();
        for (Account Acc :newList){
            if(oldMap!=null && acc.Phone!=oldMap.get(acc.Id).Phone){
                accIdtoAccountMap.put(acc.Id,acc);
            }
        }

        for(Opportunity opp:[SELECT Id,Account_Phone__c,AccountId from Opportunity where AccountId in :accIdtoAccountMap.keySet()]){
            Opportunity oppor=new Opportunity();
            if(accIdtoAccountMap.containskey(opp.AccountId)){
                oppor.Id=opp.Id;
                oppor.Account_Phone__c=accIdtoAccountMap.get(opp.AccountId).Phone;
                oppToUpdated.add(oppor);
            }
        }if(!oppToUpdated.isEmpty()){
            update oppToUpdated;
        }
        
    }
}