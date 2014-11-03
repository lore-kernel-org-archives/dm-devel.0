From: James Simmons <uja.ornl@gmail.com>
Subject: [PATCH] md: submit MMP reads REQ_SYNC to bypass RAID5
	cache
Date: Mon, 3 Nov 2014 14:01:10 -0700
Message-ID: <CAOdCWHxeE47jwjJvyWOoHdjZ4LaDFQiZZbGpqdLZzd+PjzpyRw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1134a2c46d49320506faa594
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
To: dm-devel@redhat.com
Cc: andreas.dilger@intel.com, bruno.faccini@intel.com
List-Id: dm-devel.ids

--001a1134a2c46d49320506faa594
Content-Type: multipart/alternative; boundary=001a1134a2c46d492d0506faa592

--001a1134a2c46d492d0506faa592
Content-Type: text/plain; charset=UTF-8

Hello.

   This is a patch against the latest kernel source which is based on
a patch used by Lustre. The below describes what we are trying to
achieve. I like to get a feedback if this is the right approach.

----------------------------------------------------------------------

The ext4 MMP block reads always need to get fresh data from the
underlying disk.  Otherwise, if a remote node is updating the MMP
block and the reads are fetched from the MD RAID5 stripe cache,
it is possible that the local node will incorrectly decide the
remote node has died and allow the filesystem to be mounted on
two nodes at the same time.

--001a1134a2c46d492d0506faa592
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><pre style=3D"color:rgb(0,0,0);word-wrap:break-word;white-=
space:pre-wrap">Hello.</pre><pre style=3D"color:rgb(0,0,0);word-wrap:break-=
word;white-space:pre-wrap">   This is a patch against the latest kernel sou=
rce which is based on a patch used by Lustre. The below describes what we a=
re trying to achieve. I like to get a feedback if this is the right approac=
h.</pre><pre style=3D"color:rgb(0,0,0);word-wrap:break-word;white-space:pre=
-wrap">--------------------------------------------------------------------=
--</pre><pre style=3D"color:rgb(0,0,0);word-wrap:break-word;white-space:pre=
-wrap">The ext4 MMP block reads always need to get fresh data from the
underlying disk.  Otherwise, if a remote node is updating the MMP
block and the reads are fetched from the MD RAID5 stripe cache,
it is possible that the local node will incorrectly decide the
remote node has died and allow the filesystem to be mounted on
two nodes at the same time.
</pre><div><br></div></div>

--001a1134a2c46d492d0506faa592--

