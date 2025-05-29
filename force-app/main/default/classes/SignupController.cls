public with sharing class SignupController {
    @AuraEnabled
    public static void createUser(String name, String username, String password, String email, String role, Integer age, Date birthday, Date joiningDate, string ManagerName,Boolean isManager) {
        UserDetail__c newUser = new UserDetail__c();
        newUser.Name = name;
        newUser.Username__c = username;
        newUser.Password__c = password;
        newUser.Email__c = email;
        newUser.Role__c = role;
        newUser.Age__c = age;
        newUser.Birthday__c = birthday;
        newUser.Joining_Date__c = joiningDate;
        newUser.Manager_Name__c=ManagerName;
        newUser.Manager__c=isManager;
        insert newUser;
        sendWelcomeEmail(email);
        if (isManager==true){
            Manager__c manager =new Manager__c();
            manager.Name=name;
            manager.Email__c=email;
            insert manager;
        }
    }
    @future (callout=true)
    public static void sendWelcomeEmail(String userEmail) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { userEmail });
        email.setSubject('Welcome to Our Platform!');
        email.setPlainTextBody('Thank you for signing up. We’re excited to have you on board.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
    @AuraEnabled
    public static List<Manager__c> getManagers(){
        
        List<Manager__c> manager= [SELECT Id,Name FROM Manager__c];
       
        return manager;
       
    }

}