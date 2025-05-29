public class OpportunityActivityAnalyzer implements Queueable{
    Map<Id, ScoreData> scoreMap;
    public OpportunityActivityAnalyzer(Map<Id, ScoreData> input) {
        this.scoreMap = input;
    }
    map<Id,Integer> CountOfOpps=new  map<Id,Integer>();
    public void execute(QueueableContext context){
        Date RecentlyCutoffDate=Date.today().addMonths(-2);
        List<Account> opplist=[SELECT Id, Name, (SELECT Id,CloseDate FROM Opportunities where CloseDate>= :RecentlyCutoffDate or CloseDate=null) FROM Account];
        for(Account acc: opplist){
            Id accId = acc.Id;
            System.debug('accId'+accId);
            Integer oppCount = acc.Opportunities.size();
            System.debug('oppCount'+oppCount);
            if(oppCount>0){
                if(!scoreMap.containsKey(accId)) scoreMap.put(accId, new ScoreData());
            	scoreMap.get(accId).opps = oppCount; 
            }
                       
        }
         System.debug('scoreMap size'+scoreMap.size());
        System.debug('scoreMap'+scoreMap);
        System.enqueueJob(new SalesHealthScoreUpdater(scoreMap));
    }

}