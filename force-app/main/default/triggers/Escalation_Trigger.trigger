trigger Escalation_Trigger on Case (before insert,before update) {
    if (Trigger.isInsert || Trigger.isUpdate){
        if(Trigger.isBefore){
            Case_Trigger.Escalation_Handler(Trigger.new);
        }
    }

}