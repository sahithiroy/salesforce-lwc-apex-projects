public class SalesHealthScoreUpdater implements Queueable{
    Map<Id, ScoreData> scoreMap;
    public SalesHealthScoreUpdater(Map<Id, ScoreData> input) {
        this.scoreMap = input;
    }
    public void execute(QueueableContext context){
        List<Account> updates = new List<Account>();
        System.debug('scoreMap size'+scoreMap.size());
		System.debug('scoreMap'+scoreMap);
        for (Id accId : scoreMap.keySet()) {
            ScoreData data = scoreMap.get(accId);
            System.debug('accId'+accId);
            System.debug('data.contacts'+data.contacts);
            System.debug('data.opps'+data.opps);
            Decimal score = (data.contacts * 1.5) + (data.opps * 2);
            System.debug('score'+score);
            updates.add(new Account(Id = accId, Sales_Health_Score__c = score,AccountEmail__c='test@gmail.com',AnnualRevenue=56000,NumberofLocations__c=4,phone='1234567898'));
            System.debug('updates'+updates);
        }

        if (!updates.isEmpty()){ 
            try{
            System.debug('start updating');
            update updates;
            }
            catch(Exception e){
                System.debug('failed updating'+ e.getMessage());
            }
        }
                                

        System.enqueueJob(new SalesManagerNotifier());
        
    }
}