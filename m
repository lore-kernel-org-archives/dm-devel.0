From: Krzysztof Kolasa <kkolasa@winsoft.pl>
Subject: Re: [PATCH] dm-crypt: Fix per-bio data alignment
Date: Mon, 18 Aug 2014 21:32:13 +0200
Message-ID: <53F254BD.5090806@winsoft.pl>
References: <53F238EF.10409@winsoft.pl>
	<1408386997-14690-1-git-send-email-gmazyland@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6377744620040203920=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1408386997-14690-1-git-send-email-gmazyland@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com
Cc: mpatocka@redhat.com, agk@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

This is a cryptographically signed message in MIME format.

--===============6377744620040203920==
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha1; boundary="------------ms010503060905040809000908"

This is a cryptographically signed message in MIME format.

--------------ms010503060905040809000908
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: quoted-printable

On 18.08.2014 20:36, Milan Broz wrote:
> The commit
>    298a9fa08a1577211d42a75e8fc073baef61e0d9
>    dm crypt: use per-bio data
> causes OOPS on 32bit i686 architecture
>
>    BUG: unable to handle kernel paging request at 20000000
>    IP: [<e0fe2433>] clone_endio+0x13/0xe0 [dm_mod]
>    ...
>
>   [<c1257b61>] bio_endio+0x61/0x90
>   [<e142476c>] crypt_dec_pending+0x8c/0xd0 [dm_crypt]
>   [<e142666f>] kcryptd_crypt+0x4bf/0x4f0 [dm_crypt]
>
> This patch fixes the issue by aligning per-bio alocated structure size.=

>
> Reported-by: Krzysztof Kolasa <kkolasa@winsoft.pl>
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---
>   drivers/md/dm-crypt.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 2785007..33f26a2 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1735,9 +1735,10 @@ static int crypt_ctr(struct dm_target *ti, unsig=
ned int argc, char **argv)
>   		goto bad;
>   	}
>  =20
> -	cc->per_bio_data_size =3D ti->per_bio_data_size =3D
> -				sizeof(struct dm_crypt_io) + cc->dmreq_start +
> -				sizeof(struct dm_crypt_request) + cc->iv_size;
> +	cc->per_bio_data_size =3D ALIGN(sizeof(struct dm_crypt_io) + cc->dmre=
q_start +
> +				      sizeof(struct dm_crypt_request) + cc->iv_size,
> +				      ARCH_KMALLOC_MINALIGN);
> +	ti->per_bio_data_size =3D cc->per_bio_data_size;
>  =20
>   	cc->page_pool =3D mempool_create_page_pool(MIN_POOL_PAGES, 0);
>   	if (!cc->page_pool) {

patch tested positive for x86 ( no oops ) and x86_64  ( continues to=20
work OK ).

thanks


--------------ms010503060905040809000908
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
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDgxODE5MzIxM1owIwYJ
KoZIhvcNAQkEMRYEFMGXFZgUBpFryQPmGEPIRF6PaYV/MGwGCSqGSIb3DQEJDzFfMF0wCwYJ
YIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZ0GCSsGAQQBgjcQBDGBjzCB
jDB4MQswCQYDVQQGEwJQTDEiMCAGA1UEChMZVW5pemV0byBUZWNobm9sb2dpZXMgUy5BLjEn
MCUGA1UECxMeQ2VydHVtIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRwwGgYDVQQDExNDZXJ0
dW0gTGV2ZWwgSUlJIENBAhABw4d6KSuqDFcuWaNhb8SaMIGfBgsqhkiG9w0BCRACCzGBj6CB
jDB4MQswCQYDVQQGEwJQTDEiMCAGA1UEChMZVW5pemV0byBUZWNobm9sb2dpZXMgUy5BLjEn
MCUGA1UECxMeQ2VydHVtIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRwwGgYDVQQDExNDZXJ0
dW0gTGV2ZWwgSUlJIENBAhABw4d6KSuqDFcuWaNhb8SaMA0GCSqGSIb3DQEBAQUABIIBAHmh
fhbyJqAXomdf+4vcWdV9r7O9+96CYxCEMMsRRpdRTGMjLfZU8ivuDzTNUwCV1UIMofEQqg/A
aDD2ungMySq04jBJn0n0tmoC/2dAMci20M8/OtXoQoa0VfCDHwAq2+GxpztePFuKmXSZIi/O
oMszPSHkUL4F2445RS2j1msbrKYiTshmOseYiD+Uy9PSX+lbgYIlbavx9I/BP6m1uZqU+k/m
7EemShE010bNqZraitS+FkjUjUsWjRwZ6y+nqT+yU+VufW2mIunDhUFACkJPqlA78murYBNp
rpgDaal/eOzFlEv2XAmluwLFbnNvNbnHlVxMBDgkH2km3Vy6PQEAAAAAAAA=
--------------ms010503060905040809000908--


--===============6377744620040203920==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6377744620040203920==--
