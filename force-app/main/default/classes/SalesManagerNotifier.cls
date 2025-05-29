public class SalesManagerNotifier implements Queueable {
    public void execute(QueueableContext context) {
        List<Account> lowScoreAccounts = [
            SELECT Id, Name, Sales_Health_Score__c 
            FROM Account 
            WHERE Sales_Health_Score__c < 0
        ];
        if (!lowScoreAccounts.isEmpty()) {
            System.debug('Accounts needing review: ' + lowScoreAccounts.size());
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for (Account acc : lowScoreAccounts) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { 'sahithiroy2003@gmail.com' }); 
                mail.setSubject('Account flagged for Sales Health Score');
                mail.setPlainTextBody('Account ID ' + acc.Id + '  Sales Health Score: ' + acc.Sales_Health_Score__c);
                emails.add(mail);
            }

            Messaging.sendEmail(emails);
            System.debug('Successfully sent emails: ' + emails.size());
        } else {
            System.debug('No accounts with low Sales Health Score found.');
        }
    }
}