From: Edward Goggin <egoggin@emc.com>
Subject: RE: patch to get_refwwid()
	inmultipath-tools/libmultipath/configure.c
Date: Mon, 13 Nov 2006 21:40:33 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1545@CORPUSMX40A.corp.emc.com>
References: <1163458804.10466.120.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C70796.41DEE9DB"
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1163458804.10466.120.camel@localhost.localdomain>
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

------_=_NextPart_001_01C70796.41DEE9DB
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I messed up the patch a bit.  Apparently dm_get_uuid() can
return a zero without actually having found a dm name which
matches the name parameter.

Also, I changed dm_get_uuid() so it either returns 1 or a null
string in the uuid return parameter -- in 2 different cases=20
it was doing neither.

The <dm_device_name> qualifier for the command line
"multipath -ll <dm device name>" can now accept up
to 3 different names for the same dm mapped device,
that is, a user friendly name, an alias in
/etc/multipath.conf, and the current name as
reported by "dmsetup ls".  Is this OK or should
we enforce that only the current name as reported
by "dmsetup ls" is acceptable if the mapped device
already exists?=20

> -----Original Message-----
> From: Christophe Varoqui [mailto:christophe.varoqui@free.fr]=20
> Sent: Monday, November 13, 2006 6:00 PM
> To: goggin, edward
> Cc: dm-devel@redhat.com; dave.wysochanski@redhat.com
> Subject: Re: patch to get_refwwid()=20
> inmultipath-tools/libmultipath/configure.c
>=20
> Le lundi 13 novembre 2006 =E0 17:32 -0500, Edward Goggin a =E9crit :
> > Christophe,
> >=20
> > This patch enables "multipath -l <dm device name>"
> > to work if the current dm_alias has been changed by
> > "dmsetup rename" or other means.
> >=20
> Nice to have. Merged localy.=20
>=20
> My dev tree also has the "calc prio for down path" patch, so I'll push
> it to korg once David W. has further commented the change.
>=20
> Regards,
> cvaroqui
>=20
>=20
>=20

------_=_NextPart_001_01C70796.41DEE9DB
Content-Type: application/octet-stream;
	name="configure.c.diff"
Content-Transfer-Encoding: base64
Content-Description: configure.c.diff
Content-Disposition: attachment;
	filename="configure.c.diff"

ZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9jb25maWd1cmUuYyBiL2xpYm11bHRpcGF0aC9jb25m
aWd1cmUuYwppbmRleCAyYjdlNjEzLi5iNjZjZjIzIDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgv
Y29uZmlndXJlLmMKKysrIGIvbGlibXVsdGlwYXRoL2NvbmZpZ3VyZS5jCkBAIC01NDcsNyArNTQ3
LDcgQEAgZ2V0X3JlZnd3aWQgKGNoYXIgKiBkZXYsIGVudW0gZGV2dHlwZXMgZAogewogCXN0cnVj
dCBwYXRoICogcHA7CiAJY2hhciBidWZmW0ZJTEVfTkFNRV9TSVpFXTsKLQljaGFyICogcmVmd3dp
ZCA9IE5VTEw7CisJY2hhciAqIHJlZnd3aWQgPSBOVUxMLCB0bXB3d2lkW1dXSURfU0laRV07CiAK
IAlpZiAoZGV2X3R5cGUgPT0gREVWX05PTkUpCiAJCXJldHVybiBOVUxMOwpAQCAtNjAyLDYgKzYw
MiwxMiBAQCBnZXRfcmVmd3dpZCAoY2hhciAqIGRldiwgZW51bSBkZXZ0eXBlcyBkCiAJCWdvdG8g
b3V0OwogCX0KIAlpZiAoZGV2X3R5cGUgPT0gREVWX0RFVk1BUCkgeworCisJCWlmICgoKGRtX2dl
dF91dWlkKGRldiwgdG1wd3dpZCkpID09IDApICYmIChzdHJsZW4odG1wd3dpZCkpKSB7CisJCQly
ZWZ3d2lkID0gdG1wd3dpZDsKKwkJCWdvdG8gb3V0OworCQl9CisKIAkJLyoKIAkJICogbWF5IGJl
IGEgYmluZGluZwogCQkgKi8K

------_=_NextPart_001_01C70796.41DEE9DB
Content-Type: application/octet-stream;
	name="devmapper.c.diff"
Content-Transfer-Encoding: base64
Content-Description: devmapper.c.diff
Content-Disposition: attachment;
	filename="devmapper.c.diff"

ZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9kZXZtYXBwZXIuYyBiL2xpYm11bHRpcGF0aC9kZXZt
YXBwZXIuYwppbmRleCA2OWVlY2RlLi4wOTk2MWJmIDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgv
ZGV2bWFwcGVyLmMKKysrIGIvbGlibXVsdGlwYXRoL2Rldm1hcHBlci5jCkBAIC0yMjgsMTEgKzIy
OCwxNSBAQCBkbV9nZXRfdXVpZChjaGFyICpuYW1lLCBjaGFyICp1dWlkKQogCWlmICghZG10KQog
CQlyZXR1cm4gMTsKIAotICAgICAgICBpZiAoIWRtX3Rhc2tfc2V0X25hbWUgKGRtdCwgbmFtZSkp
Ci0gICAgICAgICAgICAgICAgZ290byB1dWlkb3V0OworICAgICAgICBpZiAoIWRtX3Rhc2tfc2V0
X25hbWUgKGRtdCwgbmFtZSkpIHsKKwkJZG1fdGFza19kZXN0cm95KGRtdCk7CisJCXJldHVybiAx
OworCX0KIAotCWlmICghZG1fdGFza19ydW4oZG10KSkKLSAgICAgICAgICAgICAgICBnb3RvIHV1
aWRvdXQ7CisJaWYgKCFkbV90YXNrX3J1bihkbXQpKSB7CisJCWRtX3Rhc2tfZGVzdHJveShkbXQp
OworCQlyZXR1cm4gMTsKKwl9CiAKIAl1dWlkdG1wID0gZG1fdGFza19nZXRfdXVpZChkbXQpOwog
CWlmICh1dWlkdG1wKSB7CkBAIC0yNDQsNyArMjQ4LDYgQEAgZG1fZ2V0X3V1aWQoY2hhciAqbmFt
ZSwgY2hhciAqdXVpZCkKIAllbHNlCiAJCXV1aWRbMF0gPSAnXDAnOwogCi11dWlkb3V0OgogCWRt
X3Rhc2tfZGVzdHJveShkbXQpOwogCiAJcmV0dXJuIDA7Cg==

------_=_NextPart_001_01C70796.41DEE9DB
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C70796.41DEE9DB--
