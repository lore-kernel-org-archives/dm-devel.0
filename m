From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: [PATCH 1/2] dm: add stripe end_io function and event
	trigger
Date: Fri, 7 Dec 2007 12:10:51 -0800
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC01A86F93@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C8390D.453F3566"
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

------_=_NextPart_001_01C8390D.453F3566
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From: Brian Wood <brian.j.wood@intel.com>

This patch adds the stripe_end_io function to process errors that might
occur after an IO operation. As part of this there are a number of
enhancements made to record and trigger events:
	- New atomic variable in struct stripe to record the number of
errors each stripe volume has experienced (could be used later with
uevents to report back directly to userspace)
	- New workqueue/work struct setup to process the trigger_event
function
	- New trigger_event function to process failure events. This
will determine the exact stripe that cause the IO error, record the
error and call dm_table_event()
	- With this change Alasdair requested that the version number be
incremented

Signed-off-by: Brian Wood <brian.j.wood@intel.com>

--- linux-2.6.24-rc3/drivers/md/dm-stripe.c	2007-12-06
01:47:11.000000000 -0800
+++ linux-2.6.24-rc3.mod/drivers/md/dm-stripe.c	2007-12-06
01:45:25.000000000 -0800
@@ -12,10 +12,14 @@
 #include <linux/bio.h>
 #include <linux/slab.h>
 #include <linux/log2.h>
+#include <linux/namei.h>
=20
 #define DM_MSG_PREFIX "striped"
+#define IO_ERROR_COUNT 15
+#define DEV_STR_LEN 15
=20
 struct stripe {
+	atomic_t error_count;
 	struct dm_dev *dev;
 	sector_t physical_start;
 };
@@ -30,9 +34,71 @@ struct stripe_c {
 	uint32_t chunk_shift;
 	sector_t chunk_mask;
=20
+	/* Needed for handling events */
+	struct dm_target *ti;
+
+	/* Work struct used for triggering events*/
+	struct work_struct kstriped_ws;
+
 	struct stripe stripe[0];
 };
