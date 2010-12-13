From: <Menny_Hamburger@Dell.com>
Subject: dm-devel] [PATCH 1/1]: dm+dh: missing call to
 pg_init_done causes I/O to be hung forever
Date: Mon, 13 Dec 2010 16:12:37 +0000
Message-ID: <D8C50530D6022F40A817A35C40CC06A7064AF92400@DUBX7MCDUB01.EMEA.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_004_D8C50530D6022F40A817A35C40CC06A7064AF92400DUBX7MCDUB01E_"
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--_004_D8C50530D6022F40A817A35C40CC06A7064AF92400DUBX7MCDUB01E_
Content-Type: multipart/alternative;
	boundary="_000_D8C50530D6022F40A817A35C40CC06A7064AF92400DUBX7MCDUB01E_"

--_000_D8C50530D6022F40A817A35C40CC06A7064AF92400DUBX7MCDUB01E_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Attached is a clean patch file.

Menny.

Menny Hamburger
Engineer
Dell | IDC
office +972 97698789,  fax +972 97698889
Dell IDC. 4 Hacharoshet St, Raanana 43657, Israel


--_000_D8C50530D6022F40A817A35C40CC06A7064AF92400DUBX7MCDUB01E_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"Trebuchet MS";
	panose-1:2 11 6 3 2 2 2 2 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DWordSection1>

<p class=3DMsoNormal><b><span style=3D'font-size:10.0pt;font-family:"Trebuc=
het MS","sans-serif";
color:#444444'>Attached is a clean patch file.<o:p></o:p></span></b></p>

<p class=3DMsoNormal><b><span style=3D'font-size:10.0pt;font-family:"Trebuc=
het MS","sans-serif";
color:#444444'><o:p>&nbsp;</o:p></span></b></p>

<p class=3DMsoNormal><b><span style=3D'font-size:10.0pt;font-family:"Trebuc=
het MS","sans-serif";
color:#444444'>Menny.<o:p></o:p></span></b></p>

<p class=3DMsoNormal><b><span style=3D'font-size:10.0pt;font-family:"Trebuc=
het MS","sans-serif";
color:#444444'><o:p>&nbsp;</o:p></span></b></p>

<p class=3DMsoNormal><b><span style=3D'font-size:10.0pt;font-family:"Trebuc=
het MS","sans-serif";
color:#444444'>Menny Hamburger</span></b><span style=3D'font-size:8.0pt;
font-family:"Trebuchet MS","sans-serif";color:#444444'><o:p></o:p></span></=
p>

<p class=3DMsoNormal><span style=3D'font-size:8.0pt;font-family:"Trebuchet =
MS","sans-serif";
color:#444444'>Engineer<o:p></o:p></span></p>

<p class=3DMsoNormal><b><span style=3D'font-size:8.0pt;font-family:"Trebuch=
et MS","sans-serif";
color:#0085C3'>Dell</span></b><span style=3D'font-size:8.0pt;font-family:"T=
rebuchet MS","sans-serif";
color:#444444'> | IDC<b><o:p></o:p></b></span></p>

<p class=3DMsoNormal><b><span style=3D'font-size:8.0pt;font-family:"Trebuch=
et MS","sans-serif";
color:#444444'>office </span></b><span style=3D'font-size:8.0pt;font-family=
:"Trebuchet MS","sans-serif";
color:#444444'>+972 97698789<b>,&nbsp; fax </b>+972 97698889<b><o:p></o:p><=
/b></span></p>

<p class=3DMsoNormal><span style=3D'font-size:8.0pt;font-family:"Trebuchet =
MS","sans-serif";
color:#444444'>Dell IDC. 4 Hacharoshet St, Raanana 43657, Israel</span><spa=
n
style=3D'color:#1F497D'><o:p></o:p></span></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

</div>

</body>

</html>

--_000_D8C50530D6022F40A817A35C40CC06A7064AF92400DUBX7MCDUB01E_--

--_004_D8C50530D6022F40A817A35C40CC06A7064AF92400DUBX7MCDUB01E_
Content-Type: application/octet-stream; name="missing_pg_init_done.patch"
Content-Description: missing_pg_init_done.patch
Content-Disposition: attachment; filename="missing_pg_init_done.patch";
	size=2571; creation-date="Mon, 13 Dec 2010 16:09:38 GMT";
	modification-date="Mon, 13 Dec 2010 16:06:15 GMT"
