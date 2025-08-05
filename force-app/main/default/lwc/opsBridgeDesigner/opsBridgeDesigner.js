// opsBridgeDesigner.js - Enhanced Workflow Designer with Execution Integration
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

// Import Apex methods
import saveWorkflowDefinition from '@salesforce/apex/WorkflowDesignerController.saveWorkflowDefinition';
import getWorkflowDefinitions from '@salesforce/apex/WorkflowDesignerController.getWorkflowDefinitions';
import triggerWorkflow from '@salesforce/apex/WorkflowController.triggerWorkflow';
import validateWorkflow from '@salesforce/apex/WorkflowDesignerController.validateWorkflow';

export default class OpsBridgeDesigner extends NavigationMixin(LightningElement) {
    @track workflowSteps = [];
    @track nextStepId = 1;
    @track workflowName = 'New Deployment Pipeline';
    @track workflowDescription = '';
    @track selectedTriggerType = 'Manual';
    @track repositoryUrl = '';
    @track branchPattern = '';
    @track isModalOpen = false;
    @track savedWorkflows = [];
    @track selectedWorkflow = null;
    @track isExecuting = false;

    // Enhanced action library with more realistic OpsBridge actions
    actionLibrary = [
        {
            id: 'git_merge',
            title: 'Git Merge',
            icon: '🔀',
            description: 'Merge branch using GitHub Actions',
            color: '#a8e6cf',
            connector: 'GitHub Actions',
            category: 'Source Control'
        },
        {
            id: 'sf_deploy',
            title: 'Salesforce Deploy',
            icon: '☁️',
            description: 'Deploy metadata to Salesforce org',
            color: '#4ecdc4',
            connector: 'Jenkins',
            category: 'Deployment'
        },
        {
            id: 'provar_test',
            title: 'Provar Tests',
            icon: '🧪',
            description: 'Execute Provar test automation',
            color: '#9c27b0',
            connector: 'Provar',
            category: 'Testing'
        },
        {
            id: 'accelq_test',
            title: 'Accelq Tests',
            icon: '🤖',
            description: 'Run Accelq automated test suite',
            color: '#673ab7',
            connector: 'Accelq',
            category: 'Testing'
        },
        {
            id: 'jenkins_job',
            title: 'Jenkins Pipeline',
            icon: '🔧',
            description: 'Trigger custom Jenkins pipeline',
            color: '#d33833',
            connector: 'Jenkins',
            category: 'CI/CD'
        },
        {
            id: 'approval',
            title: 'Manual Approval',
            icon: '✅',
            description: 'Require human approval to proceed',
            color: '#ff6b6b',
            connector: 'Salesforce',
            category: 'Governance'
        },
        {
            id: 'servicenow_ticket',
            title: 'ServiceNow Ticket',
            icon: '🎫',
            description: 'Create change request ticket',
            color: '#81c926',
            connector: 'ServiceNow',
            category: 'ITSM'
        },
        {
            id: 'slack_notify',
            title: 'Slack Notification',
            icon: '💬',
            description: 'Send team notification',
            color: '#4a154b',
            connector: 'Slack',
            category: 'Communication'
        },
        {
            id: 'azure_deploy',
            title: 'Azure Pipeline',
            icon: '🌐',
            description: 'Execute Azure DevOps pipeline',
            color: '#0078d4',
            connector: 'Azure DevOps',
            category: 'CI/CD'
        },
        {
            id: 'quality_gate',
            title: 'Quality Gate',
            icon: '🚪',
            description: 'Code quality and security checks',
            color: '#ff9500',
            connector: 'SonarQube',
            category: 'Quality'
        }
    ];

    triggerTypeOptions = [
        { label: 'Manual Trigger', value: 'Manual' },
        { label: 'Git Push', value: 'Git Push' },
        { label: 'Scheduled', value: 'Scheduled' },
        { label: 'Webhook', value: 'Webhook' },
        { label: 'API Call', value: 'API' }
    ];

    @wire(getWorkflowDefinitions)
    wiredWorkflows({ error, data }) {
        console.log('getWorkflowDefinitions');
        if (data) {
            this.savedWorkflows = data.map(workflow => ({
                ...workflow,
                lastExecuted: workflow.Last_Execution__c ? 
                    new Date(workflow.Last_Execution__c).toLocaleDateString() : 'Never'
            }));
            console.log('this.savedWorkflows',JSON.stringify(this.savedWorkflows));
        } else if (error) {
            this.showToast('Error', 'Failed to load saved workflows', 'error');
        }
    }

