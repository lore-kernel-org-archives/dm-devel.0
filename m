From: Edward Goggin <egoggin@emc.com>
Subject: patch to readsector0.c to allow use of sg_read() from
	other multipath-tools path checkers
Date: Fri, 10 Nov 2006 17:55:46 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1534@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C7051B.5B91A32D"
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7051B.5B91A32D
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Christophe,

Here is the patch to readsector0.c isolated from the rest.

 <<readsector0.c.diff>>=20

------_=_NextPart_001_01C7051B.5B91A32D
Content-Type: application/octet-stream;
	name="readsector0.c.diff"
Content-Transfer-Encoding: base64
Content-Description: readsector0.c.diff
Content-Disposition: attachment;
	filename="readsector0.c.diff"

ZGlmZiAtLWdpdCBhL2xpYmNoZWNrZXJzL3JlYWRzZWN0b3IwLmMgYi9saWJjaGVja2Vycy9yZWFk
c2VjdG9yMC5jCmluZGV4IGIwYWNlYzkuLmRkMTg1MjggMTAwNjQ0Ci0tLSBhL2xpYmNoZWNrZXJz
L3JlYWRzZWN0b3IwLmMKKysrIGIvbGliY2hlY2tlcnMvcmVhZHNlY3RvcjAuYwpAQCAtMzQsOCAr
MzQsOCBAQCB2b2lkIHJlYWRzZWN0b3IwX2ZyZWUgKHN0cnVjdCBjaGVja2VyICogCiAJcmV0dXJu
OwogfQogCi1zdGF0aWMgaW50Ci1zZ19yZWFkIChpbnQgc2dfZmQsIHVuc2lnbmVkIGNoYXIgKiBi
dWZmKQoraW50CitzZ19yZWFkIChpbnQgc2dfZmQsIHVuc2lnbmVkIGNoYXIgKiBidWZmLCB1bnNp
Z25lZCBjaGFyICogc2Vuc2VCdWZmKQogewogCS8qIGRlZmF1bHRzICovCiAJaW50IGJsb2NrcyA9
IDE7CkBAIC00NSw3ICs0NSw2IEBAIHNnX3JlYWQgKGludCBzZ19mZCwgdW5zaWduZWQgY2hhciAq
IGJ1ZmYKIAlpbnQgKiBkaW9wID0gTlVMTDsKIAogCXVuc2lnbmVkIGNoYXIgcmRDbWRbY2Ric3pd
OwotCXVuc2lnbmVkIGNoYXIgc2Vuc2VCdWZmW1NFTlNFX0JVRkZfTEVOXTsKIAlzdHJ1Y3Qgc2df
aW9faGRyIGlvX2hkcjsKIAlpbnQgcmVzOwogCWludCByZF9vcGNvZGVbXSA9IHsweDgsIDB4Mjgs
IDB4YTgsIDB4ODh9OwpAQCAtOTcsOSArOTYsMTAgQEAgZXh0ZXJuIGludAogcmVhZHNlY3RvcjAg
KHN0cnVjdCBjaGVja2VyICogYykKIHsKIAl1bnNpZ25lZCBjaGFyIGJ1Zls1MTJdOworCXVuc2ln
bmVkIGNoYXIgc2J1ZltTRU5TRV9CVUZGX0xFTl07CiAJaW50IHJldDsKIAotCXJldCA9IHNnX3Jl
YWQoYy0+ZmQsICZidWZbMF0pOworCXJldCA9IHNnX3JlYWQoYy0+ZmQsICZidWZbMF0sICZzYnVm
WzBdKTsKIAogCXN3aXRjaCAocmV0KQogCXsK

------_=_NextPart_001_01C7051B.5B91A32D
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C7051B.5B91A32D--
