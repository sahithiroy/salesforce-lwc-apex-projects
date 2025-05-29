public class LoginResponse {
    @AuraEnabled public Id loginActivityId;
    @AuraEnabled public Boolean isManager;

    public LoginResponse(Id loginActivityId, Boolean isManager) {
        this.loginActivityId = loginActivityId;
        this.isManager = isManager;
    }
}