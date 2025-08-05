import { LightningElement,wire} from 'lwc';
import { NavigationMixin,CurrentPageReference } from 'lightning/navigation';
import storeTokens from '@salesforce/apex/OAuthController.storeTokens';
export default class Authentication extends NavigationMixin(LightningElement) {
    authURL='https://login.salesforce.com/?client_id=3MVG9GCMQoQ6rpzQHnD7aSs3GfF1sS3hUQOUO5ktPnV7508btl2dM.j7s5tdB3HkyOWLwJUilGhps0YV7NcV5&redirect_uri=https://mindful-badger-1rzhd2-dev-ed.trailblaze.my.salesforce.com&response_type=code';

    handleAuthenticate(){
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
                attributes: {
                    url:this.authURL
                }
            },true
        );
    }
   /*
    urlStateParameters=null
    currentPageReference=null;
    recordId;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            console.log('currentPageReference'+currentPageReference);
            this.urlStateParameters = currentPageReference.state;
            console.log('URL Parameters:', this.urlStateParameters);
            if (this.urlStateParameters.code) {
                const authCode = this.urlStateParameters.code;
                console.log('Auth Code:', authCode);
                storeTokens({ authCode })
                    .then(() => {
                        console.log('Tokens stored successfully');
                    })
                    .catch(error => {
                        console.error('Error storing tokens:', error);
                    });
            }
        }
    }
    
    handleAuthenticate(){
        this[NavigationMixin.Navigate]({
                        type: 'standard__webPage',
                        attributes: {
                            url:this.authURL
                        }
                    },true
                );
    }
                */
}