    // Drag and Drop Handlers
    handleDragStart(event) {
        const actionId = event.target.dataset.actionId;
        const actionData = this.actionLibrary.find(action => action.id === actionId);
        
        event.dataTransfer.setData('text/plain', JSON.stringify(actionData));
        event.dataTransfer.effectAllowed = 'copy';
        
        event.target.style.opacity = '0.5';
        event.target.style.transform = 'rotate(5deg)';
    }

    handleDragEnd(event) {
        event.target.style.opacity = '1';
        event.target.style.transform = 'rotate(0deg)';
    }

    handleDragOver(event) {
        event.preventDefault();
        event.dataTransfer.dropEffect = 'copy';
        
        const canvas = this.template.querySelector('.workflow-canvas');
        canvas.classList.add('drag-over');
    }

    handleDragLeave(event) {
        const canvas = this.template.querySelector('.workflow-canvas');
        canvas.classList.remove('drag-over');
    }

    handleDrop(event) {
        event.preventDefault();
        
        const canvas = this.template.querySelector('.workflow-canvas');
        canvas.classList.remove('drag-over');
        
        try {
            const actionData = JSON.parse(event.dataTransfer.getData('text/plain'));
            
            const newStep = {
                id: this.nextStepId++,
                title: actionData.title,
                icon: actionData.icon,
                description: actionData.description,
                color: actionData.color,
                actionType: actionData.id,
                connector: actionData.connector,
                category: actionData.category,
                status: 'Configured',
                order: this.workflowSteps.length + 1,
                configuration: this.getDefaultConfiguration(actionData.id)
            };
            
            this.workflowSteps = [...this.workflowSteps, newStep];
            
            this.showToast('Success', `${actionData.title} added to workflow!`, 'success');
            
            // Add visual feedback
            this.animateNewStep();
            
        } catch (error) {
            this.showToast('Error', 'Failed to add action to workflow', 'error');
        }
    }

    // Workflow Management
    handleRemoveStep(event) {
        const stepId = parseInt(event.target.dataset.stepId);
        this.workflowSteps = this.workflowSteps.filter(step => step.id !== stepId);
        this.reorderSteps();
        this.showToast('Info', 'Step removed from workflow', 'info');
    }

    handleMoveStepUp(event) {
        const stepId = parseInt(event.target.dataset.stepId);
        const stepIndex = this.workflowSteps.findIndex(step => step.id === stepId);
        
        if (stepIndex > 0) {
            const steps = [...this.workflowSteps];
            [steps[stepIndex - 1], steps[stepIndex]] = [steps[stepIndex], steps[stepIndex - 1]];
            this.workflowSteps = steps;
            this.reorderSteps();
        }
    }

    handleMoveStepDown(event) {
        const stepId = parseInt(event.target.dataset.stepId);
        const stepIndex = this.workflowSteps.findIndex(step => step.id === stepId);
        
        if (stepIndex < this.workflowSteps.length - 1) {
            const steps = [...this.workflowSteps];
            [steps[stepIndex], steps[stepIndex + 1]] = [steps[stepIndex + 1], steps[stepIndex]];
            this.workflowSteps = steps;
            this.reorderSteps();
        }
    }

    reorderSteps() {
        this.workflowSteps = this.workflowSteps.map((step, index) => ({
            ...step,
            order: index + 1
        }));
    }

    // Save Workflow
    async handleSaveWorkflow() {
        console.log('handleSaveWorkFlow');
        console.log('this.workflowName',this.workflowName);
        console.log('this.workflowName.trim()',this.workflowName.trim());
        if (!this.workflowName.trim()) {
            this.showToast('Error', 'Please enter a workflow name', 'error');
            return;
        }
        console.log('this.workflowSteps',JSON.stringify(this.workflowSteps));
        if (this.workflowSteps.length === 0) {
            this.showToast('Error', 'Please add at least one step to the workflow', 'error');
            return;
        }

        try {
            const workflowData = {
                name: this.workflowName,
                description: this.workflowDescription,
                triggerType: this.selectedTriggerType,
                repositoryUrl: this.repositoryUrl,
                branchPattern: this.branchPattern,
                steps: this.workflowSteps.map(step => ({
                    name: step.title,
                    actionType: step.actionType,
                    order: step.order,
                    connector: step.connector,
                    configuration: step.configuration
                }))
            };
            console.log('JSON.stringify(workflowData)',JSON.stringify(workflowData));
            const result = await saveWorkflowDefinition({ workflowData: JSON.stringify(workflowData) });
            
            this.showToast('Success', 'Workflow saved successfully!', 'success');
            this.selectedWorkflow = result;
            console.log('this.selectedWorkflow',this.selectedWorkflow);
            // Refresh saved workflows list
            this.refreshWorkflowsList();
            
        } catch (error) {
            this.showToast('Error', 'Failed to save workflow: ' + error.body.message, 'error');
        }
    }

