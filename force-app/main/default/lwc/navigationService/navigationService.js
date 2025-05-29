import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class NavigationService extends NavigationMixin(LightningElement) {
    handleOnClick() {
        debugger;
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName:'Recent'
                
            }
        });
    }
}