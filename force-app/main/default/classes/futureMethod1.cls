public class futureMethod1 {
    @future
    public static void updateContactEmailsAsync(Id accountId,String Website){
        List<Contact> contactstoUpdate=[SELECT Id,Email From Contact WHERE AccountId = :accountId];
        System.debug('contactstoUpdate'+contactstoUpdate);
        System.debug('accountId'+accountId);
        System.debug('Website'+Website);
        for(Contact con :contactstoUpdate){
            System.debug('Email checked');
            con.Email=Website;
             System.debug('Email updated');
        }
        if(!contactstoUpdate.isEmpty()){
            System.debug('contactstoUpdate'+contactstoUpdate);
            update contactstoUpdate;
            System.debug('update Successfully');
        }
    }
}