=20
+struct workqueue_struct *kstriped;
+
+/*
+ * An event is triggered whenever a drive
+ * drops out of a stripe volume.
+ */
+static void trigger_event(struct work_struct *work)
+{
+	int i, len;
+	char dev_path[DEV_STR_LEN];
+	struct stripe_c *sc =3D container_of(work, struct stripe_c,
kstriped_ws);
+	struct nameidata nd;
+	struct inode *inode;
+
+	/* Test to see which stripe drive triggered the event. */
+	for (i =3D 0; i < sc->stripes; i++) {
+		memset(dev_path, 0, DEV_STR_LEN);
+		memcpy(dev_path, "/dev/", len =3D strlen("/dev/"));
+		/* Copy name of the drive stored in the gendisk
structure
+		 * (this is the same name as what is stored in the
+		 * /proc and /sysfs filesystems */
+		memcpy(dev_path+len,
+			sc->stripe[i].dev->bdev->bd_disk->disk_name,
+
strlen(sc->stripe[i].dev->bdev->bd_disk->disk_name));
+
+		/* Check to see if path can be used to
+		 * fill nameidata structure */
+		if (path_lookup(dev_path, LOOKUP_FOLLOW, &nd)) {
+			atomic_inc(&(sc->stripe[i].error_count));
+			goto out;
+		}
+
+		/* Next check to see if device has an inode entry
+		 * (this is where it will likely find the disabled
device) */
+		inode =3D nd.dentry->d_inode;
+		if (!inode) {
+			atomic_inc(&(sc->stripe[i].error_count));
+			goto out;
+		}
+
+		/* Finally as a last check, see if the inode mode is set
+		 * to be a block device, record error if not */
+		if (!S_ISBLK(inode->i_mode))
+			atomic_inc(&(sc->stripe[i].error_count));
+
+out:
+		/* We don't want to generate hundreds of work queue
calls
+		 * when IO errors occur for a device, so we only queue
up the
+		 * first IO_ERROR_COUNT for a given underlying hardware
device.
+		 * After that point is reached we still record the
errors,
+		 * but won't call dm_table_event() to report them. */
+		if (atomic_read(&(sc->stripe[i].error_count)) <
IO_ERROR_COUNT)
+			dm_table_event(sc->ti->table);
+	}
+}
+
 static inline struct stripe_c *alloc_context(unsigned int stripes)
 {
 	size_t len;
@@ -63,6 +129,7 @@ static int get_stripe(struct dm_target *
 		return -ENXIO;
=20
 	sc->stripe[stripe].physical_start =3D start;
+
 	return 0;
 }
=20
@@ -135,6 +202,12 @@ static int stripe_ctr(struct dm_target *
 		return -ENOMEM;
 	}
=20
+	/* Initialize the work_struct */
+	INIT_WORK(&sc->kstriped_ws, trigger_event);
+
+	/* Set pointer to dm target; used in trigger_event */
+	sc->ti =3D ti;
+
 	sc->stripes =3D stripes;
 	sc->stripe_width =3D width;
 	ti->split_io =3D chunk_size;
@@ -149,7 +222,6 @@ static int stripe_ctr(struct dm_target *
 	 */
 	for (i =3D 0; i < stripes; i++) {
 		argv +=3D 2;
-
 		r =3D get_stripe(ti, sc, i, argv);
 		if (r < 0) {
 			ti->error =3D "Couldn't parse stripe destination";
@@ -158,9 +230,16 @@ static int stripe_ctr(struct dm_target *
 			kfree(sc);
 			return r;
 		}
+		/* Initialize error_count */
+		atomic_set(&(sc->stripe[i].error_count), 0);
 	}
=20
 	ti->private =3D sc;
+
+	/* Trigger event to let dmeventd daemon know to
+	 * check device status when stripe's DSO is registered*/
+	queue_work(kstriped, &sc->kstriped_ws);
+
 	return 0;
 }
=20
@@ -172,6 +251,7 @@ static void stripe_dtr(struct dm_target=20
 	for (i =3D 0; i < sc->stripes; i++)
 		dm_put_device(ti, sc->stripe[i].dev);
=20
+	flush_workqueue(kstriped);
 	kfree(sc);
 }
=20
@@ -213,13 +293,37 @@ static int stripe_status(struct dm_targe
 	return 0;
 }
=20
+static int stripe_end_io(struct dm_target *ti, struct bio *bio,
+			 int error, union map_info *map_context)
+{
+	struct stripe_c *sc =3D (struct stripe_c *) ti->private;
+
+	if (!error)
+		return 0; /* I/O complete */
+
+	if ((error =3D=3D -EWOULDBLOCK) && bio_rw_ahead(bio))
+		return error;
+
+	if (error =3D=3D -EOPNOTSUPP)
+		return error;
+
+	/* Error not caught above, trigger event.
+	 * For example, if member device gets
+	 * disconnected this sets "error =3D=3D -5" */
+	if (error < 0)
+		queue_work(kstriped, &sc->kstriped_ws);
+
+	return error;
+}
+
 static struct target_type stripe_target =3D {
 	.name   =3D "striped",
-	.version=3D {1, 0, 2},
+	.version =3D {1, 1, 2},
 	.module =3D THIS_MODULE,
 	.ctr    =3D stripe_ctr,
 	.dtr    =3D stripe_dtr,
 	.map    =3D stripe_map,
+	.end_io =3D stripe_end_io,
 	.status =3D stripe_status,
 };
=20
@@ -231,6 +335,13 @@ int __init dm_stripe_init(void)
 	if (r < 0)
 		DMWARN("target registration failed");
=20
+	kstriped =3D create_singlethread_workqueue("kstriped");
+	if (!kstriped) {
+		DMERR("failed to create workqueue kstriped");
+		dm_unregister_target(&stripe_target);
+		return -ENOMEM;
+	}
+
 	return r;
 }
=20
@@ -239,5 +350,7 @@ void dm_stripe_exit(void)
 	if (dm_unregister_target(&stripe_target))
 		DMWARN("target unregistration failed");
=20
+	destroy_workqueue(kstriped);
+
 	return;
 }

