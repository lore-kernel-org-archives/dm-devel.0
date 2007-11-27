From: Pedro Bandim Faustino <pedro.faustino@fccn.pt>
Subject: Re: user defined device name and table - SOLVED
Date: Tue, 27 Nov 2007 10:00:04 +0000
Message-ID: <474BEAA4.9010702@fccn.pt>
References: <474ADDCF.8030703@fccn.pt> <20071126194624.GA23541@us.ibm.com>
Reply-To: pedro.faustino@fccn.pt,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0599890322=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071126194624.GA23541@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: malahal@us.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a cryptographically signed message in MIME format.

--===============0599890322==
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=sha1; boundary="------------ms040605060506030000090901"

This is a cryptographically signed message in MIME format.

--------------ms040605060506030000090901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

malahal@us.ibm.com wrote:
> Pedro Bandim Faustino [pedro.faustino@fccn.pt] wrote:
>   
>> Hi All,
>>
>> I have a working multipath on root, but some questions still unanswered.
>> I'm hoping you can help me out ;)
>>
>> But this is what I really would like to have:
>>
>> Output of multipath -ll:
>> SRV07_BOOT (3600a0b8000295d64000009304742b4c8) dm-0 IBM,1814      FAStT
>> [size=4.0G][features=1 queue_if_no_path][hwhandler=0]
>> \_ round-robin 0 [prio=0][enabled]
>> \_ 2:0:0:0 sda 8:0   [active][ready]
>> \_ 3:0:0:0 sdc 8:32  [active][ready]
>> \_ round-robin 0 [prio=6][active]
>> \_ 2:0:1:0 sdb 8:16  [active][ready]
>> \_ 3:0:1:0 sdd 8:48  [active][ready]
>>
>>
>> I can modify the table by modifying the init script in the initrd image and 
>> then booting with the modified initrd image but I don't know how to change 
>> the name from mpath0 to SRV07_BOOT.
>>     
>
> I don't know how Fedora Core 7 handles this in the initrd. Old RHEL
> systems (prior to RHEL5.1) have nash commands to construct hard coded
> multipath devices. You probably supply the name as part those commands.
> If Fedora Core 7 uses something similar to RHEL5.2, then you could
> probably use aliases in the multipath.conf file and rebuild initrd???
>   
Fedora does use nash commands in its mkinitrd script. From what I 
understood Fedora 7 mkinitrd doesn't fetch multipath settings from the 
conf file, instead it checks the current, in use, settings.

So, what I've done was change the table (at boot time, modifying the 
init script of the initrd image) and rebooted with this new image.
Then, I've changed the friendly name (using dmsetup rename command), 
issued a mkinitrd and rebooted with this new image.
(You can do the above by modifying the init script just once)

So I finally got the what I wanted and also the desired names at 
/dev/mapper and /dev/mpath.
What I'm going to do now is configure the multipathd and multipath.conf 
to finish my setup.

Cheers and thanks for your help,
Pedro Bandim Faustino

