trigger TriggerTest on Account (before insert,after insert,before update,after update) {
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            AccountTriggerHandler.beforeInsert(Trigger.new);
        }else if (Trigger.isAfter){
             AccountTriggerHandler.afterInsert(Trigger.new);
        }
    }
    else if (Trigger.isUpdate){
        if (Trigger.isBefore){
            AccountTriggerHandler.beforeUpdate(Trigger.new,Trigger.oldMap);
        }else if (Trigger.isAfter){
            AccountTriggerHandler.afterUpdate(Trigger.new,Trigger.oldMap);
        }
    }
}