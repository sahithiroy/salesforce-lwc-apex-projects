trigger futuretrigger on Account (after update) {
    for(Account acc: Trigger.new){
        Account oldAcc = Trigger.oldMap.get(acc.Id);
        if (acc.Website != oldAcc.Website && acc.Website != null) {
            futureMethod1.updateContactEmailsAsync(acc.Id, acc.Website);
        }
    }

}