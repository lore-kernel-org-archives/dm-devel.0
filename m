From: Tejaswini Poluri <tejaswinipoluri3@gmail.com>
Subject: [PATCH] multipathd: add map feature fix
Date: Fri, 10 Jul 2015 15:49:55 +0530
Message-ID: <CAH=b03tRJCct+nX-=XAYqpfP_YtZyxwS9L69RBcr4qKDMrcckQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=089e0102f4569fba57051a82b6da
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, dm-devel-request@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>, Benjamin Marzinski <bmarzins@redhat.com>
List-Id: dm-devel.ids

--089e0102f4569fba57051a82b6da
Content-Type: multipart/alternative; boundary=089e0102f4569fba50051a82b6d8

--089e0102f4569fba50051a82b6d8
Content-Type: text/plain; charset=UTF-8

Hii,

Its found that the add map feature of multipathd tools is not working. i.e
its  not able to add the map again once removed. The following is the test
case:

*Case  : remove and add map.*
root@x86-generic-64:~# multipathd -k'show maps'
name    sysfs uuid
dmpath0 dm-0  1IET_00010001
root@x86-generic-64:~# multipathd -k'remove map dmpath0'
ok
root@x86-generic-64:~# multipathd -k'show maps'
root@x86-generic-64:~# multipathd -k'add map dmpath0'
ok
root@x86-generic-64:~# multipathd -k'show maps'
root@x86-generic-64:~#
Once a map is removed, we are able to add it only using #multipath  command
and not using multipathd tools.

I worked on a fix for the same and the following patch solves the problem.
There is also some unused code which could removed here in ev_add_map
function.
PFA the patches.

It would be great if the patches are reviewed. It would also help if
someone could share the procedure for submission of patches.

Regards,
Tejaswini

--089e0102f4569fba50051a82b6d8
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hii,=C2=A0<div><br></div><div>Its found that the add map f=
eature of multipathd tools is not working. i.e its =C2=A0not able to add th=
e map again once removed. The following is the test case:</div><div><b styl=
e=3D"font-size:12.8000001907349px"><br></b></div><div><b style=3D"font-size=
:12.8000001907349px">Case =C2=A0: remove and add map.</b><br style=3D"font-=
size:12.8000001907349px"><span style=3D"font-size:12.8000001907349px">root@=
x86-generic-64:~# multipathd -k&#39;show maps&#39;</span><br style=3D"font-=
size:12.8000001907349px"><span style=3D"font-size:12.8000001907349px">name=
=C2=A0=C2=A0=C2=A0 sysfs uuid</span><br style=3D"font-size:12.8000001907349=
px"><span style=3D"font-size:12.8000001907349px">dmpath0 dm-0=C2=A0 1IET_00=
010001</span><br style=3D"font-size:12.8000001907349px"><span style=3D"font=
-size:12.8000001907349px">root@x86-generic-64:~# multipathd -k&#39;remove m=
ap dmpath0&#39;</span><br style=3D"font-size:12.8000001907349px"><span styl=
e=3D"font-size:12.8000001907349px">ok</span><br style=3D"font-size:12.80000=
01907349px"><span style=3D"font-size:12.8000001907349px">root@x86-generic-6=
4:~# multipathd -k&#39;show maps&#39;</span><br style=3D"font-size:12.80000=
01907349px"><span style=3D"font-size:12.8000001907349px">root@x86-generic-6=
4:~# multipathd -k&#39;add map dmpath0&#39;</span><br style=3D"font-size:12=
.8000001907349px"><span style=3D"font-size:12.8000001907349px">ok</span><br=
 style=3D"font-size:12.8000001907349px"><span style=3D"font-size:12.8000001=
907349px">root@x86-generic-64:~# multipathd -k&#39;show maps&#39;</span><br=
 style=3D"font-size:12.8000001907349px"><span style=3D"font-size:12.8000001=
907349px">root@x86-generic-64:~#</span><br style=3D"font-size:12.8000001907=
349px"><span style=3D"font-size:12.8000001907349px">Once a map is removed, =
we are able to add it only using #multipath=C2=A0 command and not using mul=
tipathd tools.</span></div><div><span style=3D"font-size:12.8000001907349px=
"><br></span></div><div><span style=3D"font-size:12.8000001907349px">I work=
ed on a fix for the same and the following patch solves the problem. There =
is also some unused code which could removed here in ev_add_map function.=
=C2=A0</span></div><div><span style=3D"font-size:12.8000001907349px">PFA th=
e patches.</span></div><div><span style=3D"font-size:12.8000001907349px"><b=
r></span></div><div><span style=3D"font-size:12.8000001907349px">It would b=
e great if the patches are reviewed. It would also help if someone could sh=
are the procedure for submission of patches.</span></div><div><br></div><di=
v><span style=3D"font-size:12.8000001907349px">Regards,</span></div><div><s=
pan style=3D"font-size:12.8000001907349px">Tejaswini=C2=A0</span><br style=
=3D"font-size:12.8000001907349px"></div></div>

