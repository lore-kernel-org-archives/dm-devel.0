From: Ritesh Raj Sarraf <rrs@debian.org>
Subject: Re: What license is multipath-tools under
Date: Fri, 29 Jul 2016 00:11:00 +0530
Message-ID: <1469731260.4380.19.camel@debian.org>
References: <1469616127.6204.9.camel@debian.org>
	<26bf809d-9e9e-b4ae-9110-a67819246907@gmail.com>
	<1469724801.17451.27.camel@debian.org>
	<1469726763.2295.20.camel@HansenPartnership.com>
Reply-To: rrs@debian.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0982720345226874426=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469726763.2295.20.camel@HansenPartnership.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============0982720345226874426==
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-1TlQYvDvRVyJqUZKg5MP"


--=-1TlQYvDvRVyJqUZKg5MP
Content-Type: multipart/mixed; boundary="=-b5t5zrAExKICgwkKFt82"


--=-b5t5zrAExKICgwkKFt82
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello James,

On Thu, 2016-07-28 at 13:26 -0400, James Bottomley wrote:
> On Thu, 2016-07-28 at 22:23 +0530, Ritesh Raj Sarraf wrote:
> > Thanks Xose, for digging this information. But shouldn't this=C2=A0
> > information go into respective source files?
>=20
> If there's a COPYING file, there's no need for individual files to have
> a copyright.=C2=A0 The licence of the file defaults to whatever COPYING (=
or
> LICENCE or some recognizable top level file says).=C2=A0 A significant
> number of Linux Kernel files don't have individual file header copyrigh
> ts, if you want an example of this.

Yes. But as I understand, the entire Linux [1] code base is GPLv2 only. Whe=
reas
in case of multipath-tools, as Xose mentioned in the previous email, it is =
a mix
of:

* GPLv2 (only?)
* GPLv2+
* LGPLv2

Having this information in the source repository (not necessarily as indivi=
dual
source headers) will speak out much clear.

I think something like Debian's Machine-readable copyright format will be a=
 good
fit in this case.

https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/

An example project, with mixed licenses:
http://metadata.ftp-master.debian.org/changelogs/main/libs/libstoragemgmt/u=
nstab
le_copyright

BTW, this topic hit my mind 2 days ago when I looked at the aging (old form=
at)
multipath-tools/debian/copyright in my packaging repo and wanted to fix it.

http://metadata.ftp-master.debian.org/changelogs/main/m/multipath-tools/uns=
table
_copyright



I have attached a patch for a copyright file, based on what Xose had mentio=
ned
in the email. There still are files, like=C2=A0libmultipath/prioritizers/al=
ua.c,
which mention the license as plain GPL. So, this patch is still not complet=
e.


[1] with some minor exceptions I just noticed.

--=20
Ritesh Raj Sarraf | http://people.debian.org/~rrs
Debian - The Universal Operating System
--=-b5t5zrAExKICgwkKFt82
Content-Disposition: attachment;
	filename="0001-Add-initial-licensing-copyright-file.patch"
Content-Type: text/x-patch;
	name="0001-Add-initial-licensing-copyright-file.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSBhMTQ4YzZkZThiNTU4ODU4ZTMyMTBjOTczNTc0ODU5OTU0YWQyZTYzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSaXRlc2ggUmFqIFNhcnJhZiA8cnJzQGRlYmlhbi5vcmc+CkRh
