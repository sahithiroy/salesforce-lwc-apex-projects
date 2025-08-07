public class Task {
    public static void sendEmailToEligibleContacts() {
        // Query Contacts and their related open Cases created 3+ days ago
        List<Contact> contacts = [
            SELECT Id, Email,
                (SELECT Id, CreatedDate
                 FROM Cases
                 WHERE Status IN ('New', 'Working')
                 AND CreatedDate <= :System.today().addDays(-3))
            FROM Contact
            WHERE Email != null
        ];
		System.debug('contacts->'+contacts);
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        for (Contact con : contacts) {
            List<Case> openCases = con.Cases;
			System.debug('opencases'+openCases);
            System.debug('size of opencases'+openCases.size());
            if (openCases != null && openCases.size() > 3) {
                System.debug('Start Email');
                System.debug('Start Email');
                System.debug('Start Email');
                System.debug('Start Email');
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { con.Email });
                email.setSubject('Action Required: Open Cases');
                email.setPlainTextBody('You have more than 3 open cases, and at least one of them has been open for 3 or more days. Please take necessary actions.');
                emailsToSend.add(email);
                System.debug('Sending Email');
            }
        }

        if (!emailsToSend.isEmpty()) {
            Messaging.sendEmail(emailsToSend);
        }
    }
}