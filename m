From: Chaitra Bhat <Chaitra.Bhat@VERIFONE.com>
Subject: Re: dm-verity: Verification fails but do not see
 Input/Output Error on read
Date: Thu, 15 Aug 2013 09:36:28 +0000
Message-ID: <20847BF06520E04D933186677BF7B72401AF140E@VF2WDEXMB1.verifone.com>
References: <20847BF06520E04D933186677BF7B724D1F523@VF2WDEXMB1.verifone.com>,
	<20130808121858.GB31819@agk-dp.fab.redhat.com>
	<20847BF06520E04D933186677BF7B724D1F55D@VF2WDEXMB1.verifone.com>,
	<alpine.LRH.2.02.1308080849500.15699@file01.intranet.prod.int.rdu2.redhat.com>
	<20847BF06520E04D933186677BF7B724D1F58F@VF2WDEXMB1.verifone.com>,
	<alpine.LRH.2.02.1308081256540.20081@file01.intranet.prod.int.rdu2.redhat.com>
	<20847BF06520E04D933186677BF7B724D231DC@VF2WDEXMB1.verifone.com>,
	<alpine.LRH.2.02.1308142022070.14155@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0786128188084118063=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1308142022070.14155@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

--===============0786128188084118063==
Content-Type: multipart/signed;
	boundary="PGP_Universal_B0240285_E14A393C_FF25AA81_7A198DFD";
	protocol="application/pgp-signature"; micalg=pgp-sha512

--PGP_Universal_B0240285_E14A393C_FF25AA81_7A198DFD
Content-Language: en-GB
Content-Type: multipart/mixed;
	boundary="_002_20847BF06520E04D933186677BF7B72401AF140EVF2WDEXMB1verif_"

--_002_20847BF06520E04D933186677BF7B72401AF140EVF2WDEXMB1verif_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Mikulas,

I have attached a simple script to demonstrate what I was trying to tell. I=
t is based on the verify-compat-test script. Feel free to modify the script=
; the script is basically to get the idea across.

For the Successful Case
#source script_test
#check_root_hash  512 9de18652fe74edfb9b805aaed72ae2aa48f94333f1ba5c452ac33=
b1c39325174 $SALT 1 sha256 2

For the Failure Case
#source script_test
#check_root_hash  512 9de18652fe74edfb9b805aaed72ae2aa48f94333f1ba5c452ac33=
b1c39325174 $SALT 1 sha256 1

Regards,
Chaitra
________________________________________
From: Mikulas Patocka [mpatocka@redhat.com]
Sent: 15 August 2013 01:23
To: Chaitra Bhat
Cc: device-mapper development; Alasdair G Kergon
Subject: RE: [dm-devel] dm-verity: Verification fails but do not see Input/=
Output Error on read

On Tue, 13 Aug 2013, Chaitra Bhat wrote:

> Hi Mikulas,
>
> I figured out what was happening - but I would need your help to explain
> these behaviours please :)
>
> Case I - Format the hash device, verify and create the dm-verity target.
> Then modify data in the underlying data-device using dd. Read back the
> data from the modified location from the verity-device.
>
> Result: Verify fails but 'NO' I/O error reported when reading back from
> the location using dd.

So, create a script that results in this scenario of not reporting I/O
error and send it to us.

Mikulas

> Case II - Format the hash device, verify and create the dm-verity target
> device. Remove the verity target, then modify the data in the
> data-device using dd. Load the verity target and read-back the data from
> the verity-device from the modified location.
>
> Result: Verify fails and also get I/O error on reading that location
> using dd.
>
> My understanding was that the verity-device could be created and mounted
> and then if the underlying data was corrupted somehow, then a read of
> invalid data from that corrupted location will return -EIO.
>
> Chaitra
>
> PS: I was following the examples in the verity-compat-test script.

________________________________
This electronic message, including attachments, is intended only for the us=
e of the individual or company named above or to which it is addressed. The=
 information contained in this message shall be considered confidential and=
 proprietary, and may include confidential work product. If you are not the=
 intended recipient, please be aware that any unauthorized use, disseminati=