--------------ms040605060506030000090901
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIIgzCC
ApwwggIFoAMCAQICEHdhA6xMoKDlvViilbLaSmYwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MDMwODE3MDMzN1oX
DTA4MDMwNzE3MDMzN1owgYExGDAWBgNVBAQTD0JhbmRpbSBGYXVzdGlubzEWMBQGA1UEKhMN
UGVkcm8gRW1hbnVlbDEmMCQGA1UEAxMdUGVkcm8gRW1hbnVlbCBCYW5kaW0gRmF1c3Rpbm8x
JTAjBgkqhkiG9w0BCQEWFnBlZHJvLmZhdXN0aW5vQGZjY24ucHQwgZ8wDQYJKoZIhvcNAQEB
BQADgY0AMIGJAoGBALs9bU3kCFFNuwq4D31is437qoll+zTat9251PNiVr9tvgJVUcCXVXWh
RA6Vtg9ZM3h6ojtSAWKKmBHwPI5tpbDSGiTxk/jZDmR3YnpGIJV/6ajVLqwOcPGAdtbC/KzU
8QKxvM3e5ned845LALXxhF15HhJMq2qremQvx2czCfNNAgMBAAGjMzAxMCEGA1UdEQQaMBiB
FnBlZHJvLmZhdXN0aW5vQGZjY24ucHQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQUFAAOB
gQBSo8NmLL0DB6y/hfUP1gPE4NVlcEFanJNP5BMHbxdnhpoQ5DSKIfXxtivbt4VROgcpWAmO
S8BVI0P7TDKoZV37lptD1A5QTsaR24f4zj/h57MvDx5RowUMcTv+WLWTB4hQ6vEXQnAj25ka
lx1aRWclOBP6t5UmuLlmwhOEEwrvxTCCApwwggIFoAMCAQICEHdhA6xMoKDlvViilbLaSmYw
DQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0
aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1
aW5nIENBMB4XDTA3MDMwODE3MDMzN1oXDTA4MDMwNzE3MDMzN1owgYExGDAWBgNVBAQTD0Jh
bmRpbSBGYXVzdGlubzEWMBQGA1UEKhMNUGVkcm8gRW1hbnVlbDEmMCQGA1UEAxMdUGVkcm8g
RW1hbnVlbCBCYW5kaW0gRmF1c3Rpbm8xJTAjBgkqhkiG9w0BCQEWFnBlZHJvLmZhdXN0aW5v
QGZjY24ucHQwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBALs9bU3kCFFNuwq4D31is437
qoll+zTat9251PNiVr9tvgJVUcCXVXWhRA6Vtg9ZM3h6ojtSAWKKmBHwPI5tpbDSGiTxk/jZ
DmR3YnpGIJV/6ajVLqwOcPGAdtbC/KzU8QKxvM3e5ned845LALXxhF15HhJMq2qremQvx2cz
CfNNAgMBAAGjMzAxMCEGA1UdEQQaMBiBFnBlZHJvLmZhdXN0aW5vQGZjY24ucHQwDAYDVR0T
AQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQBSo8NmLL0DB6y/hfUP1gPE4NVlcEFanJNP5BMH
bxdnhpoQ5DSKIfXxtivbt4VROgcpWAmOS8BVI0P7TDKoZV37lptD1A5QTsaR24f4zj/h57Mv
Dx5RowUMcTv+WLWTB4hQ6vEXQnAj25kalx1aRWclOBP6t5UmuLlmwhOEEwrvxTCCAz8wggKo
oAMCAQICAQ0wDQYJKoZIhvcNAQEFBQAwgdExCzAJBgNVBAYTAlpBMRUwEwYDVQQIEwxXZXN0
ZXJuIENhcGUxEjAQBgNVBAcTCUNhcGUgVG93bjEaMBgGA1UEChMRVGhhd3RlIENvbnN1bHRp
bmcxKDAmBgNVBAsTH0NlcnRpZmljYXRpb24gU2VydmljZXMgRGl2aXNpb24xJDAiBgNVBAMT
G1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBDQTErMCkGCSqGSIb3DQEJARYccGVyc29uYWwt
ZnJlZW1haWxAdGhhd3RlLmNvbTAeFw0wMzA3MTcwMDAwMDBaFw0xMzA3MTYyMzU5NTlaMGIx
CzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSww
KgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQTCBnzANBgkqhkiG
9w0BAQEFAAOBjQAwgYkCgYEAxKY8VXNV+065yplaHmjAdQRwnd/p/6Me7L3N9VvyGna9fww6
YfK/Uc4B1OVQCjDXAmNaLIkVcI7dyfArhVqqP3FWy688Cwfn8R+RNiQqE88r1fOCdz0Dviv+
uxg+B79AgAJk16emu59l0cUqVIUPSAR/p7bRPGEEQB5kGXJgt/sCAwEAAaOBlDCBkTASBgNV
HRMBAf8ECDAGAQH/AgEAMEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwudGhhd3RlLmNv
bS9UaGF3dGVQZXJzb25hbEZyZWVtYWlsQ0EuY3JsMAsGA1UdDwQEAwIBBjApBgNVHREEIjAg
pB4wHDEaMBgGA1UEAxMRUHJpdmF0ZUxhYmVsMi0xMzgwDQYJKoZIhvcNAQEFBQADgYEASIzR
UIPqCy7MDaNmrGcPf6+svsIXoUOWlJ1/TCG4+DYfqi2fNi/A9BxQIJNwPP2t4WFiw9k6GX6E
sZkbAMUaC4J0niVQlGLH2ydxVyWN3amcOY6MIE9lX5Xa9/eH1sYITq726jTlEBpbNU1341Yh
eILcIRk13iSx0x1G/11fZU8xggLjMIIC3wIBATB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQK
ExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29u
YWwgRnJlZW1haWwgSXNzdWluZyBDQQIQd2EDrEygoOW9WKKVstpKZjAJBgUrDgMCGgUAoIIB
wzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wNzExMjcxMDAw
MDRaMCMGCSqGSIb3DQEJBDEWBBToDdC8QixZGv/69yjXcaOsStzPZTBSBgkqhkiG9w0BCQ8x
RTBDMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMC
BzANBggqhkiG9w0DAgIBKDCBhQYJKwYBBAGCNxAEMXgwdjBiMQswCQYDVQQGEwJaQTElMCMG
A1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBl
cnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEHdhA6xMoKDlvViilbLaSmYwgYcGCyqGSIb3
DQEJEAILMXigdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcg
KFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3Vpbmcg
Q0ECEHdhA6xMoKDlvViilbLaSmYwDQYJKoZIhvcNAQEBBQAEgYAZPZ2TPyReAnWZpi1iiyH8
KGlMmyjbvTzA1myq5CbpzLLM4yKoDjPqe68hLbKETOf5N5gDA0nl/PXzmKM4BjGL/9TIZ/sw
pawxrC1lhJEToG8Vcxjk1igWmFvX7rzvTBwAWDwUKWkEniui/n15kNg39XF9ZOa+jtTcyMgw
TaJesQAAAAAAAA==
--------------ms040605060506030000090901--


--===============0599890322==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0599890322==--
