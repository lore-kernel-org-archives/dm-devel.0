From: Chaitra Bhat <Chaitra.Bhat@VERIFONE.com>
Subject: dm-verity: Verification fails but do not see
 Input/Output Error on read
Date: Thu, 8 Aug 2013 09:01:44 +0000
Message-ID: <20847BF06520E04D933186677BF7B724D1F523@VF2WDEXMB1.verifone.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5254640593749474671=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5254640593749474671==
Content-Type: multipart/signed;
	boundary="PGP_Universal_3034362E_5DAD21DF_8FC4ECF0_3D634E0D";
	protocol="application/pgp-signature"; micalg=pgp-sha512

--PGP_Universal_3034362E_5DAD21DF_8FC4ECF0_3D634E0D
Content-Language: en-GB
Content-Type: multipart/alternative;
	boundary="_000_20847BF06520E04D933186677BF7B724D1F523VF2WDEXMB1verifon_"

--_000_20847BF06520E04D933186677BF7B724D1F523VF2WDEXMB1verifon_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi All,

I am currently experimenting with dm-verity. I was able to successfully set=
-up a dm-verity target and mount it as a read-only filesystem.

But when I was testing the functionality of dm-verity, I found this. As sug=
gested by Will Drewry in one of his e-mails, I used dd to write over the un=
derlying block device, then tried to dd it out via the dm-verity device. I =
did not get EIO when I did this.

I then did a veritysetup verify and it said "Verification failed at positio=
n x", with 'x' being the position I had modified using dd.

So, any idea why do I not get Input/Output Error message when I know that v=
erification is failing at that location?

(Yes, I did drop the caches before reading)

-Chaitra
________________________________
This electronic message, including attachments, is intended only for the us=
e of the individual or company named above or to which it is addressed. The=
 information contained in this message shall be considered confidential and=
 proprietary, and may include confidential work product. If you are not the=
 intended recipient, please be aware that any unauthorized use, disseminati=
on, distribution or copying of this message is strictly prohibited. If you =
have received this email in error, please notify the sender by replying to =
this message and deleting this email immediately.

--_000_20847BF06520E04D933186677BF7B724D1F523VF2WDEXMB1verifon_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html dir=3D"ltr">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style id=3D"owaParaStyle" type=3D"text/css">
<!--
p
	{margin-top:0;
	margin-bottom:0}
-->
</style>
</head>
<body>
<div style=3D"direction:ltr; font-family:Tahoma; color:#000000; font-size:1=
0pt">Hi All,<br>
<br>
I am currently experimenting with dm-verity. <font size=3D"2"><span style=
=3D"font-size:10pt"></span></font>I was able to successfully set-up a dm-ve=
rity target and mount it as a read-only filesystem.<br>
<br>
But when I was testing the functionality of dm-verity, I found this. As sug=
gested by Will Drewry in one of his e-mails, I used dd to write over the un=
derlying block device, then tried to dd it out via the dm-verity device. I =
did not get EIO when I did this.<br>
<br>
I then did a veritysetup verify and it said &quot;Verification failed at po=
sition x&quot;, with 'x' being the position I had modified using dd.<br>
<br>
So, any idea why do I not get Input/Output Error message when I know that v=
erification is failing at that location?<br>
<br>
(Yes, I did drop the caches before reading)<br>
<br>
-Chaitra<br>
</div>
<hr>
<font face=3D"VERDANA" color=3D"GRAY" size=3D"2">This electronic message, i=
ncluding attachments, is intended only for the use of the individual or com=
pany named above or to which it is addressed. The information contained in =
this message shall be considered confidential
 and proprietary, and may include confidential work product. If you are not=
 the intended recipient, please be aware that any unauthorized use, dissemi=
nation, distribution or copying of this message is strictly prohibited. If =
you have received this email in
 error, please notify the sender by replying to this message and deleting t=
his email immediately.</font>
</body>
</html>

--_000_20847BF06520E04D933186677BF7B724D1F523VF2WDEXMB1verifon_--

--PGP_Universal_3034362E_5DAD21DF_8FC4ECF0_3D634E0D
Content-Type: application/pgp-signature; x-mac-type=70674453; name="PGP.sig"
Content-Disposition: attachment; filename="PGP.sig"

-----BEGIN PGP SIGNATURE-----
Version: PGP Universal 3.2.0 (Build 2599)

iQIVAwUBUgNfIfoDVUR++NlrAQo4WxAAqLYrstFS4r4pFJot2D6D8NL4NJ0LXMoB
w+TMInG6wEKzf9ye1OliS0rAxSl8zdQwvUk4DS9bG9M0HquBDlXi42NmHYoaJEzp
XOcgxwzBCXpnN/15BvJV0X9xoghbbD6qCamSQeve54gw0jsmOkvlxejtvVqiKeli
kM9hlV1YrQJJ2gP+hhgmJfwX6QXARCq41g17o5ES9a4KUIMflVy2I9KAERUAlxER
rGC0jVFGs2aZd/3GNCsg9RMN689FMe9o9BXM9LbTrFGuoQj0C2S9Z96egycQL96B
WuvLb8ovRzVIMwp8ito2ITwl/Y5XoRO+aawLm4d4EdzMjAk1GbldMSDWJLIOmA6e
T2kLxNFKXqxSQaBwIM1nWqsAkYeSGYg5LRR9XWbH/+lt/YjgcZQw1DHPpvSt/Qqk
OroVlJGVjJV+Ko4Mvf0L0cAJlZIlhBoj+pWHDgZa7IXpkAjh6A8b4cxNI9iU5AqF
Txzgia1bcSpb4HIIJQ6dXDYmIRySIdXtf+d/aF/GRFTJYHFPXPLNfBTqMFq4LAJb
8eZ4KztVNYItmertl5O4RrCh7M9CLvHLqdLlnRqWEo0b3iXFA5B131wtt1+gsD/7
VRGONhkuAIoFGOsit77N3noFcGsWtwMpUQS9k/x6AC5VJHqlO5KKF334/iqcV6+R
ayln5qyS5QA=
=Ct6F
-----END PGP SIGNATURE-----

--PGP_Universal_3034362E_5DAD21DF_8FC4ECF0_3D634E0D--


--===============5254640593749474671==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5254640593749474671==--
