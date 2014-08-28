From: Krzysztof Kolasa <kkolasa@winsoft.pl>
Subject: Re: [PATCH] dm-crypt: Fix access beyond the end of
	allocated space
Date: Thu, 28 Aug 2014 21:28:44 +0200
Message-ID: <53FF82EC.8080308@winsoft.pl>
References: <alpine.LRH.2.02.1408281108120.31317@file01.intranet.prod.int.rdu2.redhat.com>
	<53FF6E1D.10308@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2588095356524029780=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53FF6E1D.10308@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a cryptographically signed message in MIME format.

--===============2588095356524029780==
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha1; boundary="------------ms070806050005040103040902"

This is a cryptographically signed message in MIME format.

--------------ms070806050005040103040902
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: quoted-printable

W dniu 28.08.2014 o 19:59, Milan Broz pisze:
> On 08/28/2014 05:09 PM, Mikulas Patocka wrote:
>> dm-crypt has a bug that it accesses memory beyond allocated space.
>>
>> To minimize allocation overhead, dm-crypt puts several structures into=
 one
>> block allocated with kmalloc. The block holds struct ablkcipher_reques=
t,
>> cipher-specific scratch pad (crypto_ablkcipher_reqsize(any_tfm(cc))),
>> struct dm_crypt_request and initialization vector.
>>
>> The variable dmreq_start is set to offset of struct dm_crypt_request
>> within this memory block. dm-crypt allocates block with this size:
>> cc->dmreq_start + sizeof(struct dm_crypt_request) + cc->iv_size.
>>
>> When accessing the initialization vector, dm-crypt uses the function
>> iv_of_dmreq, which performs this calculation: ALIGN((unsigned long)(dm=
req
>> + 1), crypto_ablkcipher_alignmask(any_tfm(cc)) + 1).
>>
>> dm-crypt allocated "cc->iv_size" bytes beyond the end of dm_crypt_requ=
est
>> structure. However, when dm-crypt accesses the initialization vector, =
it
>> takes a pointer to the end of dm_crypt_request, aligns it, and then us=
es
>> it as the initialization vector.
>>
>> If the end of dm_crypt_request is not aligned on
>> crypto_ablkcipher_alignmask(any_tfm(cc)), the alignment causes
>> initialization vector to point beyond the allocated space. This bug is=

>> very old (it dates back to commit 3a7f6c990ad04e6f576a159876c602d14d6f=
7fef
>> in 2.6.25). However, the bug was masked by the fact that kmalloc round=
s up
>> the size to the next power of two. Recent change in dm-crypt that puts=

>> this structure to per-bio data (298a9fa08a1577211d42a75e8fc073baef61e0=
d9)
>> made this bug show up, because there is no longer any padding beyond t=
he
>> end of iv_size.
>>
>> This patch fixes the bug by calculating the variable iv_size_padding a=
nd
>> adding it to the allocated size.
>>
>> The patch also corrects alignment of dm_crypt_request. struct
>> dm_crypt_request is specific to dm-crypt (it isn't used by the crypto
>> subsystem at all), so it is aligned on __alignof__(struct
>> dm_crypt_request).
>>
>> The patch also aligns per_bio_data_size on ARCH_KMALLOC_MINALIGN, so t=
hat
>> it is aligned as if the block was allocated with kmalloc.
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Thanks for fixing this!
>
> I tried all reproducers I have and no problems here with your patch.
> (Except another unrelated oops in scsi_debug :-)
>
> Tested-by: Milan Broz <gmazyland@gmail.com>
>
> Milan
>

Thanks, I have no any problems after patch application ( with Truecrypt=20
on system 64x and x86 )

Krzysztof


--------------ms070806050005040103040902
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: Kryptograficzna sygnatura S/MIME

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
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDgyODE5Mjg0NFowIwYJ
KoZIhvcNAQkEMRYEFMFMvfvEBaeiYa3lZ5PtkFsFu5cHMGwGCSqGSIb3DQEJDzFfMF0wCwYJ
YIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZ0GCSsGAQQBgjcQBDGBjzCB
jDB4MQswCQYDVQQGEwJQTDEiMCAGA1UEChMZVW5pemV0byBUZWNobm9sb2dpZXMgUy5BLjEn
MCUGA1UECxMeQ2VydHVtIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRwwGgYDVQQDExNDZXJ0
dW0gTGV2ZWwgSUlJIENBAhABw4d6KSuqDFcuWaNhb8SaMIGfBgsqhkiG9w0BCRACCzGBj6CB
jDB4MQswCQYDVQQGEwJQTDEiMCAGA1UEChMZVW5pemV0byBUZWNobm9sb2dpZXMgUy5BLjEn
MCUGA1UECxMeQ2VydHVtIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRwwGgYDVQQDExNDZXJ0
dW0gTGV2ZWwgSUlJIENBAhABw4d6KSuqDFcuWaNhb8SaMA0GCSqGSIb3DQEBAQUABIIBAAun
D4c/0OEUir7owHcNQLUGqboFn2HgBqgqB4rCWSzqSDzOAgGMgV600JtPHEijnRRpeFlbTMSD
r+nQxt9sAyt7tzMDit9DM7dkvusWQVnZoK6rjDW74VM2RI2ei/RkUCDvJEvDP2Bk4MntMBKb
K+2a5nEAwII0jmZnoDJErojjOapHAb1yZDMc7pYifMecxNjuxWMnwp9On8y3xWb/AbuTIdTu
jupD1yJJ0QkU2g9yYo2Vj4n1MCXJ/w0ED+EI3pzGhF2IIazZJMXRVFdz1FcflezTHqvP5yEk
5tTXid1biJorDRtvB/ipoUSnkssvh9D5+5EgCqcBU/1iT3RircEAAAAAAAA=
--------------ms070806050005040103040902--


--===============2588095356524029780==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2588095356524029780==--
