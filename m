From: bart brooks <bart_brooks@hotmail.com>
Subject: RE: PATCH to Add Pivot3 to multipath-tools
Date: Wed, 17 Oct 2007 12:59:03 +0000
Message-ID: <BAY128-W36B1DEC3EA643FCBE077109D9D0@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_d36dd19f-67cc-4a6e-8b48-b14710be7899_"
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
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, christophe.varoqui@free.fr
List-Id: dm-devel.ids

--_d36dd19f-67cc-4a6e-8b48-b14710be7899_
Content-Type: multipart/alternative;
	boundary="_a02adcfe-e116-4481-9163-609067585b6a_"

--_a02adcfe-e116-4481-9163-609067585b6a_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Hello Hannes, Sorry an old version of the patch was submitted.An updated ve=
rsion is attached, which uses scsi_id and and the DEFAULT_HWHANDLER - Bart>=
 Date: Wed, 17 Oct 2007 08:37:53 +0200> From: hare@suse.de> To: bart_brooks=
@hotmail.com> CC: dm-devel@redhat.com; christophe.varoqui@free.fr> Subject:=
 Re: [dm-devel] PATCH to Add Pivot3 to multipath-tools> > bart brooks wrote=
:> > Hello,> > > > I have put together a patch, which adds Pivot3 RAIGE sup=
port to multipath-tools.> > > > Could you please apply.> > > And could you =
please submit the 'pivot3' hardware handler?> And what exactly is the diffe=
rence between 'scsi_id' and 'scsi_id-p3'?> Do you have any patches for this=
?> > Cheers,> > Hannes> -- > Dr. Hannes Reinecke zSeries & Storage> hare@su=
se.de +49 911 74053 688> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=
=FCrnberg> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
_________________________________________________________________
Help yourself to FREE treats served up daily at the Messenger Caf=E9. Stop =
by today.
http://www.cafemessenger.com/info/info_sweetstuff2.html?ocid=3DTXT_TAGLM_Oc=
tWLtagline=

--_a02adcfe-e116-4481-9163-609067585b6a_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style>
.hmmessage P
{
margin:0px;
padding:0px
}
body.hmmessage
{
FONT-SIZE: 10pt;
FONT-FAMILY:Tahoma
}
</style>
</head>
<body class=3D'hmmessage'>
<BR>Hello Hannes,<BR>&nbsp;<BR>Sorry an old version of the patch was submit=
ted.<BR>An updated version is attached, which uses scsi_id and and the DEFA=
ULT_HWHANDLER -<BR>&nbsp;<BR>Bart<BR><BR>&gt; Date: Wed, 17 Oct 2007 08:37:=
53 +0200<BR>&gt; From: hare@suse.de<BR>&gt; To: bart_brooks@hotmail.com<BR>=
&gt; CC: dm-devel@redhat.com; christophe.varoqui@free.fr<BR>&gt; Subject: R=
e: [dm-devel] PATCH to Add Pivot3 to multipath-tools<BR>&gt; <BR>&gt; bart =
brooks wrote:<BR>&gt; &gt; Hello,<BR>&gt; &gt; <BR>&gt; &gt; I have put tog=
ether a patch, which adds Pivot3 RAIGE support to multipath-tools.<BR>&gt; =
&gt; <BR>&gt; &gt; Could you please apply.<BR>&gt; &gt; <BR>&gt; And could =
you please submit the 'pivot3' hardware handler?<BR>&gt; And what exactly i=
s the difference between 'scsi_id' and 'scsi_id-p3'?<BR>&gt; Do you have an=
y patches for this?<BR>&gt; <BR>&gt; Cheers,<BR>&gt; <BR>&gt; Hannes<BR>&gt=
; -- <BR>&gt; Dr. Hannes Reinecke zSeries &amp; Storage<BR>&gt; hare@suse.d=
e +49 911 74053 688<BR>&gt; SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 =
N=FCrnberg<BR>&gt; GF: Markus Rex, HRB 16746 (AG N=FCrnberg)<BR><BR><br /><=
hr />Help yourself to FREE treats served up daily at the Messenger Caf=E9. =
<a href=3D'http://www.cafemessenger.com/info/info_sweetstuff2.html?ocid=3DT=
XT_TAGLM_OctWLtagline' target=3D'_new'>Stop by today!</a></body>
</html>=

--_a02adcfe-e116-4481-9163-609067585b6a_--

--_d36dd19f-67cc-4a6e-8b48-b14710be7899_
Content-Type: text/plain
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="pivot3-multipath-tools"