on, distribution or copying of this message is strictly prohibited. If you =
have received this email in error, please notify the sender by replying to =
this message and deleting this email immediately.

--_002_20847BF06520E04D933186677BF7B72401AF140EVF2WDEXMB1verif_
Content-Type: application/x-shellscript; name="script_test.sh"
Content-Description: script_test.sh
Content-Disposition: attachment;
	modification-date="Thu, 15 Aug 2013 09:35:26 GMT";
	creation-date="Thu, 15 Aug 2013 09:35:26 GMT"; size=2776;
	filename="script_test.sh"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKClZFUklUWVNFVFVQPXZlcml0eXNldHVwCgpERVZfTkFNRT12ZXIKREVWX09V
VD0iJERFVl9OQU1FLm91dCIKSU1HPXZlcml0eS1kYXRhCklNR19IQVNIPXZlcml0eS1oYXNoCgpT
QUxUPWU0OGRhNjA5MDU1MjA0ZTg5YWU1M2I2NTVjYTIyMTZkZDk4M2NmM2NiODI5ZjM0ZjYzYTI5
N2QxMDZkNTNlMmQKCmZ1bmN0aW9uIHJlbW92ZV9tYXBwaW5nKCkKewoJWyAtYiAvZGV2L21hcHBl
ci8kREVWX05BTUUgXSAmJiBkbXNldHVwIHJlbW92ZSAkREVWX05BTUUKCVsgISAteiAiJExPT1BE
RVYxIiBdICYmIGxvc2V0dXAgLWQgJExPT1BERVYxID4vZGV2L251bGwgMj4mMQoJcm0gLWYgJElN
RyAkSU1HX0hBU0ggJERFVl9PVVQgPi9kZXYvbnVsbCAyPiYxCglMT09QREVWMT0iIgoJTE9PUERF
VjI9IiIKfQoKZnVuY3Rpb24gZmFpbCgpCnsKCVsgLW4gIiQxIiBdICYmIGVjaG8gIiQxIgoJZWNo
byAiRkFJTEVEIgoJWyAtZiAkREVWX09VVCBdICYmIGNhdCAkREVWX09VVAoJcmVtb3ZlX21hcHBp
bmcKCWV4aXQgMgp9CgpmdW5jdGlvbiBza2lwKCkKewoJWyAtbiAiJDEiIF0gJiYgZWNobyAiJDEi
CglleGl0IDAKfQoKZnVuY3Rpb24gcHJlcGFyZSgpICMgJDEgZGV2MV9zaXogWyQyIGRldjJfc2l6
ZV0KewoJcmVtb3ZlX21hcHBpbmcKCglkZCBpZj0vZGV2L3plcm8gb2Y9JElNRyBicz0xayBjb3Vu
dD0kMSA+L2Rldi9udWxsIDI+JjEKCUxPT1BERVYxPSQobG9zZXR1cCAtZiAyPi9kZXYvbnVsbCkK
CVsgLXogIiRMT09QREVWMSIgXSAmJiBmYWlsICJObyBmcmVlIGxvb3AgZGV2aWNlIgoJbG9zZXR1
cCAkTE9PUERFVjEgJElNRwoKCVsgLXogIiQyIiBdICYmIHJldHVybgoJTE9PUERFVjI9JElNR19I
QVNICn0KCmZ1bmN0aW9uIHdpcGUoKQp7CglkZCBpZj0vZGV2L3plcm8gb2Y9JExPT1BERVYxIGJz
PTI1NmsgPi9kZXYvbnVsbCAyPiYxCglybSAtZiAkSU1HX0hBU0ggJERFVl9PVVQgPi9kZXYvbnVs
bCAyPiYxCn0KCmZ1bmN0aW9uIGNoZWNrX2V4aXN0cygpCnsKCVsgLWIgL2Rldi9tYXBwZXIvJERF
Vl9OQU1FIF0gfHwgZmFpbAp9CgpmdW5jdGlvbiBjb21wYXJlX291dCgpICMgJDEgd2hhdCwgJDIg
ZXhwZWN0ZWQKewoJT1BUPSQoZ3JlcCAtdiAiXiMiICRERVZfT1VUIHwgZ3JlcCAtaSAiJDEiIHwg
c2VkIC1lIHMvLipcOlwgLy8gKQoJWyAteiAiJE9QVCIgXSAmJiBmYWlsCglbICRPUFQgIT0gJDIg
XSAmJiBmYWlsICIkMSBkaWZmZXJzICgkMikiCn0KCmZ1bmN0aW9uIGNoZWNrX3Jvb3RfaGFzaCgp
ICMgJDEgc2l6ZSwgJDIgaGFzaCwgJDMgc2FsdCwgJDQgdmVyc2lvbiwgJDUgaGFzaCwgJDYgY2Fz
ZQp7CglyZW1vdmVfbWFwcGluZwoKCXByZXBhcmUgODE5MiAxMDI0CgoJREVWX1BBUkFNUz0iJExP
T1BERVYxICRMT09QREVWMiIKCglGT1JNQVRfUEFSQU1TPSItLWZvcm1hdD0kNCAtLWRhdGEtYmxv
Y2stc2l6ZT0kMSAtLWhhc2gtYmxvY2stc2l6ZT0kMSAtLWhhc2g9JDUgLS1zYWx0PSQzIgoJVkVS
SUZZX1BBUkFNUz0iIgoKCXdpcGUKCXNsZWVwIDEKCSRWRVJJVFlTRVRVUCBmb3JtYXQgJERFVl9Q
QVJBTVMgJEZPUk1BVF9QQVJBTVMgPiRERVZfT1VUIHx8IGZhaWwKCgllY2hvIC1uICJbcm9vdCBo
YXNoXSIKCWNvbXBhcmVfb3V0ICJyb290IGhhc2giICQyCgljb21wYXJlX291dCAic2FsdCIgIiQz
IgoKCSRWRVJJVFlTRVRVUCB2ZXJpZnkgJERFVl9QQVJBTVMgJFZFUklGWV9QQVJBTVMgJDIgPj4k
REVWX09VVCAyPiYxIHx8IGZhaWwKCWVjaG8gLW4gIlt2ZXJpZnldIgoKCSRWRVJJVFlTRVRVUCBj
cmVhdGUgJERFVl9OQU1FICRERVZfUEFSQU1TICRWRVJJRllfUEFSQU1TICQyID4+JERFVl9PVVQg
Mj4mMSB8fCBmYWlsCgljaGVja19leGlzdHMKCWVjaG8gLW4gIlthY3RpdmF0ZV0iCgoJI1N1Y2Nl
c3MgQ2FzZQoJaWYgWyAkNiA9ICIyIiBdIDsgdGhlbgoKCQkjIENhc2UgSSAtIEdldCBJL08gRXJy
b3Igb24gcmVhZGluZwoKCQkkVkVSSVRZU0VUVVAgcmVtb3ZlICRERVZfTkFNRSB8fCBmYWlsCgkJ
ZWNobyAtbiAiW3JlbW92ZV0iCgoJCWRkIGlmPS9kZXYvdXJhbmRvbSBvZj0kTE9PUERFVjEgYnM9
MSBzZWVrPTM0NTYgY291bnQ9OCBjb252PW5vdHJ1bmMgMj4vZGV2L251bGwKCgkJJFZFUklUWVNF
VFVQIHZlcmlmeSAkREVWX1BBUkFNUyAkVkVSSUZZX1BBUkFNUyAkMiA+PiRERVZfT1VUIDI+JjEg
JiYgXAoJCQlmYWlsICJ2ZXJpZnkgZmFpbHMiCgoJCSRWRVJJVFlTRVRVUCBjcmVhdGUgJERFVl9O
QU1FICRERVZfUEFSQU1TICRWRVJJRllfUEFSQU1TICQyID4+JERFVl9PVVQgMj4mMSB8fCBcCgkJ
CWZhaWwgImFjdGl2YXRpb24iCgoJCWRkIGlmPS9kZXYvZG0tMCBvZj0vZGV2L251bGwgYnM9MSBz
a2lwPTM0NTYgY291bnQ9OCA+PiRERVZfT1VUIDI+JjEKCgllbHNlICNGYWlsdXJlIENhc2UKCQkK
CQkjIENhc2UgSUkgLSBObyBJL08gRXJyb3Igb24gcmVhZGluZwoKICAgICAgICBkZCBpZj0vZGV2
L3VyYW5kb20gb2Y9JExPT1BERVYxIGJzPTEgc2Vlaz0zNDU2IGNvdW50PTggY29udj1ub3RydW5j
IDI+L2Rldi9udWxsCgkJCgkJc2xlZXAgMQoKICAgICAgICAkVkVSSVRZU0VUVVAgdmVyaWZ5ICRE
RVZfUEFSQU1TICRWRVJJRllfUEFSQU1TICQyID4+JERFVl9PVVQgJiYgXAogICAgICAgICAgICBm
YWlsICJ2ZXJpZnkgZmFpbHMiCgogICAgICAgIGRkIGlmPS9kZXYvZG0tMCBvZj0vZGV2L251bGwg
YnM9MSBza2lwPTM0NTYgY291bnQ9OCA+PiRERVZfT1VUIAoKCWZpCgoJJFZFUklUWVNFVFVQIHJl
bW92ZSAkREVWX05BTUUgfHwgZmFpbCAiZGVhY3RpdmF0aW9uIgp9Cg==
--_002_20847BF06520E04D933186677BF7B72401AF140EVF2WDEXMB1verif_--

