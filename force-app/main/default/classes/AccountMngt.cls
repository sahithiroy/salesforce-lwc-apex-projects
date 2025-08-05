@RestResource(urlmapping='/accountmngt/*')
global class AccountMngt {
    @httpGet
    global static AccountWrapper getTopAccounts(){ 
        System.debug('Request received from user: ' + UserInfo.getUserName());
        map<String,String>parasMap=RestContext.request.params;
        String accIndustry=parasMap.get('industry');
        Set<id> accountIds=new Set<id>();
        List<Account> acclist=[SELECT Id,AnnualRevenue,Industry From Account where AnnualRevenue>500 and Industry =:accIndustry order by name limit 3 ];
        for(Account acc:accList){
            accountIds.add(acc.Id);
        }
        List<Contact> conList=[select Id,Accountid,Name,Email from Contact where AccountId=:accountIds];
        List<Case> caseList=[SELECT Id,AccountId from case where AccountId=:accountIds];
        AccountWrapper accWrapper=new AccountWrapper();
        accWrapper.accList=accList;
        accWrapper.conList=conList;
        accWrapper.caseList =caseList;
        return accWrapper;
    }
    @httpPost
    global static String createContact(String description,String Email,String lastName){
        Contact con =new Contact();
        con.Description=description;
        con.Email=Email;
        con.LastName=lastName;
        try{
            insert con;
            return 'Contact created Successfully';
        }catch(Exception ex){
            return ex.getMessage();
        }
    }
    @httpdelete
    global static String deleteAccount(){
        map<String,String>parasMap=RestContext.request.params;
        String accId=parasMap.get('accId');
        System.debug('accId'+accId);
        List<Contact> conList=[SELECT Id from Contact where Id =:accId];
        System.debug('conList'+conList);
        if (!conList.isEmpty()){
            try{
                delete conList;
                return 'delete contact details successfully';
            }catch(Exception ex){
                return ex.getMessage();
            }
        }else{
            return 'Record Not Found';
        }
    }
    @httpPut
    global static String UpdateRecord(String Name){
        map<String,String>parasMap=RestContext.request.params;
        String accId=parasMap.get('accId');
        
        System.debug('accId'+accId);
        List<Account> accList=[SELECT ID,Name from Account where ID=:accId];
        System.debug('accList'+accList);
        if(!accList.isEmpty()){
            try{
                accList[0].Name='SahithiSugavasi';
                update accList;
                return 'Update Details Successfully';
            }catch(Exception ex){
                return ex.getMessage();
            }
        }else{
            return 'No Record Found';
        }
    }
    global class AccountWrapper{
        global List<Account> accList;
        global List<Contact> conList;
        global List<Case> caseList;
            
    }

}