    // Execute Workflow
    async handleExecuteWorkflow() {
        if (!this.selectedWorkflow) {
            this.showToast('Error', 'Please save the workflow before executing', 'error');
            return;
        }

        try {
            this.isExecuting = true;
            
            const executionId = await triggerWorkflow({ workflowDefinitionId: this.selectedWorkflow });
            
            this.showToast('Success', 'Workflow execution started!', 'success');
            
            // Navigate to monitoring view
            this.navigateToMonitor(executionId);
            
        } catch (error) {
            this.showToast('Error', 'Failed to execute workflow: ' + error.body.message, 'error');
        } finally {
            this.isExecuting = false;
        }
    }

    // Load Existing Workflow
    handleLoadWorkflow(event) {
        const workflowId = event.currentTarget.dataset.workflowId;
        const workflow = this.savedWorkflows.find(w => w.Id === workflowId);
        
        if (workflow) {
            this.workflowName = workflow.Name;
            this.workflowDescription = workflow.Description__c || '';
            this.selectedTriggerType = workflow.Trigger_Type__c;
            this.repositoryUrl = workflow.Repository_URL__c || '';
            this.branchPattern = workflow.Branch_Pattern__c || '';
            this.selectedWorkflow = workflow.Id;
            
            // TODO: Load workflow steps from stored configuration
            this.showToast('Success', `Loaded workflow: ${workflow.Name}`, 'success');
        }
    }

