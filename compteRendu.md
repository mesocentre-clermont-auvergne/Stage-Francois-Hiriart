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

## Conclusion

