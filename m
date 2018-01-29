From: =?utf-8?B?VG9tIEdlbmco6IC/6Iqz5b+gKQ==?= <gengfangzhong@inspur.com>
Subject: Re: multipath-tools: add INSPUR/MCS to hardware table
Date: Mon, 29 Jan 2018 06:04:29 +0000
Message-ID: <6FA0216CBF61AE4AA9DA6744243E7853DB5C4578@jtjnmailbox06.home.langchao.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0065849094011262066=="
Return-path: <dm-devel-bounces@redhat.com>
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
To: "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0065849094011262066==
Content-Language: zh-CN
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_0198_01D3990A.144BA1E0"

------=_NextPart_000_0198_01D3990A.144BA1E0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi, Xose,
I sent the patch to dm-devel last week, but forgot to CC you. Please help to 
review and have chance to submit to the mainline.
Thank you a lot.


From 091bae5fec22c61f0c3e6f9ab848fecae5203122 Mon Sep 17 00:00:00 2001
From: Tom Geng <gengfangzhong@inspur.com>
Date: Tue, 23 Jan 2018 15:33:09 +0800
Subject: [PATCH] multipath-tools: add INSPUR/MCS to hardware table

---
 libmultipath/hwtable.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 448effe3..93d67df0 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1181,6 +1181,17 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 30,
 	},
+	/*
+	 * INSPUR
+	 */
+	{
+		/* AS5300/AS5500 G2 */
+		.vendor        = "INSPUR",
+		.product       = "MCS",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+	},
 	/*
 	 * EOL
 	 */
-- 
2.15.1.windows.2


------=_NextPart_000_0198_01D3990A.144BA1E0
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
ATAcBgkqhkiG9w0BCQUxDxcNMTgwMTI5MDYwNDI5WjAjBgkqhkiG9w0BCQQxFgQU+AxOZDquWi23
4p9EugB7sKBFEMMweAYJKwYBBAGCNxAEMWswaTBbMRMwEQYKCZImiZPyLGQBGRYDY29tMRgwFgYK
CZImiZPyLGQBGRYIbGFuZ2NoYW8xFDASBgoJkiaJk/IsZAEZFgRob21lMRQwEgYDVQQDEwtMYW5n
Q2hhby1DQQIKEE001QABAAJ1STB6BgsqhkiG9w0BCRACCzFroGkwWzETMBEGCgmSJomT8ixkARkW
A2NvbTEYMBYGCgmSJomT8ixkARkWCGxhbmdjaGFvMRQwEgYKCZImiZPyLGQBGRYEaG9tZTEUMBIG
A1UEAxMLTGFuZ0NoYW8tQ0ECChBNNNUAAQACdUkwgZMGCSqGSIb3DQEJDzGBhTCBgjALBglghkgB
ZQMEASowCwYJYIZIAWUDBAEWMAoGCCqGSIb3DQMHMAsGCWCGSAFlAwQBAjAOBggqhkiG9w0DAgIC
AIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAhowCwYJYIZIAWUDBAIDMAsGCWCGSAFlAwQCAjALBglg
hkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAucNLy3aaNQRGNyLks2IX+shQDhKZ9qao1GWYngTA
vz/09JYdGWbOUCv1hwzk4JJHG7llKqMwEPEDYoKkR4Wgd20l7kppTKZED6N1IV/REZ+N47scn3ML
ewtYEiyu1rT3JdMpMYkSoay7CtxmDGMJzfTajJQyh8p1VkEfUOAYqitDoJhStcI7ffpugRp8j2v6
1/Qf8nxzcP0YnIXKPNgdLsEEmKWXi2EZWh+166L3fG+k4O0p19B8DCC0F4DVi/DifQWxVjQBbit1
CanSvwtTINQ2nDIs5bU7TrIAbbr+3W6JSkf4XsO6cI3jG0gxPZKFur9JE0FWMFRDixDCD9fBwAAA
AAAAAA==

------=_NextPart_000_0198_01D3990A.144BA1E0--


--===============0065849094011262066==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0065849094011262066==--
