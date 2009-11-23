From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: RE: [Patch 1/2][RESEND] New Logging approach for Device
	Mapper
Date: Mon, 23 Nov 2009 12:54:41 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93C74ED3@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "agk@redhat.com" <agk@redhat.com>, "hare@suse.de" <hare@suse.de>, "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Chauhan,
	Vijay" <Vijay.Chauhan@lsi.com>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids

=20
On Tuesday, November 10, 2009 at 13:25:00 UTC, Alasdair G Kergon wrote:=20
> dm tables show major:minor and I'd still like to see that in=20
 > the output.
 > dm-X is meaningless to most people.
 > Most useful to the user is the 'name' - like vg1-lv2 - but we expect
 > to change dm-1 to dm-vg1-lv2 in the near future (agreed with udev
 > so it'll be /dev/dm-vg1-lv2 instead of /dev/dm-1).  (The delay
 > is because it needs a name-length fix and some character mapping
 > because udev chose to use a significantly-restricted character
 > set.)
 >=20
 > So, it's best to include both dm-X and major:minor - works now and
 > in future that way.

Thanks for you comment. I have made the changes in patch[1/2] to display =
both dm-X and major:minor.  Syslog with dm logging now looks as below in =
the snippet. Hope it looks fine. Please give your comments:

Thanks,
Vijay

snippet of syslog :
-----------------------
Nov 20 01:03:04 localhost kernel: device-mapper: ioctl: 360022190ccc9b100=
117b802b05eae8b5: Creating dm device
Nov 20 01:03:04 localhost kernel: device-mapper: ioctl: [253:0] dm-0: Ins=
erting in hash table
Nov 20 01:03:04 localhost kernel: device-mapper: ioctl: [253:0] dm-0: Suc=
cessfully inserted in hash table
Nov 20 01:03:04 localhost kernel: device-mapper: multipath: version 1.1.0=
 loaded
Nov 20 01:03:04 localhost kernel: device-mapper: dm-path-selector: path s=
elector round-robin registered successfully
Nov 20 01:03:04 localhost kernel: device-mapper: multipath round-robin: v=
ersion 1.0.0 loaded
Nov 20 01:03:04 localhost kernel: device-mapper: dm-path-selector: path s=
elector module round-robin Loaded successfully
Nov 20 01:03:04 localhost kernel: device-mapper: table: [253:0] dm-0: mul=
tipath: error getting device
Nov 20 01:03:04 localhost kernel: device-mapper: ioctl: 360022190ccc9b100=
117b802b05eae8b5: Creating dm device
Nov 20 01:03:04 localhost kernel: device-mapper: ioctl: [253:0] dm-0: Ins=
erting in hash table
Nov 20 01:03:04 localhost kernel: device-mapper: ioctl: [253:0] dm-0: Suc=
cessfully inserted in hash table
Nov 20 01:03:04 localhost kernel: device-mapper: table: [253:0] dm-0: mul=
tipath: error getting device
Nov 20 01:03:04 localhost kernel: device-mapper: ioctl: 3600a0b800029eba4=
00007a824afa59bd: Creating dm device
Nov 20 01:03:04 localhost kernel: device-mapper: ioctl: [253:0] dm-0: Ins=
erting in hash table
Nov 20 01:03:04 localhost kernel: device-mapper: ioctl: [253:0] dm-0: Suc=
cessfully inserted in hash table
Nov 20 01:03:04 localhost kernel: sd 4:0:0:0: rdac: LUN 0 (owned)
Nov 20 01:03:04 localhost kernel: rdac: device handler registered
Nov 20 01:03:04 localhost multipathd: 3600a0b800029eba400007a824afa59bd: =
load table [0 2097152 multipath 2 pg_init_retries 49 1 rdac 1 1 round-rob=
in 0 1 1 8:16 1000]
Nov 20 01:03:04 localhost multipathd: 3600a0b800029eba400007a824afa59bd: =
event checker started
Nov 20 01:03:04 localhost multipathd: path checkers start up
Nov 20 01:03:05 localhost kernel: device-mapper: multipath: [253:0] dm-0:=
 Switching to pathgroup index 1
Nov 20 01:03:05 localhost kernel: device-mapper: multipath: [253:0] dm-0:=
 Selecting path sdb for I/O
Nov 20 01:03:05 localhost kernel: device-mapper: multipath: [253:0] dm-0:=
 pg_init_done: failover status =3D 0

--
This patch replaces adds new macro definition DMLOG, DMLOG1, DMLOG2.=20
* DMLOG prints messages without device name where as DMLOG1 and DMLOG2 pr=
ints messages with dm device name.
* For DMLOG1, 3rd parameter should be of type "struct mapped_device *"=20
* For DMLOG2, 3rd parameter should be of type "struct target *".

