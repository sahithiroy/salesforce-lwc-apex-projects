trigger Count_Contact_Trigger on Contact (after insert,after update,after delete,after undelete) {
    if (Trigger.isAfter){
        if (Trigger.isInsert){
            CountOfContacts.UpdateCountOfContacts(Trigger.new,null);
        }else if(Trigger.isUndelete){
            CountOfContacts.UpdateCountOfContacts(Trigger.new,null);
        }else if(Trigger.isUpdate){
            CountOfContacts.UpdateCountOfContacts(Trigger.new,Trigger.oldMap);
        }else if(Trigger.isDelete){
            CountOfContacts.UpdateCountOfContacts(null,Trigger.oldMap);
        }
    }

}