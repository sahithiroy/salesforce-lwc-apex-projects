import { LightningElement, track,wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';

export default class ParentComponent extends LightningElement {
    message = 'Hello from the Parent!';
    value = 'sahithi';
    selectedAccountId;

    @track accountOptions = [];
    @wire(getAccounts)
    wiredAccounts({ data, error }) {
        if (data) {
            this.accountOptions = data.map(acc => ({
                label: acc.Name,
                value: acc.Id
            }));
        } else if (error) {
            console.error('Error fetching accounts:', error);
        }
    }


    // This method is triggered when the "View Details" button is clicked
    /*handleViewDetails() {
        getAccounts()
            .then(data => {
                // Map the result to combobox format
                this.accountOptions = data.map(acc => ({
                    label: acc.Name,
                    value: acc.Id
                }));
            })
            .catch(error => {
                console.error('Error fetching accounts:', error);
            });
    }*/

    // Handle combobox selection
    handleChange(event) {
        this.selectedAccountId = event.detail.value;
    }
}