--089e0102f4569fba50051a82b6d8--

--089e0102f4569fba57051a82b6da
Content-Type: text/x-patch; charset=US-ASCII; name="disable_code.patch"
Content-Disposition: attachment; filename="disable_code.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ibxh0h2g0

Y29tbWl0IDkxMGI0YTgyZWM0ODNiNDhlYWY4YjI0ZWIzZDc4MjkyNzNjNjkwZWQKQXV0aG9yOiBU
ZWphc3dpbmkgPHRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPgpEYXRlOiAgIFdlZCBKdWwgOCAx
NzoxODowMyAyMDE1ICswNTMwCgogICAgbXVsdGlwYXRoZDogRGlzYWJsZWQgY29kZSB0aGF0IGlz
IG5vdCBiZWluZyB1c2VkLgogICAgCiAgICBUaGlzIHBhcnQgb2YgdGhlIGNvZGUgaXMgbW92ZWQg
dG8gY2xpX2FkZF9tYXAgYW5kCiAgICBkaXNhYmxlZCBoZXJlIGFzIGl0IGlzIG5vdCB1c2VkIGJ5
IGFueSBmdW5jdGlvbiBjYWxsCiAgICBoZXJlLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBUZWph
c3dpbmkgPHRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPgoKZGlmZiAtLWdpdCBhL211bHRpcGF0
aGQvbWFpbi5jIGIvbXVsdGlwYXRoZC9tYWluLmMKaW5kZXggZjg3NjI1OC4uMDYwMjM3YyAxMDA2
NDQKLS0tIGEvbXVsdGlwYXRoZC9tYWluLmMKKysrIGIvbXVsdGlwYXRoZC9tYWluLmMKQEAgLTMy
OSw2ICszMjksOCBAQCBldl9hZGRfbWFwIChjaGFyICogZGV2LCBjaGFyICogYWxpYXMsIHN0cnVj
dCB2ZWN0b3JzICogdmVjcykKIAkJCXJldHVybiAxOwogCQl9CiAJfQorI2lmIDAgLypEaXNhYmxl
ZCBhcyB0aGUgY29kZSBpcyBub3QgYmVpbmcgdXNlZCBieSBhbnlvbmUuCisJVE9ETzpjb25maXJt
IHRoYXQgbm8gZmVhdHVyZSByZXF1aXJlcyB0aGlzIGNvZGUqLwogCXIgPSBnZXRfcmVmd3dpZChk
ZXYsIERFVl9ERVZNQVAsIHZlY3MtPnBhdGh2ZWMsICZyZWZ3d2lkKTsKIAogCWlmIChyZWZ3d2lk
KSB7CkBAIC0zNDQsNiArMzQ2LDcgQEAgZXZfYWRkX21hcCAoY2hhciAqIGRldiwgY2hhciAqIGFs
aWFzLCBzdHJ1Y3QgdmVjdG9ycyAqIHZlY3MpCiAJCWNvbmRsb2coMCwgIiVzOiB1ZXZfYWRkX21h
cCAlcyBmYWlsZWQiLCBhbGlhcywgZGV2KTsKIAogCUZSRUUocmVmd3dpZCk7CisjZW5kaWYKIAly
ZXR1cm4gcjsKIH0KIAo=
--089e0102f4569fba57051a82b6da
Content-Type: text/x-patch; charset=US-ASCII; name="add_map.patch"
Content-Disposition: attachment; filename="add_map.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ibxh0h2z1

