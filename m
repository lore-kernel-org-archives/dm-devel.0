From: <Menny_Hamburger@Dell.com>
Subject: [Patch 1 of 2]: scsi-dh + dm-mpath: propagate SCSI
 device deletion to multipath
Date: Wed, 15 Dec 2010 08:28:55 +0000
Message-ID: <D8C50530D6022F40A817A35C40CC06A7064AFC9440@DUBX7MCDUB01.EMEA.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_004_D8C50530D6022F40A817A35C40CC06A7064AFC9440DUBX7MCDUB01E_"
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

--_004_D8C50530D6022F40A817A35C40CC06A7064AFC9440DUBX7MCDUB01E_
Content-Type: multipart/alternative;
	boundary="_000_D8C50530D6022F40A817A35C40CC06A7064AFC9440DUBX7MCDUB01E_"

--_000_D8C50530D6022F40A817A35C40CC06A7064AFC9440DUBX7MCDUB01E_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The problem:
When a SCSI device attached to a device handler is deleted, userland proces=
ses currently performing I/O on the device will I/O hang forever.

The root cause:
When scsi_dh_activate returns SCSI_DH_NOSYS the activate_complete callback =
is not called and the error is not propagated to the
multipath layer. A similar situation occurs when the handler is in the proc=
ess of being deleted (e.g. the SCSI device is in a SDEV_CANCEL or SDEV_DEL =
state).

Attached is the SCSI H/W handler part of this patch.

Menny Hamburger
Engineer
Dell | IDC
office +972 97698789,  fax +972 97698889
Dell IDC. 4 Hacharoshet St, Raanana 43657, Israel


--_000_D8C50530D6022F40A817A35C40CC06A7064AFC9440DUBX7MCDUB01E_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
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

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-fami=
ly:"Courier New"'>The
problem:<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-fami=
ly:"Courier New"'>When
a SCSI device attached to a device handler is deleted, userland processes
currently performing I/O on the device will I/O hang forever.<o:p></o:p></s=
pan></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-fami=
ly:"Courier New"'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-fami=
ly:"Courier New"'>The
root cause:<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-fami=
ly:"Courier New"'>When
scsi_dh_activate returns SCSI_DH_NOSYS the activate_complete callback is no=
t
called and the error is not propagated to the<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-fami=
ly:"Courier New"'>multipath
layer. A similar situation occurs when the handler is in the process of bei=
ng
deleted (e.g. the SCSI device is in a SDEV_CANCEL or SDEV_DEL state).<o:p><=
/o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-fami=
ly:"Courier New"'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-fami=
ly:"Courier New"'>Attached
is the SCSI H/W handler part of this patch.<o:p></o:p></span></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

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

--_000_D8C50530D6022F40A817A35C40CC06A7064AFC9440DUBX7MCDUB01E_--

--_004_D8C50530D6022F40A817A35C40CC06A7064AFC9440DUBX7MCDUB01E_
Content-Type: application/octet-stream;
	name="scsi-scsi_dh-handle_device-deletion.patch"
Content-Description: scsi-scsi_dh-handle_device-deletion.patch
Content-Disposition: attachment;
	filename="scsi-scsi_dh-handle_device-deletion.patch"; size=2489;
	creation-date="Wed, 15 Dec 2010 08:20:37 GMT";
	modification-date="Wed, 15 Dec 2010 08:19:25 GMT"
Content-Transfer-Encoding: base64

