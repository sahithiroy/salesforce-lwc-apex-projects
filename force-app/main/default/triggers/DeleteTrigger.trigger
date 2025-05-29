trigger DeleteTrigger on Employee__c (before delete,after undelete) {
    if(Trigger.isDelete){
        if(Trigger.isBefore){
            EmployeeTrigger.beforeDelete(trigger.old);
        }
    }if(Trigger.isUndelete){
        if (Trigger.isAfter){
            EmployeeTrigger.afterUnDelete(trigger.new);
        }
    }
}