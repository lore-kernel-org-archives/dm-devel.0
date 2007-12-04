From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: [PATCH 1/2] add stripe end_io function and event trigger
Date: Tue, 4 Dec 2007 09:36:29 -0800
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC01A1DFE8@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
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

--- linux-2.6.24-rc3/drivers/md/dm-stripe.c	2007-11-16
21:16:36.000000000 -0800
+++ linux-2.6.24-rc3.mod/drivers/md/dm-stripe.c	2007-12-03
07:08:16.000000000 -0800
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
@@ -30,9 +34,69 @@
 	uint32_t chunk_shift;
 	sector_t chunk_mask;
=20
-	struct stripe stripe[0];
+	/* Needed for handling events */
+	struct dm_target *ti;
+=09
+	/* Work struct used for triggering events*/
+	struct work_struct kstriped_ws;
+
+	struct stripe stripe[0];=09
 };
=20
+struct workqueue_struct *kstriped;
+
+/*
+ * An event is triggered whenever a drive=20
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
+		memset(dev_path, 0, DEV_STR_LEN);=20
+		memcpy(dev_path, "/dev/", len =3D strlen("/dev/"));
+		/* Copy name of the drive stored in the gendisk
structure
+		 * (this is the same name as what is stored in the /proc
and /sysfs filesystems */
+		memcpy(dev_path+len,
sc->stripe[i].dev->bdev->bd_disk->disk_name,=20
+
strlen(sc->stripe[i].dev->bdev->bd_disk->disk_name)); 		=09
+	=09
+		/* Check to see if path can be used to fill nameidata
structure */
+		if (path_lookup(dev_path, LOOKUP_FOLLOW, &nd)) {
+			atomic_inc(&(sc->stripe[i].error_count));
+			goto out;
+		}
+	=09
+		/* Next check to see if device has an inode entry=20
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
+		if (!S_ISBLK(inode->i_mode)) {
+			atomic_inc(&(sc->stripe[i].error_count));
+		}
+out:	=09
+		/* We don't want to generate hundreds of work queue
calls
+		 * when IO errors occur for a device, so we only queue
up the=20
+		 * first IO_ERROR_COUNT for a given underlying hardware
device.=20
+		 * After that point is reached we still record the
errors,=20
+		 * but won't call dm_table_event() to report them. */
+		if(atomic_read(&(sc->stripe[i].error_count)) <
IO_ERROR_COUNT) {
+			dm_table_event(sc->ti->table);
+		}
+	}
+}
+
 static inline struct stripe_c *alloc_context(unsigned int stripes)
 {
 	size_t len;
@@ -63,6 +127,7 @@
 		return -ENXIO;
=20
 	sc->stripe[stripe].physical_start =3D start;
+=09
 	return 0;
 }
=20
@@ -134,6 +199,12 @@
 		    "failed";
 		return -ENOMEM;
 	}
+=09
+	/* Initialize the work_struct */=09
+	INIT_WORK(&sc->kstriped_ws, trigger_event);
+
+	/* Set pointer to dm target; used in trigger_event */
+	sc->ti =3D ti;
=20
 	sc->stripes =3D stripes;
 	sc->stripe_width =3D width;
@@ -143,13 +214,12 @@
 	for (sc->chunk_shift =3D 0; chunk_size; sc->chunk_shift++)
 		chunk_size >>=3D 1;
 	sc->chunk_shift--;
-
+=09
 	/*
 	 * Get the stripe destinations.
 	 */
 	for (i =3D 0; i < stripes; i++) {
 		argv +=3D 2;
-
 		r =3D get_stripe(ti, sc, i, argv);
 		if (r < 0) {
 			ti->error =3D "Couldn't parse stripe destination";
@@ -158,9 +228,16 @@
 			kfree(sc);
 			return r;
 		}
+		/* Initialize error_count */
+		atomic_set(&(sc->stripe[i].error_count), 0);
 	}
=20
 	ti->private =3D sc;
+=09
+	/* Trigger event to let dmeventd daemon know to
+	 * check device status when stripe's DSO is registered*/
+	queue_work(kstriped, &sc->kstriped_ws);
+=09
 	return 0;
 }
=20
@@ -172,6 +249,7 @@
 	for (i =3D 0; i < sc->stripes; i++)
 		dm_put_device(ti, sc->stripe[i].dev);
=20
+	flush_workqueue(kstriped);
 	kfree(sc);
 }
=20
@@ -213,13 +291,38 @@
 	return 0;
 }
=20
+static int stripe_end_io(struct dm_target *ti, struct bio *bio,
+			 int error, union map_info *map_context)
+{
+	struct stripe_c *sc =3D (struct stripe_c *) ti->private;
+=09
+	if (!error)
+		return 0; /* I/O complete */
+=09
+	if ((error =3D=3D -EWOULDBLOCK) && bio_rw_ahead(bio))
+		return error;
+=09
+	if (error =3D=3D -EOPNOTSUPP)
+		return error;
+=09
+	/* Error not caught above, trigger event.=20
+	 * For example, if member device gets=20
+	 * disconnected this sets "error =3D=3D -5" */
+	if (error < 0) {
+		queue_work(kstriped, &sc->kstriped_ws);
+	}
+
+	return error;
+}
+
 static struct target_type stripe_target =3D {
 	.name   =3D "striped",
-	.version=3D {1, 0, 2},
+	.version=3D {1, 1, 2},
 	.module =3D THIS_MODULE,
 	.ctr    =3D stripe_ctr,
 	.dtr    =3D stripe_dtr,
 	.map    =3D stripe_map,
+	.end_io =3D stripe_end_io,
 	.status =3D stripe_status,
 };
=20
@@ -230,7 +333,14 @@
 	r =3D dm_register_target(&stripe_target);
 	if (r < 0)
 		DMWARN("target registration failed");
-
+=09
+	kstriped =3D create_singlethread_workqueue("kstriped");
+	if (!kstriped) {
+		DMERR("failed to create workqueue kstriped");
+		dm_unregister_target(&stripe_target);
+		return -ENOMEM;
+	}
+=09
 	return r;
 }
=20
@@ -238,6 +348,8 @@
 {
 	if (dm_unregister_target(&stripe_target))
 		DMWARN("target unregistration failed");
-
+=09
+	destroy_workqueue(kstriped);
+=09
 	return;
 }
