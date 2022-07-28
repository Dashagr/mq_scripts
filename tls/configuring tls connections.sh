
# CREATING AN TLS CERTIFICATE
# the best practice is putting ssl to java folder, the ssl for qmgr is inside the qmgrs ssl file


# create a key database
runmqckm -keydb -create -db keydatabase -pw passw0rd -type cms -stash

# create a self-signed personal certificate
runmqckm -cert -create -db keydatabase.kdb -pw passw0rd -label ibmwebspheremqqmdasha -dn "CN=QMDasha,O=IBM,C=UA,OU=MQ Support" -size 2048 -expire 365

# extract the public part of a self-signed certificate
runmqckm -cert -extract -db keydatabase.kdb -pw passw0rd -label ibmwebspheremqqmdasha -target qmdashatarget -format ascii




#================
#SENDERAPP

# create a key database for java sender app
runmqckm -keydb -create -db senderjks.jks -pw passw0rd -type jks -stash

# add the public part of the IBM MQ certificate to the java key repository sender app
runmqckm -cert -add -db senderjks.jks -pw passw0rd -label senderapp -file /var/mqm/qmgrs/QMDasha/ssl/qmdashatarget -format ascii



# create a self-signed personal certificate
runmqckm -cert -create -db senderjks.jks -pw passw0rd -label senderappcert -dn "CN=QMDasha,O=IBM,C=UA,OU=MQ Support" -size 2048 -expire 365

# extract the public part of a self-signed certificate
runmqckm -cert -extract -db senderjks.jks -pw passw0rd -label senderappcert -target senderapptarget -format ascii





#================
#RECEIVERAPP

# create a key database for java receiver app
runmqckm -keydb -create -db receiverjks.jks -pw passw0rd -type jks -stash

# add the public part of the IBM MQ certificate to the java key repository sender app
runmqckm -cert -add -db receiverjks.jks -pw passw0rd -label receiverapp -file /var/mqm/qmgrs/QMDasha/ssl/qmdashatarget -format ascii

# create a self-signed personal certificate
runmqckm -cert -create -db receiverjks.jks -pw passw0rd -label receiverappcert -dn "CN=QMDasha,O=IBM,C=UA,OU=MQ Support" -size 2048 -expire 365

# extract the public part of a self-signed certificate
runmqckm -cert -extract -db receiverjks.jks -pw passw0rd -label receiverappcert -target receiverapptarget -format ascii



#=================
#AFTER THAT GOING BACK TO QM DATABASE FOLDER

#adding a public parts of sender and receiver apps certificate
runmqckm -cert -add -db keydatabase.kdb -pw passw0rd -label senderapppart -file /home/daria/Documents/mqappliance-master/java/ssl/senderapp/senderapptarget -format ascii
runmqckm -cert -add -db keydatabase.kdb -pw passw0rd -label receiverapppart -file /home/daria/Documents/mqappliance-master/java/ssl/receiverapp/receiverapptarget -format ascii



# Update a qmgrs parameters
ALTER QMGRS SSLKEYR (/var/mqm/qmgrs/QMDasha/ssl/keydatabase)
