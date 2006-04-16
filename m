From: =?ISO-8859-1?Q?Roger_H=E5kansson?= <roger.hakansson@algitech.com>
Subject: Re: Problems with multipathing
Date: Mon, 17 Apr 2006 00:44:12 +0200
Message-ID: <4442C8BC.1060108@algitech.com>
References: <443BF12E.50900@ludd.luth.se>	<443BF87A.10804@free.fr>	<443C19E6.8000607@ludd.luth.se>	<443E870E.1070902@ludd.luth.se>
	<443EB907.1070600@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1045955514=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <443EB907.1070600@free.fr>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a cryptographically signed message in MIME format.

--===============1045955514==
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=sha1; boundary="------------ms060802090509010705080106"

This is a cryptographically signed message in MIME format.

--------------ms060802090509010705080106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Christophe Varoqui wrote:
> I don't know your hardware (vendor =3D IFT, product =3D A16F-R2221)=20

http://www.infortrend.com/main/2_product/a16f-r2221.asp

> but it seems assymmetrical.

I guess that you with "asymmetrical" means that paths are only presented
on one controller at a time, more on that later.

> Most hardware in this familly need a hardware
> handler, and some need the "queue_if_no_path" feature set too.
>
> You'll have to find how your array works and try to figure if some
> existing hardware handler does the good thing.

I've done some testing and it seems that multibus works fine, but when a
controller fails and the secondary controller takes over, the
scsi-devices are seen as "dead" and if I, before multipath determines
both paths to be permanently faulty, do a "echo 1 >
/sys/class/scsi_device/1:0:0:0/device/rescan", multipath will not fail
the device.

So the question is if this is something a hardware_handler could do, and
if so, how hard is it to write such a handler?

> As a last resort, post the maximum techical details about what  your
> hardware needs to activate backup paths, and hope that some good soul i=
s
> willing to code the handler.

Ok, I'll give you as much info as I can (if its of any use is another
thing...).

The "box" has two controllers, which Infortrend calls active-active,
which in this case means that one can create logical drives (and
optionally logical volumes) which are assigned to one of the
controllers, but a logical drive can only be active on one controller at
a time.
The "box" also has two "channels" which are connected to both
controllers, each controller can be assigned multiple "host controller
IDs" on each channel.
"Host controller ID-index" (lowest "host controller id" on primary
controller will have 0, next 1.. to N, lowest on secondary will have N+1
and so on) together with some static pieces (MAC-address) form the WWNN,
beginning with 20.
All targets on "channel 0" will have WWPN beginning with 21 and the rest
identical to the WWNN, targets on "channel 1" begin with 22.

When a controller fails, the other one takes over all logical drives,
LUNs, WWNN and WWPN.

Another thing which I don't know if its important or not, but the "box"
have four fysical SFP-ports which can be configured in two ways, either
in "hubbed mode" where two are "hubbed" together on one "channel" on
both controllers and the other two on the other channel, or "non-hubbed
mode" where each port are staticly bound to a specific "channel" on a
specific controller.
As far as I've been able to tell, there is no difference in behaviour
between hubbed/non-hubbed mode
--=20
Roger H=E5kansson , Senior Consultant
Algitech Consulting AB
S=F6dra Kungsgatan 5 (Office)
Box 28, S-971 02 Lule=E5 , Sweden
Tel:    +46 (0)920 88313    Mobile: +46 (0)705 549533
Fax:    +1 (0)928 222 7116  E-mail: roger.hakansson@algitech.com


