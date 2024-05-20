public with sharing class ContactController {
    
    @AuraEnabled
    public static String createContactBO(String userType, String firstName, String lastName, String email, String civilite) {
        try {
            // Créer un nouveau contact
            Contact newContact = new Contact();
            newContact.FirstName = firstName;
            newContact.LastName = lastName;
            newContact.Email = email;
            newContact.Salutation = civilite;
            
            // Insérer le contact dans la base de données
            insert newContact;

            // Retourner l'ID du contact créé
            return newContact.Id;
        } catch (DmlException e) {
            throw new AuraHandledException('Erreur lors de la création du contact : ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static String createUserBo(String contactId, String username) {
        try {
            // Récupérer les informations du contact
            Contact contact = [SELECT FirstName, LastName, Email FROM Contact WHERE Id = :contactId LIMIT 1];

            // Créer un nouvel utilisateur en utilisant l'ID du contact
            User newUser = new User();
            newUser.ContactId = contactId;
            newUser.Username = username;
            newUser.Email = contact.Email;
            newUser.FirstName = contact.FirstName;
            newUser.LastName = contact.LastName;
            newUser.Alias = username.length() > 8 ? username.substring(0, 8) : username; // Alias doit être unique et <= 8 caractères
            newUser.TimeZoneSidKey = 'America/Los_Angeles';
            newUser.LocaleSidKey = 'en_US';
            newUser.EmailEncodingKey = 'UTF-8';
            newUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id;
            newUser.LanguageLocaleKey = 'en_US';

            // Insérer l'utilisateur dans la base de données
            insert newUser;

            // Retourner l'ID de l'utilisateur créé
            return newUser.Id;
        } catch (DmlException e) {
            throw new AuraHandledException('Erreur lors de la création de l\'utilisateur : ' + e.getMessage());
        } catch (QueryException e) {
            throw new AuraHandledException('Erreur lors de la récupération du contact : ' + e.getMessage());
        }
    }
}
