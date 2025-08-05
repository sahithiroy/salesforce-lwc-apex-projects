import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CreateContactForm extends NavigationMixin(LightningElement) {
    @api recordId;
    fields = ['FirstName', 'LastName', 'Email'];
    recordTypeId;

    get defaultValues() {
        return {
            AccountId: this.recordId
        };
    }

    handleSuccess(event) {
        const contactId = event.detail.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: contactId,
                objectApiName: 'Contact',
                actionName: 'view'
            }
        });
    }
}