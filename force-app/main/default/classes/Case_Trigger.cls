public class Case_Trigger {
    public static void Escalation_Handler(List<Case> newList){
        for (Case c: newList){
            if (c.Priority=='High' && c.Status=='Escalated'){
                c.Escalation_Level__c = 'Level 1';
            }else if (c.Priority=='Medium'){
                c.Escalation_Level__c = 'Level 0';
            }else{
                c.Escalation_Level__c = 'Level ';
            }
        }
    }

}