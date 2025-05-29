public class SubscriptionRenewalBatch implements Database.Batchable<sObject>{
    List<Subscription__c> salesReviewList = new List<Subscription__c>();
    public Database.QueryLocator start(Database.BatchableContext bc){
        //issue1
        Date today = Date.today();
        Date cutoffDate = today.addDays(60);
        System.debug('cutoffDate'+cutoffDate);
        return Database.getQueryLocator([SELECT Name,Status__c,Sales_Review__c,RenewedManually__c,
                                          OverUsage__c,NextRenewal__c,EndDate__c,Discount__c,
                                         (SELECT Id, UsageAmount__c, UsageMonth__c FROM Usage__r) from Subscription__c 
                                          where Status__c='Active' and EndDate__c <= :cutoffDate]);
    }
    
    
    public void execute(Database.BatchableContext bc,List<Subscription__c> scope){
        List<Subscription__c> updates= new List<Subscription__c>();
        System.debug('activeUsers-->'+scope);
        System.debug(scope.size());
        Set<Id> subscriptionIds = new Set<Id>();
        for (Subscription__c sub :scope){
            subscriptionIds.add(sub.Id);
        }
        System.debug('subscriptionIds--->'+subscriptionIds);
        Map<Id, Customer__c> subscriptionIdToCustomer = new Map<Id, Customer__c>();
    	for (Customer__c cust : [SELECT Id, Subscription__c, SatisfactionScore__c FROM Customer__c WHERE Subscription__c IN :subscriptionIds]) {
        	subscriptionIdToCustomer.put(cust.Subscription__c, cust);
    	}
        System.debug('subscriptionIdToCustomer-->'+subscriptionIdToCustomer);
        for(Subscription__c sub :scope){
            System.debug('Each activeUser-->'+sub);
            Decimal totalUsage = 0;
            Integer count = 0;
            Decimal avgUsage = 0;
            Decimal purchasedLimit = 100;
            System.debug('sub.Usages__r--->'+sub.Usage__r);
            for(Usage__c usage : sub.Usage__r){
                System.debug('usageUsers-->'+usage);
                if (usage.UsageMonth__c != null && usage.UsageMonth__c >= Date.today().addMonths(-6)) {
                    System.debug('usageUsersMonth-->'+usage.UsageMonth__c);
                    totalUsage += usage.UsageAmount__c;
                    count++;
                }
            }
            System.debug('totalusage'+totalUsage);
            System.debug('count-->'+count);
            if (count > 0) {
                avgUsage = totalUsage / count;
            }
            System.debug('avgUsage-->'+avgUsage);
            Boolean overUsage = (avgUsage > 1.2 * purchasedLimit);
            System.debug('overUsage-->'+overUsage);
            if(overUsage){
                sub.OverUsage__c=overUsage;
                Customer__c relatedCust = subscriptionIdToCustomer.get(sub.Id);
                System.debug('relatedCust'+relatedCust);
                System.debug('relatedCust.SatisfactionScore__c'+relatedCust.SatisfactionScore__c);
            	if (relatedCust.SatisfactionScore__c >= 95) {
                    System.debug('before sub.Discount__c-->'+sub.Discount__c);
                	sub.Discount__c = sub.Discount__c + 5;
                    System.debug('after sub.Discount__c-->'+sub.Discount__c);
            	}    
            }
            System.debug('sub.RenewedManually__c'+sub.RenewedManually__c);
            if(sub.RenewedManually__c==true){
                sub.Sales_Review__c=true;
                System.debug('sub.Sales_Review__c-->'+sub.Sales_Review__c);
                salesReviewList.add(sub);
                System.debug('salesReviewList'+salesReviewList);
            }
            if (sub.EndDate__c != null) {
                    sub.NextRenewal__c = sub.EndDate__c.addMonths(12);
                }
            System.debug('upadtedrecords'+sub);
             updates.add(sub);
        }
       
        if (!updates.isEmpty()) {
            update updates;
        }
            
        
    }
     public void finish(Database.BatchableContext bc){
         System.debug('salesReviewList-->'+salesReviewList);
         if (!salesReviewList.isEmpty()) {
             System.debug('salesReviewList is not empty');
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for (Subscription__c sub : salesReviewList) {
                System.debug('Send Emails for SalesReview');
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { 'sahithiroy2003@gmail.com' }); 
                mail.setSubject('Subscription flagged for Sales Review');
                mail.setPlainTextBody('Subscription ID ' + sub.Id + ' requires manual review.');
                emails.add(mail);
                System.debug('Successfully send emails');
            }

            Messaging.sendEmail(emails);
        }
     }

}