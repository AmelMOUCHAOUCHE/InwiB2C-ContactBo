public with sharing class UserController {

    @AuraEnabled
    public static String createUser(String username, String firstName, String lastName, String profileName, String email) {
        try {
            // Récupérer l'ID du profil en fonction de son nom
            Id userProfileId = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1].Id;

            // Créer un nouvel utilisateur avec les informations fournies
            User newUser = new User(
                Username = username,
                FirstName = firstName,
                LastName = lastName,
                Email = email,
                Alias = 'Default', // Exemple de valeur pour le champ Alias
                TimeZoneSidKey = 'America/New_York', // Exemple de valeur pour le champ Time Zone
                LocaleSidKey = 'en_US', // Exemple de valeur pour le champ Locale
                EmailEncodingKey = 'UTF-8', // Exemple de valeur pour le champ Email Encoding
                ProfileId = userProfileId, // Utiliser l'ID du profil récupéré
                LanguageLocaleKey = 'en_US' // Exemple de valeur pour le champ Language
            );

            // Insérer le nouvel utilisateur dans Salesforce
            insert newUser;

            // Retourner l'ID de l'utilisateur créé
            return newUser.Id;
        } catch (Exception e) {
            // Retourner un message d'erreur en cas d'échec
            throw new AuraHandledException('Erreur lors de la création de l\'utilisateur : ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void assignPermissionSets(List<String> permSetNames, String userId) {
        try {
            // Vérifier si les noms des Permission Sets et l'ID de l'utilisateur ne sont pas nuls ou vides
            if (permSetNames.isEmpty() || String.isBlank(userId)) {
                throw new IllegalArgumentException('Les noms des Permission Sets et l\'ID de l\'utilisateur sont requis.');
            }

            System.debug('Recherche des Permission Sets avec les noms : ' + permSetNames);

            // Récupérer les IDs des Permission Sets en fonction de leurs noms
            List<PermissionSet> permSetList = [
                SELECT Id, Name 
                FROM PermissionSet 
                WHERE Name IN :permSetNames
            ];

            // Vérifier si des Permission Sets ont été trouvés
            if (permSetList.isEmpty()) {
                throw new IllegalArgumentException('Aucun des Permission Sets spécifiés n\'a été trouvé.');
            }

            // Créer une liste pour stocker les enregistrements PermissionSetAssignment
            List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();

            // Créer un enregistrement PermissionSetAssignment pour chaque Permission Set trouvé
            for (PermissionSet permSet : permSetList) {
                PermissionSetAssignment psa = new PermissionSetAssignment(
                    AssigneeId = userId,
                    PermissionSetId = permSet.Id
                );
                psaList.add(psa);
            }

            // Insérer tous les enregistrements PermissionSetAssignment
            insert psaList;

            // Ajouter des journaux de débogage pour la confirmation
            System.debug('PermissionSets ' + permSetNames + ' assigned to user ' + userId);
            for (PermissionSetAssignment psa : psaList) {
                System.debug('Assigned PermissionSet: ' + psa.PermissionSetId + ' to User: ' + psa.AssigneeId);
            }

        } catch (Exception e) {
            // Gestion des erreurs
            System.debug('Erreur lors de l\'attribution des Permission Sets : ' + e.getMessage());
            throw new AuraHandledException('Erreur lors de l\'attribution des Permission Sets : ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void assignPermissionSetLicenses(List<String> permSetLicenseNames, String userId) {
        try {
            // Vérifier si les noms des Permission Set Licenses et l'ID de l'utilisateur ne sont pas nuls ou vides
            if (permSetLicenseNames.isEmpty() || String.isBlank(userId)) {
                throw new IllegalArgumentException('Les noms des Permission Set Licenses et l\'ID de l\'utilisateur sont requis.');
            }

            System.debug('Recherche des Permission Set Licenses avec les noms : ' + permSetLicenseNames);

            // Récupérer les IDs des Permission Set Licenses en fonction de leurs noms
            List<PermissionSetLicense> permSetLicenseList = [
                SELECT Id, DeveloperName 
                FROM PermissionSetLicense 
                WHERE DeveloperName IN :permSetLicenseNames
            ];

            // Vérifier si des Permission Set Licenses ont été trouvés
            if (permSetLicenseList.isEmpty()) {
                throw new IllegalArgumentException('Aucun des Permission Set Licenses spécifiés n\'a été trouvé.');
            }

            // Créer une liste pour stocker les enregistrements PermissionSetLicenseAssign
            List<PermissionSetLicenseAssign> pslaList = new List<PermissionSetLicenseAssign>();

            // Créer un enregistrement PermissionSetLicenseAssign pour chaque Permission Set License trouvé
            for (PermissionSetLicense permSetLicense : permSetLicenseList) {
                PermissionSetLicenseAssign psla = new PermissionSetLicenseAssign(
                    AssigneeId = userId,
                    PermissionSetLicenseId = permSetLicense.Id
                );
                pslaList.add(psla);
            }

            // Insérer tous les enregistrements PermissionSetLicenseAssign
            insert pslaList;

            // Ajouter des journaux de débogage pour la confirmation
            System.debug('PermissionSetLicenses ' + permSetLicenseNames + ' assigned to user ' + userId);
            for (PermissionSetLicenseAssign psla : pslaList) {
                System.debug('Assigned PermissionSetLicense: ' + psla.PermissionSetLicenseId + ' to User: ' + psla.AssigneeId);
            }

        } catch (Exception e) {
            // Gestion des erreurs
            System.debug('Erreur lors de l\'attribution des Permission Set Licenses : ' + e.getMessage());
            throw new AuraHandledException('Erreur lors de l\'attribution des Permission Set Licenses : ' + e.getMessage());
        }
    }
    @AuraEnabled
    public static void createContact(String civilite, String firstName, String lastName, String email, Id userId, Id accountId) {
        try {
            // Créer un nouveau contact avec les informations fournies
            Contact newContact = new Contact(
                FirstName = firstName,
                LastName = lastName,
                Email = email,
                AccountId = accountId, // Utiliser l'ID de l'agence sélectionnée
                InwiB2C_Civilit__c = civilite,
                inwiCGC_UserCGC__c = userId 
            );

            // Insérer le nouveau contact dans Salesforce
            insert newContact;
        } catch (Exception e) {
            // Retourner un message d'erreur en cas d'échec
            throw new AuraHandledException('Erreur lors de la création du contact : ' + e.getMessage());
        }
    }
}
