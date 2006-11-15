From: Edward Goggin <egoggin@emc.com>
Subject: RE: patch to discovery.c to still get pathpriorityforpaths
	with path state of PATH_DOWN
Date: Wed, 15 Nov 2006 14:48:08 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1552@CORPUSMX40A.corp.emc.com>
References: <1163573321.4917.13.camel@linux-cxyg.rtp.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C708EE.F969E8C7"
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1163573321.4917.13.camel@linux-cxyg.rtp.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dave.wysochanski@redhat.com
Cc: dm-devel@redhat.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C708EE.F969E8C7
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

On Wednesday, November 15, 2006 1:49 AM, Dave Wysochanski wrote

> One other thought I had was the notion of a "priority valid"=20
> flag (or a
> special priority value) in the path for the case of=20
> group_by_prio.  Set
> it to invalid in alloc_path(), then just don't add the path to the
> multipath struct in coalesce_paths() if the priority value=20
> was invalid.
> Then over in checkerloop(), add the path to the multipath map when you
> get a valid priority.
>=20
> It is more complicated than that I'm sure (e.g. checkerloop() assumes
> pp->mpp is non-null in places, etc) but seemed like a half-decent
> approach to at least consider.
>=20
> This approach doesn't take into consideration the general case of a
> change in path priority though.

I very much like the first part of your "priority valid" idea
mentioned above.

I've enclosed a patch for the first part of your idea.  The patch
should address the concern you had about recalculating priority
for a path when its path state changes from not PATH_DOWN to
PATH_DOWN.  It now only retrieves the priority for PATH_DOWN
paths if the path's priority has never been successfully
retrieved before.

I've punted for now on the reloading of the map if a path priority
change has caused a path group membership change.  This is kind of
complex, has lots of down sides, and there doesn't seem to be a
need for it as of now.

------_=_NextPart_001_01C708EE.F969E8C7
Content-Type: application/octet-stream;
	name="structs.h.diff"
Content-Transfer-Encoding: base64
Content-Description: structs.h.diff
Content-Disposition: attachment;
	filename="structs.h.diff"

ZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9zdHJ1Y3RzLmggYi9saWJtdWx0aXBhdGgvc3RydWN0
cy5oCmluZGV4IGZhYTJiOGYuLmM2ZmNiMWYgMTAwNjQ0Ci0tLSBhL2xpYm11bHRpcGF0aC9zdHJ1
Y3RzLmgKKysrIGIvbGlibXVsdGlwYXRoL3N0cnVjdHMuaApAQCAtOTcsNiArOTcsNyBAQCBzdHJ1
Y3QgcGF0aCB7CiAJaW50IGRtc3RhdGU7CiAJaW50IGZhaWxjb3VudDsKIAlpbnQgcHJpb3JpdHk7
CisJaW50IHByaW9fdmFsaWQ7CiAJaW50IHBnaW5kZXg7CiAJY2hhciAqIGdldHVpZDsKIAljaGFy
ICogZ2V0cHJpbzsK

------_=_NextPart_001_01C708EE.F969E8C7
Content-Type: application/octet-stream;
	name="structs.c.diff"
Content-Transfer-Encoding: base64
Content-Description: structs.c.diff
Content-Disposition: attachment;
	filename="structs.c.diff"

ZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9zdHJ1Y3RzLmMgYi9saWJtdWx0aXBhdGgvc3RydWN0
cy5jCmluZGV4IGYwNTY0YzIuLjgyYmRkZjQgMTAwNjQ0Ci0tLSBhL2xpYm11bHRpcGF0aC9zdHJ1
Y3RzLmMKKysrIGIvbGlibXVsdGlwYXRoL3N0cnVjdHMuYwpAQCAtMzEsNiArMzEsNyBAQCBhbGxv
Y19wYXRoICh2b2lkKQogCQlwcC0+c2dfaWQuc2NzaV9pZCA9IC0xOwogCQlwcC0+c2dfaWQubHVu
ID0gLTE7CiAJCXBwLT5mZCA9IC0xOworCQlwcC0+cHJpb192YWxpZCA9IDA7CiAJfQogCXJldHVy
biBwcDsKIH0K

