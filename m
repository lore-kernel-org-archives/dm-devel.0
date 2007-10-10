From: Sandrine Twardy <twardy@univ-tln.fr>
Subject: Multipath on boot and root partition with Redhat5.0
Date: Wed, 10 Oct 2007 12:58:41 +0200
Message-ID: <470CB061.5000902@univ-tln.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1494400364=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a cryptographically signed message in MIME format.

--===============1494400364==
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=sha1; boundary="------------ms060704040401030304070508"

This is a cryptographically signed message in MIME format.

--------------ms060704040401030304070508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I have a SAN Eva 5000 HP And I have installed a redhat 5.0 on my server 
with "linux mpath", so far all is fine.
I have an os device multipathed as follow :

 > multipath -ll
mpath0 () dm-0 COMPAQ,HSV110 (C)COMPAQ
[size=7.0G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
\_ 3:0:0:1 sdb 8:16  [active][ready]
\_ 4:0:0:1 sdc 8:32  [active][ready]

But when I presents a new lun to my host and scans again the scsi lun, I 
am losing the multipath on the disk (/ and /boot)
(possibly because the name of device is changed from sdb/sdc to sdc/sde ? )

Here's an extract of my multipath.conf:

multipath {
              wwid                    3600508b40000c1c50001c000000b0000
              path_grouping_policy    group_by_serial
              rr_weight               uniform
              prio_callout            /bin/true
              alias                   os_lun
      }
     But it's seems that on boot the mutlipath.conf file is not read.  
Am I right?
When the system is booted, multipathd cannot use the boot device ...
What can I do to fix the boot device name persistence? Where is supposed 
to be configuration file that defines the multipath options of the boot 
device ?

Right now, the server can boot because my fstab is like this:
LABEL=/1                /                      LABEL=/boot             
/boot

Thanks you for your help

--------------ms060704040401030304070508
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIOQzCC
A9swggLDoAMCAQICAQIwDQYJKoZIhvcNAQEEBQAwTzELMAkGA1UEBhMCRlIxDDAKBgNVBAoT
A0NSVTESMBAGA1UEAxMJYWMtcmFjaW5lMR4wHAYJKoZIhvcNAQkBFg9jYS1hZG1pbkBjcnUu
ZnIwHhcNMDMwNTE2MDkzMTE3WhcNMTIxMjE0MDkzMTE3WjBUMQswCQYDVQQGEwJGUjEMMAoG
A1UEChMDQ1JVMRcwFQYDVQQDEw5hYy11dGlsaXNhdGV1cjEeMBwGCSqGSIb3DQEJARYPY2Et
YWRtaW5AY3J1LmZyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtXGYMirQ2feu
6b4FDrH8PRwIyjfXPSXaG33GoatYJIbOmxAwnGbwVBng3WDzoW5X45RWq93nOxSdx4MTsGQJ
pBihob2h4XeGpL54WlLd+kvOxvp/0OzLYYcESI3dpVRjf6jB8Ggc7BUlE+ptIjyXAVTNKz1o
6aiLSR6G1zG5cidq3BAXjlpfvbX9EWfICcnmLMSQ29oam857EsAJRuGHNajdPEMUlsioEIf2
Zf4YL9pa5rJ5Efs7NTxu8ffICGYlCynJXJTC461sRrub8s6SOM69NTw8EM+1A3ewd5WyGkZe
QSG7SJyJY8Lg8u4CMoflOjP3LSYhCLI1Ic0gX08dkQIDAQABo4G8MIG5MA8GA1UdEwEB/wQF
MAMBAf8wHQYDVR0OBBYEFBUKfCi1rKa81/0yMx15vbNJCjGQMHcGA1UdIwRwMG6AFK8vz0qV
BLbeJLMJqVU+XA4c+HEuoVOkUTBPMQswCQYDVQQGEwJGUjEMMAoGA1UEChMDQ1JVMRIwEAYD
VQQDEwlhYy1yYWNpbmUxHjAcBgkqhkiG9w0BCQEWD2NhLWFkbWluQGNydS5mcoIBADAOBgNV
HQ8BAf8EBAMCAQYwDQYJKoZIhvcNAQEEBQADggEBAMG/+LofN2vISFWieXrHsFsIrM/2WUhf
zAcE2/Ga+/UWvJaDJO9RlbUNN3l+f40L1yUJW9kZqY4XMBcbJ6jbpmeJ+zTf+zveAD/sl9ZN
qoC931HFLq/TGjZSIQxX4Nxad9DFbok66X1qfRZF4+beaz2zjrF07LvjWX6201Rc6zQhNyTy
UdO/wYY0EBYu0CFrTK4RxS6d2LsyO1p1Xj7oMCa9Utmu/igZoXJYL709POBKHJoYNU+LI6iJ
8aYcZupJ/GXVxfj68L1KP2i8cM3a570bJCDbsKcchzZqsvII5cewU7KKPH4fyMyfsA39tJ0V
BMQyvdWZHpS75DN0eB5UVzUwggUuMIIEFqADAgECAgIKQDANBgkqhkiG9w0BAQQFADBUMQsw
CQYDVQQGEwJGUjEMMAoGA1UEChMDQ1JVMRcwFQYDVQQDEw5hYy11dGlsaXNhdGV1cjEeMBwG
CSqGSIb3DQEJARYPY2EtYWRtaW5AY3J1LmZyMB4XDTA3MDEwODA5Mjk0MloXDTA4MDEwODA5
Mjk0MlowXTELMAkGA1UEBhMCRlIxETAPBgNVBAoTCDA4MzA3NjZHMRgwFgYDVQQDEw9TYW5k
cmluZSBUd2FyZHkxITAfBgkqhkiG9w0BCQEWEnR3YXJkeUB1bml2LXRsbi5mcjCCASIwDQYJ
KoZIhvcNAQEBBQADggEPADCCAQoCggEBAKYqhhIMqyeBKq+WIXHNpC3Wj7SyTFYccOhe4+Nr
qp+kLtm0Mhhz1C4FAKD+/qwWziGxoqD/GEcW0pEWbOBtODhbpB9//ZmaYeSOAK8C3YkmocCq
bcfW4DpI/Q5Pg70TYZR6lUSDqfhgPklaqWGyhUxVUtBa6QD9Nv+6V5QtaNeUJdYHRJnZILnJ
cHdLC4gQ9CvOtzmMRPg2sHcN3VxxNYllowGO9H45mZlwHhR6VzdHuDf//CwNmRj4iN7leA54
u26CUHBjfDkRUih8lKTOKZHu49RgmTPZHf0Ed/lLNJ24sSWXkX/9n5tUBVqh32gg9oNl++/F
7L8Wtpz0WjRfxCsCAwEAAaOCAf8wggH7MAwGA1UdEwEB/wQCMAAwEQYJYIZIAYb4QgEBBAQD
AgSwMA4GA1UdDwEB/wQEAwIF4DAdBgNVHREEFjAUgRJ0d2FyZHlAdW5pdi10bG4uZnIwcAYJ
YIZIAYb4QgENBGMWYUNlcnRpZmljYXQgYWMtdXRpbGlzYXRldXIuIFBvdXIgdG91dGUgaW5m
b3JtYXRpb24gc2UgcmVwb3J0ZXIg4CBodHRwOi8vaWdjLmNydS5mci9hYy11dGlsaXNhdGV1
ci8wHQYDVR0OBBYEFMbnT0HJ90KMqv0b9i/izEv3KpmwMHcGA1UdIwRwMG6AFBUKfCi1rKa8
1/0yMx15vbNJCjGQoVOkUTBPMQswCQYDVQQGEwJGUjEMMAoGA1UEChMDQ1JVMRIwEAYDVQQD
EwlhYy1yYWNpbmUxHjAcBgkqhkiG9w0BCQEWD2NhLWFkbWluQGNydS5mcoIBAjBPBgNVHR8E
SDBGMESgQqBAhj5odHRwOi8vaWdjLmNydS5mci9jZ2ktYmluL2xvYWRjcmw/Q0E9YWMtdXRp
bGlzYXRldXImZm9ybWF0PURFUjBOBgNVHSAERzBFMEMGDikDBgEEAAG3XwMBAgAEMDEwLwYI
KwYBBQUHAgEWI2h0dHA6Ly9pZ2MuY3J1LmZyL3JlZmVyZW5jZXMvcGMucGRmMA0GCSqGSIb3
DQEBBAUAA4IBAQBPIY34p+RuG1fU6htoB4Q7KqTSKDq0ujKqSYgwNVAYMO8FYMr3XXQNUPtQ
STnBt+YyzhM/ACrsvDUPLCm9zxa6/ZBeHXR94WhTCnbk0D5EEfiytyzjeBL18GVGT4to0oid
877KDJ+6JsqZUdsP9ThyBUNucqZ2B8/VLo3iX7qoIMacASNq14A1RnX1ct11qyqKqH1nkGbk
daW6l/M7XWmmFa4YVJeznupH7FoluxwMtLz1cOm9FQbJj+55C3v6My0UpKotvpXQxAprfsYO
HcacAaINP3p3df3cWsx6d98VaQLklBxOHHmfox6JT4b6qKpGc8awZwcJnIIuTyGaHQp0MIIF
LjCCBBagAwIBAgICCkAwDQYJKoZIhvcNAQEEBQAwVDELMAkGA1UEBhMCRlIxDDAKBgNVBAoT
A0NSVTEXMBUGA1UEAxMOYWMtdXRpbGlzYXRldXIxHjAcBgkqhkiG9w0BCQEWD2NhLWFkbWlu
QGNydS5mcjAeFw0wNzAxMDgwOTI5NDJaFw0wODAxMDgwOTI5NDJaMF0xCzAJBgNVBAYTAkZS
MREwDwYDVQQKEwgwODMwNzY2RzEYMBYGA1UEAxMPU2FuZHJpbmUgVHdhcmR5MSEwHwYJKoZI
hvcNAQkBFhJ0d2FyZHlAdW5pdi10bG4uZnIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
AoIBAQCmKoYSDKsngSqvliFxzaQt1o+0skxWHHDoXuPja6qfpC7ZtDIYc9QuBQCg/v6sFs4h
saKg/xhHFtKRFmzgbTg4W6Qff/2ZmmHkjgCvAt2JJqHAqm3H1uA6SP0OT4O9E2GUepVEg6n4
YD5JWqlhsoVMVVLQWukA/Tb/uleULWjXlCXWB0SZ2SC5yXB3SwuIEPQrzrc5jET4NrB3Dd1c
cTWJZaMBjvR+OZmZcB4Uelc3R7g3//wsDZkY+Ije5XgOeLtuglBwY3w5EVIofJSkzimR7uPU
YJkz2R39BHf5SzSduLEll5F//Z+bVAVaod9oIPaDZfvvxey/Frac9Fo0X8QrAgMBAAGjggH/
MIIB+zAMBgNVHRMBAf8EAjAAMBEGCWCGSAGG+EIBAQQEAwIEsDAOBgNVHQ8BAf8EBAMCBeAw
HQYDVR0RBBYwFIESdHdhcmR5QHVuaXYtdGxuLmZyMHAGCWCGSAGG+EIBDQRjFmFDZXJ0aWZp
Y2F0IGFjLXV0aWxpc2F0ZXVyLiBQb3VyIHRvdXRlIGluZm9ybWF0aW9uIHNlIHJlcG9ydGVy
IOAgaHR0cDovL2lnYy5jcnUuZnIvYWMtdXRpbGlzYXRldXIvMB0GA1UdDgQWBBTG509ByfdC
jKr9G/Yv4sxL9yqZsDB3BgNVHSMEcDBugBQVCnwotaymvNf9MjMdeb2zSQoxkKFTpFEwTzEL
MAkGA1UEBhMCRlIxDDAKBgNVBAoTA0NSVTESMBAGA1UEAxMJYWMtcmFjaW5lMR4wHAYJKoZI
hvcNAQkBFg9jYS1hZG1pbkBjcnUuZnKCAQIwTwYDVR0fBEgwRjBEoEKgQIY+aHR0cDovL2ln
Yy5jcnUuZnIvY2dpLWJpbi9sb2FkY3JsP0NBPWFjLXV0aWxpc2F0ZXVyJmZvcm1hdD1ERVIw
TgYDVR0gBEcwRTBDBg4pAwYBBAABt18DAQIABDAxMC8GCCsGAQUFBwIBFiNodHRwOi8vaWdj
LmNydS5mci9yZWZlcmVuY2VzL3BjLnBkZjANBgkqhkiG9w0BAQQFAAOCAQEATyGN+KfkbhtX
1OobaAeEOyqk0ig6tLoyqkmIMDVQGDDvBWDK9110DVD7UEk5wbfmMs4TPwAq7Lw1Dywpvc8W
uv2QXh10feFoUwp25NA+RBH4srcs43gS9fBlRk+LaNKInfO+ygyfuibKmVHbD/U4cgVDbnKm
dgfP1S6N4l+6qCDGnAEjateANUZ19XLddasqiqh9Z5Bm5HWlupfzO11pphWuGFSXs57qR+xa
JbscDLS89XDpvRUGyY/ueQt7+jMtFKSqLb6V0MQKa37GDh3GnAGiDT96d3X93FrMenffFWkC
5JQcThx5n6MeiU+G+qiqRnPGsGcHCZyCLk8hmh0KdDGCAw4wggMKAgEBMFowVDELMAkGA1UE
BhMCRlIxDDAKBgNVBAoTA0NSVTEXMBUGA1UEAxMOYWMtdXRpbGlzYXRldXIxHjAcBgkqhkiG
9w0BCQEWD2NhLWFkbWluQGNydS5mcgICCkAwCQYFKw4DAhoFAKCCAYkwGAYJKoZIhvcNAQkD
MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDcxMDEwMTA1ODQxWjAjBgkqhkiG9w0B
CQQxFgQUyN9KlS5WUK3hJSRmcp/pBGUKLFYwUgYJKoZIhvcNAQkPMUUwQzAKBggqhkiG9w0D
BzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwIC
ASgwaQYJKwYBBAGCNxAEMVwwWjBUMQswCQYDVQQGEwJGUjEMMAoGA1UEChMDQ1JVMRcwFQYD
VQQDEw5hYy11dGlsaXNhdGV1cjEeMBwGCSqGSIb3DQEJARYPY2EtYWRtaW5AY3J1LmZyAgIK
QDBrBgsqhkiG9w0BCRACCzFcoFowVDELMAkGA1UEBhMCRlIxDDAKBgNVBAoTA0NSVTEXMBUG
A1UEAxMOYWMtdXRpbGlzYXRldXIxHjAcBgkqhkiG9w0BCQEWD2NhLWFkbWluQGNydS5mcgIC
CkAwDQYJKoZIhvcNAQEBBQAEggEAcB+tDuUGb65/abK3TPAZVxUcgnSCIAnVST152RQxJOis
Z62UXK9DxexMLLAgIrg8XT3EzdM3xTOhYEIonQCr3LbiQakSkwWKRyC6LX+X4obZIczf9noZ
s/vmxbNEQsdoUttFMNJQoZhFf7Y98zht44dHkTx32tLd8Y9at7jPa/J1T02eq+CRuGMgerQb
uUUBGEtgox6We3wkZsMdl3moIepRHTyeIR07ENvqXOZqVdRO7/ZNaYnxhpK9SsUUp9Q6Whnu
miNXTResqarrnqjoSIbnU1hzK9BlxKVBSShLr7HtNMORUTd6ep77gUMH35yvEpIDFV6v8zE8
W0x7+IdSgwAAAAAAAA==
--------------ms060704040401030304070508--


--===============1494400364==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1494400364==--
