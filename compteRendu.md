# Compte Rendu Activité

## Résultats:


## Développements:

## Journal:
### 25-29/05/2020: 
#### Travail effectué

* Lecture de cours sur l’utilisation de Git [Gérez votre code avec Git et GitHub](https://openclassrooms.com/fr/courses/2342361-gerez-votre-code-avec-git-et-github) et [Utilisez Git et GitHub pour vos projets de développement](https://openclassrooms.com/fr/courses/5641721-utilisez-git-et-github-pour-vos-projets-de-developpement), installation et prise en main de Git.
Quelques commandes testées de Git:
```
	git config --global user.name "myUserName"
	git config --global user.email "mon@adresse.mail"
	git init
	git add unFichier
	git commit -m "Ajoute le fichier unFichier"
	git log
	git checkout SHA
	git reset --hard
	
```

* Documentation sur le [développement pour Galaxy](https://training.galaxyproject.org/training-material/topics/dev/)
* Documentation sur l’outil planemo, installation de virtualenv et planemo et [entrainement sur planemo](https://planemo.readthedocs.io/en/latest/writing_standalone.html)
Commandes permettant la création et le test d'un outil sur Galaxy:
```
	virtualenv -p /usr/bin/python3 venv # Creation of virtual environment
	cd venv
	source bin/activate	# Activation of virtual environment
	pip3 install planemo	# Installation of planemo in virtual environment
	
	# Initialization of the file seqtk_seq2.xml 
	planemo tool_init --id 'seqtk_seq2' --name 'Convert to FASTA (seqtk)' \
		--requirement seqtk@1.2 --example_command 'seqtk seq -a 2.fastq > 2.fasta'\
		--example_input 2.fastq --example_output 2.fasta --test_case \
		--cite_url 'https://github.com/lh3/seqtk' --help_from_command 'seqtk seq'
	
	gedit seqtk_seq2	# Modification of the file seqtk_seq2
	planemo lint 		# ou planemo l
	planemo test 		# ou planemo t
	planemo serve 		# ou planemo s
```


#### Point bloquants, Questions

* l’utilisation de  `planemo t`  ainsi que  `planemo s` entraine des erreurs, il doit manquer des dépendances (peut-être libbzip2).


#### Travail prévu

* Débugé  `planemo t`  et `planemo s`


### 01-05/06/2020: 
#### Travail effectué

* Résolution du bug sur `planemo t` et `planemo s` en installant la librairie libbzip2
* Entrainement sur planemo avec l'outil [setk](https://planemo.readthedocs.io/en/latest/writing_standalone.html) et [bwa](https://planemo.readthedocs.io/en/latest/writing_advanced.html) fini et documentation sur les macros. Ces entraînements ont permis de connaitre les bases du langages XML et de l'utilisation de planemo. Cela a aussi permis savoir comment faire une page galaxy avec des entrées adapatables ( balise `<conditional>`) et un choix des paramétres. J'ai aussi vu comment faire des macros c'est-à-dire des fichiers qui contiennent des "fonctions" utilisable par autres les scripts XML (ça permet d'éviter de ré-écrire du code entre 2 programmes) et comment écrire des tests pour les outils.

Commande utilisé sur l'exercice BWA:
```
planemo project_init --template bwa bwa
cd bwa/test-data
bwa index -a is bwa-mem-mt-genome.fa
bwa mem bwa-mem-mt-genome.fa bwa-mem-fastq1.fq bwa-mem-fastq2.fq | \
  samtools view -Sb - > temporary_bam_file.bam && \
  (samtools sort -f temporary_bam_file.bam bwa-aln-test2.bam || samtools sort -o bwa-aln-test2.bam temporary_bam_file.bam)
gedit bwa-mem.xml 	# Modification causing test error
planemo l
planemo t 			# One test failed
gedit bwa-mem.xml 	# Modification which fix the test issue
planemo l
planemo t --failed 	# Check only the test which failed
```

#### Point bloquants, Questions

* l'installation de l'éditeur de markdown, "Remarkable", n'a pas pu se faire et a entrainé des "bugs" dans le programme d'installation `apt-get`

#### Travail prévu

* Début du développement d'outils pour rendre la page Galaxy du blastcmd plus adaptable en permettant d'utiliser des séquences de référence téléchargées par l'utilisateur.


### 08-12/06/2020
#### Travail effectué


* Ajout du [galaxy_blast](https://github.com/mesocentre-clermont-auvergne/galaxy_blast) de peterjc en tant que sous-module dans le répertoire Stage-Francois-Hiriart mais la modification du sous-module entrainait des erreurs car sur github le sous-module devenait un lien pointant vers le github de peterjc qui ne contenait pas les commits ajoutés.
commandes lancées:

```
git submodule add https://github.com/peterjc/galaxy_blast.git
cd galaxy_blast
git branch blastcmdAdapatability
git checkout blastcmdAdapatability

cd tools/ncbi_blast_plus
planemo l		# See "failed linting"

# To see more easily which file make the "failed linting"
for i in `ls | grep \.xml$`; \
do \
	echo -e "\n\n\n $i"; \
	planemo l $i; \
done
# Just a warning because ncbi_psiblast_wrapper.xmlgedit have no test
planemo t --test_data ../../test-data/	# See an error
firefox tool_test_output.html		# See that ncbi_deltablast_wrapper.xml make an error
mv ncbi_deltablast_wrapper.xml ..
```

* Pour pallier le problème on crée un second dépot git qui contient une copie de du dépot de peterjc et on c'est cette copie qu'on rajoute en sous-module car on pourra la modifier
commande lancées:

```
git clone https://github.com/peterjc/galaxy_blast.git
cd galaxy_blast/
git remote set-url origin https://github.com/mesocentre-clermont-auvergne/galaxy_blast.git
git push -u origin master
```

* Modification du fichier ncbi_macros.xml pour permettre de choisir une base de donnée blast qui vient de l'historique.

```
gedit ncbi_macros.xml
planemo l								# Verify that the XML syntax is correct
planemo t --test_data ../../test-data	# Make tests to verify if modification is without bug
```

#### Point bloquants, Questions

* Les modification dans le fichiers **macro.xml** entraine des erreurs de correspondances avec les variables du fichier **ncbi\_blastdbcmd_wrapper.xml**

#### Travail prévu

* Modifier le fichier **ncbi\_blastdbcmd\_wrapper.xml** pour rendre les modifications du fichiers **ncbi_macros.xml** compatibles


### 15-19/06/2020
#### Travail effectué

* Modification du fichier **ncbi\_blastdbcmd\_wrapper.xml** pour qu'il permette de choisir une base de donnée provenant de l'historique. Pour voir les erreurs et tester le script les tests ont été fait en utilisant le `planemo s --no_cleanup --test_data test-data`.

* Ajout de la fonction *N\_DB\_SUBJECT\_ORIGIN* dans le fichier macros.xml pour avoir des noms de fichier en sortie qui correspondent au fichier donné en entré pour l'outil.

* Réglage d'un problème de reconnaissance de variable entre le script **ncbi_macros.xml** et **ncbi\_blastdbcmd\_wrapper.xml**.

* Préparation de la présentation du travail fait pendant les 4 premières semaines.
#### Point bloquants, Questions

Il y a eu des blocages une fois les modifications faites sur la ligne 17 du fichier **ncbi\_blastdbcmd\_wrapper.xml**
```
	-db "{os.path.join($db_opts.db_origin.histdb.extra_files_path, "blastdb")}"
```

Cette ligne de code entrainait l'erreur suivante:
```
/tmp/tmpmkm0xpzn/job_working_directory/000/11/tool_script.sh: line 13: [: 0: unary operator expected
BLAST Database error: No alias or index file found for protein database [{os.path.join(/tmp/tmpmkm0xpzn/files/000/dataset_2_files,] in search path [/tmp/tmpmkm0xpzn/job_working_directory/000/11/working::]
```

Cette erreur a été corrigée en changeants les guillemets extérieurs par des apostrophes car les doubles paires de guillemets s'interféraient entre eux.
```
-db '${os.path.join($db_opts.db_origin.histdb.extra_files_path, "blastdb")}'`.
```

Mais cette syntaxe aussi est correcte 
```
	-db "$db_opts.db_origin.histdb.extra_files_path/blastdb"
```

#### Travail prévu

* Continuer la préparation de l'oral et faire la présentation le mardi 23 juin.

* Faire un pull request des modifications faites.


### 22-26/06/2020
#### Travail effectué

* Préparation de la présentation et présentation du travail de mi-parcours le mardi 23 juin.

* Les commentaires inutiles ont été enlevés et une première tentative de pull request a été faite

* Installation de l'outil bsmpap, des scripts xml, et blibliographie de l'outil bsmap afin de répondre à la seconde demande d'utilisateur

#### Point bloquants, Questions

* Le premier pull request semblait généré des erreurs à cause de tabulations mis dans le code, les tabulations ont donc été enlevé. Cette erreur est possiblement dû aux différentes versions de python utilisé entre moi-même (3.7) et peterjc (2.7)

* Il manque des données test pour pouvoir tester l'outil bsmap au fur et à mesure des modifications.

### 29/06-03/07 2020
#### Travail effectué

* Délétion des espaces à la fin de certaines lignes dans les scripts modifiés dans BLAST car cela générait des erreurs pour le pull request

#### Point bloquants, Questions

* Présence d'un bug lors de l'utilisation de bsmap sous `planemo serve` qui ne correspondait pas au bug décrit par l'utilisateur. Le bug présentait disait qu'il y avait une erreur alors que le bsmap ne faisait pas d'erreur et donnait un résultat. Pour tenter de régléer le problème, il y a eu des modifications dans les scripts xml qui appelait bsmap en précisant la nouvelle version de bsmap utilisé. Il y a aussi eu une installation de bsmap avec conda (qui à aussi rencontré certains problèmes, il manquait conda-build et le fait de vouloir upgrade conda-build une fois intallé entrainé des erreurs qui corrompait conda).

### 06/07-10/07 2020
#### Travail effectué

* Résolution du bug sur bsmap, cela provenait du fait que la sortie du diagnostique des étapes de bsmap sur le nouvelle version était écrit dans la sortie erreur (stderr) ce qui ne devait pas être le cas précédement (stdin). Or pour le fichier log on prenait la sortie standard de bsmap pour le mettre dans le fichier log et vu que cet sortie était vide car envoyé maintenant dans la sortie erreur alors le fichier log était vide. La résolution du problème nous amène donc maintenant au bug décrit par l'utilisateur à savoir un argument inconnue "-2" est utilisé pour bsmap.

* Début de la rédaction du rapport de stage

## Conclusion

