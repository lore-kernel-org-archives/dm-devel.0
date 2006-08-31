From: Edward Goggin <egoggin@emc.com>
Subject: 2nd of 2 patches for dm_emc.c and dm-multipath hardware
	handler interface
Date: Thu, 31 Aug 2006 10:32:26 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1398@CORPUSMX40A.corp.emc.com>
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
To: dm-devel@redhat.com
Cc: michaelc@cs.wisc.edu, agk@redhat.com
List-Id: dm-devel.ids

This is the second patch in a set of 2 patches.

Signed-off-by: Ed Goggin <egoggin@emc.com>
--- linux-2.6.18-rc4/drivers/md/dm.c.orig	2006-08-28
01:57:18.000000000 -0500
+++ linux-2.6.18-rc4/drivers/md/dm.c	2006-08-28 22:41:01.000000000
-0500
@@ -1136,6 +1136,7 @@ void dm_put(struct mapped_device *md)
 		free_dev(md);
 	}
 }
+EXPORT_SYMBOL_GPL(dm_put);
=20
 /*
  * Process the deferred bios


--- linux-2.6.18-rc4/drivers/md/dm-mpath.c.orig	2006-08-28
01:57:25.000000000 -0500
+++ linux-2.6.18-rc4/drivers/md/dm-mpath.c	2006-08-28
22:41:16.000000000 -0500
@@ -630,6 +630,7 @@ static int parse_hw_handler(struct arg_s
 	int r;
 	struct hw_handler_type *hwht;
 	unsigned hw_argc;
+	struct mapped_device *md;
=20
 	static struct param _params[] =3D {
 		{0, 1024, "invalid number of hardware handler args"},
@@ -648,7 +649,14 @@ static int parse_hw_handler(struct arg_s
 		return -EINVAL;
 	}
=20
-	r =3D hwht->create(&m->hw_handler, hw_argc - 1, as->argv);
+	/*
+	 * No need to hold a reference on the mapped device here
+	 * since one is already held for the duration of the=20
+	 * mapped device open.
+	 */
+	md =3D dm_table_get_md(ti->table);
+	r =3D hwht->create(&m->hw_handler, hw_argc - 1, as->argv, md);
+	dm_put(md);
 	if (r) {
 		dm_put_hw_handler(hwht);
 		ti->error =3D "hardware handler constructor failed";


--- linux-2.6.18-rc4/drivers/md/dm-hw-handler.h.orig	2006-08-28
01:57:35.000000000 -0500
+++ linux-2.6.18-rc4/drivers/md/dm-hw-handler.h	2006-08-28
22:41:57.000000000 -0500
@@ -28,7 +28,7 @@ struct hw_handler_type {
 	struct module *module;
=20
 	int (*create) (struct hw_handler *handler, unsigned int argc,
-		       char **argv);
+		       char **argv, struct mapped_device *md);
 	void (*destroy) (struct hw_handler *hwh);
=20
 	void (*pg_init) (struct hw_handler *hwh, unsigned bypassed,


--- linux-2.6.18-rc4/drivers/md/dm-emc.c.orig	2006-08-28
22:40:35.000000000 -0500
+++ linux-2.6.18-rc4/drivers/md/dm-emc.c	2006-08-28
22:40:44.000000000 -0500
@@ -61,6 +61,7 @@ unsigned char short_trespass_pg[] =3D {
  */
 struct emc_handler {
 	spinlock_t lock;
+	struct mapped_device *md;
 	struct hw_handler *hwh;
 	struct path *path;
 	struct work_struct wkq;
@@ -111,7 +112,8 @@ static int parse_sp_info_reply(struct re
 		if (h->buffer[48] !=3D 0) {
 			DMWARN("Detected in-progress ucode upgrade NDU "
 			       "operation while finding current active "
-			       "SP using path %s.", path->dev->name);
+			       "SP for mapped device %s using path %s.",
+			       dm_device_name(h->md), path->dev->name);
 			err =3D MP_BYPASS_PG;
 		} else {
 			*default_sp =3D h->buffer[5];
@@ -141,11 +143,13 @@ static int parse_sp_info_reply(struct re
=20
req->sense_len,
 							   &sshdr))
 			DMERR("Found valid sense data 0x%2x, 0x%2x,
0x%2x "
-			      "while finding current active SP using
path %s.",
+			      "while finding current active SP for "
+			      "mapped device %s using path %s.",
 		       	      sshdr.sense_key, sshdr.asc, sshdr.ascq,
-			      path->dev->name);
-		else DMERR("Error 0x%x finding current active SP using "
-		     	   "path %s.", req->errors, path->dev->name);
+			      dm_device_name(h->md), path->dev->name);
+		else DMERR("Error 0x%x finding current active SP for "
+		     	   "mapped device %s using path %s.",
req->errors,
+			   dm_device_name(h->md), path->dev->name);
 	}
=20
 	return (err);
@@ -164,8 +168,10 @@ static int parse_pg_init_reply(struct re
 						   req->sense_len,
&sshdr)) {
=20
 		DMERR("Found valid sense data 0x%2x, 0x%2x, 0x%2x while
"
-		      "sending CLARiiON trespass command using path
%s.",
-		      sshdr.sense_key, sshdr.asc, sshdr.ascq,
path->dev->name);
+		      "sending CLARiiON trespass command for mapped "=20
+		      "device %s using path %s.",
+		       sshdr.sense_key, sshdr.asc, sshdr.ascq,
+		       dm_device_name(h->md), path->dev->name);
=20
 		if ((sshdr.sense_key =3D 0x05) &&
 	    	    (sshdr.asc =3D 0x04) &&
@@ -175,8 +181,9 @@ static int parse_pg_init_reply(struct re
 			 * pg_init or copy will be aborted mid-stream.
 			 */
 			DMWARN("Array Based Copy in progress while "
-			       "sending CLARiiON trespass command "
-			       "using path %s.", path->dev->name);
+			       "sending CLARiiON trespass command for "
+			       "mapped device %s using path %s.",
+			       dm_device_name(h->md), path->dev->name);
 			err =3D MP_BYPASS_PG;
 		} else if ((sshdr.sense_key =3D 0x02) &&
 	    	    	 (sshdr.asc =3D 0x04) &&
@@ -187,13 +194,15 @@ static int parse_pg_init_reply(struct re
 			 */
 			DMWARN("Detected in-progress ucode upgrade NDU "
 			       "operation while sending CLARiiON
trespass "
-			       " command using path %s.",
path->dev->name);
+			       " command for mapped device %s using path
%s.",
+			       dm_device_name(h->md), path->dev->name);
 			err =3D MP_BYPASS_PG;
 		} else
 			err =3D MP_FAIL_PATH;
 	} else if (req->errors) {
 		DMERR("Error 0x%x while sending CLARiiON trespass
command "
-		      "using path %s.", req->errors, path->dev->name);
+		      "for apped device %s using path %s.", req->errors,
+		      dm_device_name(h->md), path->dev->name);
 		err =3D MP_FAIL_PATH;
 	}
