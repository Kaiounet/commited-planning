= Spécification des Besoins

Cette section détaille les exigences fonctionnelles et non fonctionnelles du système *Commit Ed*. L'analyse découle de la problématique identifiée : offrir une plateforme d'évaluation alignée sur les workflows professionnels (Dev-First).

== Besoins Fonctionnels

Les besoins fonctionnels sont regroupés par domaine d'application, correspondant à l'architecture distribuée du projet.

=== Gestion des Utilisateurs et Classes (Service Core)
Ce module constitue le socle administratif de la plateforme.
- *Authentification et Autorisation* : Le système doit permettre une authentification sécurisée (JWT) pour trois rôles distincts : Administrateur, Professeur, et Étudiant.
- *Gestion des Classes* : Le professeur doit pouvoir créer des classes, générer des codes d'invitation uniques et gérer la liste des inscrits.
- *Gestion des Devoirs (Assignments)* : Le professeur doit pouvoir créer un devoir en spécifiant un titre, une description, une date limite et lier un dépôt GitHub "Template".

=== Workflow Pédagogique & GitOps (Service Orchestrator)
Ce module est le cœur critique assurant l'immersion "Dev-First".
- *Distribution de Code* : Lorsqu'un étudiant démarre un devoir, le système doit faciliter la création de son dépôt de travail (via Fork automatique ou Clonage de Template).
- *Détection de Soumission* : Le système doit être capable de détecter quand un étudiant a soumis son travail (via Webhook GitHub ou action manuelle de l'étudiant).
- *Clonage Automatisé* : Le système doit pouvoir récupérer le code de l'étudiant dans un environnement temporaire pour l'analyser.

=== Analyse et Évaluation (Services Intelligence & Orchestrator)
- *Exécution Sécurisée* : Le code étudiant doit être exécuté dans des environnements isolés (Conteneurs Docker) pour ne pas affecter le serveur principal.
- *Analyse de Code* : Le système doit exécuter des tests unitaires ou des outils de qualité (linter) sur le code soumis.
- *Rapport de Feedback* : Un rapport simple doit être généré après l'analyse, indiquant si les tests sont passés ou échoués.
- *Fallback Manuel* : Le professeur doit pouvoir consulter la note automatique et la modifier manuellement si nécessaire.

=== Suivi et Intelligence (Service Analytics)
- *Tableaux de Bord (Dashboard)* : Visualisation des statistiques clés : nombre de soumissions par devoir et moyenne de la classe.
- *Alertes Basiques* : Identification des étudiants n'ayant rien soumis à 24h de la date limite.
- *Analyse de Difficulté* : Le système doit pouvoir identifier les devoirs ayant un taux d'échec anormalement élevé.

== Besoins Non-Fonctionnels

Ces exigences définissent les critères de qualité technique réalistes pour la réussite du projet.

=== Sécurité et Configuration
- *Isolation Basique* : Les conteneurs exécutant le code étudiant ne doivent pas avoir d'accès privilégié au système hôte (pas de montage de volume racine).
- *Sécurité des Accès* : Les mots de passe utilisateurs doivent être hachés et les tokens API ne doivent pas être exposés dans le code source.
- *Configuration Externe* : Les paramètres sensibles (URLs de base de données, Clés API) doivent être chargés via des variables d'environnement (`.env`) et non écrits en dur.

=== Performance et Fluidité
- *Traitement en Arrière-plan* : L'analyse de code ne doit pas geler l'interface utilisateur. L'étudiant doit pouvoir continuer à naviguer pendant que son code est analysé.
- *Temps de Chargement* : Les pages principales (Dashboard, Liste des devoirs) doivent se charger rapidement (affichage des données sans latence excessive).

=== Fiabilité
- *Gestion des Erreurs* : Si l'analyse du code échoue (ex: erreur de compilation), le système doit le signaler proprement à l'étudiant au lieu de planter ou d'afficher une page blanche.
- *Intégrité des Données* : Les notes et les soumissions ne doivent pas être perdues. L'utilisation d'une base de données relationnelle (Oracle) garantit la persistance.

=== Maintenabilité et Déploiement
- *Code Propre* : Le code source doit suivre les bonnes pratiques de chaque langage (PSR pour PHP, Conventions Java/C\#) pour faciliter la relecture par les autres membres.
- *Déploiement Unifié* : L'application complète doit pouvoir être lancée sur une machine de développement via une seule commande (ex: `docker-compose up`).
- *Documentation API* : Les points d'entrée (Endpoints) utilisés entre le Frontend et le Backend doivent être documentés (même succinctement) pour éviter les erreurs d'intégration.

=== Ergonomie
- *Feedback Visuel* : L'utilisateur doit toujours savoir ce qui se passe (ex: afficher un "spinner" de chargement pendant une requête).
- *Navigation Intuitive* : Un utilisateur (Prof ou Étudiant) doit pouvoir trouver les actions principales (Soumettre, Corriger) en moins de 3 clics.