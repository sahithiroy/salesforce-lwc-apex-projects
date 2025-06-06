import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import handleLogout from '@salesforce/apex/UserDetails.handleLogout';
import managerAuthenticated from '@salesforce/apex/UserDetails.managerAuthenticated';
import CEOAuthentication from '@salesforce/apex/UserDetails.CEOAuthentication';
import getActiveUserCount from '@salesforce/apex/UserDetails.getActiveUserCount';
import getEmployeeLoginActivities from '@salesforce/apex/UserDetails.getEmployeeLoginActivities';
import getAllUsers from '@salesforce/apex/UserDetails.getAllUsers';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountViewer extends NavigationMixin(LightningElement) {
    @track accounts = [];
    @track selectedAccountId;
    @track isManager = false;
    @track isCeo = false;
    @track employeeLoginActivities = [];
    @track allUsers = [];
    @track filteredUsers = [];

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Industry', fieldName: 'Industry' },
        { label: 'Phone', fieldName: 'Phone' },
        {
            type: 'button',
            typeAttributes: {
                label: 'View Related',
                name: 'view_related',
                variant: 'brand'
            }
        }
    ];

    connectedCallback() {
        const activityId = sessionStorage.getItem('loginActivityId');
        if (activityId) {
            this.checkManagerStatus(activityId);
            this.checkCEO(activityId);
        } else {
            console.warn('loginActivityId not found in sessionStorage.');
        }
        this.checkUserLoad();
        this.fetchAllUsers();
    }

    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
        } else if (error) {
            console.error('Error fetching accounts:', error);
        }
    }

    handleRowAction(event) {
        const action = event.detail.action.name;
        const row = event.detail.row;

        if (action === 'view_related') {
            this.selectedAccountId = row.Id;
        }
    }

    navigateToLogin() {
        const activityId = sessionStorage.getItem('loginActivityId');
        if (activityId) {
            handleLogout({ loginActivityId: activityId })
                .then(() => {
                    sessionStorage.removeItem('loginActivityId');
                    this[NavigationMixin.Navigate]({
                        type: 'standard__navItemPage',
                        attributes: {
                            apiName: 'Login_page'
                        }
                    });
                })
                .catch(error => {
                    console.error('Logout error:', error);
                });
        } else {
            console.warn('No login activity ID found.');
        }
    }

    checkManagerStatus(activityId) {
        managerAuthenticated({ loginActivityId: activityId })
            .then((managerId) => {
                console.log('Manager ID:', managerId);
                if (managerId) {
                    this.isManager = true;
                    this.managerId = managerId;
                    this.loadEmployeeActivities();
                } else {
                    this.isManager = false;
                }
            })
            .catch((error) => {
                console.error('Error checking manager status:', error);
            });
    }

    loadEmployeeActivities() {
        getEmployeeLoginActivities({ managerId: this.managerId })
            .then((data) => {
                console.log('Employee login activities:', data);
                this.employeeLoginActivities = data;
            })
            .catch((error) => {
                console.error('Error loading employee activities:', error);
            });
    }

    checkUserLoad() {
        getActiveUserCount()
            .then(count => {
                if (count > 3) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Heavy Traffic',
                            message: 'The page is under heavy traffic, please be cautious when initiating any long running job.',
                            variant: 'warning',
                            mode: 'sticky'
                        })
                    );
                }
            })
            .catch(error => {
                console.error('Error fetching active user count:', error);
            });
    }

    checkCEO(activityId) {
        CEOAuthentication({ loginActivityId: activityId })
            .then((result) => {
                console.debug(`CEO result: ${JSON.stringify(result)}`);
                if (result) {
                    this.isCeo = true;
                } else {
                    this.isCeo = false;
                }
            })
            .catch((error) => {
                console.error('Error checking CEO authentication:', error);
                this.isCeo = false;
            });
    }

    fetchAllUsers() {
        getAllUsers()
            .then(data => {
                this.allUsers = data;
                this.filteredUsers = data;
            })
            .catch(error => {
                console.error('Error fetching users:', error);
            });
    }

    handleSearch(event) {
        const searchKey = event.target.value.toLowerCase();
        this.filteredUsers = this.allUsers.filter(user => user.Name.toLowerCase().includes(searchKey));
    }
}