Signed-Off by: Vijay Chauhan <vijay.chauhan@lsi.com>
---
diff -uprN linux-2.6.32-rc5-orig/drivers/md/dm.c linux-2.6.32-rc5/drivers=
/md/dm.c
--- linux-2.6.32-rc5-orig/drivers/md/dm.c	2009-11-09 06:09:34.000000000 +=
0530
+++ linux-2.6.32-rc5/drivers/md/dm.c	2009-11-20 01:11:53.000000000 +0530
@@ -24,6 +24,9 @@
=20
 #define DM_MSG_PREFIX "core"
=20
+unsigned int dm_logging_level;
+EXPORT_SYMBOL(dm_logging_level);
+
 /*
  * Cookies are numeric values sent with CHANGE and REMOVE
  * uevents while resuming, removing or renaming the device.
@@ -205,6 +208,8 @@ static struct kmem_cache *_tio_cache;
 static struct kmem_cache *_rq_tio_cache;
 static struct kmem_cache *_rq_bio_info_cache;
=20
+const char *dm_gendisk_device_name(struct mapped_device *md);
+
 static int __init local_init(void)
 {
 	int r =3D -ENOMEM;
@@ -2045,6 +2050,18 @@ const char *dm_device_name(struct mapped
 }
 EXPORT_SYMBOL_GPL(dm_device_name);
=20
+const char *dm_gendisk_device_name(struct mapped_device *md)
+{
+	  struct gendisk *disk =3D dm_disk(md);
+	  return  disk->disk_name;
+}
+
+struct mapped_device *dm_target_get_md(struct dm_target *ti)
+{
+	return dm_table_get_md(ti->table);
+}
+EXPORT_SYMBOL_GPL(dm_target_get_md);
+
 void dm_put(struct mapped_device *md)
 {
 	struct dm_table *map;
@@ -2679,6 +2696,10 @@ EXPORT_SYMBOL(dm_get_mapinfo);
 module_init(dm_init);
 module_exit(dm_exit);
=20
+module_param(dm_logging_level, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(dm_logging_level, "a bit mask of logging levels");
+
+
 module_param(major, uint, 0);
 MODULE_PARM_DESC(major, "The major number of the device mapper");
 MODULE_DESCRIPTION(DM_NAME " driver");
diff -uprN linux-2.6.32-rc5-orig/drivers/md/dm-ioctl.c linux-2.6.32-rc5/d=
rivers/md/dm-ioctl.c
--- linux-2.6.32-rc5-orig/drivers/md/dm-ioctl.c	2009-11-09 06:09:34.00000=
0000 +0530
+++ linux-2.6.32-rc5/drivers/md/dm-ioctl.c	2009-11-20 01:11:41.000000000 =
+0530
@@ -50,6 +50,7 @@ static struct list_head _name_buckets[NU
 static struct list_head _uuid_buckets[NUM_BUCKETS];
=20
 static void dm_hash_remove_all(int keep_open_devices);
+const char *dm_gendisk_device_name(struct mapped_device *md);
=20
 /*
  * Guards access to both hash tables.
diff -uprN linux-2.6.32-rc5-orig/drivers/md/dm-mpath.c linux-2.6.32-rc5/d=
rivers/md/dm-mpath.c
--- linux-2.6.32-rc5-orig/drivers/md/dm-mpath.c	2009-11-09 06:09:34.00000=
0000 +0530
+++ linux-2.6.32-rc5/drivers/md/dm-mpath.c	2009-11-20 01:07:13.000000000 =
+0530
@@ -115,7 +115,6 @@ static void trigger_event(struct work_st
 static void activate_path(struct work_struct *work);
 static void deactivate_path(struct work_struct *work);
=20
-
 /*-----------------------------------------------
  * Allocation routines
  *-----------------------------------------------*/
diff -uprN linux-2.6.32-rc5-orig/drivers/md/dm-path-selector.c linux-2.6.=
32-rc5/drivers/md/dm-path-selector.c
--- linux-2.6.32-rc5-orig/drivers/md/dm-path-selector.c	2009-11-09 06:09:=
34.000000000 +0530
+++ linux-2.6.32-rc5/drivers/md/dm-path-selector.c	2009-11-20 01:07:13.00=
0000000 +0530
@@ -15,6 +15,8 @@
=20
 #include <linux/slab.h>
