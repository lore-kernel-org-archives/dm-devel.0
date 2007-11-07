From: Scott James Remnant <scott@ubuntu.com>
Subject: [Kernel PATCH] emit change on devmapper devices
Date: Wed, 07 Nov 2007 11:50:07 -0500
Message-ID: <1194454207.6273.5.camel@wing-commander>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1378442349=="
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
To: linux-hotplug-devel@lists.sourceforge.net
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============1378442349==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-1/Mt7TrOivwMcgmv59kJ"


--=-1/Mt7TrOivwMcgmv59kJ
Content-Type: multipart/mixed; boundary="=-SjhlnEYY+A5hD5q4f9RJ"


--=-SjhlnEYY+A5hD5q4f9RJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi guys,

I've had this patch sitting on my disk for a few months, and haven't
done anything more than test it.  Before I stuff it into git, and send
it to the kernel, would you guys have a look over it and see whether
it's technically correct.

The patch simply causes a kobject "change" event to be emitted on
devmapper block devices when they are renamed.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-SjhlnEYY+A5hD5q4f9RJ
Content-Description: 
Content-Disposition: inline; filename=dm-rename-change.patch
Content-Type: text/x-patch; charset=UTF-8
Content-Transfer-Encoding: base64

ZGlmZiAtcnVOcCBsaW51eC1zb3VyY2UtMi42LjIyfi9kcml2ZXJzL21kL2RtLWlvY3RsLmMgbGlu
dXgtc291cmNlLTIuNi4yMi9kcml2ZXJzL21kL2RtLWlvY3RsLmMNCi0tLSBsaW51eC1zb3VyY2Ut
Mi42LjIyfi9kcml2ZXJzL21kL2RtLWlvY3RsLmMJMjAwNy0wNy0xMCAxNzo1NDo0NC4wMDAwMDAw
MDAgKzAxMDANCisrKyBsaW51eC1zb3VyY2UtMi42LjIyL2RyaXZlcnMvbWQvZG0taW9jdGwuYwky
MDA3LTA3LTEwIDIyOjAxOjA5LjAwMDAwMDAwMCArMDEwMA0KQEAgLTMyMyw2ICszMjMsOCBAQCBz
dGF0aWMgaW50IGRtX2hhc2hfcmVuYW1lKGNvbnN0IGNoYXIgKm9sDQogCWhjLT5uYW1lID0gbmV3
X25hbWU7DQogCWxpc3RfYWRkKCZoYy0+bmFtZV9saXN0LCBfbmFtZV9idWNrZXRzICsgaGFzaF9z
dHIobmV3X25hbWUpKTsNCiANCisJZG1fY2hhbmdlZChoYy0+bWQpOw0KKw0KIAkvKg0KIAkgKiBX
YWtlIHVwIGFueSBkbSBldmVudCB3YWl0ZXJzLg0KIAkgKi8NCmRpZmYgLXJ1TnAgbGludXgtc291
cmNlLTIuNi4yMn4vZHJpdmVycy9tZC9kbS5jIGxpbnV4LXNvdXJjZS0yLjYuMjIvZHJpdmVycy9t
ZC9kbS5jDQotLS0gbGludXgtc291cmNlLTIuNi4yMn4vZHJpdmVycy9tZC9kbS5jCTIwMDctMDUt
MTMgMTk6NTU6NTAuMDAwMDAwMDAwICswMTAwDQorKysgbGludXgtc291cmNlLTIuNi4yMi9kcml2
ZXJzL21kL2RtLmMJMjAwNy0wNy0xMCAyMjowMTowOS4wMDAwMDAwMDAgKzAxMDANCkBAIC0xNTQy
LDYgKzE1NDIsMTEgQEAgaW50IGRtX25vZmx1c2hfc3VzcGVuZGluZyhzdHJ1Y3QgZG1fdGFyZw0K
IH0NCiBFWFBPUlRfU1lNQk9MX0dQTChkbV9ub2ZsdXNoX3N1c3BlbmRpbmcpOw0KIA0KK3ZvaWQg
ZG1fY2hhbmdlZChzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQpDQorew0KKwlrb2JqZWN0X3VldmVu
dCgmbWQtPmRpc2stPmtvYmosIEtPQkpfQ0hBTkdFKTsNCit9DQorDQogc3RhdGljIHN0cnVjdCBi
bG9ja19kZXZpY2Vfb3BlcmF0aW9ucyBkbV9ibGtfZG9wcyA9IHsNCiAJLm9wZW4gPSBkbV9ibGtf
b3BlbiwNCiAJLnJlbGVhc2UgPSBkbV9ibGtfY2xvc2UsDQpkaWZmIC1ydU5wIGxpbnV4LXNvdXJj
ZS0yLjYuMjJ+L2RyaXZlcnMvbWQvZG0uaCBsaW51eC1zb3VyY2UtMi42LjIyL2RyaXZlcnMvbWQv
ZG0uaA0KLS0tIGxpbnV4LXNvdXJjZS0yLjYuMjJ+L2RyaXZlcnMvbWQvZG0uaAkyMDA3LTA1LTEz
IDE5OjU1OjUwLjAwMDAwMDAwMCArMDEwMA0KKysrIGxpbnV4LXNvdXJjZS0yLjYuMjIvZHJpdmVy
cy9tZC9kbS5oCTIwMDctMDctMTAgMjI6MDE6MDkuMDAwMDAwMDAwICswMTAwDQpAQCAtMTUxLDQg
KzE1MSw2IEBAIHVuaW9uIG1hcF9pbmZvICpkbV9nZXRfbWFwaW5mbyhzdHJ1Y3QgYmkNCiBpbnQg
ZG1fb3Blbl9jb3VudChzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQpOw0KIGludCBkbV9sb2NrX2Zv
cl9kZWxldGlvbihzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQpOw0KIA0KK3ZvaWQgZG1fY2hhbmdl
ZChzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQpOw0KKw0KICNlbmRpZg0K


--=-SjhlnEYY+A5hD5q4f9RJ--

--=-1/Mt7TrOivwMcgmv59kJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHMey/SnQiFMl4yK4RAk7xAKCcxasLM3u04gFWJgH/8fCFTLn3RgCgqeju
fR3VtGiyX6iBKIlISyvHAow=
=5myu
-----END PGP SIGNATURE-----

--=-1/Mt7TrOivwMcgmv59kJ--



--===============1378442349==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >> http://get.splunk.com/
--===============1378442349==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-hotplug-devel mailing list  http://linux-hotplug.sourceforge.net
Linux-hotplug-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel

--===============1378442349==--