--001a1134a2c46d49320506faa594
Content-Type: text/plain; charset=US-ASCII; name="raid5.diff"
Content-Disposition: attachment; filename="raid5.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i22be3qd0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvcmFpZDUuYyBiL2RyaXZlcnMvbWQvcmFpZDUuYwppbmRl
eCA5YzY2ZTU5Li4xMWI3NDljIDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL3JhaWQ1LmMKKysrIGIv
ZHJpdmVycy9tZC9yYWlkNS5jCkBAIC0yNjc4LDYgKzI2NzgsOSBAQCBzdGF0aWMgaW50IGFkZF9z
dHJpcGVfYmlvKHN0cnVjdCBzdHJpcGVfaGVhZCAqc2gsIHN0cnVjdCBiaW8gKmJpLCBpbnQgZGRf
aWR4LCBpbgogCQl9CiAJCWlmIChzZWN0b3IgPj0gc2gtPmRldltkZF9pZHhdLnNlY3RvciArIFNU
UklQRV9TRUNUT1JTKQogCQkJc2V0X2JpdChSNV9PVkVSV1JJVEUsICZzaC0+ZGV2W2RkX2lkeF0u
ZmxhZ3MpOworCX0gZWxzZSBpZiAoYmktPmJpX3J3ICYgUkVRX05PQ0FDSEUpIHsKKwkJLyogZm9y
Y2UgdG8gcmVhZCBmcm9tIHVuZGVybHlpbmcgZGlzayBpZiByZXF1ZXN0ZWQgKi8KKwkJY2xlYXJf
Yml0KFI1X1VQVE9EQVRFLCAmc2gtPmRldltkZF9pZHhdLmZsYWdzKTsKIAl9CiAKIAlwcl9kZWJ1
ZygiYWRkZWQgYmkgYiMlbGx1IHRvIHN0cmlwZSBzIyVsbHUsIGRpc2sgJWQuXG4iLApAQCAtNDc0
MCw2ICs0NzQzLDkgQEAgc3RhdGljIHZvaWQgbWFrZV9yZXF1ZXN0KHN0cnVjdCBtZGRldiAqbWRk
ZXYsIHN0cnVjdCBiaW8gKiBiaSkKIAkJCQkJIGJpLCAwKTsKIAkJYmlvX2VuZGlvKGJpLCAwKTsK
IAl9CisKKwlpZiAoYmktPmJpX3J3ICYgUkVRX05PQ0FDSEUpCisJCW1kX3dha2V1cF90aHJlYWQo
bWRkZXYtPnRocmVhZCk7CiB9CiAKIHN0YXRpYyBzZWN0b3JfdCByYWlkNV9zaXplKHN0cnVjdCBt
ZGRldiAqbWRkZXYsIHNlY3Rvcl90IHNlY3RvcnMsIGludCByYWlkX2Rpc2tzKTsKZGlmZiAtLWdp
dCBhL2luY2x1ZGUvbGludXgvYmxrX3R5cGVzLmggYi9pbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5o
CmluZGV4IDQ0NWQ1OTIuLjZjMzI5YzkgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvYmxrX3R5
cGVzLmgKKysrIGIvaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaApAQCAtMTY1LDYgKzE2NSw3IEBA
IGVudW0gcnFfZmxhZ19iaXRzIHsKIAlfX1JFUV9JTlRFR1JJVFksCS8qIEkvTyBpbmNsdWRlcyBi
bG9jayBpbnRlZ3JpdHkgcGF5bG9hZCAqLwogCV9fUkVRX0ZVQSwJCS8qIGZvcmNlZCB1bml0IGFj
Y2VzcyAqLwogCV9fUkVRX0ZMVVNILAkJLyogcmVxdWVzdCBmb3IgY2FjaGUgZmx1c2ggKi8KKwlf
X1JFUV9OT0NBQ0hFLAkJLyogcmVxdWVzdCBieXBhc3MgYW55IGNhY2hlICovCiAKIAkvKiBiaW8g
b25seSBmbGFncyAqLwogCV9fUkVRX1JBSEVBRCwJCS8qIHJlYWQgYWhlYWQsIGNhbiBmYWlsIGFu
eXRpbWUgKi8KQEAgLTIzOSw2ICsyNDAsNyBAQCBlbnVtIHJxX2ZsYWdfYml0cyB7CiAjZGVmaW5l
IFJFUV9GTFVTSF9TRVEJCSgxVUxMIDw8IF9fUkVRX0ZMVVNIX1NFUSkKICNkZWZpbmUgUkVRX0lP
X1NUQVQJCSgxVUxMIDw8IF9fUkVRX0lPX1NUQVQpCiAjZGVmaW5lIFJFUV9NSVhFRF9NRVJHRQkJ
KDFVTEwgPDwgX19SRVFfTUlYRURfTUVSR0UpCisjZGVmaW5lIFJFUV9OT0NBQ0hFCQkoMVVMTCA8
PCBfX1JFUV9OT0NBQ0hFKQogI2RlZmluZSBSRVFfU0VDVVJFCQkoMVVMTCA8PCBfX1JFUV9TRUNV
UkUpCiAjZGVmaW5lIFJFUV9QTQkJCSgxVUxMIDw8IF9fUkVRX1BNKQogI2RlZmluZSBSRVFfSEFT
SEVECQkoMVVMTCA8PCBfX1JFUV9IQVNIRUQpCg==
--001a1134a2c46d49320506faa594
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--001a1134a2c46d49320506faa594--