Brian Wood
Software Engineer
Intel Corp., Manageability & Platform Software Division
brian.j.wood@intel.com


------_=_NextPart_001_01C8390D.453F3566
Content-Type: application/octet-stream;
	name="dm-stripe-end_io-event-trigger.patch"
Content-Transfer-Encoding: base64
Content-Description: dm-stripe-end_io-event-trigger.patch
Content-Disposition: attachment;
	filename="dm-stripe-end_io-event-trigger.patch"

RnJvbTogQnJpYW4gV29vZCA8YnJpYW4uai53b29kQGludGVsLmNvbT4KClRoaXMgcGF0Y2ggYWRk
cyB0aGUgc3RyaXBlX2VuZF9pbyBmdW5jdGlvbiB0byBwcm9jZXNzIGVycm9ycyB0aGF0IG1pZ2h0
Cm9jY3VyIGFmdGVyIGFuIElPIG9wZXJhdGlvbi4gQXMgcGFydCBvZiB0aGlzIHRoZXJlIGFyZSBh
IG51bWJlciBvZgplbmhhbmNlbWVudHMgbWFkZSB0byByZWNvcmQgYW5kIHRyaWdnZXIgZXZlbnRz
OgoJLSBOZXcgYXRvbWljIHZhcmlhYmxlIGluIHN0cnVjdCBzdHJpcGUgdG8gcmVjb3JkIHRoZSBu
dW1iZXIgb2YKZXJyb3JzIGVhY2ggc3RyaXBlIHZvbHVtZSBoYXMgZXhwZXJpZW5jZWQgKGNvdWxk
IGJlIHVzZWQgbGF0ZXIgd2l0aAp1ZXZlbnRzIHRvIHJlcG9ydCBiYWNrIGRpcmVjdGx5IHRvIHVz
ZXJzcGFjZSkKCS0gTmV3IHdvcmtxdWV1ZS93b3JrIHN0cnVjdCBzZXR1cCB0byBwcm9jZXNzIHRo
ZSB0cmlnZ2VyX2V2ZW50CmZ1bmN0aW9uCgktIE5ldyB0cmlnZ2VyX2V2ZW50IGZ1bmN0aW9uIHRv
IHByb2Nlc3MgZmFpbHVyZSBldmVudHMuIFRoaXMKd2lsbCBkZXRlcm1pbmUgdGhlIGV4YWN0IHN0
cmlwZSB0aGF0IGNhdXNlIHRoZSBJTyBlcnJvciwgcmVjb3JkIHRoZQplcnJvciBhbmQgY2FsbCBk
bV90YWJsZV9ldmVudCgpCgktIFdpdGggdGhpcyBjaGFuZ2UgQWxhc2RhaXIgcmVxdWVzdGVkIHRo
YXQgdGhlIHZlcnNpb24gbnVtYmVyIGJlCmluY3JlbWVudGVkCgpTaWduZWQtb2ZmLWJ5OiBCcmlh
biBXb29kIDxicmlhbi5qLndvb2RAaW50ZWwuY29tPgoKLS0tIGxpbnV4LTIuNi4yNC1yYzMvZHJp
dmVycy9tZC9kbS1zdHJpcGUuYwkyMDA3LTEyLTA2IDAxOjQ3OjExLjAwMDAwMDAwMCAtMDgwMAor
KysgbGludXgtMi42LjI0LXJjMy5tb2QvZHJpdmVycy9tZC9kbS1zdHJpcGUuYwkyMDA3LTEyLTA2
IDAxOjQ1OjI1LjAwMDAwMDAwMCAtMDgwMApAQCAtMTIsMTAgKzEyLDE0IEBACiAjaW5jbHVkZSA8
bGludXgvYmlvLmg+CiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPgogI2luY2x1ZGUgPGxpbnV4L2xv
ZzIuaD4KKyNpbmNsdWRlIDxsaW51eC9uYW1laS5oPgogCiAjZGVmaW5lIERNX01TR19QUkVGSVgg
InN0cmlwZWQiCisjZGVmaW5lIElPX0VSUk9SX0NPVU5UIDE1CisjZGVmaW5lIERFVl9TVFJfTEVO
IDE1CiAKIHN0cnVjdCBzdHJpcGUgeworCWF0b21pY190IGVycm9yX2NvdW50OwogCXN0cnVjdCBk
bV9kZXYgKmRldjsKIAlzZWN0b3JfdCBwaHlzaWNhbF9zdGFydDsKIH07CkBAIC0zMCw5ICszNCw3
MSBAQCBzdHJ1Y3Qgc3RyaXBlX2MgewogCXVpbnQzMl90IGNodW5rX3NoaWZ0OwogCXNlY3Rvcl90
IGNodW5rX21hc2s7CiAKKwkvKiBOZWVkZWQgZm9yIGhhbmRsaW5nIGV2ZW50cyAqLworCXN0cnVj
dCBkbV90YXJnZXQgKnRpOworCisJLyogV29yayBzdHJ1Y3QgdXNlZCBmb3IgdHJpZ2dlcmluZyBl
dmVudHMqLworCXN0cnVjdCB3b3JrX3N0cnVjdCBrc3RyaXBlZF93czsKKwogCXN0cnVjdCBzdHJp
cGUgc3RyaXBlWzBdOwogfTsKIAorc3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QgKmtzdHJpcGVkOwor
CisvKgorICogQW4gZXZlbnQgaXMgdHJpZ2dlcmVkIHdoZW5ldmVyIGEgZHJpdmUKKyAqIGRyb3Bz
IG91dCBvZiBhIHN0cmlwZSB2b2x1bWUuCisgKi8KK3N0YXRpYyB2b2lkIHRyaWdnZXJfZXZlbnQo
c3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQoreworCWludCBpLCBsZW47CisJY2hhciBkZXZfcGF0
aFtERVZfU1RSX0xFTl07CisJc3RydWN0IHN0cmlwZV9jICpzYyA9IGNvbnRhaW5lcl9vZih3b3Jr
LCBzdHJ1Y3Qgc3RyaXBlX2MsIGtzdHJpcGVkX3dzKTsKKwlzdHJ1Y3QgbmFtZWlkYXRhIG5kOwor
CXN0cnVjdCBpbm9kZSAqaW5vZGU7CisKKwkvKiBUZXN0IHRvIHNlZSB3aGljaCBzdHJpcGUgZHJp
dmUgdHJpZ2dlcmVkIHRoZSBldmVudC4gKi8KKwlmb3IgKGkgPSAwOyBpIDwgc2MtPnN0cmlwZXM7
IGkrKykgeworCQltZW1zZXQoZGV2X3BhdGgsIDAsIERFVl9TVFJfTEVOKTsKKwkJbWVtY3B5KGRl
dl9wYXRoLCAiL2Rldi8iLCBsZW4gPSBzdHJsZW4oIi9kZXYvIikpOworCQkvKiBDb3B5IG5hbWUg
b2YgdGhlIGRyaXZlIHN0b3JlZCBpbiB0aGUgZ2VuZGlzayBzdHJ1Y3R1cmUKKwkJICogKHRoaXMg
aXMgdGhlIHNhbWUgbmFtZSBhcyB3aGF0IGlzIHN0b3JlZCBpbiB0aGUKKwkJICogL3Byb2MgYW5k
IC9zeXNmcyBmaWxlc3lzdGVtcyAqLworCQltZW1jcHkoZGV2X3BhdGgrbGVuLAorCQkJc2MtPnN0
cmlwZVtpXS5kZXYtPmJkZXYtPmJkX2Rpc2stPmRpc2tfbmFtZSwKKwkJCXN0cmxlbihzYy0+c3Ry
aXBlW2ldLmRldi0+YmRldi0+YmRfZGlzay0+ZGlza19uYW1lKSk7CisKKwkJLyogQ2hlY2sgdG8g
c2VlIGlmIHBhdGggY2FuIGJlIHVzZWQgdG8KKwkJICogZmlsbCBuYW1laWRhdGEgc3RydWN0dXJl
ICovCisJCWlmIChwYXRoX2xvb2t1cChkZXZfcGF0aCwgTE9PS1VQX0ZPTExPVywgJm5kKSkgewor
CQkJYXRvbWljX2luYygmKHNjLT5zdHJpcGVbaV0uZXJyb3JfY291bnQpKTsKKwkJCWdvdG8gb3V0
OworCQl9CisKKwkJLyogTmV4dCBjaGVjayB0byBzZWUgaWYgZGV2aWNlIGhhcyBhbiBpbm9kZSBl
bnRyeQorCQkgKiAodGhpcyBpcyB3aGVyZSBpdCB3aWxsIGxpa2VseSBmaW5kIHRoZSBkaXNhYmxl
ZCBkZXZpY2UpICovCisJCWlub2RlID0gbmQuZGVudHJ5LT5kX2lub2RlOworCQlpZiAoIWlub2Rl
KSB7CisJCQlhdG9taWNfaW5jKCYoc2MtPnN0cmlwZVtpXS5lcnJvcl9jb3VudCkpOworCQkJZ290
byBvdXQ7CisJCX0KKworCQkvKiBGaW5hbGx5IGFzIGEgbGFzdCBjaGVjaywgc2VlIGlmIHRoZSBp
bm9kZSBtb2RlIGlzIHNldAorCQkgKiB0byBiZSBhIGJsb2NrIGRldmljZSwgcmVjb3JkIGVycm9y
IGlmIG5vdCAqLworCQlpZiAoIVNfSVNCTEsoaW5vZGUtPmlfbW9kZSkpCisJCQlhdG9taWNfaW5j
KCYoc2MtPnN0cmlwZVtpXS5lcnJvcl9jb3VudCkpOworCitvdXQ6CisJCS8qIFdlIGRvbid0IHdh
bnQgdG8gZ2VuZXJhdGUgaHVuZHJlZHMgb2Ygd29yayBxdWV1ZSBjYWxscworCQkgKiB3aGVuIElP
IGVycm9ycyBvY2N1ciBmb3IgYSBkZXZpY2UsIHNvIHdlIG9ubHkgcXVldWUgdXAgdGhlCisJCSAq
IGZpcnN0IElPX0VSUk9SX0NPVU5UIGZvciBhIGdpdmVuIHVuZGVybHlpbmcgaGFyZHdhcmUgZGV2
aWNlLgorCQkgKiBBZnRlciB0aGF0IHBvaW50IGlzIHJlYWNoZWQgd2Ugc3RpbGwgcmVjb3JkIHRo
ZSBlcnJvcnMsCisJCSAqIGJ1dCB3b24ndCBjYWxsIGRtX3RhYmxlX2V2ZW50KCkgdG8gcmVwb3J0
IHRoZW0uICovCisJCWlmIChhdG9taWNfcmVhZCgmKHNjLT5zdHJpcGVbaV0uZXJyb3JfY291bnQp
KSA8IElPX0VSUk9SX0NPVU5UKQorCQkJZG1fdGFibGVfZXZlbnQoc2MtPnRpLT50YWJsZSk7CisJ
fQorfQorCiBzdGF0aWMgaW5saW5lIHN0cnVjdCBzdHJpcGVfYyAqYWxsb2NfY29udGV4dCh1bnNp
Z25lZCBpbnQgc3RyaXBlcykKIHsKIAlzaXplX3QgbGVuOwpAQCAtNjMsNiArMTI5LDcgQEAgc3Rh
dGljIGludCBnZXRfc3RyaXBlKHN0cnVjdCBkbV90YXJnZXQgKgogCQlyZXR1cm4gLUVOWElPOwog
CiAJc2MtPnN0cmlwZVtzdHJpcGVdLnBoeXNpY2FsX3N0YXJ0ID0gc3RhcnQ7CisKIAlyZXR1cm4g
MDsKIH0KIApAQCAtMTM1LDYgKzIwMiwxMiBAQCBzdGF0aWMgaW50IHN0cmlwZV9jdHIoc3RydWN0
IGRtX3RhcmdldCAqCiAJCXJldHVybiAtRU5PTUVNOwogCX0KIAorCS8qIEluaXRpYWxpemUgdGhl
IHdvcmtfc3RydWN0ICovCisJSU5JVF9XT1JLKCZzYy0+a3N0cmlwZWRfd3MsIHRyaWdnZXJfZXZl
bnQpOworCisJLyogU2V0IHBvaW50ZXIgdG8gZG0gdGFyZ2V0OyB1c2VkIGluIHRyaWdnZXJfZXZl
bnQgKi8KKwlzYy0+dGkgPSB0aTsKKwogCXNjLT5zdHJpcGVzID0gc3RyaXBlczsKIAlzYy0+c3Ry
aXBlX3dpZHRoID0gd2lkdGg7CiAJdGktPnNwbGl0X2lvID0gY2h1bmtfc2l6ZTsKQEAgLTE0OSw3
ICsyMjIsNiBAQCBzdGF0aWMgaW50IHN0cmlwZV9jdHIoc3RydWN0IGRtX3RhcmdldCAqCiAJICov
CiAJZm9yIChpID0gMDsgaSA8IHN0cmlwZXM7IGkrKykgewogCQlhcmd2ICs9IDI7Ci0KIAkJciA9
IGdldF9zdHJpcGUodGksIHNjLCBpLCBhcmd2KTsKIAkJaWYgKHIgPCAwKSB7CiAJCQl0aS0+ZXJy
b3IgPSAiQ291bGRuJ3QgcGFyc2Ugc3RyaXBlIGRlc3RpbmF0aW9uIjsKQEAgLTE1OCw5ICsyMzAs
MTYgQEAgc3RhdGljIGludCBzdHJpcGVfY3RyKHN0cnVjdCBkbV90YXJnZXQgKgogCQkJa2ZyZWUo
c2MpOwogCQkJcmV0dXJuIHI7CiAJCX0KKwkJLyogSW5pdGlhbGl6ZSBlcnJvcl9jb3VudCAqLwor
CQlhdG9taWNfc2V0KCYoc2MtPnN0cmlwZVtpXS5lcnJvcl9jb3VudCksIDApOwogCX0KIAogCXRp
LT5wcml2YXRlID0gc2M7CisKKwkvKiBUcmlnZ2VyIGV2ZW50IHRvIGxldCBkbWV2ZW50ZCBkYWVt
b24ga25vdyB0bworCSAqIGNoZWNrIGRldmljZSBzdGF0dXMgd2hlbiBzdHJpcGUncyBEU08gaXMg
cmVnaXN0ZXJlZCovCisJcXVldWVfd29yayhrc3RyaXBlZCwgJnNjLT5rc3RyaXBlZF93cyk7CisK
IAlyZXR1cm4gMDsKIH0KIApAQCAtMTcyLDYgKzI1MSw3IEBAIHN0YXRpYyB2b2lkIHN0cmlwZV9k
dHIoc3RydWN0IGRtX3RhcmdldCAKIAlmb3IgKGkgPSAwOyBpIDwgc2MtPnN0cmlwZXM7IGkrKykK
IAkJZG1fcHV0X2RldmljZSh0aSwgc2MtPnN0cmlwZVtpXS5kZXYpOwogCisJZmx1c2hfd29ya3F1
ZXVlKGtzdHJpcGVkKTsKIAlrZnJlZShzYyk7CiB9CiAKQEAgLTIxMywxMyArMjkzLDM3IEBAIHN0
YXRpYyBpbnQgc3RyaXBlX3N0YXR1cyhzdHJ1Y3QgZG1fdGFyZ2UKIAlyZXR1cm4gMDsKIH0KIAor
c3RhdGljIGludCBzdHJpcGVfZW5kX2lvKHN0cnVjdCBkbV90YXJnZXQgKnRpLCBzdHJ1Y3QgYmlv
ICpiaW8sCisJCQkgaW50IGVycm9yLCB1bmlvbiBtYXBfaW5mbyAqbWFwX2NvbnRleHQpCit7CisJ
c3RydWN0IHN0cmlwZV9jICpzYyA9IChzdHJ1Y3Qgc3RyaXBlX2MgKikgdGktPnByaXZhdGU7CisK
KwlpZiAoIWVycm9yKQorCQlyZXR1cm4gMDsgLyogSS9PIGNvbXBsZXRlICovCisKKwlpZiAoKGVy
cm9yID09IC1FV09VTERCTE9DSykgJiYgYmlvX3J3X2FoZWFkKGJpbykpCisJCXJldHVybiBlcnJv
cjsKKworCWlmIChlcnJvciA9PSAtRU9QTk9UU1VQUCkKKwkJcmV0dXJuIGVycm9yOworCisJLyog
RXJyb3Igbm90IGNhdWdodCBhYm92ZSwgdHJpZ2dlciBldmVudC4KKwkgKiBGb3IgZXhhbXBsZSwg
aWYgbWVtYmVyIGRldmljZSBnZXRzCisJICogZGlzY29ubmVjdGVkIHRoaXMgc2V0cyAiZXJyb3Ig
PT0gLTUiICovCisJaWYgKGVycm9yIDwgMCkKKwkJcXVldWVfd29yayhrc3RyaXBlZCwgJnNjLT5r
c3RyaXBlZF93cyk7CisKKwlyZXR1cm4gZXJyb3I7Cit9CisKIHN0YXRpYyBzdHJ1Y3QgdGFyZ2V0
X3R5cGUgc3RyaXBlX3RhcmdldCA9IHsKIAkubmFtZSAgID0gInN0cmlwZWQiLAotCS52ZXJzaW9u
PSB7MSwgMCwgMn0sCisJLnZlcnNpb24gPSB7MSwgMSwgMn0sCiAJLm1vZHVsZSA9IFRISVNfTU9E
VUxFLAogCS5jdHIgICAgPSBzdHJpcGVfY3RyLAogCS5kdHIgICAgPSBzdHJpcGVfZHRyLAogCS5t
YXAgICAgPSBzdHJpcGVfbWFwLAorCS5lbmRfaW8gPSBzdHJpcGVfZW5kX2lvLAogCS5zdGF0dXMg
PSBzdHJpcGVfc3RhdHVzLAogfTsKIApAQCAtMjMxLDYgKzMzNSwxMyBAQCBpbnQgX19pbml0IGRt
X3N0cmlwZV9pbml0KHZvaWQpCiAJaWYgKHIgPCAwKQogCQlETVdBUk4oInRhcmdldCByZWdpc3Ry
YXRpb24gZmFpbGVkIik7CiAKKwlrc3RyaXBlZCA9IGNyZWF0ZV9zaW5nbGV0aHJlYWRfd29ya3F1
ZXVlKCJrc3RyaXBlZCIpOworCWlmICgha3N0cmlwZWQpIHsKKwkJRE1FUlIoImZhaWxlZCB0byBj
cmVhdGUgd29ya3F1ZXVlIGtzdHJpcGVkIik7CisJCWRtX3VucmVnaXN0ZXJfdGFyZ2V0KCZzdHJp
cGVfdGFyZ2V0KTsKKwkJcmV0dXJuIC1FTk9NRU07CisJfQorCiAJcmV0dXJuIHI7CiB9CiAKQEAg
LTIzOSw1ICszNTAsNyBAQCB2b2lkIGRtX3N0cmlwZV9leGl0KHZvaWQpCiAJaWYgKGRtX3VucmVn
aXN0ZXJfdGFyZ2V0KCZzdHJpcGVfdGFyZ2V0KSkKIAkJRE1XQVJOKCJ0YXJnZXQgdW5yZWdpc3Ry
YXRpb24gZmFpbGVkIik7CiAKKwlkZXN0cm95X3dvcmtxdWV1ZShrc3RyaXBlZCk7CisKIAlyZXR1
cm47CiB9Cg==

------_=_NextPart_001_01C8390D.453F3566
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C8390D.453F3566--
