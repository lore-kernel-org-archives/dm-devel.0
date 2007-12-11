From: Scott James Remnant <scott@ubuntu.com>
Subject: [PATCH] improve atomicity of device creation
Date: Tue, 11 Dec 2007 16:08:36 +0000
Message-ID: <1197389316.25082.27.camel@quest>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0346351178=="
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: dm-devel@redhat.com
Cc: linux-hotplug-devel@lists.sourceforge.net
List-Id: dm-devel.ids


--===============0346351178==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-J8dB8Ao03i3knOoqDHHL"


--=-J8dB8Ao03i3knOoqDHHL
Content-Type: multipart/mixed; boundary="=-Qayf6nXfraxENM6+hzsi"


--=-Qayf6nXfraxENM6+hzsi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This is a patch we've written and applied in Ubuntu to improve the
atomicity of devmapper device creation somewhat, and avoid races with
udev.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-Qayf6nXfraxENM6+hzsi
Content-Disposition: inline; filename=devmapper-1.02.20-atomic-mknod.patch
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name=devmapper-1.02.20-atomic-mknod.patch;
	charset=UTF-8

LS0tIGRldm1hcHBlci0xLjAyLjIwLm9yaWcvbGliL2xpYmRtLWNvbW1vbi5jDQorKysgZGV2bWFw
cGVyLTEuMDIuMjAvbGliL2xpYmRtLWNvbW1vbi5jDQpAQCAtMjUyLDEyICsyNTIsMTEgQEANCiBz
dGF0aWMgaW50IF9hZGRfZGV2X25vZGUoY29uc3QgY2hhciAqZGV2X25hbWUsIHVpbnQzMl90IG1h
am9yLCB1aW50MzJfdCBtaW5vciwNCiAJCQkgdWlkX3QgdWlkLCBnaWRfdCBnaWQsIG1vZGVfdCBt
b2RlKQ0KIHsNCi0JY2hhciBwYXRoW1BBVEhfTUFYXTsNCisJY2hhciBwYXRoW1BBVEhfTUFYXSwg
dG1wcGF0aFtQQVRIX01BWCArIDddOw0KIAlzdHJ1Y3Qgc3RhdCBpbmZvOw0KIAlkZXZfdCBkZXYg
PSBNS0RFVihtYWpvciwgbWlub3IpOw0KIAltb2RlX3Qgb2xkX21hc2s7DQotDQotCV9idWlsZF9k
ZXZfcGF0aChwYXRoLCBzaXplb2YocGF0aCksIGRldl9uYW1lKTsNCisJaW50IHJldHZhbDsNCiAN
CiAJaWYgKHN0YXQocGF0aCwgJmluZm8pID49IDApIHsNCiAJCWlmICghU19JU0JMSyhpbmZvLnN0
X21vZGUpKSB7DQpAQCAtMjY5LDMxICsyNjgsMzkgQEANCiAJCS8qIElmIHJpZ2h0IGlub2RlIGFs
cmVhZHkgZXhpc3RzIHdlIGRvbid0IHRvdWNoIHVpZCBldGMuICovDQogCQlpZiAoaW5mby5zdF9y
ZGV2ID09IGRldikNCiAJCQlyZXR1cm4gMTsNCi0NCi0JCWlmICh1bmxpbmsocGF0aCkgPCAwKSB7
DQotCQkJbG9nX2Vycm9yKCJVbmFibGUgdG8gdW5saW5rIGRldmljZSBub2RlIGZvciAnJXMnIiwN
Ci0JCQkJICBkZXZfbmFtZSk7DQotCQkJcmV0dXJuIDA7DQotCQl9DQogCX0NCiANCisJX2J1aWxk
X2Rldl9wYXRoKHBhdGgsIHNpemVvZihwYXRoKSwgZGV2X25hbWUpOw0KKwlzdHJjcHkgKHRtcHBh
dGgsIHBhdGgpOw0KKwlzdHJjYXQgKHRtcHBhdGgsICIuZG0tdG1wIik7DQorDQogCW9sZF9tYXNr
ID0gdW1hc2soMCk7DQotCWlmIChta25vZChwYXRoLCBTX0lGQkxLIHwgbW9kZSwgZGV2KSA8IDAp
IHsNCi0JCWxvZ19lcnJvcigiVW5hYmxlIHRvIG1ha2UgZGV2aWNlIG5vZGUgZm9yICclcyciLCBk
ZXZfbmFtZSk7DQorCXJldHZhbCA9IG1rbm9kKHRtcHBhdGgsIFNfSUZCTEsgfCBtb2RlLCBkZXYp
Ow0KKwl1bWFzayhvbGRfbWFzayk7DQorCWlmIChyZXR2YWwgPCAwKSB7DQorCQlsb2dfZXJyb3Io
IlVuYWJsZSB0byBtYWtlIHRlbXBvcmFyeSBkZXZpY2Ugbm9kZSBmb3IgJyVzJyIsIGRldl9uYW1l
KTsNCiAJCXJldHVybiAwOw0KIAl9DQotCXVtYXNrKG9sZF9tYXNrKTsNCiANCi0JaWYgKGNob3du
KHBhdGgsIHVpZCwgZ2lkKSA8IDApIHsNCisJaWYgKGNob3duKHRtcHBhdGgsIHVpZCwgZ2lkKSA8
IDApIHsNCiAJCWxvZ19lcnJvcigiJXM6IGNob3duIGZhaWxlZDogJXMiLCBwYXRoLCBzdHJlcnJv
cihlcnJubykpOw0KKwkJdW5saW5rKHRtcHBhdGgpOw0KIAkJcmV0dXJuIDA7DQogCX0NCiANCiAj
aWZkZWYgSEFWRV9TRUxJTlVYDQotCWlmICghZG1fc2V0X3NlbGludXhfY29udGV4dChwYXRoLCBT
X0lGQkxLKSkNCisJaWYgKCFkbV9zZXRfc2VsaW51eF9jb250ZXh0KHRtcHBhdGgsIFNfSUZCTEsp
KSB7DQorCQl1bmxpbmsodG1wcGF0aCk7DQogCQlyZXR1cm4gMDsNCisJfQ0KICNlbmRpZg0KIA0K
KwlpZiAocmVuYW1lKHRtcHBhdGgsIHBhdGgpIDwgMCkgew0KKwkJbG9nX2Vycm9yKCJVbmFibGUg
dG8gcmVwbGFjZSBkZXZpY2Ugbm9kZSBmb3IgJyVzJyIsIGRldl9uYW1lKTsNCisJCXVubGluayh0
bXBwYXRoKTsNCisJCXJldHVybiAwOw0KKwl9DQorDQogCXJldHVybiAxOw0KIH0NCiANCg==


--=-Qayf6nXfraxENM6+hzsi--

--=-J8dB8Ao03i3knOoqDHHL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHXrYESnQiFMl4yK4RAr0NAJ4r4VKoPNDEGYTNYDX0PkuHQYnCnwCeMlDk
IUQ+x9f6mZEHmYc6HBPszHc=
=BQS6
-----END PGP SIGNATURE-----

--=-J8dB8Ao03i3knOoqDHHL--



--===============0346351178==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
SF.Net email is sponsored by: 
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://sourceforge.net/services/buy/index.php
--===============0346351178==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-hotplug-devel mailing list  http://linux-hotplug.sourceforge.net
Linux-hotplug-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel

--===============0346351178==--
