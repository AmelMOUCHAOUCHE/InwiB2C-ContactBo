import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createUser from '@salesforce/apex/UserController.createUser';
import assignPermissionSets from '@salesforce/apex/UserController.assignPermissionSets';
import assignPermissionSetLicenses from '@salesforce/apex/UserController.assignPermissionSetLicenses';
import createContact from '@salesforce/apex/UserController.createContact';
import createContactBO from '@salesforce/apex/ContactController.createContactBo';
import createUserBO from '@salesforce/apex/ContactController.createUserBo';


export default class ParentComp extends LightningElement {
    @track selectedType = '';
    @track distributorId = '';
    @track showHelloWorld = true;
    @track showDistributeur = false;
    @track showSection3 = false;
    @track helloWorldValidated = false;
    @track distributeurValidated = false;
    @track Error = '';
    @track agenceId;
    @track agenceName;
    @track nom = '';
    @track prenom = '';
    @track civilite = '';
    @track email = '';
    @track username = '';
    @track produit = '';

    handleTypeChange(event) {
        this.selectedType = event.detail; // Récupère le type d'utilisateur sélectionné
        console.log('Selected Type in handleTypeChange:', this.selectedType);
    }

    lookupUpdatehandler(event) {
        this.distributorId = event.detail; // récupérer l'id du distributeur 
        this.Error = '';
        console.log('distributeur in handleTypeChange:', this.distributorId);
    }

    lookupUpdatehandlerAgence(event) {
        this.agenceId = event.detail;
        console.log('Agence in handleTypeChange:', this.agenceId);
    }

    handleCancel() {
        this.showForm = false; // On ajoutera une logique pour revenir à la page de création ou autre
    }

    handleSave() {
        this.showForm = false; // Masquer le formulaire après avoir sauvegardé
        this.showToast('Info', `Selected Type: ${this.selectedType}`, 'info');
        console.log('Selected Type in handleSave:', this.selectedType); 
        let userId; // Déclaration de userId pour qu'il soit accessible dans toute la méthode handleSave

        if (this.selectedType === 'Livreur' || this.selectedType === 'Animateur') {
            // Appeler la méthode Apex pour créer un nouvel utilisateur
            createUser({ 
                username: this.username,
                firstName: this.nom,
                lastName: this.prenom,
                email: this.email,
                profileName: 'End User'
            })
            .then(result => {
                // Affichez un message de succès à l'utilisateur
                this.showToast('Success', 'User created successfully', 'success');
                
                // Capturer l'ID de l'utilisateur créé
                userId = result; 

                // Définir les Permission Sets de base
                let permSetNames = ['LightningRetailExecutionStarter', 'MapsUser'];
                console.log('Selected Type in then:', this.selectedType); 
                
                // Ajouter des Permission Sets spécifiques si le type est 'livreur'
                if (this.selectedType === 'Livreur') {
                    permSetNames.push('ActionPlans');
                }

                // Appel de la méthode pour attribuer les Permission Sets
                return assignPermissionSets({ permSetNames: permSetNames, userId: userId });
            })
            .then(() => {
                // Affichez un message de succès pour l'attribution des Permission Sets
                this.showToast('Success', 'Permission sets assigned successfully', 'success');

                // Définir les Permission Set Licenses de base
                let permSetLicenseNames = ['SFMaps_Maps_LiveMobileTracking', 'IndustriesVisitPsl', 'SFMaps_Maps_Advanced', 'LightningRetailExecutionStarterPsl'];

                // Appel de la méthode pour attribuer les Permission Set Licenses
                return assignPermissionSetLicenses({ permSetLicenseNames: permSetLicenseNames, userId: userId });
            })
            .then(() => {
                // Affichez un message de succès pour l'attribution des Permission Set Licenses
                this.showToast('Success', 'Permission set licenses assigned successfully', 'success');
                
                // Appeler la méthode Apex pour créer un nouveau contact
                return createContact({
                    //accountId: this.selectedTypeAgence, // a revoir 
                    civilite: this.civilite,
                    firstName: this.nom,
                    lastName: this.prenom,
                    email: this.email,
                    userId: userId,
                    accountId: this.agenceId,
                    inwiCGC_UserCGC__c: userId
                });
            })
            .then(() => {
                // Affichez un message de succès pour la création du contact
                this.showToast('Success', 'Contact created successfully', 'success');
                console.log('Agence in then:', this.agenceId);

            })
            .catch(error => {
                // Affichez un message d'erreur à l'utilisateur
                this.showToast('Error', 'Erreur lors de la création de l\'utilisateur ou de l\'attribution des permissions : ' + (error.body ? error.body.message : error.message), 'error');
                console.error('Erreur lors de la création de l\'utilisateur ou de l\'attribution des permissions : ', error);
            });
        } else {
            // Appeler la méthode Apex pour créer un nouveau contact et utilisateur BO
            createContactBO({ 
                firstName: this.nom,
                lastName: this.prenom,
                email: this.email,
                civilite: this.civilite
            })
            .then(contactId => {
                // Affichez un message de succès à l'utilisateur
                this.showToast('Success', 'Contact created successfully', 'success');
                
                // Capturer l'ID du contact créé
                return createUserBO({ 
                    contactId: contactId,
                    username: this.username
                });
            })
            .then(userId => {
                // Affichez un message de succès pour la création de l'utilisateur
                this.showToast('Success', 'User created successfully', 'success');
            })
            .catch(error => {
                // Affichez un message d'erreur à l'utilisateur
                this.showToast('Error', 'Erreur lors de la création du contact ou de l\'utilisateur : ' + (error.body ? error.body.message : error.message), 'error');
                console.error('Erreur lors de la création du contact ou de l\'utilisateur : ', error);
            });
        }
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    handleNomUpdate(event) {
        this.nom = event.detail;
    }

    handlePrenomUpdate(event) {
        this.prenom = event.detail;
    }

    handleCiviliteUpdate(event) {
        this.civilite = event.detail;
    }

    handleEmailUpdate(event) {
        this.email = event.detail;
    }

    handleUsernameUpdate(event) {
        this.username = event.detail;
    }

    handleProduitUpdate(event) {
        this.produit = event.detail;
    }
}