Content-Transfer-Encoding: base64

RnJvbTogTWVubnkgSGFtYnVyZ2VyIDxNZW5ueV9IYW1idXJnZXJARGVsbC5jb20+ClN1YmplY3Q6
IFttZF0gW3Njc2lfZGhdIGNhbGwgcGdfaW5pdF9kb25lIGluIG1wYXRoIGFjdGl2YXRlIHdoZW4g
dGhlIGRldmljZSBpcyByZW1vdmVkLgpCdWd6aWxsYTogNjQ1MzQzCgpXaGVuIHNjc2lfZGhfYWN0
aXZhdGUgcmV0dXJucyBTQ1NJX0RIX05PU1lTIHRoZSBIL1cgaGFuZGxlciBjYWxsYmFjayBpcyBu
b3QgY2FsbGVkLCBwZ19pbml0X2RvbmUgaXMgbm90IGNhbGxlZCBpbiAKdGhlIG11bHRpcGF0aCBs
YXllciBhbmQgcGVuZGluZyBJL08gaXMgcmVxdWV1ZWQgZm9yZXZlcjsgdGhpcyBzaXR1YXRpb24g
Y2F1c2VzIGFsbCB1c2VybGFuZCBwcm9jZXNzZXMgY3VycmVudGx5IHBlcmZvcm1pbmcgSS9PCm9u
IHRoZSBkZXZpY2UgdG8gSS9PIGhhbmcuIEEgc2ltaWxhciBzaXR1YXRpb24gb2NjdXJzIHdoZW4g
dGhlIGRldmljZSBoYXMgdHJhbnNpdGlvbmVkIHRvIFNERVZfQ0FOQ0VML1NERVZfREVMIGFuZCB0
aGUgZGV2aWNlCmhhbmRsZXIgZGF0YSBoYWQgbm90IHlldCBiZWVuIGRlbGV0ZWQuCgpUaGUgZWFz
aWVzdCB3YXkgdG8gcmVwcm9kdWNlIHRoaXMgaXMgaW4gYW4gSVNDU0kgZW52aXJvbm1lbnQ6CiAg
ZGQgaWY9L2Rldi9kbS0wIG9mPS9kZXYvemVybyBicz04ayBjb3VudD0xMDAwMDAwICYKICAvZXRj
L2luaXQuZC9pc2NzaSBzdG9wCkluIHRoaXMgZXhhbXBsZSwgZGQgd2lsbCBJL08gaGFuZyBmb3Jl
dmVyIGFuZCB0aGUgb25seSB3YXkgdG8gcmVsZWFzZSBpdCB3aWxsIGJlIHRvIHJlYm9vdCB0aGUg
bWFjaGluZQoKVGhpcyBwYXRjaCBjYWxscyBwZ19pbml0X2RvbmUgZGlyZWN0bHkgZnJvbSB0aGUg
bXBhdGggY29kZSB3aGVuIHRoZSBzY3NpX2RoX2FjdGl2YXRlIHJldHVybnMgYSBub24gU0NTSV9E
SF9PSyBlcnJvci4KCk5vdGU6ClRoaXMgcGF0Y2ggaXMgb3ZlciBSSEVMNS41LgpXaGVuIHJ1bm5p
bmcgYW4gdXBzdHJlYW0ga2VybmVsLCB0aGUgYWJvdmUgc2NlbmFyaW8gbWF5IG5vdCBvY2N1ciBi
ZWNhdXNlIHRoZSByZXF1ZXN0IHF1ZXVlIGlzIGFib3J0ZWQgaW4gZG0tbXBhdGguYzpmYWlsX3Bh
dGguClRoaXMgcGF0Y2ggbWFrZXMgc3VyZSB0aGUgcHJvYmxlbSBkb2VzIG5vdCBvY2N1ciBhdCBh
bGwsIHJhdGhlciB0aGFuIGhhbmRsaW5nIGl0IHdoZW4gaXQgZG9lcy4gSW4gYWRkaXRpb24sIGl0
IHNlZW1zIHRvbyByaXNreSB0byBhcHBseSAKcmVxdWVzdCBxdWV1ZSBhYm9ydCBmdW5jdGlvbmFs
aXR5IG9uIFJIRUw1IGF0IHRoaXMgc3RhZ2UuCgpkaWZmIC1yIC1VIDIgYS9kcml2ZXJzL21kL2Rt
LW1wYXRoLmMgYi9kcml2ZXJzL21kL2RtLW1wYXRoLmMKLS0tIGEvZHJpdmVycy9tZC9kbS1tcGF0
aC5jCTIwMTAtMTItMTMgMTg6MDY6MTUuMzQyOTIwMDAwICswMjAwCisrKyBiL2RyaXZlcnMvbWQv
ZG0tbXBhdGguYwkyMDEwLTEyLTEzIDE4OjA2OjE1LjQ1MzA5MjAwMCArMDIwMApAQCAtMTE5MCw0
ICsxMTkwLDUgQEAKIAljYXNlIFNDU0lfREhfT0s6CiAJCWJyZWFrOworCWNhc2UgU0NTSV9ESF9E
RVZfT0ZGTElORUQ6CiAJY2FzZSBTQ1NJX0RIX05PU1lTOgogCQlpZiAoIW0tPmh3X2hhbmRsZXJf
bmFtZSkgewpAQCAtMTI1Miw3ICsxMjUzLDE1IEBACiB7CiAJc3RydWN0IHBncGF0aCAqcGdwYXRo
ID0gKHN0cnVjdCBwZ3BhdGggKikgZGF0YTsKKwlpbnQgZXJyOwogCi0Jc2NzaV9kaF9hY3RpdmF0
ZShiZGV2X2dldF9xdWV1ZShwZ3BhdGgtPnBhdGguZGV2LT5iZGV2KSwKKwllcnIgPSBzY3NpX2Ro
X2FjdGl2YXRlKGJkZXZfZ2V0X3F1ZXVlKHBncGF0aC0+cGF0aC5kZXYtPmJkZXYpLAogCQkJCXBn
X2luaXRfZG9uZSwgJnBncGF0aC0+cGF0aCk7CisKKwkvKgorCSAqIElmIGVycm9yIGlzIG5vdCBT
Q1NJX0RIX09LLCB3ZSBoYXZlIG5vdCBlbnRlcmVkIHRoZSBzY3NpX2RoIEgvVyBoYW5kbGVyIGFu
ZCBkaWQgbm90IGNhbGwgcGdfaW5pdF9kb25lIC0gCisJICogbmVlZCB0byBjYWxsIHBnX2luaXRf
ZG9uZSBkaXJlY3RseS4KKwkgKi8KKwlpZiAoZXJyKSAKKwkJcGdfaW5pdF9kb25lKCZwZ3BhdGgt
PnBhdGgsIGVycik7CiB9CiAKZGlmZiAtciAtVSAyIGEvZHJpdmVycy9zY3NpL2RldmljZV9oYW5k
bGVyL3Njc2lfZGguYyBiL2RyaXZlcnMvc2NzaS9kZXZpY2VfaGFuZGxlci9zY3NpX2RoLmMKLS0t
IGEvZHJpdmVycy9zY3NpL2RldmljZV9oYW5kbGVyL3Njc2lfZGguYwkyMDEwLTEyLTEzIDE4OjA2
OjE1LjM5MzcxMjAwMCArMDIwMAorKysgYi9kcml2ZXJzL3Njc2kvZGV2aWNlX2hhbmRsZXIvc2Nz
aV9kaC5jCTIwMTAtMTItMTMgMTg6MDY6MTUuNTAwOTA3MDAwICswMjAwCkBAIC00NDMsNCArNDQz
LDkgQEAKIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKHEtPnF1ZXVlX2xvY2ssIGZsYWdzKTsKIAor
CWlmIChzZGV2LT5zZGV2X3N0YXRlID09IFNERVZfQ0FOQ0VMIHx8CisJICAgIHNkZXYtPnNkZXZf
c3RhdGUgPT0gU0RFVl9ERUwgfHwKKwkgICAgc2Rldi0+c2Rldl9zdGF0ZSA9PSBTREVWX09GRkxJ
TkUpCisJCWVyciA9IFNDU0lfREhfREVWX09GRkxJTkVEOworCiAJaWYgKGVycikKIAkJcmV0dXJu
IGVycjsK

--_004_D8C50530D6022F40A817A35C40CC06A7064AF92400DUBX7MCDUB01E_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_004_D8C50530D6022F40A817A35C40CC06A7064AF92400DUBX7MCDUB01E_--
