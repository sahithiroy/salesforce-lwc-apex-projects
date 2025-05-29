public class InvoiceTriggerHandler {
    public static void InvoiceHandler(List<Invoice__c> newList){
        for (Invoice__c i: newList){
            System.debug('newRecorddate'+i.DueDate__c);
            System.debug('newRecorddate'+i.Status__c);
            if (i.DueDate__c!=null && i.Status__c!='Paid' && i.DueDate__c<Date.today()){
                i.IsOverdue__c=True;
            }else{
                i.IsOverdue__c=False;
            }
        }
    }

}