ZGlmZiAtTmF1cnAgbXVsdGlwYXRoLXRvb2xzLTAuNC44LW9yaWcvbGlibXVsdGlwYXRoL2h3dGFi
bGUuYyBtdWx0aXBhdGgtdG9vbHMtMC40LjgvbGlibXVsdGlwYXRoL2h3dGFibGUuYw0KLS0tIG11
bHRpcGF0aC10b29scy0wLjQuOC1vcmlnL2xpYm11bHRpcGF0aC9od3RhYmxlLmMJMjAwNy0xMC0x
MiAxODoyMDozMC4wMDAwMDAwMDAgLTA0MDANCisrKyBtdWx0aXBhdGgtdG9vbHMtMC40LjgvbGli
bXVsdGlwYXRoL2h3dGFibGUuYwkyMDA3LTEwLTE3IDA3OjUyOjM1LjAwMDAwMDAwMCAtMDQwMA0K
QEAgLTU5MCw2ICs1OTAsMjcgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9
IHsNCiAJCS5taW5pbyAgICAgICAgID0gREVGQVVMVF9NSU5JTywNCiAJCS5jaGVja2VyX25hbWUg
ID0gUkVBRFNFQ1RPUjAsDQogCX0sDQorIAkvKg0KKwkgKiBQaXZvdDMgUkFJR0UNCisJICoNCisJ
ICogTWFpbnRhaW5lciA6IEJhcnQgQnJvb2tzLCBQaXZvdDMNCisJICogTWFpbCA6IGJhcnRiQHBp
dm90My5jb20NCisJICovDQorCXsNCisJCS52ZW5kb3IgICAgICAgID0gIlBJVk9UMyIsDQorCQku
cHJvZHVjdCAgICAgICA9ICJSQUlHRSBWT0xVTUUiLA0KKwkJLmdldHVpZCAgICAgICAgPSAiL3Ni
aW4vc2NzaV9pZCAtcCAweDgwIC1nIC11IC1zIC9ibG9jay8lbiIsDQorCQkuZ2V0cHJpbyAgICAg
ICA9IE5VTEwsDQorCQkuZmVhdHVyZXMgICAgICA9ICIxIHF1ZXVlX2lmX25vX3BhdGgiLA0KKwkJ
Lmh3aGFuZGxlciAgICAgPSBERUZBVUxUX0hXSEFORExFUiwNCisJCS5zZWxlY3RvciAgICAgID0g
REVGQVVMVF9TRUxFQ1RPUiwNCisJCS5wZ3BvbGljeSAgICAgID0gTVVMVElCVVMsDQorCQkucGdm
YWlsYmFjayAgICA9IEZBSUxCQUNLX1VOREVGLA0KKwkJLnJyX3dlaWdodCAgICAgPSBSUl9XRUlH
SFRfTk9ORSwNCisJCS5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9VTkRFRiwNCisJCS5t
aW5pbyAgICAgICAgID0gMTAwLA0KKwkJLmNoZWNrZXJfbmFtZSAgPSBUVVIsDQorCX0sDQogCS8q
DQogCSAqIEVPTA0KIAkgKi8NCmRpZmYgLU5hdXJwIG11bHRpcGF0aC10b29scy0wLjQuOC1vcmln
L211bHRpcGF0aC5jb25mLnN5bnRoZXRpYyBtdWx0aXBhdGgtdG9vbHMtMC40LjgvbXVsdGlwYXRo
LmNvbmYuc3ludGhldGljDQotLS0gbXVsdGlwYXRoLXRvb2xzLTAuNC44LW9yaWcvbXVsdGlwYXRo
LmNvbmYuc3ludGhldGljCTIwMDctMTAtMTIgMTg6MjA6MzAuMDAwMDAwMDAwIC0wNDAwDQorKysg
bXVsdGlwYXRoLXRvb2xzLTAuNC44L211bHRpcGF0aC5jb25mLnN5bnRoZXRpYwkyMDA3LTEwLTE3
IDA3OjUzOjM2LjAwMDAwMDAwMCAtMDQwMA0KQEAgLTY3LDQgKzY3LDE2IEBADQogIwkJcHJvZHVj
dAkJCSJNU0ExMDAwICAgICAgICAgIg0KICMJCXBhdGhfZ3JvdXBpbmdfcG9saWN5CW11bHRpYnVz
DQogIwl9DQorIwlkZXZpY2Ugew0KKyMJCSMgUGl2b3QzIFJBSUdFICBhcnJheQ0KKyMJCXZlbmRv
cgkJCSJQSVZPVDMiDQorIwkJcHJvZHVjdAkJCSJSQUlHRSBWT0xVTUUiDQorIwkJcGF0aF9ncm91
cGluZ19wb2xpY3kJbXVsdGlidXMNCisjCQlnZXR1aWRfY2FsbG91dCAgICAgICAgICAiL3NiaW4v
c2NzaV9pZCAtcCAweDgwIC1nIC11IC1zIC9ibG9jay8lbiINCisjCQlwYXRoX2NoZWNrZXIJCXR1
cg0KKyMJCXBhdGhfc2VsZWN0b3IJCSJyb3VuZC1yb2JpbiAwIg0KKyMJCWhhcmR3YXJlX2hhbmRs
ZXIJIjAiDQorIwkJZmFpbGJhY2sJCWltbWVkaWF0ZQ0KKyMJCXJyX21pbl9pbwkJMTAwDQorIwl9
DQogI30NCg==

--_d36dd19f-67cc-4a6e-8b48-b14710be7899_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_d36dd19f-67cc-4a6e-8b48-b14710be7899_--