RnJvbTogTWVubnkgSGFtYnVyZ2VyIDxNZW5ueV9IYW1idXJnZXJARGVsbC5jb20+ClN1YmplY3Q6
IFtzY3NpXSBzY3NpX2RoOiBoYW5kbGVyIFNDU0kgZGV2aWNlIGRlbGV0aW9uIGNvcnJlY3RseSBi
eSB0aGUgU0NTSSBkZXZpY2UgaGFuZGxlcgpCdWd6aWxsYTogNjQ1MzQzCgpXaGVuIGEgU0NTSSBk
ZXZpY2UgYXR0YWNoZWQgdG8gYSBkZXZpY2UgaGFuZGxlciBpcyBkZWxldGVkLCB1c2VybGFuZCBw
cm9jZXNzZXMgY3VycmVudGx5IHBlcmZvcm1pbmcgSS9PIG9uIHRoZSBkZXZpY2Ugd2lsbCBJL08g
aGFuZyBmb3JldmVyLgoKV2hlbiBzY3NpX2RoX2FjdGl2YXRlIHJldHVybnMgU0NTSV9ESF9OT1NZ
UyB0aGUgYWN0aXZhdGVfY29tcGxldGUgY2FsbGJhY2sgaXMgbm90IGNhbGxlZCBhbmQgdGhlIGVy
cm9yIGlzIG5vdCBwcm9wYWdhdGVkIHRvIHRoZSBtZCBsYXllci4KQSBzaW1pbGFyIHNpdHVhdGlv
biBvY2N1cnMgd2hlbiB0aGUgaGFuZGxlciBpcyBpbiB0aGUgcHJvY2VzcyBvZiBiZWluZyBkZWxl
dGVkIChlLmcuIHRoZSBTQ1NJIGRldmljZSBpcyBpbiBhIFNERVZfQ0FOQ0VMIG9yIFNERVZfREVM
IHN0YXRlKS4KClRoZSBwYXRjaCB3YXMgdGVzdGVkIGluIGFuIElTQ1NJIGVudmlyb25tZW50LCBS
REFDIEgvVyBoYW5kbGVyIGFuZCBtdWx0aXBhdGguCkluIHRoZSBmb2xsb3dpbmcgcmVwcm9kdWN0
aW9uIHByb2Nlc3MsIGRkIHdpbGwgSS9PIGhhbmcgZm9yZXZlciBhbmQgdGhlIG9ubHkgd2F5IHRv
IHJlbGVhc2UgaXQgd2lsbCBiZSB0byByZWJvb3QgdGhlIG1hY2hpbmU6CjEpIFBlcmZvcm0gSS9P
IG9uIGEgbXVsdGlwYXRoIGRldmljZToKICAgIGRkIGlmPS9kZXYvZG0tMCBvZj0vZGV2L3plcm8g
YnM9OGsgY291bnQ9MTAwMDAwMCAmCjIpIERlbGV0ZSBhbGwgc2xhdmUgU0NTSSBkZXZpY2VzIGNv
bnRhaW5lZCBpbiB0aGUgZG06CiAgIEkpICBJbiBhbiBJU0NTSSBlbnZpcm9ubWVudCwgdGhlIGVh
c2llc3Qgd2F5IHRvIGRvIHRoaXMgaXMgYnkgc3RvcHBpbmcgSVNDU0k6CiAgICAgICAvZXRjL2lu
aXQuZC9pc2NzaSBzdG9wCiAgIElJKSBBbm90aGVyIHdheSB0byBkZWxldGUgdGhlIGRldmljZXMg
aXMgYnkgYXBwbHlpbmcgdGhlIGZvbGxvd2luZyBiYXNoIHNjcmlwdGxldDoKICAgICAgIGRtX2Rl
dnM9JChscyAvc3lzL2Jsb2NrLyB8IGdyZXAgZG0tIHwgeGFyZ3MpCiAgICAgICBmb3IgZG1fZGV2
IGluICRkbV9kZXZzOyBkbwogICAgICAgICBkZXZpY2VzPSQobHMgL3N5cy9ibG9jay8kZG1fZGV2
L3NsYXZlcykKICAgICAgICAgZm9yIGRldmljZSBpbiAkZGV2aWNlczsgZG8KICAgICAgICAgICAg
ZWNobyAxID4gL3N5cy9ibG9jay8kZGV2aWNlL2RldmljZS9kZWxldGUKICAgICAgICAgZG9uZQog
ICAgICAgZG9uZQoKVGhpcyBwYXRjaCBjYWxscyB0aGUgYWN0aXZhdGVfY29tcGxldGUgY2FsbGJh
Y2sgZnVuY3Rpb24gZGlyZWN0bHkgZnJvbSBzY3NpX2RoX2FjdGl2YXRlIHdoZW4gZWl0aGVyIHRo
ZSBzY3NpX2RoIGludGVybmFsIGRhdGEgaGFzIGFscmVhZHkgCmJlZW4gZGVsZXRlZCBvciBpcyBp
biB0aGUgcHJvY2VzcyBvZiBiZWluZyBkZWxldGVkLgoKTm90ZToKVGhlIHBhdGNoIGlzIG92ZXIg
UkhFTDUuNSwgd2hpY2ggZG9lcyBub3QgaW5jbHVkZSBibG9jayBkZXZpY2UgcmVxdWVzdCBxdWV1
ZSBhYm9ydCBmdW5jdGlvbmFsaXR5LgpXaGVuIHJ1bm5pbmcgYW4gdXBzdHJlYW0ga2VybmVsLCB0
aGUgYWJvdmUgc2NlbmFyaW8gbWF5IG5vdCBvY2N1ciBiZWNhdXNlIHRoZSByZXF1ZXN0IHF1ZXVl
IGlzIGFib3J0ZWQgd2hlbiB0aGUgbXVsdGlwYXRoIGZhaWxzIHRoZSBwYXRoLgpUaGlzIHBhdGNo
IG1ha2VzIHN1cmUgdGhlIHByb2JsZW0gZG9lcyBub3QgaGFwcGVuIGF0IGFsbCwgcmF0aGVyIHRo
YW4gaGFuZGxlIGl0IHdoZW4gaXQgZG9lcy4gCgpkaWZmIC1yIC1VIDIgYS9kcml2ZXJzL3Njc2kv
ZGV2aWNlX2hhbmRsZXIvc2NzaV9kaC5jIGIvZHJpdmVycy9zY3NpL2RldmljZV9oYW5kbGVyL3Nj
c2lfZGguYwotLS0gYS9kcml2ZXJzL3Njc2kvZGV2aWNlX2hhbmRsZXIvc2NzaV9kaC5jCTIwMTAt
MTItMTUgMTA6MTk6MjUuNjg1ODkzMDAwICswMjAwCisrKyBiL2RyaXZlcnMvc2NzaS9kZXZpY2Vf
aGFuZGxlci9zY3NpX2RoLmMJMjAxMC0xMi0xNSAxMDoxOToyNS43Mzg3ODQwMDAgKzAyMDAKQEAg
LTQ0Myw2ICs0NDMsMTQgQEAKIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKHEtPnF1ZXVlX2xvY2ss
IGZsYWdzKTsKIAotCWlmIChlcnIpCisJaWYgKHNkZXYtPnNkZXZfc3RhdGUgPT0gU0RFVl9DQU5D
RUwgfHwKKwkgICAgc2Rldi0+c2Rldl9zdGF0ZSA9PSBTREVWX0RFTCB8fAorCSAgICBzZGV2LT5z
ZGV2X3N0YXRlID09IFNERVZfT0ZGTElORSkKKwkJZXJyID0gU0NTSV9ESF9ERVZfT0ZGTElORUQ7
CisKKwlpZiAoZXJyKSB7CisJCWlmIChmbikKKwkJCWZuKGZuX2RhdGEsIGVycik7CiAJCXJldHVy
biBlcnI7CisJfQogCiAJaWYgKHNjc2lfZGgtPmFjdGl2YXRlKQo=

--_004_D8C50530D6022F40A817A35C40CC06A7064AFC9440DUBX7MCDUB01E_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_004_D8C50530D6022F40A817A35C40CC06A7064AFC9440DUBX7MCDUB01E_--
