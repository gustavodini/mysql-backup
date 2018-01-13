#!/bin/bash
#Script de backup de banco de dados Mysql.
#Leonardo Macedo Cerqueira - leonardo.macedo.c@gmail.com

DATA=$(date +"%d-%m-%Y")	 #definição de variável para a data dos backups. 
DEST="/home/gustavo/temp/backup"	 #pasta de destino do backup.
DESTDAY="${DEST}/bkp-mysql-$DATA/"	#pasta de backup diario

# Login do usuario root do mysql:
MUSER="root"              #login do usuario administrativo do mysql.
MPASS="123456"   # senha.
MHOST="127.0.0.1"  	    #ip que o mysql esta up. no caso localhost

#Caminhos dos binarios: mysql, gzip e mysqldump.
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
GZIP="$(which gzip)"

#Rotina de Backup. 
echo 'Iniciando backup...'
[ ! -d "${DEST}" ] && mkdir -p "${DEST}"
### consultando todas os bancos/bases de dados do mysql:
echo 'Consultando todas os bancos/bases de dados do mysql...'
DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
for db in $DBS
do
/bin/mkdir -p $DESTDAY
FILE=${DEST}/bkp-mysql-$DATA/banco-${db}.${DATA}.gz
### execucao do backup 
echo 'Execucao do backup......'
$MYSQLDUMP --single-transaction -u $MUSER -h$MHOST -p$MPASS $db | $GZIP -9 > $FILE
done

#Apagando backups antigos
#Opcional. apaga PASTA de backups de 20 dias.
echo 'Apagando backups antigos. Apaga PASTA de backups de 3 dias.'
DATAREMOVE=$(date -d "3 day ago" +"%d-%m-%Y")
/bin/rm -rf ${DEST}/bkp-mysql-$DATAREMOVE
echo 'Backup na pasta '$DESTDAY

#Enviando para Dreamhost (espelho de backup)
#echo 'Enviando para servidor Dreamhost (espelho de backup)'
#sshpass -p 'carasebocas2010' scp -r $DESTDAY gustavodini@208.113.224.4:/home/gustavodini/pro-treino-backups

