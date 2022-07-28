# Key repository created automatically

# under mqcli you can list a certificates for a specific QM
listcert -m KEYDASHA

# to create a self-signed certificate, run
createcert -m KEYDASHA -dn "CN=keystorrr,O=IBM,C=UA,OU=MQ Support" -label keycerdd

# List the KEYYstore content to verify the certificate was created:
listcert -m KEYY

#Extract the public part.
#In MQ appliance, the public part of the certificate is automatically extracted and placed in mqpubcert://

# You can run the following command to verify:

mqa(config)# dir mqpubcert://

# Download the public KEYY from the appliance to be sent to the remote end (Linux box).

copy mqpubcert://KEYY_keyycert scp://daria@192.168.1.12//home/daria/git/Messaging/ssl/keyycert







# On a linux side

#SENDERAPP

# create a KEYY database for java sender app
runmqckm -keydb -create -db senderjks.jks -pw passw0rd -type jks 

# create a self-signed personal certificate
runmqckm -cert -create -db senderjks.jks -pw passw0rd -label sendercert -dn "CN=key,O=IBM,C=UA,OU=MQ Support" -size 2048 -expire 365

# extract the public part of a self-signed certificate
runmqckm -cert -extract -db senderjks.jks -pw passw0rd -label sendercert -target sendercert -format ascii


# add the appliance queue manager public KEYY to the queue manager SSL1
runmqckm -cert -add -db senderjks.jks -pw passw0rd -label keyycert -file keyycert 

# send exracted public part to appliance
copy scp://daria@192.168.1.12//home/daria/git/Messaging/ssl/sendercert mqpubcert://

# check that mqa certificate is inside the jks 
runmqckm -cert -details -label KEYYdashapublic -db /home/daria/git/Messaging/ssl/senderjks.jks -pw passw0rd



#MQCLI

#Add a java certificate 
addcert -m KEYY -label sendercert -file sendercert


# inside MQA 
ALTER CHANNEL(CHNL.KEYY) CHLTYPE(SVRCONN) SSLCIPH(TLS_RSA_WITH_AES_128_CBC_SHA256)