------_=_NextPart_001_01C708EE.F969E8C7
Content-Type: application/octet-stream;
	name="discovery.c.diff"
Content-Transfer-Encoding: base64
Content-Description: discovery.c.diff
Content-Disposition: attachment;
	filename="discovery.c.diff"

ZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYyBiL2xpYm11bHRpcGF0aC9kaXNj
b3ZlcnkuYwppbmRleCBlZmMyMDE2Li42ODlhZTlmIDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgv
ZGlzY292ZXJ5LmMKKysrIGIvbGlibXVsdGlwYXRoL2Rpc2NvdmVyeS5jCkBAIC02MzksNiArNjM5
LDcgQEAgZ2V0X3ByaW8gKHN0cnVjdCBwYXRoICogcHApCiAJfQogCWlmICghcHAtPmdldHByaW8p
IHsKIAkJcHAtPnByaW9yaXR5ID0gMTsKKwkJcHAtPnByaW9fdmFsaWQgPSAxOwogCX0gZWxzZSBp
ZiAoYXBwbHlfZm9ybWF0KHBwLT5nZXRwcmlvLCAmYnVmZlswXSwgcHApKSB7CiAJCWNvbmRsb2co
MCwgImVycm9yIGZvcm1hdHRpbmcgcHJpbyBjYWxsb3V0IGNvbW1hbmQiKTsKIAkJcHAtPnByaW9y
aXR5ID0gLTE7CkBAIC02NDcsOCArNjQ4LDEwIEBAIGdldF9wcmlvIChzdHJ1Y3QgcGF0aCAqIHBw
KQogCQljb25kbG9nKDAsICJlcnJvciBjYWxsaW5nIG91dCAlcyIsIGJ1ZmYpOwogCQlwcC0+cHJp
b3JpdHkgPSAtMTsKIAkJcmV0dXJuIDE7Ci0JfSBlbHNlCisJfSBlbHNlIHsKIAkJcHAtPnByaW9y
aXR5ID0gYXRvaShwcmlvKTsKKwkJcHAtPnByaW9fdmFsaWQgPSAxOworCX0KIAogCWNvbmRsb2co
MywgIiVzOiBwcmlvID0gJXUiLCBwcC0+ZGV2LCBwcC0+cHJpb3JpdHkpOwogCXJldHVybiAwOwpA
QCAtNzAxLDcgKzcwNCwxMiBAQCBwYXRoaW5mbyAoc3RydWN0IHBhdGggKnBwLCB2ZWN0b3IgaHd0
YWJsCiAJaWYgKG1hc2sgJiBESV9DSEVDS0VSICYmIGdldF9zdGF0ZShwcCkpCiAJCWdvdG8gYmxh
bms7CiAJCi0JaWYgKG1hc2sgJiBESV9QUklPICYmIHBwLT5zdGF0ZSAhPSBQQVRIX0RPV04pCisK
KwkvKgorCSAqIFJldHJpZXZlIHBhdGggcHJpb3JpdHkgZm9yIGV2ZW4gUEFUSF9ET1dOIHBhdGhz
IGlmIGl0IGhhcyBuZXZlcgorCSAqIGJlZW4gc3VjY2Vzc2Z1bGx5IG9idGFpbmVkIGJlZm9yZS4K
KwkgKi8KKwlpZiAobWFzayAmIERJX1BSSU8gJiYgKChwcC0+c3RhdGUgIT0gUEFUSF9ET1dOKSB8
fCAhcHAtPnByaW9fdmFsaWQpKQogCQlnZXRfcHJpbyhwcCk7CiAKIAlpZiAobWFzayAmIERJX1dX
SUQgJiYgIXN0cmxlbihwcC0+d3dpZCkpCg==

------_=_NextPart_001_01C708EE.F969E8C7
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C708EE.F969E8C7--
