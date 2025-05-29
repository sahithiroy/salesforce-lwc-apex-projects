import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class AccountRecordViewer extends NavigationMixin(LightningElement) {
    @api recordId;
    isEditMode = false;
 
    handleEdit() {
        this.isEditMode = true;
    }
 
    handleCancel() {
        this.isEditMode = false;
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'list'
            },
            state: {
                filterName: 'Recent' 
            }
        });
    }
    handleCancel1() {
        this.isEditMode = false;
    }
 
    handleSuccess() {
        this.isEditMode = false;
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'list'
            },
            state: {
                filterName: 'Recent' 
            }
        });
    
    }
}