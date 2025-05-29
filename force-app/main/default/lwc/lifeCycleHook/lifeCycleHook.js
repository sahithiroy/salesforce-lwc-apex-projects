import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';

export default class AccountList extends LightningElement {
    accounts;
    error;

    constructor() {
        super();
        console.log('Constructor: Component is being created');
    }

    @wire(getAccounts)
    wiredAccounts({ data, error }) {
        if (data) {
            this.accounts = data;
            this.error = undefined;
            console.log('Data fetched:', data);
        } else if (error) {
            this.error = error;
            this.accounts = undefined;
            console.log('Error occurred:', error);
        }
    }

    connectedCallback() {
        console.log('connectedCallback: Component inserted into the DOM');
        // Could initiate any subscription or setup logic
    }

    renderedCallback() {
        console.log('renderedCallback: Component has rendered');
        // Can update DOM elements or run post-render logic
    }

    disconnectedCallback() {
        console.log('disconnectedCallback: Component removed from the DOM');
        // Perform cleanup tasks like removing event listeners or clearing timers
    }

    errorCallback(error, stack) {
        console.log('errorCallback: An error occurred');
        console.error('Error:', error);
        console.error('Stack Trace:', stack);
        // Handle or log the error
    }
}