--PGP_Universal_B0240285_E14A393C_FF25AA81_7A198DFD
Content-Type: application/pgp-signature; x-mac-type=70674453; name="PGP.sig"
Content-Disposition: attachment; filename="PGP.sig"

-----BEGIN PGP SIGNATURE-----
Version: PGP Universal 3.2.0 (Build 2599)

iQIVAwUBUgyhMPoDVUR++NlrAQr1Jg//dJuzZ7J8yWfjGFy9ejpq4AU6hxxaM5OL
oi7nCdkl3S1ETiynF4G1dPyI/s23qOrGolGC1gsdolr3p81Z7RF2cVCb821m/U1O
EpqCfC9oPVfDTh+HoITVVKxx28ih7b6Jax0N9Mi9VC2eNFIjpsmB45rKBHfOi2RK
QYapTD7Yt1/S7brB0Q2PBl5WcXCdAThR0PzL5X8xi+ZWhQL88f4KiebzhA94QMdt
FwQ26/yE6b1tvRyHr22QtzVYI6lVfbvI5fxKD3PlPHZmi1mMlp7umuXKv92Wuis9
Q4lVyCk0B8vZN4ttap2weKY/PoHxW+3oKFXbs6k9YKOSVE60jhsY9l4jMtYMuzV1
LpxQfRAAejG52YusIXqpUQZTGGUdddEBkQaQPDuCeM7KcFCiuiL7afHR9fl+72wi
sdWmg8qe2YcDq2aLlI4xJY7OPd8iYWXBDLVx5fZxIxiRBnYe1x2bk8x8naV9keJV
UYrfZwAu1ixQ/3es+8CBcqPjOt9be0t6nkfRf9jigOhPOoDQroNW0/LYRHVq7zHO
l1jSpWbP8pZSjVNIDqe9WOcaG6YP+MCCgfaqIisQNZVBHx+xLqIrVX/23mmdFJR0
uigo/55oc3rAqyhyIjDZMLrfTy8Tqc1JQbd5Z/sLIh83so8iZ2IzezkCK/QrRqhY
iJSSsBiO88w=
=37DA
-----END PGP SIGNATURE-----

--PGP_Universal_B0240285_E14A393C_FF25AA81_7A198DFD--


--===============0786128188084118063==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0786128188084118063==--
