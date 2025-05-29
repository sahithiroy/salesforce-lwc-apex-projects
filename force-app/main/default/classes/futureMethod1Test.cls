@isTest
public class futureMethod1Test {

    @testSetup
    static void setupData() {
        // Create a test Account
        Account acc = new Account(Name = 'Test Account',AnnualRevenue=308089809,AccountEmail__c='sahithi@gmail.com',NumberofLocations__c=6,Phone='979867867867');
        insert acc;

        // Create 300 Contacts for that Account
        List<Contact> contactList = new List<Contact>();
        for (Integer i = 0; i < 100000; i++) {
            contactList.add(new Contact(
                FirstName = 'First' + i,
                LastName = 'Last' + i,
                Email = 'original' + i + '@example.com',
                AccountId = acc.Id
            ));
        }
        insert contactList;
    }

    @isTest
    static void testFutureMethod() {
        // Get the test account
        Account testAcc = [SELECT Id FROM Account LIMIT 1];
        String newWebsite = 'updated@example.com';

        // Call the future method
        Test.startTest();
        futureMethod1.updateContactEmailsAsync(testAcc.Id, newWebsite);
        Test.stopTest(); // Ensures future method finishes

        // Verify that all contacts are updated
        List<Contact> updatedContacts = [SELECT Email FROM Contact WHERE AccountId = :testAcc.Id];
        for (Contact c : updatedContacts) {
            System.assertEquals(newWebsite, c.Email);
        }
    }
}