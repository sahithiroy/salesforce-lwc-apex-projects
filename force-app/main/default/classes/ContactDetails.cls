public with sharing class ContactDetails {
    @AuraEnabled(cacheable=True)
    public static List<Contact> getContactsbyAccountId(Id accountId){
        try {
            System.debug('try');
            System.debug(accountId);
            return [SELECT AccountId,Name FROM Contact where AccountId =: accountId];
            
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}