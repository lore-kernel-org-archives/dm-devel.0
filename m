From: Krzysztof Kolasa <kkolasa@winsoft.pl>
Subject: Re: commit 298a9fa dm crypt: use per-bio data hard crash
 kernel ( the system freezes )
Date: Mon, 18 Aug 2014 19:33:35 +0200
Message-ID: <53F238EF.10409@winsoft.pl>
References: <53F0F7C7.2010501@winsoft.pl>
	<20140818151526.GA16744@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5533099365558656843=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140818151526.GA16744@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

This is a cryptographically signed message in MIME format.

--===============5533099365558656843==
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha1; boundary="------------ms050904020000080307060105"

This is a cryptographically signed message in MIME format.

--------------ms050904020000080307060105
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: quoted-printable

On 18.08.2014 17:15, Alasdair G Kergon wrote:
> On Sun, Aug 17, 2014 at 08:43:19PM +0200, Krzysztof Kolasa wrote:
>> Enter - create oops on console, system freezes
> Can you supply the boot log including the oops details?
> (Upload a photo and send a link to it if you can't get it as text.)
>
> Alasdair
>
>
screen very quickly running out and there is only insignificant side of=20
oops...

bisect log :

# bad: [7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9] Linux 3.17-rc1
# good: [19583ca584d6f574384e17fe7613dfaeadcdc4a6] Linux 3.16
git bisect start 'v3.17-rc1' 'v3.16'
# good: [ae045e2455429c418a418a3376301a9e5753a0a8] Merge=20
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect good ae045e2455429c418a418a3376301a9e5753a0a8
# good: [44c916d58b9ef1f2c4aec2def57fa8289c716a60] Merge tag=20
'cleanup-for-3.17' of=20
git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good 44c916d58b9ef1f2c4aec2def57fa8289c716a60
# good: [023f78b02c729070116fa3a7ebd4107a032d3f5c] Merge branch=20
'for-next' of git://git.samba.org/sfrench/cifs-2.6
git bisect good 023f78b02c729070116fa3a7ebd4107a032d3f5c
# good: [d27c0d90184a13e9e9f28c38e84f889a259f6b5f] Merge branch=20
'x86-efi-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/=
tip
git bisect good d27c0d90184a13e9e9f28c38e84f889a259f6b5f
# bad: [ae36e95cf81c98b111b84317adeb358aaffa80e2] Merge tag=20
'devicetree-for-linus' of git://git.secretlab.ca/git/linux
git bisect bad ae36e95cf81c98b111b84317adeb358aaffa80e2
# good: [4a319a490ca59a746b3d36768c0e29ee19832366] Merge branch=20
'for-3.17/core' of git://git.kernel.dk/linux-block
git bisect good 4a319a490ca59a746b3d36768c0e29ee19832366
# good: [d429a3639ca967ce2f35e3e8d4e70caec7149ded] Merge branch=20
'for-3.17/drivers' of git://git.kernel.dk/linux-block
git bisect good d429a3639ca967ce2f35e3e8d4e70caec7149ded
# good: [e36152aa84cf68bd7f09acffd480cd2b6aa5480d] mmc: sh_mmcif:=20
Configure DMA slave bus width
git bisect good e36152aa84cf68bd7f09acffd480cd2b6aa5480d
# bad: [4dacb91c7d1ab30aa9aac0d55216fc177d454254] Merge tag=20
'stable/for-linus-3.17-b-rc0-tag' of=20
git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip
git bisect bad 4dacb91c7d1ab30aa9aac0d55216fc177d454254
# bad: [56b1ebf2d9798257c5932c8a0dd9da16796dbf36] dm switch: efficiently =

support repetitive patterns
git bisect bad 56b1ebf2d9798257c5932c8a0dd9da16796dbf36
# good: [895b47d7989af3aacea16380b190b1bb8f046362] dm cache metadata:=20
use dm-space-map-metadata.h defined size limits
git bisect good 895b47d7989af3aacea16380b190b1bb8f046362
# bad: [298a9fa08a1577211d42a75e8fc073baef61e0d9] dm crypt: use per-bio d=
ata
git bisect bad 298a9fa08a1577211d42a75e8fc073baef61e0d9
# good: [6a2414836154dc22b224c837ad7b862f78d595d1] block: use kmalloc=20
alignment for bio slab
git bisect good 6a2414836154dc22b224c837ad7b862f78d595d1
# first bad commit: [298a9fa08a1577211d42a75e8fc073baef61e0d9] dm crypt: =

use per-bio data



--------------ms050904020000080307060105
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
bDBaBggrBgEFBQcBAQROMEwwIQYIKwYBBQUHMAGGFWh0dHA6Ly9vY3NwLmNlcnR1bS5wbDAn
BggrBgEFBQcwAoYbaHR0cDovL3d3dy5jZXJ0dW0ucGwvbDMuY2VyMB8GA1UdIwQYMBaAFATJ
2prcSkl3rzADBGYux87y+Bd9MB0GA1UdDgQWBBSDc5sJYMsdTdjm9qQWXUehbDVLgzAOBgNV
HQ8BAf8EBAMCBPAwggE9BgNVHSAEggE0MIIBMDCCASwGCiqEaAGG9ncCAgMwggEcMCUGCCsG
AQUFBwIBFhlodHRwczovL3d3dy5jZXJ0dW0ucGwvQ1BTMIHyBggrBgEFBQcCAjCB5TAgFhlV
bml6ZXRvIFRlY2hub2xvZ2llcyBTLkEuMAMCAQEagcBVc2FnZSBvZiB0aGlzIGNlcnRpZmlj
YXRlIGlzIHN0cmljdGx5IHN1YmplY3RlZCB0byB0aGUgQ0VSVFVNIENlcnRpZmljYXRpb24g
UHJhY3RpY2UgU3RhdGVtZW50IChDUFMpIGluY29ycG9yYXRlZCBieSByZWZlcmVuY2UgaGVy
ZWluIGFuZCBpbiB0aGUgcmVwb3NpdG9yeSBhdCBodHRwczovL3d3dy5jZXJ0dW0ucGwvcmVw
b3NpdG9yeS4wHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBEGCWCGSAGG+EIBAQQE
AwIFoDAdBgNVHREEFjAUgRJra29sYXNhQHdpbnNvZnQucGwwDQYJKoZIhvcNAQEFBQADggEB
AAI98P3y5OBE/SLnwBNQNjmR+wcvZAUX5/xSZ6KHnVHzKPTZlGySNl1TrhAWnCRDthm92Kdu
zPtSaGflQZhEfG5DutK1EgIAHMBYDRV4jEZztFHZVfkDxPXgnR0XRFmb3xquNODcCt3SIKDv
J9JA5UHrzWJ9DsKUWbaZAV7NdK454aabllpHzjmagL76HqIRRuT0wwpn+pyGkU68gDFfOlZ0
s9Htz5YMcmBwTmuLbYxAgM+aHYXhhqdf7w3m84YL9QviZRhW+TsvDdRy6g3GnUJXQ1r8i/FC
Q3nukRRa0sz0Db1SyDiCFO171v8VpJO4L8r6DzMK36RBc8A5g9cOSXkxggPFMIIDwQIBATCB
jDB4MQswCQYDVQQGEwJQTDEiMCAGA1UEChMZVW5pemV0byBUZWNobm9sb2dpZXMgUy5BLjEn
MCUGA1UECxMeQ2VydHVtIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRwwGgYDVQQDExNDZXJ0
dW0gTGV2ZWwgSUlJIENBAhABw4d6KSuqDFcuWaNhb8SaMAkGBSsOAwIaBQCgggINMBgGCSqG
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDgxODE3MzMzNVowIwYJ
KoZIhvcNAQkEMRYEFINEN8Fqb3Hl1dnfajgLmWFpn47mMGwGCSqGSIb3DQEJDzFfMF0wCwYJ
YIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZ0GCSsGAQQBgjcQBDGBjzCB
jDB4MQswCQYDVQQGEwJQTDEiMCAGA1UEChMZVW5pemV0byBUZWNobm9sb2dpZXMgUy5BLjEn
MCUGA1UECxMeQ2VydHVtIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRwwGgYDVQQDExNDZXJ0
dW0gTGV2ZWwgSUlJIENBAhABw4d6KSuqDFcuWaNhb8SaMIGfBgsqhkiG9w0BCRACCzGBj6CB
jDB4MQswCQYDVQQGEwJQTDEiMCAGA1UEChMZVW5pemV0byBUZWNobm9sb2dpZXMgUy5BLjEn
MCUGA1UECxMeQ2VydHVtIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRwwGgYDVQQDExNDZXJ0
dW0gTGV2ZWwgSUlJIENBAhABw4d6KSuqDFcuWaNhb8SaMA0GCSqGSIb3DQEBAQUABIIBAAz2
hmC3yPNYccG43E6znKzpd5cydGTUJYgKGXonDiLdGcDunMOfUtNMQnQAogEaAuTU9c6KbzOW
Z16GEdvUBsmBLAbVt9r0ZiaXNMqHnTpFO77ssCPH75VPrSzsGpKNfI8wVdc6A4g9LqoSb7Pe
cSKb4xWBPRYxNN88ryoWbwfiYYCWf8YuFr6nBmp9vIhjycuZGTKuTv8q7u+R0KlbuhPCv9Q1
SAA3bIi2w/xamJLFMKcZlqveCpmLtcnk7KMgB6a3fDV60KVPhsdSOUeTNrqsBiftRs1UAdxX
Czmyi/JRSYb51uxNcBag53hqHOBuSchEKD7Ehj1sXhKm0WxMa5UAAAAAAAA=
--------------ms050904020000080307060105--


--===============5533099365558656843==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5533099365558656843==--
