// orderStatusSubscriber.js
import { LightningElement } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import { subscribe, unsubscribe, onError, setDebugFlag } from 'lightning/empApi';

export default class OrderStatusSubscriber extends LightningElement {
    channelName = '/event/Order_Status_Event__e';
    subscription = {};

    connectedCallback() {
        console.log('connectedcallback')
        this.handleSubscribe();
        this.registerErrorListener();
    }

    handleSubscribe() {
        console.log('handle subsrcibe')
        const messageCallback = (response) => {
            console.log('New platform event received: ', response);
            // You can process event data here
        };
        console.log('messageCallback',messageCallback);
        subscribe(this.channelName, -1, messageCallback).then(response => {
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
            this.subscription = response;
        });
    }

    registerErrorListener() {
        onError(error => {
            console.error('Received error from server: ', error);
        });
    }
}
