public class AccountUpdating {
    Public static void createdLogs(Map<Id, Account> updatedAccountsMap){
        Set<Id> accountIds = updatedAccountsMap.keySet();
        System.debug('accountIds-->'+accountIds);
        List<Account> accounts=[SELECT Id,Name,Owner.Email,(SELECT Id,Name,Amount,StageName,Sales_Manager__c,CreatedById from Opportunities where Amount>100000 and StageName='Negotiation/Review')from Account WHERE Id IN :accountIds];
        System.debug(accounts.size());
        for(Account acc:accounts){
            System.debug('Accounts->'+acc);
        }
        List<Opportunity_Log__c> logsToInsert = new List<Opportunity_Log__c>();
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        for (Account acc:accounts){
            Boolean emailsent=false;
            for (Opportunity opp : acc.Opportunities){
                if(opp.Sales_Manager__c==Null){
                    System.debug('Logs Created');
                    logsToInsert.add(new Opportunity_Log__c(
                        Name=opp.Name,
                        Opportunity_Id__c = opp.Id,
                        Account_Id__c = acc.Id,
                        Created_By_Id__c = opp.CreatedById
                    ));
                    System.debug('Logs created Succesfully');
                    
                }
                System.debug('logsToInsert size-->'+logsToInsert.size());
                System.debug('logsToInsert-->'+logsToInsert);
                emailsent=True;
            }
            System.debug('OwnerEmail-->'+acc.Owner.Email);
            System.debug('emailsent'+emailsent);
            if (emailsent && acc.Owner.Email !=Null ){
                System.debug('Start Emailing');
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { acc.Owner.Email  });
                email.setSubject('Please review sales quotation');
                email.setPlainTextBody('Please review the quotation given by our sales team. Expecting to hear from you soon.');
                emailsToSend.add(email);
                System.debug('Send Successfully Email');
            }
        }
        if (!logsToInsert.isEmpty()) {
            System.debug('Try');
        System.debug('start inserting');
        System.debug(logsToInsert);
        insert logsToInsert;
    
 }

        if (!emailsToSend.isEmpty()) {
            Messaging.sendEmail(emailsToSend);
        }
        
        
        
        
    }

}