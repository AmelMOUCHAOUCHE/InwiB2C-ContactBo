import { LightningElement, track, api } from 'lwc';

export default class InformationContactUser extends LightningElement {
    @api selectedType = ''; // importer le typeuser saisi dans le premier composant
    
    @track nom = '';
    @track prenom = '';
    @track civilite = '';
    @track email = '';
    @track username = '';
    @track produit = '';
    @track afficherProduit = false;
    
    // Définir les options pour la civilité
    get civiliteOptions() {
        return [
            { label: 'M', value: 'M' },
            { label: 'Mlle', value: 'Mlle' },
            { label: 'Mr', value: 'Mr' }
        ];
    }

    // Définir les options pour le champ produit
    get produitOptions() {
        return [
            { label: 'FTTH', value: 'FTTH' },
            { label: 'ADSL', value: 'ADSL' } 
        ];
    }

    handleCiviliteChange(event) {
        this.civilite = event.target.value;
        this.dispatchUpdateEvent('civilite', this.civilite);
    }

    handleNomChange(event) {
        this.nom = event.target.value;
        this.dispatchUpdateEvent('nom', this.nom);
    }

    handlePrenomChange(event) {
        this.prenom = event.target.value;
        this.dispatchUpdateEvent('prenom', this.prenom);
    }

    handleEmailChange(event) {
        this.email = event.target.value;
        this.dispatchUpdateEvent('email', this.email);
        console.log('email:' + this.email);
    }

    handleUsernameChange(event) {
        this.username = event.target.value;
        console.log('UserName:' + this.username);
        this.dispatchUpdateEvent('username', this.username);
        
    }
    

    handleProduitChange(event) {
        this.produit = event.target.value;
        this.dispatchUpdateEvent('produit', this.produit);
    }

    // Dispatch a custom event with updated value
    dispatchUpdateEvent(fieldName, value) {
        const updateEvent = new CustomEvent(`${fieldName}update`, {
            detail: value
        });
        this.dispatchEvent(updateEvent);
    }

    // Gérer les changements de sélection de produit
    get showProduitField() {
        return this.selectedType === 'Animateur';
    }

}
