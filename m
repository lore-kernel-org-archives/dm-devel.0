From: Ritesh Raj Sarraf <rrs@debian.org>
Subject: Re: Next release plans?
Date: Tue, 19 Apr 2016 17:17:56 +0530
Message-ID: <1461066476.4833.40.camel@debian.org>
References: <561531AF.4080907@gmail.com> <570BDA57.7040606@gmail.com>
	<CABr-Gnfgz=upeMOUuMSPTXMqLojqOxEfub7GEd0rAjDZ1F3Z6w@mail.gmail.com>
	<7daddb85-3de7-9015-35fd-2e535f707f7a@gmail.com>
Reply-To: rrs@debian.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3258099395999351886=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7daddb85-3de7-9015-35fd-2e535f707f7a@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, mathieu.tl@gmail.com
List-Id: dm-devel.ids


--===============3258099395999351886==
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vClOeXtnTs4NTuXYPacf"


--=-vClOeXtnTs4NTuXYPacf
Content-Type: multipart/mixed; boundary="=-W7JZyJfoPxjInmIF3q1Q"


--=-W7JZyJfoPxjInmIF3q1Q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-04-19 at 00:22 +0200, Xose Vazquez Perez wrote:
> On 04/18/2016 11:42 AM, Christophe Varoqui wrote:
>=20
> >=20
> > Hannes has not submitted the SuSE patchset for inclusion yet, but I'll =
bump
> > the version to 0.6.1 if he does.
> CCed: Ritesh, Debian maintainer.
>=20
> Maybe there is some pending patches for upstream at Debian.

In Debian, we don't have much delta. The only minor (1 liner) patch I see
carrying is:

rrs@learner:~/.rrs-home/Community/Packaging/multipath-tools (master)$ cat
debian/patches/increase-kpartx-retries.patch=C2=A0
https://www.redhat.com/archives/dm-devel/2015-May/msg00087.html

Many users have reported that increasing the retries solves the problem

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D785251
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D734794
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D608737
Index: multipath-tools/kpartx/lopart.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- multipath-tools.orig/kpartx/lopart.c	2015-10-16 21:33:27.235438304
+0530
+++ multipath-tools/kpartx/lopart.c	2015-10-16 21:33:27.231438251 +0530
@@ -296,7 +296,7 @@
=C2=A0extern int=C2=A0
=C2=A0del_loop (const char *device)
=C2=A0{
-	int retries =3D 3;
+	int retries =3D 5;
=C2=A0	int fd;
=C2=A0
=C2=A0	if ((fd =3D open (device, O_RDONLY)) < 0) {

--=20
Ritesh Raj Sarraf | http://people.debian.org/~rrs
Debian - The Universal Operating System

--=-W7JZyJfoPxjInmIF3q1Q
Content-Disposition: attachment; filename="increase-kpartx-retries.patch"
Content-Type: text/x-patch; name="increase-kpartx-retries.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9hcmNoaXZlcy9kbS1kZXZlbC8yMDE1LU1heS9tc2cwMDA4
Ny5odG1sCgpNYW55IHVzZXJzIGhhdmUgcmVwb3J0ZWQgdGhhdCBpbmNyZWFzaW5nIHRoZSByZXRy
aWVzIHNvbHZlcyB0aGUgcHJvYmxlbQoKaHR0cHM6Ly9idWdzLmRlYmlhbi5vcmcvY2dpLWJpbi9i
dWdyZXBvcnQuY2dpP2J1Zz03ODUyNTEKaHR0cHM6Ly9idWdzLmRlYmlhbi5vcmcvY2dpLWJpbi9i
dWdyZXBvcnQuY2dpP2J1Zz03MzQ3OTQKaHR0cHM6Ly9idWdzLmRlYmlhbi5vcmcvY2dpLWJpbi9i
dWdyZXBvcnQuY2dpP2J1Zz02MDg3MzcKSW5kZXg6IG11bHRpcGF0aC10b29scy9rcGFydHgvbG9w
YXJ0LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PQotLS0gbXVsdGlwYXRoLXRvb2xzLm9yaWcva3BhcnR4L2xvcGFydC5j
CTIwMTUtMTAtMTYgMjE6MzM6MjcuMjM1NDM4MzA0ICswNTMwCisrKyBtdWx0aXBhdGgtdG9vbHMv
a3BhcnR4L2xvcGFydC5jCTIwMTUtMTAtMTYgMjE6MzM6MjcuMjMxNDM4MjUxICswNTMwCkBAIC0y
OTYsNyArMjk2LDcgQEAKIGV4dGVybiBpbnQgCiBkZWxfbG9vcCAoY29uc3QgY2hhciAqZGV2aWNl
KQogewotCWludCByZXRyaWVzID0gMzsKKwlpbnQgcmV0cmllcyA9IDU7CiAJaW50IGZkOwogCiAJ
aWYgKChmZCA9IG9wZW4gKGRldmljZSwgT19SRE9OTFkpKSA8IDApIHsK


--=-W7JZyJfoPxjInmIF3q1Q--

--=-vClOeXtnTs4NTuXYPacf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJXFhrsAAoJEKY6WKPy4XVpsbcQAJmxvYuIW3gKXm4/dqORWrEO
aHu8/VgIkEn+mWY6Ir7rQnMLw/eSGq9ceB1j5GU4Gq+T0n9ju7jwjge1rLNMh8NU
4BWbvfWpGMftCSEGUxJlRgHF+gjKpA8HCvlJTPR4QAm1pUNRNVaMIa5w8HjMifnH
SKk6nBEa5K6EfCYwF+myBB3bFfW8rC9Wq11oSvDo58a0NIjCOe3BH6J7wBYEPGgF
TektWOnArBYCs3stspXj9y1pF1zvpyeI9mCK7Z93ZQhDdXl/tE3grQQM+efH/KV1
eooWBoqPWBtlcmQA2AdepIZJ0TRV+GHGQf/Mn0zEZ9vp6/ZhwfoOAIUuqe4Ba/Nq
6jD5F29iM5cyVTMNee250FsA0eAxIM64R/GwQCZVHJ6KbZT0X4wJhCZD9Ar1a8Q1
aWvANL7XTHadBBb71/J0mQt5mNnBdsC0XrwpLdunGHICuXnNZhqa3kjIrOE2OkPd
QmiNOhOZalf12FROt32pq+XtKIgDPUSCAQSrx9FHbrKGTm1uWPTQbfcOqXLgT2TX
8ueMbALLDUN1v3bDV82hpbR3WPpbMx4jNTcQmzUcVq/iOSFHjGuDSH7/pizjG4vW
jZfhYQK568DWDrHr/Y5y5p5syms0/bpn1e4PXGpmDNoS/e1q5be5GwSvJvj+Hb9K
fcXwlCcxCnG6U2HYiR9z
=NEVn
-----END PGP SIGNATURE-----

--=-vClOeXtnTs4NTuXYPacf--


--===============3258099395999351886==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3258099395999351886==--
