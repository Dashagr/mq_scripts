
# SEQUENCE CREATING AN TLS CERTIFICATE
# the best practice is putting ssl to java folder, the ssl for qmgr is inside the qmgrs ssl file


# create a key database
runmqckm -keydb -create -db key -pw passw0rd -type cms -stash

# create a self-signed personal certificate
runmqckm -cert -create -db key.kdb -stashed -label qmkey -dn "CN=KEY,O=IBM,C=UA,OU=MQ Support" -size 2048 -expire 365

# extract the public part of a self-signed certificate
runmqckm -cert -extract -db key.kdb -stashed -label qmkey -target keyqmpub -format ascii


#================
#SENDERAPP

# create a key database for java sender app
runmqckm -keydb -create -db senderjks.jks -pw passw0rd -type jks 

# create a self-signed personal certificate
runmqckm -cert -create -db senderjks.jks -pw passw0rd -label senderpub -dn "CN=QMDasha,O=IBM,C=UA,OU=MQ Support" -size 2048 -expire 365

# extract the public part of a self-signed certificate
runmqckm -cert -extract -db senderjks.jks -pw passw0rd -label senderpub -target senderpub -format ascii


# add the public part of the IBM MQ certificate to the java key repository sender app
runmqckm -cert -add -db senderjks.jks -pw passw0rd -label qmdashapublic -file /var/mqm/qmgrs/KEY/ssl/keyqmpub -format ascii



#=================
#AFTER THAT GOING BACK TO QM DATABASE FOLDER


#adding a public parts of sender and receiver apps certificate
runmqckm -cert -add -db key.kdb -stashed -label senderpub -file /home/daria/git/Messaging/ssl/senderpub -format ascii




# Update a qmgrs parameters
ALTER QMGR SSLKEYR (/var/mqm/qmgrs/qmdasha/ssl/key) SSLCIPH(TLS_RSA_WITH_AES_256_CBC_SHA256)

#CHECK the CERTLABL parameter inside the qm , maybe its expecting another qm lavel

####
#Run the SENDER WITH SSL APP

-Dhostname=localhost
-Dport=1414
-Dchannel=CHNL.QMDASHA
-Dqmgr=QMDasha
-DsenderQ=QMDASHAQUEUE
-Duser=daria
-Dpwd=10fumupa
-DlogFile=/home/daria/Documents/SenderSSL.log
-DcipherSuite=TLS 1.2
-Djavax.net.ssl.trustStore=/home/daria/Documents/mqappliance-master/java/ssl/senderapp/senderjks.jks
-Djavax.net.ssl.trustStorePassword=passw0rd
-Djavax.net.ssl.keyStore=/home/daria/Documents/mqappliance-master/java/ssl/senderapp/senderjks.jks
-Djavax.net.ssl.keyStorePassword=passw0rd

# for list certificates
$ runmqckm -cert -list all -db senderjks.jks -pw passw0rd
$ runmqckm -cert -delete -label qmdashapublic -db senderjks.jks -pw passw0rd




-Dhostname=localhost
-Dport=1987
-Dchannel=CHNL.AJ
-Dqmgr=QMAJ
-DsenderQ=QAJ
-Duser=appuser
-Dpwd=appuser
-DlogFile=/home/daria/Documents/SenderSSL.log
-Dcom.ibm.mq.cfg.useIBMCipherMappings=false
-DcipherSuite=TLS_RSA_WITH_AES_256_CBC_SHA256
-Djavax.net.ssl.trustStore="/tmp/auto/javaclientAJ.jks"
-Djavax.net.ssl.trustStorePassword=passw0rd
-Djavax.net.ssl.keyStore="/tmp/auto/javaclientAJ.jks"
-Djavax.net.ssl.keyStorePassword=passw0rd