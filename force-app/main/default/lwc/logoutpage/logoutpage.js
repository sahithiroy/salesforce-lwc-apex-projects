import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class Logoutpage extends NavigationMixin(LightningElement) {
    navigateToLogin() {
            this[NavigationMixin.Navigate]({
                type: 'standard__navItemPage',
                attributes: {
                    apiName: 'Login_page'
                }
            });
        }
}