From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: [PATCH] multipath-tools: filter_wwid() called with the
 wrong lists from filter_path()
Date: Wed, 11 Jul 2007 15:37:26 +0200
Message-ID: <OF8BA66743.AEB38D13-ONC1257315.004A6B62-C1257315.004AB69D@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_mixed 004AB65AC1257315_="
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

--=_mixed 004AB65AC1257315_=
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

I just found a small glitch blacklist.c. Patch is attached.

Best Regards,
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
--=_mixed 004AB65AC1257315_=
Content-Type: application/octet-stream;
	name="mp-tools-03-fix-wwid-blacklist.patch"
Content-Disposition: attachment;
	filename="mp-tools-03-fix-wwid-blacklist.patch"
Content-Transfer-Encoding: base64

ZmlsdGVyX3d3aWQoKSBpcyBjYWxsZWQgd2l0aCB0aGUgd3JvbmcgbGlzdHMgZnJvbSBmaWx0ZXJf
cGF0aCgpCgpXaGVuIGZpbHRlcl9wYXRoKCkgY2FsbHMgZmlsdGVyX3d3aWQoKSBpdCBwYXNzZXMg
dGhlIGRldm5vZGUgbGlzdHMgaW5zdGVhZApvZiB0aGUgd3dpZCBsaXN0cy4KClNpZ25lZC1vZmYt
Ynk6IFN0ZWZhbiBCYWRlciA8c2hiYWRlckBkZS5pYm0uY29tPgoKLS0tCiBsaWJtdWx0aXBhdGgv
YmxhY2tsaXN0LmMgfCAgICAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEg
ZGVsZXRpb24oLSkKCkluZGV4OiBtdWx0aXBhdGgtdG9vbHMtMC40LjcubGF0ZXN0LTIwMDcwNzEx
L2xpYm11bHRpcGF0aC9ibGFja2xpc3QuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBtdWx0aXBhdGgtdG9vbHMt
MC40LjcubGF0ZXN0LTIwMDcwNzExLm9yaWcvbGlibXVsdGlwYXRoL2JsYWNrbGlzdC5jCisrKyBt
dWx0aXBhdGgtdG9vbHMtMC40LjcubGF0ZXN0LTIwMDcwNzExL2xpYm11bHRpcGF0aC9ibGFja2xp
c3QuYwpAQCAtMzAwLDcgKzMwMCw3IEBAIF9maWx0ZXJfcGF0aCAoc3RydWN0IGNvbmZpZyAqIGNv
bmYsIHN0cnUKIAlyID0gX2ZpbHRlcl9kZXZub2RlKGNvbmYtPmJsaXN0X2Rldm5vZGUsIGNvbmYt
PmVsaXN0X2Rldm5vZGUscHAtPmRldik7CiAJaWYgKHIpCiAJCXJldHVybiByOwotCXIgPSBfZmls
dGVyX3d3aWQoY29uZi0+Ymxpc3RfZGV2bm9kZSwgY29uZi0+ZWxpc3RfZGV2bm9kZSwgcHAtPnd3
aWQpOworCXIgPSBfZmlsdGVyX3d3aWQoY29uZi0+Ymxpc3Rfd3dpZCwgY29uZi0+ZWxpc3Rfd3dp
ZCwgcHAtPnd3aWQpOwogCWlmIChyKQogCQlyZXR1cm4gcjsKIAlyID0gX2ZpbHRlcl9kZXZpY2Uo
Y29uZi0+Ymxpc3RfZGV2aWNlLCBjb25mLT5lbGlzdF9kZXZpY2UsCg==

--=_mixed 004AB65AC1257315_=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=_mixed 004AB65AC1257315_=--
