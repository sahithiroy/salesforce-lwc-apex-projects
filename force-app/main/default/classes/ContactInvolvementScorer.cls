public class ContactInvolvementScorer implements Queueable {
    map<Id,ScoreData> mapScore=new map<Id,ScoreData>();
    public void execute(QueueableContext context){
        List<Account> acclist=[SELECT Id, Name, (SELECT Id, Name, Email FROM Contacts) FROM Account ];
        for(Account accRecord:acclist){
            Integer count =accRecord.Contacts.Size();
            if(count>0){
                Id accId = accRecord.Id;
            	System.debug('accId'+accId);
                Integer contactCount = count;
            	System.debug('contactCount'+contactCount);
            	ScoreData score = new ScoreData();
            	score.contacts = contactCount;
            	mapScore.put(accId, score);
            }
            
        }
        System.debug('mapScore size'+mapScore.size());
        System.debug('mapScore'+mapScore);
        
        System.enqueueJob(new OpportunityActivityAnalyzer(mapScore));
        
    }
}