=20
+#define DM_MSG_PREFIX "dm-path-selector"
+
 struct ps_internal {
 	struct path_selector_type pst;
 	struct list_head list;
diff -uprN linux-2.6.32-rc5-orig/drivers/md/dm-table.c linux-2.6.32-rc5/d=
rivers/md/dm-table.c
--- linux-2.6.32-rc5-orig/drivers/md/dm-table.c	2009-11-09 06:09:34.00000=
0000 +0530
+++ linux-2.6.32-rc5/drivers/md/dm-table.c	2009-11-20 01:11:46.000000000 =
+0530
@@ -70,6 +70,9 @@ struct dm_table {
 	struct dm_md_mempools *mempools;
 };
=20
+
+const char *dm_gendisk_device_name(struct mapped_device *md);
+
 /*
  * Similar to ceiling(log_size(n))
  */
diff -uprN linux-2.6.32-rc5-orig/include/linux/device-mapper.h linux-2.6.=
32-rc5/include/linux/device-mapper.h
--- linux-2.6.32-rc5-orig/include/linux/device-mapper.h	2009-11-09 06:10:=
02.000000000 +0530
+++ linux-2.6.32-rc5/include/linux/device-mapper.h	2009-11-20 01:20:04.00=
0000000 +0530
@@ -308,6 +308,8 @@ void *dm_vcalloc(unsigned long nmemb, un
  *---------------------------------------------------------------*/
 #define DM_NAME "device-mapper"
=20
+extern unsigned int dm_logging_level;
+
 #define DMCRIT(f, arg...) \
 	printk(KERN_CRIT DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
=20
@@ -339,17 +341,75 @@ void *dm_vcalloc(unsigned long nmemb, un
 	} while (0)
=20
 #ifdef CONFIG_DM_DEBUG
-#  define DMDEBUG(f, arg...) \
-	printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX " DEBUG: " f "\n", ## arg)
-#  define DMDEBUG_LIMIT(f, arg...) \
-	do { \
-		if (printk_ratelimit())	\
-			printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX ": " f \
-			       "\n", ## arg); \
+/* DM Logging level */
+ #define DMLOG_CRIT			0
+ #define DMLOG_ERR			1
+ #define DMLOG_WARN			2
+ #define DMLOG_INFO			3
+
+ #define DMLOG_BITS			2
+
+ /*DM Logging types */
+ enum {
+ DMLOG_INIT =3D 0,
+ DMLOG_ADD_DEV,
+ DMLOG_REMOVE_DEV,
+ DMLOG_IOCTL,
+ DMLOG_IO,
+ DMLOG_UEVENT,
+ DMLOG_TABLE,
+
+ DMLOG_FAILOVER,
+ DMLOG_PATH_ACTIVATE,
+ DMLOG_PATH_DEACTIVATE,
+ };
+
+
+
+ #  define DMLOG_LEVEL(SHIFT)                             \
+	((dm_logging_level >> (SHIFT * DMLOG_BITS)) & ((1 << (DMLOG_BITS)) - 1)=
)
+
+ #  define DMLOG(SHIFT, LEVEL, f, arg...) \
+	do {                                         \
+		if ((DMLOG_LEVEL(SHIFT)) >=3D (LEVEL)) \
+			do { 			\
+				printk(KERN_INFO DM_NAME ": " \
+					DM_MSG_PREFIX ": " f "\n", ## arg); \
+			} while (0);    \
+	} while (0)
+
+ #  define DMLOG1(SHIFT, LEVEL, MD, f, arg...) \
+	do {                                         \
+		if ((DMLOG_LEVEL(SHIFT)) >=3D (LEVEL)) \
+			do { \
+				printk(KERN_INFO DM_NAME ": " \
+					DM_MSG_PREFIX ": "); \
+				if (MD) \
+					printk("[%s] %s:", dm_device_name(MD), \
+						dm_gendisk_device_name(MD)); \
+				printk(" " f "\n", ## arg); \
+			} while (0);    \
+	} while (0)
+ #  define DMLOG2(SHIFT, LEVEL, DM_TARGET, f, arg...) \
+	do {                                         \
+		if ((DMLOG_LEVEL(SHIFT)) >=3D (LEVEL)) \
+			do { \
+				struct mapped_device *md =3D \
+					dm_target_get_md(DM_TARGET); \
+				printk(KERN_INFO DM_NAME ": " \
+					DM_MSG_PREFIX ": "); \
+				if (md) { \
+					printk("[%s] %s:", dm_device_name(md), \
+						dm_gendisk_device_name(md)); \
+					dm_put(md); \
+				} \
+				printk(" " f "\n", ## arg); \
+			} while (0);    \
 	} while (0)
 #else
-#  define DMDEBUG(f, arg...) do {} while (0)
-#  define DMDEBUG_LIMIT(f, arg...) do {} while (0)
+#define DMLOG(SHIFT, LEVEL, f, arg...) do {); } while (0)
+#define DMLOG1(SHIFT, LEVEL, MAPPED_DEVICE, f, arg...) do {); } while (0=
)
+#define DMLOG2(SHIFT, LEVEL, DM_TARGET, f, arg...) do {); } while (0)
 #endif
=20
 #define DMEMIT(x...) sz +=3D ((sz >=3D maxlen) ? \
@@ -409,4 +469,8 @@ void dm_requeue_unmapped_request(struct=20
 void dm_kill_unmapped_request(struct request *rq, int error);
 int dm_underlying_device_busy(struct request_queue *q);
=20
+struct mapped_device *dm_target_get_md(struct dm_target *ti);
+const char *dm_gendisk_device_name(struct mapped_device *md);
+void dm_put(struct mapped_device *md);
+
 #endif	/* _LINUX_DEVICE_MAPPER_H */

--

=20
