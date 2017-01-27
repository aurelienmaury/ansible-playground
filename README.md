# Exercices Formation Ansible by WeScale

# Pré-requis

* Installer Terraform (testé avec 0.8.4)
* Avoir un compte AWS et renseigner dans votre shell mes variables d'environnement AWS_* pour consommer l'API.
* Ne travailler que depuis la racine de ce workspace.
* Laissez vous guider par les éventuels messages d'erreur. Ils sont là pour une raison.

# 01. Passage de machine Bastion

* Montez l'infrastructure de test en lançant: `ansible-playbook ansible/deploy-exo_01.yml`
* Testez votre connectivité avec les machines avec: `ansible -m ping all`
* Injectez des accès grâce au playbook `ansible/inject_classroom_accesses.yml`
* Lisez et comprenez 100% des playbooks, include, template et fichiers générés.

Pour refermer l'exercice, lancez le playbook `ansible-playbook ansible/undeploy-exo_01.yml`

# 02. Créer et gérer de l'infra Cloud (AWS et/ou GCP)


# Exercices complémentaires

* factoriser les scripts `ansible/deploy-*` et `ansible/undeploy-*` pour n'en faire qu'un seul qui prenne
un paramètre d'entrée.