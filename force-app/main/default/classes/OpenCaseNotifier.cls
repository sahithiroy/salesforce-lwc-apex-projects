public class OpenCaseNotifier {
    public static void sendEmailToEligibleContacts() {
        // Calculate the date 3 days ago
        Date thresholdDate = Date.today().addDays(-3);
		System.debug(thresholdDate);
        // Map to hold contactId -> List of open cases
        Map<Id, List<Case>> contactCaseMap = new Map<Id, List<Case>>();

        // Query open cases with Contact and CreatedDate
        List<Case> openCases = [
            SELECT Id, Subject, ContactId, CreatedDate
            FROM Case
            WHERE (Status = 'New' or Status='Working')
              AND ContactId != null
        ];

        for (Case c : openCases) {
            System.debug('opencases'+c);
            if (!contactCaseMap.containsKey(c.ContactId)) {
                contactCaseMap.put(c.ContactId, new List<Case>());
            }
            contactCaseMap.get(c.ContactId).add(c);
        }
        System.debug('contactCaseMap'+contactCaseMap);
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        for (Id contactId : contactCaseMap.keySet()) {
            List<Case> cases = contactCaseMap.get(contactId);
			System.debug('cases'+cases);
            System.debug('size of cases'+cases.size());
            // Check conditions
            if (cases.size() > 3) {
                Boolean hasOldCase = false;

                for (Case c : cases) {
                    System.debug('date'+thresholdDate);
                    System.debug('createddate'+c.CreatedDate.date());
                    if (c.CreatedDate.date() <= thresholdDate) {
                        hasOldCase = true;
                        break;
                    }
                }
				//System.debug('oldcase  ->'+hasOldCase);
                if (hasOldCase) {
                    // Get contact email
                    Contact con = [SELECT Id, Email FROM Contact WHERE Id = :contactId LIMIT 1];
                    System.debug('contact details'+con);
                    if (con.Email != null) {
                        System.debug('Start Email');
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(new String[] { con.Email });
                        email.setSubject('Action Required: Open Cases');
                        email.setPlainTextBody('You have more than 3 open cases. Please take necessary actions.');
                        emailsToSend.add(email);
                    }
                }
            }
        }

        if (!emailsToSend.isEmpty()) {
            Messaging.sendEmail(emailsToSend);
        }
    }

}