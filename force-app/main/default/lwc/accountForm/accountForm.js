import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import NAME_FIELD from '@salesforce/schema/Account.Name';
import REVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
import RATING_FIELD from '@salesforce/schema/Account.Rating';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import BILLING_ADDRESS from '@salesforce/schema/Account.BillingAddress';
import COUNTRY_FIELD from '@salesforce/schema/Account.Country_Name__c';
import STATES_FIELD from '@salesforce/schema/Account.States__c';
import LOCATIONS_FIELD from '@salesforce/schema/Account.NumberofLocations__c';
import SLA_SERIAL_FIELD from '@salesforce/schema/Account.SLASerialNumber__c';
import ACCOUNT_EMAIL_FIELD from '@salesforce/schema/Account.AccountEmail__c';

export default class RecordPagetask extends NavigationMixin(LightningElement) {
    @api objectApiName = 'Account';

    fields = [
        NAME_FIELD,
        REVENUE_FIELD,
        INDUSTRY_FIELD,
        RATING_FIELD,
        PHONE_FIELD,
        BILLING_ADDRESS,
        COUNTRY_FIELD,
        STATES_FIELD,
        LOCATIONS_FIELD,
        SLA_SERIAL_FIELD,
        ACCOUNT_EMAIL_FIELD
    ];

    handleSuccess(event) {
        this.navigateToListView();
    }

    handleCancel() {
        this.navigateToListView();
    }

    navigateToListView() {
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