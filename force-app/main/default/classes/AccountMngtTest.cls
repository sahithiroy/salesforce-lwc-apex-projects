@isTest
public class AccountMngtTest {
    @testSetup
    static void setupData() {
        // Create test Accounts
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accounts.add(new Account(Name = 'Test Acc ' + i, AnnualRevenue = 1000, Industry = 'Technology',NumberofLocations__c=2,Phone='12345678904567',AccountEmail__c='test@gmail.com'));
        }
        insert accounts;
        // Create Contacts for the first 3 accounts
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            contacts.add(new Contact(LastName = 'Contact ' + i, Email = 'test' + i + '@test.com', AccountId = accounts[i].Id));
        }
        insert contacts;

        // Create Cases for same accounts
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < 3; i++) {
            cases.add(new Case(AccountId = accounts[i].Id, Status = 'New', Origin = 'Web'));
        }
        insert cases;
    }
    
    @isTest
    static void testGetTopAccounts() {
        RestRequest req = new RestRequest();
        req.requestUri = 'accountmngt/';
        req.httpMethod = 'GET';
        req.addParameter('industry', 'Technology');
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        AccountMngt.AccountWrapper result = AccountMngt.getTopAccounts();
        Test.stopTest();

        System.assertNotEquals(null, result);
        System.assert(result.accList.size() > 0, 'Accounts should be returned');
        System.assert(result.conList.size() > 0, 'Contacts should be returned');
        System.assert(result.caseList.size() > 0, 'Cases should be returned');
    }
    @isTest
    static void testCreateContact_Success() {
        Test.startTest();
        String response = AccountMngt.createContact('Test', 'sahithiroy2003@test.com', 'TestLast');
        Test.stopTest();
        System.assertEquals('Contact created Successfully', response);
        List<Contact> created = [SELECT Id FROM Contact WHERE Email = 'sahithiroy2003@test.com'];
        System.assertEquals(1, created.size(), 'One contact should have been created');
    }
    @isTest
    static void testDeleteAccount_Success() {
        Contact testContact = new Contact(LastName = 'ToDelete', Email = 'sahithiroy2003@test.com');
        insert testContact;
        RestRequest req = new RestRequest();
        req.requestUri = 'accountmngt/';
        req.httpMethod = 'DELETE';
        req.addParameter('accId', testContact.Id);
        RestContext.request = req;
        Test.startTest();
        String response = AccountMngt.deleteAccount();
        Test.stopTest();
        System.assertEquals('delete contact details successfully', response);
        System.assertEquals(0, [SELECT count() FROM Contact WHERE Id = :testContact.Id]);
    }
    @isTest
    static void testDeleteAccount_NotFound() {
        RestRequest req = new RestRequest();
        req.requestUri = 'accountmngt/';
        req.httpMethod = 'DELETE';
        req.addParameter('accId', '001dL00000wPEPoQAO'); 
        RestContext.request = req;

        Test.startTest();
        String response = AccountMngt.deleteAccount();
        Test.stopTest();

        System.assertEquals('Record Not Found', response);
    }

    @isTest
    static void testUpdateRecord_Success() {
        Account acc = new Account(Name = 'BeforeUpdate', AnnualRevenue = 900, Industry = 'Tech',NumberofLocations__c=2,Phone='12345678904567',AccountEmail__c='test@gmail.com');
        insert acc;

        RestRequest req = new RestRequest();
        req.requestUri = 'accountmngt/';
        req.httpMethod = 'PUT';
        req.addParameter('accId', acc.Id);
        RestContext.request = req;

        Test.startTest();
        String response = AccountMngt.UpdateRecord('SahithiSugavasi');
        Test.stopTest();

        System.assertEquals('Update Details Successfully', response);
        Account updatedAcc = [SELECT Name FROM Account WHERE Id = :acc.Id];
        System.assertEquals('SahithiSugavasi', updatedAcc.Name, 'Account name should be updated');
    }

    @isTest
    static void testUpdateRecord_NotFound() {
        RestRequest req = new RestRequest();
        req.requestUri = 'accountmngt/';
        req.httpMethod = 'PUT';
        req.addParameter('accId', '001dL000011XFs1QAG'); 
        RestContext.request = req;

        Test.startTest();
        String response = AccountMngt.UpdateRecord('SugavasiSahithi');
        Test.stopTest();

        System.assertEquals('No Record Found', response);
    }

}