import { LightningElement, api } from 'lwc';

export default class ChildComponent extends LightningElement {
    @api messageFromParent; // Public property

}