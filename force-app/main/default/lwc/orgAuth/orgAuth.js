import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import geturl from '@salesforce/apex/OAuthController.geturl'
export default class OrgAuth extends NavigationMixin(LightningElement) {
    @api recordId;
    url;

   handleAuthenticate() {
        /*const clientId = '3MVG9GCMQoQ6rpzQHnD7aSs3GfF1sS3hUQOUO5ktPnV7508btl2dM.j7s5tdB3HkyOWLwJUilGhps0YV7NcV5';
        const domain = 'https://login.salesforce.com';
        const redirectUri = 'https://zyroneenergy-dev-ed.develop.my.salesforce.com/lightning/n/`                                                                                                                                                                                                                                        ``````````````````````````````````';

        const authUrl = `${domain}/services/oauth2/authorize?response_type=code&client_id=${clientId}&redirect_uri=${redirectUri}`;  */     
        console.log('recordId',this.recordId);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
        geturl({ recordId: this.recordId })
            .then(locationUrl => {
                this.url = locationUrl;
                console.log('Redirect Location (Auth Code URL):', locationUrl);
                window.open(this.url, '_blank');
            })
            .catch(error => {
                console.error('Error fetching Auth Code redirect URL:', error);
            });
    }
    
}

