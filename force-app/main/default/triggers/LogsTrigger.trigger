trigger LogsTrigger on Account (after update) {
    if (Trigger.isAfter && Trigger.isUpdate){
        AccountUpdating.createdLogs(Trigger.newMap);
    }
    

}