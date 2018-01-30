From: =?utf-8?B?VG9tIEdlbmco6IC/6Iqz5b+gKQ==?= <gengfangzhong@inspur.com>
Subject: Re: multipath-tools: add INSPUR/MCS to hardware table
Date: Tue, 30 Jan 2018 01:54:29 +0000
Message-ID: <6FA0216CBF61AE4AA9DA6744243E7853DB5C4677@jtjnmailbox06.home.langchao.com>
References: <fc914b9de97f5c50029b2d2bae22d9d5@sslemail.net>
	<1517233052.12805.27.camel@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5790399981274014331=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1517233052.12805.27.camel@suse.com>
Content-Language: zh-CN
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "mwilck@suse.com" <mwilck@suse.com>, "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5790399981274014331==
Content-Language: zh-CN
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_003C_01D399B0.50B947D0"

------=_NextPart_000_003C_01D399B0.50B947D0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi, Martin,
.pgfailback    =3D -FAILBACK_IMMEDIATE  is OK for INSPUR/MCS in ALUA =
mode. We have tested failback function, the device controller works =
well.=20
Thank you a lot.



-----Original Message-----
From: Martin Wilck [mailto:mwilck@suse.com]=20
Sent: Monday, January 29, 2018 9:38 PM
To: Tom Geng(=E8=80=BF=E8=8A=B3=E5=BF=A0) <gengfangzhong@inspur.com>; =
xose.vazquez@gmail.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] multipath-tools: add INSPUR/MCS to hardware =
table

On Mon, 2018-01-29 at 06:04 +0000, Tom Geng(=E8=80=BF=E8=8A=B3=E5=BF=A0) =
wrote:
> Hi, Xose,
> I sent the patch to dm-devel last week, but forgot to CC you. Please=20
> help to review and have chance to submit to the mainline.
> Thank you a lot.
>=20
>=20
> > From 091bae5fec22c61f0c3e6f9ab848fecae5203122 Mon Sep 17 00:00:00
> > 2001
>=20
> From: Tom Geng <gengfangzhong@inspur.com>
> Date: Tue, 23 Jan 2018 15:33:09 +0800
> Subject: [PATCH] multipath-tools: add INSPUR/MCS to hardware table
>=20
> ---
>  libmultipath/hwtable.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c index=20
> 448effe3..93d67df0 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1181,6 +1181,17 @@ static struct hwentry default_hw[] =3D {
>  		.pgpolicy      =3D MULTIBUS,
>  		.no_path_retry =3D 30,
>  	},
> +	/*
> +	 * INSPUR
> +	 */
> +	{
> +		/* AS5300/AS5500 G2 */
> +		.vendor        =3D "INSPUR",
> +		.product       =3D "MCS",
> +		.pgpolicy      =3D GROUP_BY_PRIO,
> +		.pgfailback    =3D -FAILBACK_IMMEDIATE,
> +		.prio_name     =3D PRIO_ALUA,
> +	},
>  	/*
>  	 * EOL
>  	 */

multipath-tools default to .pgpolicy =3D failover. Please confirm that =
this is really your intention.

Martin

--
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107 SUSE =
Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton HRB =
21284 (AG N=C3=BCrnberg)