=20
@@ -238,7 +247,6 @@ static void sp_info_endio(struct request
 		dm_pg_init_complete(path, 0);
 	} else {
 		spin_unlock_irqrestore(&h->lock, flags);
-
 		/*
 	 	 * Do not issue the actual pg_init request if either (1)
 	 	 * we do not know the identity of the current SP or (2)
@@ -256,15 +264,18 @@ static void sp_info_endio(struct request
=20
 			/* yet, its as good as doing it */
 			dm_pg_init_complete(path, 0);
+
 			DMINFO("Ignoring path group switch-over command
for "
-			       "CLARiiON SP%s since mapped device is "
+			       "CLARiiON SP%s since mapped device %s is
"
 			       "already initialized for path %s.",
-		       	       current_sp ? "B" : "A", path->dev->name);
+		       	       current_sp ? "B" : "A",
dm_device_name(h->md),
+			       path->dev->name);
 		} else {
 			/* send path initialization request */
 			DMINFO("Issuing CLARiiON trespass command to "
-	       		       "activate SP%s using path %s.",
-			       new_current_sp ? "B" : "A",
path->dev->name);
+	       		       "activate SP%s for mapped device %s using
"
+			       "path %s.", new_current_sp ? "B" : "A",
+	       		       dm_device_name(h->md), path->dev->name);
=20
 			h->path =3D path;	/* kemchd will use this path */
 			queue_work(kemchd, &h->wkq);
@@ -454,7 +465,8 @@ static struct emc_handler *alloc_emc_han
 	return h;
 }
=20
-static int emc_create(struct hw_handler *hwh, unsigned argc, char
**argv)
+static int emc_create(struct hw_handler *hwh, unsigned argc, char
**argv,
+		      struct mapped_device *md)
 {
 	struct emc_handler *h;
 	unsigned hr, short_trespass;
@@ -488,6 +500,7 @@ static int emc_create(struct hw_handler=20
=20
 	hwh->context =3D h;
 	h->hwh =3D hwh;
+	h->md =3D md;
=20
 	return 0;
 }