    // Navigation
    navigateToMonitor(executionId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                 apiName: 'OpsBridgeMonitor'
            },
            state: {
                c__executionId: executionId
            }
        });
    }

    handleViewMonitor() {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'OpsBridgeMonitor'
            }
        });
    }

    // Modal Handlers
    handleOpenTemplateModal() {
        this.isModalOpen = true;
    }

    handleCloseModal() {
        this.isModalOpen = false;
    }

    handleLoadTemplate(event) {
        const templateName = event.target.dataset.template;
        this.loadWorkflowTemplate(templateName);
        this.isModalOpen = false;
    }

    // Utility Methods
    getDefaultConfiguration(actionType) {
        const configs = {
            git_merge: { sourceBranch: 'feature/*', targetBranch: 'develop', conflictResolution: 'manual' },
            sf_deploy: { testLevel: 'RunLocalTests', checkOnly: false, ignoreWarnings: false },
            provar_test: { testSuite: 'Regression', parallel: true, timeout: 1800 },
            accelq_test: { testSuite: 'Smoke Tests', environment: 'SIT', headless: true },
            jenkins_job: { jobName: '', parameters: {}, waitForCompletion: true },
            approval: { approvers: [], timeoutHours: 24, requiredApprovals: 1 },
            servicenow_ticket: { category: 'Change Request', priority: 'Normal', assignmentGroup: 'DevOps' },
            slack_notify: { channel: '#devops-alerts', message: 'Workflow notification' },
            azure_deploy: { pipelineId: '', branch: 'main', environment: 'staging' },
            quality_gate: { qualityGate: 'Sonar way', threshold: 80, failOnError: true }
        };
        return configs[actionType] || {};
    }

    loadWorkflowTemplate(templateName) {
        const templates = {
            'feature-deployment': {
                name: 'Feature Branch Deployment',
                description: 'Standard feature branch deployment pipeline',
                steps: [
                    { actionType: 'git_merge', title: 'Merge to SIT' },
                    { actionType: 'sf_deploy', title: 'Deploy to SIT' },
                    { actionType: 'provar_test', title: 'Run Provar Tests' },
                    { actionType: 'git_merge', title: 'Merge to UAT' },
                    { actionType: 'sf_deploy', title: 'Deploy to UAT' },
                    { actionType: 'approval', title: 'Production Approval' },
                    { actionType: 'sf_deploy', title: 'Deploy to Production' }
                ]
            },
            'hotfix-pipeline': {
                name: 'Hotfix Pipeline',
                description: 'Expedited hotfix deployment process',
                steps: [
                    { actionType: 'quality_gate', title: 'Code Quality Check' },
                    { actionType: 'sf_deploy', title: 'Deploy to Staging' },
                    { actionType: 'accelq_test', title: 'Smoke Tests' },
                    { actionType: 'approval', title: 'Emergency Approval' },
                    { actionType: 'sf_deploy', title: 'Deploy to Production' },
                    { actionType: 'slack_notify', title: 'Notify Team' }
                ]
            }
        };

        const template = templates[templateName];
        if (template) {
            this.workflowName = template.name;
            this.workflowDescription = template.description;
            this.workflowSteps = template.steps.map((step, index) => {
                const action = this.actionLibrary.find(a => a.id === step.actionType);
                return {
                    id: index + 1,
                    title: step.title,
                    icon: action.icon,
                    description: action.description,
                    color: action.color,
                    actionType: step.actionType,
                    connector: action.connector,
                    category: action.category,
                    status: 'Configured',
                    order: index + 1,
                    configuration: this.getDefaultConfiguration(step.actionType)
                };
            });
            this.nextStepId = this.workflowSteps.length + 1;
        }
    }

    animateNewStep() {
        setTimeout(() => {
            const steps = this.template.querySelectorAll('.workflow-step');
            const lastStep = steps[steps.length - 1];
            if (lastStep) {
                lastStep.style.animation = 'slideInUp 0.5s ease-out';
            }
        }, 100);
    }

    async refreshWorkflowsList() {
        try {
            // Refresh the wire adapter
            console.log('refreshWorkflowsList ')
            const workflows = await getWorkflowDefinitions();
            this.savedWorkflows = workflows.map(workflow => ({
                ...workflow,
                lastExecuted: workflow.Last_Execution__c ? 
                    new Date(workflow.Last_Execution__c).toLocaleDateString() : 'Never'
            }));
            console.log('this.savedWorkflows',this.savedWorkflows);
        } catch (error) {
            console.error('Error refreshing workflows:', error);
        }
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    // Getters
    get isWorkflowEmpty() {
        return this.workflowSteps.length === 0;
    }

    get stepCount() {
        return this.workflowSteps.length;
    }

    get hasWorkflowSteps() {
        return this.workflowSteps.length > 0;
    }

    get hasSavedWorkflows() {
        return this.savedWorkflows.length > 0;
    }

    get canExecute() {
        return this.selectedWorkflow && !this.isExecuting;
    }

    get executeButtonLabel() {
        return this.isExecuting ? 'Executing...' : 'Execute Workflow';
    }

    get actionCategories() {
        const categories = [...new Set(this.actionLibrary.map(action => action.category))];
        return categories.map(category => ({
            name: category,
            actions: this.actionLibrary.filter(action => action.category === category)
        }));
    }
    // Form Input Handlers
    handleWorkflowNameChange(event) {
        this.workflowName = event.target.value;
    }

    handleDescriptionChange(event) {
        this.workflowDescription = event.target.value;
    }

    handleTriggerTypeChange(event) {
        this.selectedTriggerType = event.detail.value;
    }

    handleRepoUrlChange(event) {
        this.repositoryUrl = event.target.value;
    }

    handleBranchPatternChange(event) {
        this.branchPattern = event.target.value;
    }

    // Workflow Management
    handleClearWorkflow() {
        this.workflowSteps = [];
        this.nextStepId = 1;
        this.showToast('Info', 'Workflow cleared', 'info');
    }

    async handleValidateWorkflow() {
        if (this.workflowSteps.length === 0) {
            this.showToast('Warning', 'Add steps to validate workflow', 'warning');
            return;
        }

        try {
            const workflowData = {
                name: this.workflowName,
                description: this.workflowDescription,
                triggerType: this.selectedTriggerType,
                repositoryUrl: this.repositoryUrl,
                branchPattern: this.branchPattern,
                steps: this.workflowSteps.map(step => ({
                    name: step.title,
                    actionType: step.actionType,
                    order: step.order,
                    connector: step.connector,
                    configuration: step.configuration
                }))
            };

            const result = await validateWorkflow({ workflowData: JSON.stringify(workflowData) });
            
            if (result.isValid) {
                this.showToast('Success', 'Workflow validation passed!', 'success');
            } else {
                this.showToast('Error', 'Validation failed: ' + result.errors.join(', '), 'error');
            }
            
            if (result.warnings && result.warnings.length > 0) {
                this.showToast('Warning', 'Warnings: ' + result.warnings.join(', '), 'warning');
            }

        } catch (error) {
            this.showToast('Error', 'Validation failed: ' + error.body.message, 'error');
        }
    }

    handleConfigureStep(event) {
        const stepId = parseInt(event.target.dataset.stepId);
        const step = this.workflowSteps.find(s => s.id === stepId);
        
        if (step) {
            // For now, just show a toast - in production you'd open a configuration modal
            this.showToast('Info', `Configure ${step.title} - Configuration modal would open here`, 'info');
        }
    }

    // Computed Properties for Template
    get isGitTrigger() {
        return this.selectedTriggerType === 'Git Push';
    }
}