dGU6IEZyaSwgMjkgSnVsIDIwMTYgMDA6MDM6MjcgKzA1MzAKU3ViamVjdDogW1BBVENIXSBBZGQg
aW5pdGlhbCBsaWNlbnNpbmcvY29weXJpZ2h0IGZpbGUKClNpZ25lZC1vZmYtYnk6IFJpdGVzaCBS
YWogU2FycmFmIDxycnNAZGViaWFuLm9yZz4KLS0tCiBjb3B5cmlnaHQgfCA2MyArKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIDEg
ZmlsZSBjaGFuZ2VkLCA2MyBpbnNlcnRpb25zKCspCiBjcmVhdGUgbW9kZSAxMDA2NDQgY29weXJp
Z2h0CgpkaWZmIC0tZ2l0IGEvY29weXJpZ2h0IGIvY29weXJpZ2h0Cm5ldyBmaWxlIG1vZGUgMTAw
NjQ0CmluZGV4IDAwMDAwMDAuLjA3NThhYjAKLS0tIC9kZXYvbnVsbAorKysgYi9jb3B5cmlnaHQK
QEAgLTAsMCArMSw2MyBAQAorRm9ybWF0OiBodHRwOi8vd3d3LmRlYmlhbi5vcmcvZG9jL3BhY2th
Z2luZy1tYW51YWxzL2NvcHlyaWdodC1mb3JtYXQvMS4wLworVXBzdHJlYW0tTmFtZTogbXVsdGlw
YXRoLXRvb2xzCitVcHN0cmVhbS1Db250YWN0OiBNdWx0aXBhdGggVG9vbHMgUHJvamVjdCAoZG0t
ZGV2ZWxAcmVkaGF0LmNvbSkKK1NvdXJjZTogaHR0cHM6Ly9odHRwOi8vZ2l0Lm9wZW5zdmMuY29t
Lz9wPW11bHRpcGF0aC10b29scy8uZ2l0O2E9c3VtbWFyeQorCitGaWxlczogKgorTGljZW5zZTog
TEdQTC0yLjErCisKK0ZpbGVzOiBrcGFydHgvCisgICAgICAgIG11bHRpcGF0aC9tYWluLmMKKyAg
ICAgICAgbGlibXVsdGlwYXRoL2NoZWNrZXJzL2NjaXNzX3R1ci5jCisgICAgICAgIGxpYm11bHRp
cGF0aC9tZW1vcnkuYworICAgICAgICBsaWJtdWx0aXBhdGgvbWVtb3J5LmgKKyAgICAgICAgbGli
bXVsdGlwYXRoL3BhcnNlci5jCisgICAgICAgIGxpYm11bHRpcGF0aC9wYXJzZXIuaAorICAgICAg
ICBsaWJtdWx0aXBhdGgvdmVjdG9yLmMKKyAgICAgICAgbGlibXVsdGlwYXRoL3ZlY3Rvci5oCisg
ICAgICAgIGxpYm11bHRpcGF0aC92ZXJzaW9uLmgKKyAgICAgICAgbGlibXVsdGlwYXRoL2ZpbGUu
YworICAgICAgICBsaWJtdWx0aXBhdGgvYWxpYXMuYworTGljZW5zZTogR1BMLTIrCisKK0ZpbGVz
OiBsaWJtdWxpdHBhdGgvdWV2ZW50LmMKKyAgICAgICAgbGlibXVsdGlwYXRoL3N5c2ZzLmMKKyAg
ICAgICAgbGlibXVsdGlwYXRoL3ByaW9yaXRpemVycy9vbnRhcC5jCitMaWNlbnNlOiBHUEwtMgor
CisKK0xpY2Vuc2U6IEdQTC0yKworIFRoaXMgcGFja2FnZSBpcyBmcmVlIHNvZnR3YXJlOyB5b3Ug
Y2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5CisgaXQgdW5kZXIgdGhlIHRlcm1zIG9m
IHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQgYnkKKyB0aGUgRnJl
ZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBv
cgorIChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24uCisgLgorIFRoaXMgcGFja2Fn
ZSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLAorIGJ1
dCBXSVRIT1VUIEFOWSBXQVJSQU5UWTsgd2l0aG91dCBldmVuIHRoZSBpbXBsaWVkIHdhcnJhbnR5
IG9mCisgTUVSQ0hBTlRBQklMSVRZIG9yIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NF
LiAgU2VlIHRoZQorIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZvciBtb3JlIGRldGFpbHMu
CisgLgorIFlvdSBzaG91bGQgaGF2ZSByZWNlaXZlZCBhIGNvcHkgb2YgdGhlIEdOVSBHZW5lcmFs
IFB1YmxpYyBMaWNlbnNlCisgYWxvbmcgd2l0aCB0aGlzIHByb2dyYW0uIElmIG5vdCwgc2VlIDxo
dHRwOi8vd3d3LmdudS5vcmcvbGljZW5zZXMvPgorIC4KKyBPbiBEZWJpYW4gc3lzdGVtcywgdGhl
IGNvbXBsZXRlIHRleHQgb2YgdGhlIEdOVSBHZW5lcmFsCisgUHVibGljIExpY2Vuc2UgdmVyc2lv
biAyIGNhbiBiZSBmb3VuZCBpbiAiL3Vzci9zaGFyZS9jb21tb24tbGljZW5zZXMvR1BMLTIiLgor
CisKK0xpY2Vuc2U6IExHUEwtMi4xKworIFRoaXMgcGFja2FnZSBpcyBmcmVlIHNvZnR3YXJlOyB5
b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5CisgaXQgdW5kZXIgdGhlIHRlcm1z
IG9mIHRoZSBHTlUgTGVzc2VyIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMgcHVibGlzaGVkIGJ5
CisgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24gMiBvZiB0aGUg
TGljZW5zZSwgb3IKKyAoYXQgeW91ciBvcHRpb24pIGFueSBsYXRlciB2ZXJzaW9uLgorIC4KKyBU
aGlzIHBhY2thZ2UgaXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVz
ZWZ1bCwKKyBidXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGll
ZCB3YXJyYW50eSBvZgorIE1FUkNIQU5UQUJJTElUWSBvciBGSVRORVNTIEZPUiBBIFBBUlRJQ1VM
QVIgUFVSUE9TRS4gIFNlZSB0aGUKKyBHTlUgTGVzc2VyIEdlbmVyYWwgUHVibGljIExpY2Vuc2Ug
Zm9yIG1vcmUgZGV0YWlscy4KKyAuCisgWW91IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEgY29weSBv
ZiB0aGUgR05VIExlc3NlciBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlCisgYWxvbmcgd2l0aCB0aGlz
IHByb2dyYW0uIElmIG5vdCwgc2VlIDxodHRwOi8vd3d3LmdudS5vcmcvbGljZW5zZXMvPgorIC4K
KyBPbiBEZWJpYW4gc3lzdGVtcywgdGhlIGNvbXBsZXRlIHRleHQgb2YgdGhlIEdOVSBMZXNzZXIg
R2VuZXJhbAorIFB1YmxpYyBMaWNlbnNlIHZlcnNpb24gMiBjYW4gYmUgZm91bmQgaW4gIi91c3Iv
c2hhcmUvY29tbW9uLWxpY2Vuc2VzL0xHUEwtMi4xIi4KKwotLSAKMi44LjEKCg==


