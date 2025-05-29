import { LightningElement,api,track,wire } from 'lwc';
import getContactsbyAccountId from '@salesforce/apex/ContactDetails.getContactsbyAccountId';
import { getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';

export default class ContactDetails extends LightningElement {
    @api recordId;
    @track contactOptions = [];
    @track selectedContactId;
    @wire (getContactsbyAccountId,{accountId:'$recordId'})
    wiredContacts({data,error}){
            if(data){
                this.contactOptions=data.map(c =>({
                    label:c.Name,
                    value:c.Id
                }));
                console.log('data',data);
            }
            else if (error){
                console.log('error',error);
            }
    }
    // Fetch selected contact's details
    @wire(getRecord, { recordId: '$selectedContactId', fields: [NAME_FIELD, EMAIL_FIELD, PHONE_FIELD] })
    contact;
    handleChange(event){
        this.selectedContactId=event.target.value;
    }



}