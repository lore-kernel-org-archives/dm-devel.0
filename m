From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: [PATCH] Error check for NULL pointer libdm-iface.c
Date: Thu, 2 Aug 2007 16:21:35 -0700
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC012EF0AF@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C7D55B.DE5FB250"
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7D55B.DE5FB250
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi everyone, I've made a patch for the NULL pointer segmentation fault
error I found in the file libdm-iface.c. Here's the patch text:

--- device-mapper.orig/lib/ioctl/libdm-iface.c	2007-08-02
15:58:25.000000000 -0700
+++ device-mapper/lib/ioctl/libdm-iface.c	2007-08-02
15:59:59.000000000 -0700
@@ -321,6 +321,9 @@
 {
 	struct target *t, *n;
=20
+	if(!dmt)
+		return; /* NULL pointer would cause segfault */
+=09
 	for (t =3D dmt->head; t; t =3D n) {
 		n =3D t->next;
 		dm_free(t->params);


Is there a contact person that I would submit userspace patches to? I
know Alasdair is the device-mapper maintainer, so is he the contact I
should submit to instead of the mailing list?

Thank you, =20

Brian Wood
Intel Corporation=20
Digital Enterprise Group
Manageability & Platform Software Division
brian.j.wood@intel.com


------_=_NextPart_001_01C7D55B.DE5FB250
Content-Type: application/octet-stream;
	name="libdm-iface_fix_segfault_dm_task_destroy.patch"
Content-Transfer-Encoding: base64
Content-Description: libdm-iface_fix_segfault_dm_task_destroy.patch
Content-Disposition: attachment;
	filename="libdm-iface_fix_segfault_dm_task_destroy.patch"

LS0tIGRldmljZS1tYXBwZXIub3JpZy9saWIvaW9jdGwvbGliZG0taWZhY2UuYwkyMDA3LTA4LTAy
IDE1OjU4OjI1LjAwMDAwMDAwMCAtMDcwMAorKysgZGV2aWNlLW1hcHBlci9saWIvaW9jdGwvbGli
ZG0taWZhY2UuYwkyMDA3LTA4LTAyIDE1OjU5OjU5LjAwMDAwMDAwMCAtMDcwMApAQCAtMzIxLDYg
KzMyMSw5IEBACiB7CiAJc3RydWN0IHRhcmdldCAqdCwgKm47CiAKKwlpZighZG10KQorCQlyZXR1
cm47IC8qIE5VTEwgcG9pbnRlciB3b3VsZCBjYXVzZSBzZWdmYXVsdCAqLworCQogCWZvciAodCA9
IGRtdC0+aGVhZDsgdDsgdCA9IG4pIHsKIAkJbiA9IHQtPm5leHQ7CiAJCWRtX2ZyZWUodC0+cGFy
YW1zKTsK

------_=_NextPart_001_01C7D55B.DE5FB250
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C7D55B.DE5FB250--
