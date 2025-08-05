public with sharing class ContactController {
    @AuraEnabled
    public static String createContact(String accountId, String firstName, String lastName, String email) {
        Contact con = new Contact(
            AccountId = accountId,
            FirstName = firstName,
            LastName = lastName,
            Email = email
        );
        insert con;
        return con.Id;
    }
}