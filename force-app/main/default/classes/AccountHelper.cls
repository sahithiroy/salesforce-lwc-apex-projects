public class AccountHelper {
    
    public String developerName = 'JuniorDev';
    public AccountHelper(){
        
    }
    public static void createRelatedContacts(List<Account> acc) {
        //System.debug('createRelatedContacts Function');
        AccountHelper helper = new AccountHelper();
        helper.createContact(acc);
        System.debug('Developer: ' + helper.developerName);
    }

    public   void createContact(List<Account> acc) {
        List<Contact> contactsToInsert = new List<Contact>();
        try{
             if (!Schema.sObjectType.Contact.isCreateable()) {
                System.debug('User does not have permission to create Contact.');
                return;
            }
            for (Account accounts:acc){
                System.debug('Contact Details created');
                Contact c = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId =accounts.Id);
                System.debug('Contact details'+c);
        		contactsToInsert.add(c);
                System.debug('Successfully inserted');
            }
        	insert contactsToInsert;
        }catch(Exception e){
            System.debug('Unable to create records: ' + e.getMessage());
        }
    }

    public static void throwError() {
        Integer a = 1;
        Integer b = 0;
        try{
        Integer result = a / b;
        }catch (Exception e){
            System.debug('b value should be greater than 0-->'+e.getMessage());
        }
    }
}