--------------ms060802090509010705080106
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJUzCC
AwQwggJtoAMCAQICAw8QYjANBgkqhkiG9w0BAQQFADBiMQswCQYDVQQGEwJaQTElMCMGA1UE
ChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNv
bmFsIEZyZWVtYWlsIElzc3VpbmcgQ0EwHhcNMDUwNzAyMTEwNDQxWhcNMDYwNzAyMTEwNDQx
WjBtMRMwEQYDVQQEDApIw6VrYW5zc29uMQ4wDAYDVQQqEwVSb2dlcjEZMBcGA1UEAwwQUm9n
ZXIgSMOla2Fuc3NvbjErMCkGCSqGSIb3DQEJARYccm9nZXIuaGFrYW5zc29uQGFsZ2l0ZWNo
LmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALdIaVHD01XBhq9YsxTSSllR
7pitdVxuwq6vfu/hqsVW0C59qymNVD0x+yUUKKtSie8ogGqBnbTSROMuGLHJ856K/v14PYHh
JUBvz9qNynpyF955NEILT3a+fx9kgxlf0BSaqEhihG3dPZMJabVz8OyJMbmWdh6/e8Ia6agK
DytFhfQNbxFyz3TxgcztGZORF/KxDf+wiwwLrlMBNyInQ+bUzMeWI7Ah3Wd2Ajf/yvYZo8ts
dr4b0yqs/9VSWmQQ6hQ/5RKc6RkgArN5rLU/NCSxQAl0dHAbNmEW5GeeEfI5cqVa9cbcHRRl
ADq+ornSEh8YVT2A4GrrmUvrIEWuAUsCAwEAAaM5MDcwJwYDVR0RBCAwHoEccm9nZXIuaGFr
YW5zc29uQGFsZ2l0ZWNoLmNvbTAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBAUAA4GBAHWY
QsnOWpg9cgrHhsW915Fy4oFKW1OFJbLSESaX2vbAxeZUhA1sOS4ag0De/6x9EpF3wkGlP7lc
j2D1k96elS12HFYYweXH+H+Th0fU2YvpJCBTLh9L5KbHJvamVWEjeuEtNScdh7WMCI8FlX/7
EoIvV6G59PoOcj8jTHgSLscdMIIDBDCCAm2gAwIBAgIDDxBiMA0GCSqGSIb3DQEBBAUAMGIx
CzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSww
KgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQTAeFw0wNTA3MDIx
MTA0NDFaFw0wNjA3MDIxMTA0NDFaMG0xEzARBgNVBAQMCkjDpWthbnNzb24xDjAMBgNVBCoT
BVJvZ2VyMRkwFwYDVQQDDBBSb2dlciBIw6VrYW5zc29uMSswKQYJKoZIhvcNAQkBFhxyb2dl
ci5oYWthbnNzb25AYWxnaXRlY2guY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAt0hpUcPTVcGGr1izFNJKWVHumK11XG7Crq9+7+GqxVbQLn2rKY1UPTH7JRQoq1KJ7yiA
aoGdtNJE4y4Yscnznor+/Xg9geElQG/P2o3KenIX3nk0QgtPdr5/H2SDGV/QFJqoSGKEbd09
kwlptXPw7IkxuZZ2Hr97whrpqAoPK0WF9A1vEXLPdPGBzO0Zk5EX8rEN/7CLDAuuUwE3IidD
5tTMx5YjsCHdZ3YCN//K9hmjy2x2vhvTKqz/1VJaZBDqFD/lEpzpGSACs3mstT80JLFACXR0
cBs2YRbkZ54R8jlypVr1xtwdFGUAOr6iudISHxhVPYDgauuZS+sgRa4BSwIDAQABozkwNzAn
BgNVHREEIDAegRxyb2dlci5oYWthbnNzb25AYWxnaXRlY2guY29tMAwGA1UdEwEB/wQCMAAw
DQYJKoZIhvcNAQEEBQADgYEAdZhCyc5amD1yCseGxb3XkXLigUpbU4UlstIRJpfa9sDF5lSE
DWw5LhqDQN7/rH0SkXfCQaU/uVyPYPWT3p6VLXYcVhjB5cf4f5OHR9TZi+kkIFMuH0vkpscm
9qZVYSN64S01Jx2HtYwIjwWVf/sSgi9Xobn0+g5yPyNMeBIuxx0wggM/MIICqKADAgECAgEN
MA0GCSqGSIb3DQEBBQUAMIHRMQswCQYDVQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBDYXBl
MRIwEAYDVQQHEwlDYXBlIFRvd24xGjAYBgNVBAoTEVRoYXd0ZSBDb25zdWx0aW5nMSgwJgYD
VQQLEx9DZXJ0aWZpY2F0aW9uIFNlcnZpY2VzIERpdmlzaW9uMSQwIgYDVQQDExtUaGF3dGUg
UGVyc29uYWwgRnJlZW1haWwgQ0ExKzApBgkqhkiG9w0BCQEWHHBlcnNvbmFsLWZyZWVtYWls
QHRoYXd0ZS5jb20wHhcNMDMwNzE3MDAwMDAwWhcNMTMwNzE2MjM1OTU5WjBiMQswCQYDVQQG
EwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMj
VGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0EwgZ8wDQYJKoZIhvcNAQEBBQAD
gY0AMIGJAoGBAMSmPFVzVftOucqZWh5owHUEcJ3f6f+jHuy9zfVb8hp2vX8MOmHyv1HOAdTl
UAow1wJjWiyJFXCO3cnwK4Vaqj9xVsuvPAsH5/EfkTYkKhPPK9Xzgnc9A74r/rsYPge/QIAC
ZNenprufZdHFKlSFD0gEf6e20TxhBEAeZBlyYLf7AgMBAAGjgZQwgZEwEgYDVR0TAQH/BAgw
BgEB/wIBADBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsLnRoYXd0ZS5jb20vVGhhd3Rl
UGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNVHQ8EBAMCAQYwKQYDVR0RBCIwIKQeMBwxGjAY
BgNVBAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqGSIb3DQEBBQUAA4GBAEiM0VCD6gsuzA2j
ZqxnD3+vrL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCTcDz9reFhYsPZOhl+hLGZGwDFGguC
dJ4lUJRix9sncVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo05RAaWzVNd+NWIXiC3CEZNd4k
sdMdRv9dX2VPMYIDOzCCAzcCAQEwaTBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3Rl
IENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVt
YWlsIElzc3VpbmcgQ0ECAw8QYjAJBgUrDgMCGgUAoIIBpzAYBgkqhkiG9w0BCQMxCwYJKoZI
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wNjA0MTYyMjQ0MTJaMCMGCSqGSIb3DQEJBDEWBBQ9
CC/U4XXjz0u3UMX6DUnu0C1YUjBSBgkqhkiG9w0BCQ8xRTBDMAoGCCqGSIb3DQMHMA4GCCqG
SIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDB4Bgkr
BgEEAYI3EAQxazBpMGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGlu
ZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWlu
ZyBDQQIDDxBiMHoGCyqGSIb3DQEJEAILMWugaTBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMc
VGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFs
IEZyZWVtYWlsIElzc3VpbmcgQ0ECAw8QYjANBgkqhkiG9w0BAQEFAASCAQCMC+8f6Q/WTGt0
E0RNk/MWbybxZ93DXCpXEkNNqjMgt7f6J+vF92cgMt8q0BWygI5M80rUmfrdNd7U6ekOWZpb
zqwWAz7cIOG2HmTwWJI/Hl4orAnAnGizy/554U3HdL/uF/wUZHoDc87JtMuIQuRXFs2c9w1J
mWN4JpvjxqTm5kCglNMOL92h+dqwL8YI5ohFxixt0tr8UYbL5BjjZah1XXRc8whSEY3ZyTE4
3pcdgh0V4d3IOlXUta+aQwqECSVcLtGZLcVTOcWejwFuE/ZN7isvCDC3PWDdRONYhJSfALOD
EpEAiVu+Tu1Rc86hxmWSagx6RzKMT0eTBSAt74HsAAAAAAAA
--------------ms060802090509010705080106--


--===============1045955514==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1045955514==--
