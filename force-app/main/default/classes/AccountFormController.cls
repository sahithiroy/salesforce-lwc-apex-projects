public with sharing class AccountFormController {
    @AuraEnabled
    public static Id createAccount(Account acc) {
        insert acc;
        return acc.Id;
    }
    @AuraEnabled
   public static void updateAccount(Account acc) {
    update acc;
  }

}