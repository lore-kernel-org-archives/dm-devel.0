From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: [PATCH 2/2] dm: add additional info to end of status line
Date: Fri, 7 Dec 2007 12:10:52 -0800
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC01A86F94@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C8390D.45C97CE2"
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
To: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C8390D.45C97CE2
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From: Brian Wood <brian.j.wood@intel.com>

This patch adds additional information to the status line. It is added
at the
end of the returned text so it will not interfere with existing=20
implementations using this data. The addition of this information will
allow
for a common return interface to match that returned with the dm-raid1.c
status line (with Jonathan Brassow's patches).

Here is a sample of what is returned with a mirror:
isw_eeaaabgfg_mirror: 0 488390920 mirror 2 8:16 8:32 3727/3727 1 AA 1
core
here is what is returned with this patch for a stripe: =20
isw_dheeijjdej_stripe: 0 976783872 striped 2 8:16 8:32 AA

Signed-off-by: Brian Wood <brian.j.wood@intel.com>

--- linux-2.6.24-rc3/drivers/md/dm-stripe.c	2007-12-06
01:51:54.000000000 -0800
+++ linux-2.6.24-rc3.mod/drivers/md/dm-stripe.c	2007-12-06
01:50:50.000000000 -0800
@@ -274,12 +274,20 @@ static int stripe_status(struct dm_targe
 			 status_type_t type, char *result, unsigned int
maxlen)
 {
 	struct stripe_c *sc =3D (struct stripe_c *) ti->private;
+	char buffer[sc->stripes + 1];
 	unsigned int sz =3D 0;
 	unsigned int i;
=20
 	switch (type) {
 	case STATUSTYPE_INFO:
-		result[0] =3D '\0';
+		DMEMIT("%d ", sc->stripes);
+		for (i =3D 0; i < sc->stripes; i++)  {
+			DMEMIT("%s ", sc->stripe[i].dev->name);
+			buffer[i] =3D
atomic_read(&(sc->stripe[i].error_count)) ?
+				'D' : 'A';
+		}
+		buffer[i] =3D '\0';
+		DMEMIT("%s ", buffer);
 		break;
=20
 	case STATUSTYPE_TABLE:

------_=_NextPart_001_01C8390D.45C97CE2
Content-Type: application/octet-stream;
	name="dm-stripe-enhanced-status-return.patch"
Content-Transfer-Encoding: base64
Content-Description: dm-stripe-enhanced-status-return.patch
Content-Disposition: attachment;
	filename="dm-stripe-enhanced-status-return.patch"

RnJvbTogQnJpYW4gV29vZCA8YnJpYW4uai53b29kQGludGVsLmNvbT4KClRoaXMgcGF0Y2ggYWRk
cyBhZGRpdGlvbmFsIGluZm9ybWF0aW9uIHRvIHRoZSBzdGF0dXMgbGluZS4gSXQgaXMgYWRkZWQg
YXQgdGhlCmVuZCBvZiB0aGUgcmV0dXJuZWQgdGV4dCBzbyBpdCB3aWxsIG5vdCBpbnRlcmZlcmUg
d2l0aCBleGlzdGluZyAKaW1wbGVtZW50YXRpb25zIHVzaW5nIHRoaXMgZGF0YS4gVGhlIGFkZGl0
aW9uIG9mIHRoaXMgaW5mb3JtYXRpb24gd2lsbCBhbGxvdwpmb3IgYSBjb21tb24gcmV0dXJuIGlu
dGVyZmFjZSB0byBtYXRjaCB0aGF0IHJldHVybmVkIHdpdGggdGhlIGRtLXJhaWQxLmMKc3RhdHVz
IGxpbmUgKHdpdGggSm9uYXRoYW4gQnJhc3NvdydzIHBhdGNoZXMpLgoKSGVyZSBpcyBhIHNhbXBs
ZSBvZiB3aGF0IGlzIHJldHVybmVkIHdpdGggYSBtaXJyb3I6Cmlzd19lZWFhYWJnZmdfbWlycm9y
OiAwIDQ4ODM5MDkyMCBtaXJyb3IgMiA4OjE2IDg6MzIgMzcyNy8zNzI3IDEgQUEgMSBjb3JlCmhl
cmUgaXMgd2hhdCBpcyByZXR1cm5lZCB3aXRoIHRoaXMgcGF0Y2ggZm9yIGEgc3RyaXBlOiAgCmlz
d19kaGVlaWpqZGVqX3N0cmlwZTogMCA5NzY3ODM4NzIgc3RyaXBlZCAyIDg6MTYgODozMiBBQQoK
U2lnbmVkLW9mZi1ieTogQnJpYW4gV29vZCA8YnJpYW4uai53b29kQGludGVsLmNvbT4KCi0tLSBs
aW51eC0yLjYuMjQtcmMzL2RyaXZlcnMvbWQvZG0tc3RyaXBlLmMJMjAwNy0xMi0wNiAwMTo1MTo1
NC4wMDAwMDAwMDAgLTA4MDAKKysrIGxpbnV4LTIuNi4yNC1yYzMubW9kL2RyaXZlcnMvbWQvZG0t
c3RyaXBlLmMJMjAwNy0xMi0wNiAwMTo1MDo1MC4wMDAwMDAwMDAgLTA4MDAKQEAgLTI3NCwxMiAr
Mjc0LDIwIEBAIHN0YXRpYyBpbnQgc3RyaXBlX3N0YXR1cyhzdHJ1Y3QgZG1fdGFyZ2UKIAkJCSBz
dGF0dXNfdHlwZV90IHR5cGUsIGNoYXIgKnJlc3VsdCwgdW5zaWduZWQgaW50IG1heGxlbikKIHsK
IAlzdHJ1Y3Qgc3RyaXBlX2MgKnNjID0gKHN0cnVjdCBzdHJpcGVfYyAqKSB0aS0+cHJpdmF0ZTsK
KwljaGFyIGJ1ZmZlcltzYy0+c3RyaXBlcyArIDFdOwogCXVuc2lnbmVkIGludCBzeiA9IDA7CiAJ
dW5zaWduZWQgaW50IGk7CiAKIAlzd2l0Y2ggKHR5cGUpIHsKIAljYXNlIFNUQVRVU1RZUEVfSU5G
TzoKLQkJcmVzdWx0WzBdID0gJ1wwJzsKKwkJRE1FTUlUKCIlZCAiLCBzYy0+c3RyaXBlcyk7CisJ
CWZvciAoaSA9IDA7IGkgPCBzYy0+c3RyaXBlczsgaSsrKSAgeworCQkJRE1FTUlUKCIlcyAiLCBz
Yy0+c3RyaXBlW2ldLmRldi0+bmFtZSk7CisJCQlidWZmZXJbaV0gPSBhdG9taWNfcmVhZCgmKHNj
LT5zdHJpcGVbaV0uZXJyb3JfY291bnQpKSA/CisJCQkJJ0QnIDogJ0EnOworCQl9CisJCWJ1ZmZl
cltpXSA9ICdcMCc7CisJCURNRU1JVCgiJXMgIiwgYnVmZmVyKTsKIAkJYnJlYWs7CiAKIAljYXNl
IFNUQVRVU1RZUEVfVEFCTEU6Cg==

------_=_NextPart_001_01C8390D.45C97CE2
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C8390D.45C97CE2--
