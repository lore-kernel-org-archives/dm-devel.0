From: Edward Goggin <egoggin@emc.com>
Subject: patch to get_refwwid() in
	multipath-tools/libmultipath/configure.c
Date: Mon, 13 Nov 2006 17:32:58 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1542@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C70773.AB74A9D5"
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

------_=_NextPart_001_01C70773.AB74A9D5
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Christophe,

This patch enables "multipath -l <dm device name>"
to work if the current dm_alias has been changed by
"dmsetup rename" or other means.

 <<configure.c.diff>>=20

------_=_NextPart_001_01C70773.AB74A9D5
Content-Type: application/octet-stream;
	name="configure.c.diff"
Content-Transfer-Encoding: base64
Content-Description: configure.c.diff
Content-Disposition: attachment;
	filename="configure.c.diff"

ZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9jb25maWd1cmUuYyBiL2xpYm11bHRpcGF0aC9jb25m
aWd1cmUuYwppbmRleCAyYjdlNjEzLi45NTc4YmVlIDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgv
Y29uZmlndXJlLmMKKysrIGIvbGlibXVsdGlwYXRoL2NvbmZpZ3VyZS5jCkBAIC01NDcsNyArNTQ3
LDcgQEAgZ2V0X3JlZnd3aWQgKGNoYXIgKiBkZXYsIGVudW0gZGV2dHlwZXMgZAogewogCXN0cnVj
dCBwYXRoICogcHA7CiAJY2hhciBidWZmW0ZJTEVfTkFNRV9TSVpFXTsKLQljaGFyICogcmVmd3dp
ZCA9IE5VTEw7CisJY2hhciAqIHJlZnd3aWQgPSBOVUxMLCB0bXB3d2lkW1dXSURfU0laRV07CiAK
IAlpZiAoZGV2X3R5cGUgPT0gREVWX05PTkUpCiAJCXJldHVybiBOVUxMOwpAQCAtNjAyLDYgKzYw
MiwxMiBAQCBnZXRfcmVmd3dpZCAoY2hhciAqIGRldiwgZW51bSBkZXZ0eXBlcyBkCiAJCWdvdG8g
b3V0OwogCX0KIAlpZiAoZGV2X3R5cGUgPT0gREVWX0RFVk1BUCkgeworCisJCWlmICgoZG1fZ2V0
X3V1aWQoZGV2LCB0bXB3d2lkKSkgPT0gMCkgeworCQkJcmVmd3dpZCA9IHRtcHd3aWQ7CisJCQln
b3RvIG91dDsKKwkJfQorCiAJCS8qCiAJCSAqIG1heSBiZSBhIGJpbmRpbmcKIAkJICovCg==

------_=_NextPart_001_01C70773.AB74A9D5
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C70773.AB74A9D5--