Y29tbWl0IDc5YWI5MDkwZDNmYmNkYjU4NDQ0Nzg0MTkxMzVkMTM5MGNmNTQ4YzIKQXV0aG9yOiBU
ZWphc3dpbmkgPHRlamFzd2luaXBvbHVyaTNAZ21haWwuY29tPgpEYXRlOiAgIFdlZCBKdWwgOCAx
NTowODo1NiAyMDE1ICswNTMwCgogICAgbXVsdGlwYXRoZDogRml4aW5nIGFkZCBtYXAgZnVuY3Rp
b25hbGl0eQogICAgCiAgICBBZGQgbWFwIGZlYXR1cmUgb2YgbXVsdGlwYXRoZCB0b29scyBmYWls
cyBhcyB0aGUgZGV2aWNlCiAgICBpcyBhbHNvIGJlZW4gY29tcGxldGVseSByZW1vdmVkIGFsb25n
IHdpdGggcmVtb3ZpbmcgdGhlIG1hcAogICAgaW4gdGhlIHJlbW92ZSBtYXAgY29kZS4gU28gd2hl
biBhZGQgbWFwIGlzIGNhbGxlZCB3ZSBhcmUKICAgIGNyZWF0aW5nIHRoZSBkZXZpY2UgYWdhaW4g
aW4ga2VybmVsIGFuZCBkb2luZyBhZGQgbWFwCiAgICB1c2luZyB0aGUgY29sb2FzY2VfcGF0aHMg
Y29kZS4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogVGVqYXN3aW5pIFBvbHVyaSA8dHBvbHVyaUBt
dmlzdGEuY29tPgoKZGlmZiAtLWdpdCBhL211bHRpcGF0aGQvY2xpX2hhbmRsZXJzLmMgYi9tdWx0
aXBhdGhkL2NsaV9oYW5kbGVycy5jCmluZGV4IGRjOTZjNDUuLmM1NGM3NjcgMTAwNjQ0Ci0tLSBh
L211bHRpcGF0aGQvY2xpX2hhbmRsZXJzLmMKKysrIGIvbXVsdGlwYXRoZC9jbGlfaGFuZGxlcnMu
YwpAQCAtNTM3LDcgKzUzNyw3IEBAIGNsaV9hZGRfbWFwICh2b2lkICogdiwgY2hhciAqKiByZXBs
eSwgaW50ICogbGVuLCB2b2lkICogZGF0YSkKIAljaGFyIGRldl9wYXRoW1BBVEhfU0laRV07CiAJ
Y2hhciAqYWxpYXM7CiAJaW50IHJjOwotCisJY2hhciAqcmVmd3dpZDsKIAlwYXJhbSA9IGNvbnZl
cnRfZGV2KHBhcmFtLCAwKTsKIAljb25kbG9nKDIsICIlczogYWRkIG1hcCAob3BlcmF0b3IpIiwg
cGFyYW0pOwogCkBAIC01NDcsNiArNTQ3LDE0IEBAIGNsaV9hZGRfbWFwICh2b2lkICogdiwgY2hh
ciAqKiByZXBseSwgaW50ICogbGVuLCB2b2lkICogZGF0YSkKIAkJY29uZGxvZygyLCAiJXM6IG1h
cCBibGFja2xpc3RlZCIsIHBhcmFtKTsKIAkJcmV0dXJuIDA7CiAJfQorCXJjID0gZ2V0X3JlZnd3
aWQocGFyYW0sIERFVl9ERVZNQVAsIHZlY3MtPnBhdGh2ZWMsICZyZWZ3d2lkKTsKKworICAgICAg
ICBpZiAocmVmd3dpZCkgeworICAgICAgICAgICAgICAgIGNvbmRsb2coMiwgIiVzOiBhZGQgbWFw
IChvcGVyYXRvcikiLCByZWZ3d2lkKTsKKyAgICAgICAgICAgICAgICBpZihjb2FsZXNjZV9wYXRo
cyh2ZWNzLCBOVUxMLCByZWZ3d2lkLCAwKSkKKwkJCWNvbmRsb2coMiwgIiVzOiBjb2FsZXNjZS1w
YXRocyBmYWlsZWQiLCBwYXJhbSk7CisgICAgICAgICAgICAgICAgZG1fbGliX3JlbGVhc2UoKTsK
KyAgICAgICAgfQogCW1pbm9yID0gZG1fZ2V0X21pbm9yKHBhcmFtKTsKIAlpZiAobWlub3IgPCAw
KSB7CiAJCWNvbmRsb2coMiwgIiVzOiBub3QgYSBkZXZpY2UgbWFwcGVyIHRhYmxlIiwgcGFyYW0p
OwpAQCAtNTY2LDYgKzU3NCw3IEBAIGNsaV9hZGRfbWFwICh2b2lkICogdiwgY2hhciAqKiByZXBs
eSwgaW50ICogbGVuLCB2b2lkICogZGF0YSkKIAl9CiAJcmMgPSBldl9hZGRfbWFwKGRldl9wYXRo
LCBhbGlhcywgdmVjcyk7CiAJRlJFRShhbGlhcyk7CisJRlJFRShyZWZ3d2lkKTsKIAlyZXR1cm4g
cmM7CiB9CiAK
--089e0102f4569fba57051a82b6da
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--089e0102f4569fba57051a82b6da--
