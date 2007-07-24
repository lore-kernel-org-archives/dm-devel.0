From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: [PATCH] multipath-tools: add dcssblk to default blacklist
Date: Tue, 24 Jul 2007 15:57:50 +0200
Message-ID: <OF18F19047.3F92D6F5-ONC1257322.004C63A4-C1257322.004CAAEF@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_mixed 004CAA7FC1257322_="
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
To: dm-devel@redhat.com
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids

--=_mixed 004CAA7FC1257322_=
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

[libmultipath] Add "^dcssblk[0-9]*" to default blacklist.

Added some System z specific device nodes, which would otherwise cause
problems, to default blacklist.

Signed-off-by: Stefan Bader <shbader@de.ibm.com>

---
 libmultipath/blacklist.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: multipath-tools-0.4.7.latest-20070723/libmultipath/blacklist.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- multipath-tools-0.4.7.latest-20070723.orig/libmultipath/blacklist.c
+++ multipath-tools-0.4.7.latest-20070723/libmultipath/blacklist.c
@@ -121,6 +121,12 @@ setup=5Fdefault=5Fblist (struct config * con
        if (store=5Fble(conf->blist=5Fdevnode, str, ORIGIN=5FDEFAULT))
                return 1;
=20
+       str =3D STRDUP("^dcssblk[0-9]*");
+       if (!str)
+               return 1;
+       if (store=5Fble(conf->blist=5Fdevnode, str, ORIGIN=5FDEFAULT))
+               return 1;
+
        vector=5Fforeach=5Fslot (conf->hwtable, hwe, i) {
                if (hwe->bl=5Fproduct) {
                        if (alloc=5Fble=5Fdevice(conf->blist=5Fdevice))



Mit freundlichem Gru=DF / Regards,
Stefan Bader

SW Linux on zSeries Development
Stefan.Bader@de.ibm.com

IBM Deutschland Entwicklung GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Gesch=E4ftsf=FChrung: Herbert Kircher
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
---------------------------------------------------------------------------=
-------
  When all other means of communication fail, try words.
--=_mixed 004CAA7FC1257322_=
Content-Type: application/octet-stream; name="mp-tools-blacklist-dcssblk.patch"
Content-Disposition: attachment; filename="mp-tools-blacklist-dcssblk.patch"
Content-Transfer-Encoding: base64

W2xpYm11bHRpcGF0aF0gQWRkICJeZGNzc2Jsa1swLTldKiIgdG8gZGVmYXVsdCBibGFja2xpc3Qu
CgpBZGRlZCBzb21lIFN5c3RlbSB6IHNwZWNpZmljIGRldmljZSBub2Rlcywgd2hpY2ggd291bGQg
b3RoZXJ3aXNlIGNhdXNlCnByb2JsZW1zLCB0byBkZWZhdWx0IGJsYWNrbGlzdC4KClNpZ25lZC1v
ZmYtYnk6IFN0ZWZhbiBCYWRlciA8c2hiYWRlckBkZS5pYm0uY29tPgoKLS0tCiBsaWJtdWx0aXBh
dGgvYmxhY2tsaXN0LmMgfCAgICA2ICsrKysrKwogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9u
cygrKQoKSW5kZXg6IG11bHRpcGF0aC10b29scy0wLjQuNy5sYXRlc3QtMjAwNzA3MjMvbGlibXVs
dGlwYXRoL2JsYWNrbGlzdC5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIG11bHRpcGF0aC10b29scy0wLjQuNy5s
YXRlc3QtMjAwNzA3MjMub3JpZy9saWJtdWx0aXBhdGgvYmxhY2tsaXN0LmMKKysrIG11bHRpcGF0
aC10b29scy0wLjQuNy5sYXRlc3QtMjAwNzA3MjMvbGlibXVsdGlwYXRoL2JsYWNrbGlzdC5jCkBA
IC0xMjEsNiArMTIxLDEyIEBAIHNldHVwX2RlZmF1bHRfYmxpc3QgKHN0cnVjdCBjb25maWcgKiBj
b24KIAlpZiAoc3RvcmVfYmxlKGNvbmYtPmJsaXN0X2Rldm5vZGUsIHN0ciwgT1JJR0lOX0RFRkFV
TFQpKQogCQlyZXR1cm4gMTsKIAorCXN0ciA9IFNUUkRVUCgiXmRjc3NibGtbMC05XSoiKTsKKwlp
ZiAoIXN0cikKKwkJcmV0dXJuIDE7CisJaWYgKHN0b3JlX2JsZShjb25mLT5ibGlzdF9kZXZub2Rl
LCBzdHIsIE9SSUdJTl9ERUZBVUxUKSkKKwkJcmV0dXJuIDE7CisKIAl2ZWN0b3JfZm9yZWFjaF9z
bG90IChjb25mLT5od3RhYmxlLCBod2UsIGkpIHsKIAkJaWYgKGh3ZS0+YmxfcHJvZHVjdCkgewog
CQkJaWYgKGFsbG9jX2JsZV9kZXZpY2UoY29uZi0+Ymxpc3RfZGV2aWNlKSkK

--=_mixed 004CAA7FC1257322_=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=_mixed 004CAA7FC1257322_=--
