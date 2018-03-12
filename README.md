# solidity-smart-contracts
Cours blockchain ESILV 4ème année
AIT SAID Karim IF5 SINGH Juspreet IF5

#TP1_Vote

1) Y'a t'il un organisateur désigné?

Aucune autorité dirigeante mais plutot différent
membres avec le même pouvoir, proposer et voter.

2) Qui seront les votants ?

Les membres de l'entreprises : les employés

3)quelles seront les propositions ?

Par exemple, êtes vous d'accord pour ajouter une 
nouvelle machine à café dans le secteur ouest?

4) Qui peut ajouter une proposition ?

Tout le monde peut ajouter une proposition.

5) Combien de temps durera le vote ?

C'est le créateur de la proposition qui décide.


6)Comment seront calculés les résultats ?

Chaque votant à la possibilité de voter qu'une
fois grace à la sécurité du smart contract, une 
adresse unique pour un utilisateur. Donc chaque
vote rapportera 1 point. Le resultat sera calculé 
en additionnant le nombre de point recolté 
pour chaque proposition.

7) Peut-on faire des délégations ? Comment ?

8)Quelles informations a-t-on sur les votants ? 
Comment s'assure-t-on que chacun ne vote que le 
nombre de fois autorisé ?

Notre contrat a en entrée quelques variables telles
que le temps de vote accordé et le nom du proprié
taire du contrat. Son nom est donc publique. 
Il y a par la suite un mapping des différentes 
adresses qui sont liées à un booléen : celui ci 
determinera si la personne à deja voté ou non.
Nous avons notamment une derniere structure 
appelée Proposal contenant description, et mapping
pour recenser les differentes adresses des votants.

#TP2_Fidelite

#TP3_Proof_of_Existence
