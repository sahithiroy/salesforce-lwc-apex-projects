trigger TriggerOfInvoicec on Invoice__c (before insert,before Update) {
    if (Trigger.isBefore){
        if (Trigger.isInsert || Trigger.isUpdate){
            InvoiceTriggerHandler.InvoiceHandler(Trigger.new);
        }
    }

}