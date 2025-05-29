import { LightningElement,wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACCOUNT_FIELD from '@salesforce/schema/Account';
export default class WireApex extends LightningElement {
    @wire (getAccounts) accounts;
    get hasDate(){
        return this.accounts.data;
    }
    @wire(getObjectInfo,{objectApiName:ACCOUNT_FIELD})
    objectInfo;

}