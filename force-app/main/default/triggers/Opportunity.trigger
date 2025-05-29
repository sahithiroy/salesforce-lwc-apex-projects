trigger Opportunity on Opportunity (after insert,after  update) {
    if (trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate){
            HighValueOpportunity.updateAccount(Trigger.new);
        }
    }

}