------=_NextPart_000_003C_01D399B0.50B947D0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIMUTCCBOgw
ggPQoAMCAQICEHJZ3dAghQm7TR3WtIciZWowDQYJKoZIhvcNAQEFBQAwWzETMBEGCgmSJomT8ixk
ARkWA2NvbTEYMBYGCgmSJomT8ixkARkWCGxhbmdjaGFvMRQwEgYKCZImiZPyLGQBGRYEaG9tZTEU
MBIGA1UEAxMLTGFuZ0NoYW8tQ0EwHhcNMDUwMTEyMDcyNTIyWhcNMjQxMTA3MTcyNjM4WjBbMRMw
EQYKCZImiZPyLGQBGRYDY29tMRgwFgYKCZImiZPyLGQBGRYIbGFuZ2NoYW8xFDASBgoJkiaJk/Is
ZAEZFgRob21lMRQwEgYDVQQDEwtMYW5nQ2hhby1DQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBAMvRSQUPw6jL6C6jqLQaQW3/yXkiew6X5DFftp11ymCmwpOEKEAHQEsOqiha/Lkj8ORt
6KjfEHc1Z4AYgzXz9YJx0lJGoM27U/o07gu73XKTYTLEbs+MCb9Juq52ptSsRsZHBb0n4AfBjFON
8gzgDmTg9TRyM2yNXDHoA1pSrHYvNT37urklW4XorW5DeMGohxlpOApkhsqlGpS2w7C2ZAR82NCp
+80yCDXraDZ5cCOhQAyZ6qHcWJIloyi8+gwzJi1MqWB91JjE4wicxof9SCyNtdbx2XwKxSL5U0zM
sZQJ+201lvmaqCrPSMcoUdZxWWKM2yYtro7oEiwB/4jpaHsCAwEAAaOCAaYwggGiMBMGCSsGAQQB
gjcUAgQGHgQAQwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTGbsOi
E24avQY6XrcvNNjg05z7IzCCARUGA1UdHwSCAQwwggEIMIIBBKCCAQCggf2GgbxsZGFwOi8vL0NO
PUxhbmdDaGFvLUNBLENOPWp0am5jYTAxLENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNl
cyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPWhvbWUsREM9bGFuZ2NoYW8sREM9Y29t
P2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmplY3RDbGFzcz1jUkxEaXN0cmlidXRp
b25Qb2ludIY8aHR0cDovL2p0am5jYTAxLmhvbWUubGFuZ2NoYW8uY29tL0NlcnRFbnJvbGwvTGFu
Z0NoYW8tQ0EuY3JsMBAGCSsGAQQBgjcVAQQDAgEBMCMGCSsGAQQBgjcVAgQWBBRYQgrth4/MB0pS
3hx7TTpz3BidCDANBgkqhkiG9w0BAQUFAAOCAQEAWjsuzhyiArAxdntQqbkoOaDt/caM2xEA3hWn
gjl4yJeKxxuU0U5KLs7wcaVYantJjeL7jb9r29Aeb5lRzcUHodJgk2xvNYAI0s7ZkmahMSbPIMha
w6sKSiq2bI08u7cyPoW5HxVJz3pEM4IkuLaWmMm/I3BUUQE3rxUdXy7iq2CE7KPNKIf+wDuouDgm
bWItUuIev5toOR37MxpPS02Ci1H2KxOGkMDFAWJawNgzseRaRqEJdgMelpS46KnBaT3uFI/wqG+0
1pMVfldgzOBA9Jaj4AC/AWU+v8Ks6+yX8/14Se7bkRltLqmXI6EGHo6KBiIAP2uGHg7lGzCmR/Ja
dTCCB2EwggZJoAMCAQICChBNNNUAAQACdUkwDQYJKoZIhvcNAQEFBQAwWzETMBEGCgmSJomT8ixk
ARkWA2NvbTEYMBYGCgmSJomT8ixkARkWCGxhbmdjaGFvMRQwEgYKCZImiZPyLGQBGRYEaG9tZTEU
MBIGA1UEAxMLTGFuZ0NoYW8tQ0EwHhcNMTcwNjIyMDgzMDMyWhcNMjIwNjIxMDgzMDMyWjCBqjET
MBEGCgmSJomT8ixkARkWA2NvbTEYMBYGCgmSJomT8ixkARkWCGxhbmdjaGFvMRQwEgYKCZImiZPy
LGQBGRYEaG9tZTEVMBMGA1UECwwM5rWq5r2u5L+h5oGvMQ8wDQYDVQQLDAbnlKjmiLcxEjAQBgNV
BAMMCeiAv+iKs+W/oDEnMCUGCSqGSIb3DQEJARYYZ2VuZ2Zhbmd6aG9uZ0BpbnNwdXIuY29tMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5QJoej3RSHiDlu7XjHI2tF+YlCUeBItIMzw5
RvGVP5kJUV0zhp0sZhSBCUA81BenIzONGwuOUak0J0+hzQNAs8NHDaRhJrRMmGju3sY+nxMskOw2
rZx50ea24h6TJYvbf6AFVc+knvNzPzvua4GClF3kh+zfg/UwEBfgpHbUWDNzHFiGPHbvEdgrDF5y
rxllUtRP6its4Wm+4DGrG+bG6hXIEQ1Y9AvM/+p3rPEvGtoOu+UfLjZihccyACuxKjJwRzY/nwzR
/PuRsXg0iFenrFOBkE+anAJ91ETPTEUN40omAXIp/LnGM/ZYAmCNK+8hqa/XZOJ6h78oaVPK8sF6
QwIDAQABo4ID1TCCA9EwCwYDVR0PBAQDAgWgMD4GCSsGAQQBgjcVBwQxMC8GJysGAQQBgjcVCILy
qR+Egdd6hqmRPYaA9xWD2I9cgUqGoq0dhteULAIBZAIBGTBEBgkqhkiG9w0BCQ8ENzA1MA4GCCqG
SIb3DQMCAgIAgDAOBggqhkiG9w0DBAICAIAwBwYFKw4DAgcwCgYIKoZIhvcNAwcwHQYDVR0OBBYE
FF3jIZwxg36oDTvJUiQNwy75rtbEMB8GA1UdIwQYMBaAFMZuw6ITbhq9Bjpety802ODTnPsjMIIB
FQYDVR0fBIIBDDCCAQgwggEEoIIBAKCB/YaBvGxkYXA6Ly8vQ049TGFuZ0NoYW8tQ0EsQ049anRq
bmNhMDEsQ049Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNv
bmZpZ3VyYXRpb24sREM9aG9tZSxEQz1sYW5nY2hhbyxEQz1jb20/Y2VydGlmaWNhdGVSZXZvY2F0
aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlvblBvaW50hjxodHRwOi8vanRq
bmNhMDEuaG9tZS5sYW5nY2hhby5jb20vQ2VydEVucm9sbC9MYW5nQ2hhby1DQS5jcmwwggEwBggr
BgEFBQcBAQSCASIwggEeMIGzBggrBgEFBQcwAoaBpmxkYXA6Ly8vQ049TGFuZ0NoYW8tQ0EsQ049
QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRp
b24sREM9aG9tZSxEQz1sYW5nY2hhbyxEQz1jb20/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29iamVjdENs
YXNzPWNlcnRpZmljYXRpb25BdXRob3JpdHkwZgYIKwYBBQUHMAKGWmh0dHA6Ly9qdGpuY2EwMS5o
b21lLmxhbmdjaGFvLmNvbS9DZXJ0RW5yb2xsL2p0am5jYTAxLmhvbWUubGFuZ2NoYW8uY29tX0xh
bmdDaGFvLUNBKDEpLmNydDApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYBBQUHAwQGCisGAQQBgjcK
AwQwNQYJKwYBBAGCNxUKBCgwJjAKBggrBgEFBQcDAjAKBggrBgEFBQcDBDAMBgorBgEEAYI3CgME
ME0GA1UdEQRGMESgKAYKKwYBBAGCNxQCA6AaDBhnZW5nZmFuZ3pob25nQGluc3B1ci5jb22BGGdl
bmdmYW5nemhvbmdAaW5zcHVyLmNvbTANBgkqhkiG9w0BAQUFAAOCAQEAWE4veiN2R5QIPFRiYcVu
uy13sYJERwDO7uFGwYZlWo/H+VnTg4HVbBOW6oVYspPrL9T019Z0+E8mSnPepQrVQcCuy1PT7PZr
RkcdLbOo7U/tx60g+9lamhB8U+phCKSwWuzw3bH2YASugWx92hI2ZJb/d+4MvtpKUPEgCwV+5oM9
V0oRiej2nlRhZKYjfMiOjdEhEaRRa6j4/NzPOssioIn/eu1tC6ee4gHuHw9lV3yMLfBG69ObVYci
UgInzWyUUjh1+rkSRM1Xg0L7y1RE0of2643atPS95LlNO7TDBccoNuzWwURh9ZN/MFQmCKhRsZhg
Di4cLpUtyxyRgxnoeTGCA30wggN5AgEBMGkwWzETMBEGCgmSJomT8ixkARkWA2NvbTEYMBYGCgmS
JomT8ixkARkWCGxhbmdjaGFvMRQwEgYKCZImiZPyLGQBGRYEaG9tZTEUMBIGA1UEAxMLTGFuZ0No
YW8tQ0ECChBNNNUAAQACdUkwCQYFKw4DAhoFAKCCAekwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMTgwMTMwMDE1NDI3WjAjBgkqhkiG9w0BCQQxFgQUG0ILvIgE4xqr
NX4l8tJtcq8S910weAYJKwYBBAGCNxAEMWswaTBbMRMwEQYKCZImiZPyLGQBGRYDY29tMRgwFgYK
CZImiZPyLGQBGRYIbGFuZ2NoYW8xFDASBgoJkiaJk/IsZAEZFgRob21lMRQwEgYDVQQDEwtMYW5n
Q2hhby1DQQIKEE001QABAAJ1STB6BgsqhkiG9w0BCRACCzFroGkwWzETMBEGCgmSJomT8ixkARkW
A2NvbTEYMBYGCgmSJomT8ixkARkWCGxhbmdjaGFvMRQwEgYKCZImiZPyLGQBGRYEaG9tZTEUMBIG
A1UEAxMLTGFuZ0NoYW8tQ0ECChBNNNUAAQACdUkwgZMGCSqGSIb3DQEJDzGBhTCBgjALBglghkgB
ZQMEASowCwYJYIZIAWUDBAEWMAoGCCqGSIb3DQMHMAsGCWCGSAFlAwQBAjAOBggqhkiG9w0DAgIC
AIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAhowCwYJYIZIAWUDBAIDMAsGCWCGSAFlAwQCAjALBglg
hkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEA4XCaVmEDOePS0539G2xk/iFN74vxzdmHUSK072qW
Z232WdL0pN2eadEmV+LIClBrJiSDJSNO7mUuA98Qyb2QZ1xgs4cyMfkA+ZGKrWl8DuLeF8lbQAlF
KQr5yOooVp4HowkRWN0108uULwegJPBxAIm339yT5AIduGNxzPDbYr10kOtIoqM9D803toKWqKa8
+EzREYh+fXooCwN5qsvO7PbOnhPRj09KmgB5HJ7YMjj0sfNcm3WUDj3PolQs+8I8tl4HlFjqr/eP
KhGGo6siKP9gQBsIT8cQlJMc13FFOh3F9JVECpbKa5bEE8wKENlYb/iwrbDPMPYzbUb23JQAXQAA
AAAAAA==

------=_NextPart_000_003C_01D399B0.50B947D0--


--===============5790399981274014331==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5790399981274014331==--