--=-b5t5zrAExKICgwkKFt82--

--=-1TlQYvDvRVyJqUZKg5MP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJXmlG8AAoJEKY6WKPy4XVpQEYP/RGEY7UAQGblXwGQLXLdVroN
D+Pb/ycvAEQnTVfO9SH7MdL64+eMcP6oGe2xvnWwzEfP8X0Kldko/Q7zrZ8Letmm
ZT8QWV0p9fCj39xr0KQyDC4pxjTXSwewcY0RvMTXE2fz9a0CBOkqg/ko1LME+Opy
r6aeT79oh6OfSJNziBrlS8yqbY9YhoCSvOSUh9m+HMx79mTJgtSbtDVzCxqkCDFV
WMBR/Ej2cr6J8QOlGFFirCeLrIpl0Ggi+AGym6rdvMyWhB6TaYefVQmUoxWKnHjO
9GNkxi1GwXZz2AM97eBsAVgv0xlVJZ/XdybcYkrFEvmNGfEGX2NuxBQpYqBXW5ap
Ds/Bwqp6yY9vwvSq6qYKw9nMjWJ3HO6rreg07B8sZJakZqol8wAnxfY71XxCs+tR
PwTsOHWlZzuwWdf8wZ6nDWBFJjTESctPM/OF//GwzG3poho51BS4vG0rOy2olj44
/MUXraHMavhrWid1yOiwt7jlhk0Qo95AqzNOOIAgmmT8g+3NB+t+pqvtBxcxZiY/
G3OAKosM6FiHxt6EcFL2JQVq0u/jEUS4QLZJusghjl9DSYBAG3jVTOZtg8wqpMVj
QCYK+q83aRMHfqXELW9WKt7oHL6erHJD0ZSrUhL0BRnnbkmo1NrpWYO9N37Umaq2
QN8clNwJDDsLClqUD3Yd
=QfpU
-----END PGP SIGNATURE-----

--=-1TlQYvDvRVyJqUZKg5MP--


--===============0982720345226874426==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0982720345226874426==--
