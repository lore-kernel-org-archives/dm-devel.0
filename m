From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH] dm-add-ioband.patch
Date: Tue, 10 Mar 2009 20:20:29 +0900 (JST)
Message-ID: <20090310.202029.193700185.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Alasdair,

dm-add-ioband.patch in the current dm quilt tree is rejected when
attempting to apply to the kernel, so I've attached a patch against
dm-add-ioband.patch. Would you please update it?

The patch I've attached also includes some changes which are reflected
some Lindent's output and some points you suggested. I would
appreciate it if you could take a look and review this patch.

Thanks,
Ryo Tsuruta

--- dm-add-ioband.patch.orig	2009-03-09 19:11:59.000000000 +0900
+++ dm-add-ioband.patch	2009-03-10 19:37:31.000000000 +0900
@@ -15,16 +15,16 @@ Signed-off-by: Hirokazu Takahashi <taka@
  Documentation/device-mapper/ioband.txt |  976 ++++++++++++++++++++++++
  drivers/md/Kconfig                     |   13 
  drivers/md/Makefile                    |    2 
- drivers/md/dm-ioband-ctl.c             | 1326 +++++++++++++++++++++++++++++++++
- drivers/md/dm-ioband-policy.c          |  460 +++++++++++
- drivers/md/dm-ioband-type.c            |   76 +
- drivers/md/dm-ioband.h                 |  194 ++++
- 7 files changed, 3047 insertions(+)
+ drivers/md/dm-ioband-ctl.c             | 1312 +++++++++++++++++++++++++++++++++
+ drivers/md/dm-ioband-policy.c          |  457 +++++++++++
+ drivers/md/dm-ioband-type.c            |   77 +
+ drivers/md/dm-ioband.h                 |  186 ++++
+ 7 files changed, 3023 insertions(+)
 
 Index: linux-2.6.29-rc7/Documentation/device-mapper/ioband.txt
 ===================================================================
---- /dev/null	1970-01-01 00:00:00.000000000 +0000
-+++ linux-2.6.29-rc7/Documentation/device-mapper/ioband.txt	2009-03-05 12:09:59.000000000 +0000
+--- /dev/null
++++ linux-2.6.29-rc7/Documentation/device-mapper/ioband.txt
 @@ -0,0 +1,976 @@
 +                     Block I/O bandwidth control: dm-ioband
 +
@@ -143,7 +143,7 @@ Index: linux-2.6.29-rc7/Documentation/de
 +   loaded.
 +
 +     # dmsetup targets | grep ioband
-+     ioband           v1.10.0
++     ioband           v1.10.2
 +
 +
 +   --------------------------------------------------------------------------
@@ -1004,9 +1004,9 @@ Index: linux-2.6.29-rc7/Documentation/de
 +         # dmsetup message ioband1 0 weight 15276:40
 Index: linux-2.6.29-rc7/drivers/md/Kconfig
 ===================================================================
---- linux-2.6.29-rc7.orig/drivers/md/Kconfig	2009-03-05 12:09:54.000000000 +0000
-+++ linux-2.6.29-rc7/drivers/md/Kconfig	2009-03-05 12:09:59.000000000 +0000
-@@ -299,4 +299,17 @@ config DM_UEVENT
+--- linux-2.6.29-rc7.orig/drivers/md/Kconfig
++++ linux-2.6.29-rc7/drivers/md/Kconfig
+@@ -289,4 +289,17 @@ config DM_UEVENT
  	---help---
  	Generate udev events for DM events.
  
@@ -1026,19 +1026,19 @@ Index: linux-2.6.29-rc7/drivers/md/Kconf
  endif # MD
 Index: linux-2.6.29-rc7/drivers/md/Makefile
 ===================================================================
---- linux-2.6.29-rc7.orig/drivers/md/Makefile	2009-03-05 12:09:54.000000000 +0000
-+++ linux-2.6.29-rc7/drivers/md/Makefile	2009-03-05 12:09:59.000000000 +0000
+--- linux-2.6.29-rc7.orig/drivers/md/Makefile
++++ linux-2.6.29-rc7/drivers/md/Makefile
 @@ -8,6 +8,7 @@ dm-multipath-objs := dm-path-selector.o 
  dm-snapshot-objs := dm-snap.o dm-exception-store.o dm-snap-transient.o \
  		    dm-snap-persistent.o
  dm-mirror-objs	:= dm-raid1.o
 +dm-ioband-objs	:= dm-ioband-ctl.o dm-ioband-policy.o dm-ioband-type.o
- dm-log-clustered-objs := dm-log-cluster.o dm-log-cluster-transfer.o
  md-mod-objs     := md.o bitmap.o
  raid456-objs	:= raid5.o raid6algos.o raid6recov.o raid6tables.o \
-@@ -39,6 +40,7 @@ obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot
+ 		   raid6int1.o raid6int2.o raid6int4.o \
+@@ -37,6 +38,7 @@ obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipa
+ obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
  obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
- obj-$(CONFIG_DM_LOG_CLUSTERED)	+= dm-log-clustered.o
  obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 +obj-$(CONFIG_DM_IOBAND)		+= dm-ioband.o
  
@@ -1046,9 +1046,9 @@ Index: linux-2.6.29-rc7/drivers/md/Makef
        cmd_unroll = $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
 Index: linux-2.6.29-rc7/drivers/md/dm-ioband-ctl.c
 ===================================================================
---- /dev/null	1970-01-01 00:00:00.000000000 +0000
-+++ linux-2.6.29-rc7/drivers/md/dm-ioband-ctl.c	2009-03-05 12:09:59.000000000 +0000
-@@ -0,0 +1,1326 @@
+--- /dev/null
++++ linux-2.6.29-rc7/drivers/md/dm-ioband-ctl.c
+@@ -0,0 +1,1312 @@
 +/*
 + * Copyright (C) 2008 VA Linux Systems Japan K.K.
 + * Authors: Hirokazu Takahashi <taka@valinux.co.jp>
@@ -1069,7 +1069,6 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +#include "dm-bio-list.h"
 +#include "dm-ioband.h"
 +
-+#define DM_MSG_PREFIX "ioband"
 +#define POLICY_PARAM_START 6
 +#define POLICY_PARAM_DELIM "=:,"
 +
@@ -1086,12 +1085,10 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +static int ioband_group_attach(struct ioband_group *, int, char *);
 +static int ioband_group_type_select(struct ioband_group *, char *);
 +
-+long ioband_debug;	/* just for debugging */
-+
 +static void do_nothing(void) {}
 +
 +static int policy_init(struct ioband_device *dp, char *name,
-+						int argc, char **argv)
++		       int argc, char **argv)
 +{
 +	struct policy_type *p;
 +	struct ioband_group *gp;
@@ -1134,23 +1131,22 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +}
 +
 +static struct ioband_device *alloc_ioband_device(char *name,
-+					int io_throttle, int io_limit)
-+
++						 int io_throttle, int io_limit)
 +{
-+	struct ioband_device *dp, *new;
++	struct ioband_device *dp, *new_dp;
 +	unsigned long flags;
 +
-+	new = kzalloc(sizeof(struct ioband_device), GFP_KERNEL);
-+	if (!new)
++	new_dp = kzalloc(sizeof(struct ioband_device), GFP_KERNEL);
++	if (!new_dp)
 +		return NULL;
 +
 +	/*
 +	 * Prepare its own workqueue as generic_make_request() may
 +	 * potentially block the workqueue when submitting BIOs.
 +	 */
-+	new->g_ioband_wq = create_workqueue("kioband");
-+	if (!new->g_ioband_wq) {
-+		kfree(new);
++	new_dp->g_ioband_wq = create_workqueue("kioband");
++	if (!new_dp->g_ioband_wq) {
++		kfree(new_dp);
 +		return NULL;
 +	}
 +
@@ -1159,37 +1155,37 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +		if (!strcmp(dp->g_name, name)) {
 +			dp->g_ref++;
 +			spin_unlock_irqrestore(&ioband_devicelist_lock, flags);
-+			destroy_workqueue(new->g_ioband_wq);
-+			kfree(new);
++			destroy_workqueue(new_dp->g_ioband_wq);
++			kfree(new_dp);
 +			return dp;
 +		}
 +	}
 +
-+	INIT_DELAYED_WORK(&new->g_conductor, ioband_conduct);
-+	INIT_LIST_HEAD(&new->g_groups);
-+	INIT_LIST_HEAD(&new->g_list);
-+	spin_lock_init(&new->g_lock);
-+	mutex_init(&new->g_lock_device);
-+	bio_list_init(&new->g_urgent_bios);
-+	new->g_io_throttle = io_throttle;
-+	new->g_io_limit[0] = io_limit;
-+	new->g_io_limit[1] = io_limit;
-+	new->g_issued[0] = 0;
-+	new->g_issued[1] = 0;
-+	new->g_blocked = 0;
-+	new->g_ref = 1;
-+	new->g_flags = 0;
-+	strlcpy(new->g_name, name, sizeof(new->g_name));
-+	new->g_policy = NULL;
-+	new->g_hold_bio = NULL;
-+	new->g_pop_bio = NULL;
-+	init_waitqueue_head(&new->g_waitq);
-+	init_waitqueue_head(&new->g_waitq_suspend);
-+	init_waitqueue_head(&new->g_waitq_flush);
-+	list_add_tail(&new->g_list, &ioband_device_list);
++	INIT_DELAYED_WORK(&new_dp->g_conductor, ioband_conduct);
++	INIT_LIST_HEAD(&new_dp->g_groups);
++	INIT_LIST_HEAD(&new_dp->g_list);
++	spin_lock_init(&new_dp->g_lock);
++	mutex_init(&new_dp->g_lock_device);
++	bio_list_init(&new_dp->g_urgent_bios);
++	new_dp->g_io_throttle = io_throttle;
++	new_dp->g_io_limit[READ] = io_limit;
++	new_dp->g_io_limit[WRITE] = io_limit;
++	new_dp->g_issued[READ] = 0;
++	new_dp->g_issued[WRITE] = 0;
++	new_dp->g_blocked = 0;
++	new_dp->g_ref = 1;
++	new_dp->g_flags = 0;
++	strlcpy(new_dp->g_name, name, sizeof(new_dp->g_name));
++	new_dp->g_policy = NULL;
++	new_dp->g_hold_bio = NULL;
++	new_dp->g_pop_bio = NULL;
++	init_waitqueue_head(&new_dp->g_waitq);
++	init_waitqueue_head(&new_dp->g_waitq_suspend);
++	init_waitqueue_head(&new_dp->g_waitq_flush);
++	list_add_tail(&new_dp->g_list, &ioband_device_list);
 +
 +	spin_unlock_irqrestore(&ioband_devicelist_lock, flags);
-+	return new;
++	return new_dp;
 +}
 +
 +static void release_ioband_device(struct ioband_device *dp)
@@ -1209,11 +1205,11 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +}
 +
 +static int is_ioband_device_flushed(struct ioband_device *dp,
-+						int wait_completion)
++				    int wait_completion)
 +{
 +	struct ioband_group *gp;
 +
-+	if (wait_completion && dp->g_issued[0] + dp->g_issued[1] > 0)
++	if (wait_completion && dp->g_issued[READ] + dp->g_issued[WRITE] > 0)
 +		return 0;
 +	if (dp->g_blocked || waitqueue_active(&dp->g_waitq))
 +		return 0;
@@ -1224,7 +1220,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +}
 +
 +static void suspend_ioband_device(struct ioband_device *dp,
-+				unsigned long flags, int wait_completion)
++				  unsigned long flags, int wait_completion)
 +{
 +	struct ioband_group *gp;
 +
@@ -1249,8 +1245,8 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	/* wait for all processes to wake up and bios to release */
 +	spin_lock_irqsave(&dp->g_lock, flags);
 +	wait_event_lock_irq(dp->g_waitq_flush,
-+			is_ioband_device_flushed(dp, wait_completion),
-+			dp->g_lock, do_nothing());
++			    is_ioband_device_flushed(dp, wait_completion),
++			    dp->g_lock, do_nothing());
 +}
 +
 +static void resume_ioband_device(struct ioband_device *dp)
@@ -1270,8 +1266,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	clear_device_suspended(dp);
 +}
 +
-+static struct ioband_group *ioband_group_find(
-+					struct ioband_group *head, int id)
++static struct ioband_group *ioband_group_find(struct ioband_group *head, int id)
 +{
 +	struct rb_node *node = head->c_group_root.rb_node;
 +
@@ -1286,25 +1281,25 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	return NULL;
 +}
 +
-+static void ioband_group_add_node(struct rb_root *root,
-+						struct ioband_group *gp)
++static void ioband_group_add_node(struct rb_root *root, struct ioband_group *gp)
 +{
-+	struct rb_node **new = &root->rb_node, *parent = NULL;
++	struct rb_node **node = &root->rb_node, *parent = NULL;
 +	struct ioband_group *p;
 +
-+	while (*new) {
-+		p = container_of(*new, struct ioband_group, c_group_node);
-+		parent = *new;
-+		new = (gp->c_id < p->c_id) ?
-+					&(*new)->rb_left : &(*new)->rb_right;
++	while (*node) {
++		p = container_of(*node, struct ioband_group, c_group_node);
++		parent = *node;
++		node = (gp->c_id < p->c_id) ?
++				&(*node)->rb_left : &(*node)->rb_right;
 +	}
 +
-+	rb_link_node(&gp->c_group_node, parent, new);
++	rb_link_node(&gp->c_group_node, parent, node);
 +	rb_insert_color(&gp->c_group_node, root);
 +}
 +
 +static int ioband_group_init(struct ioband_group *gp,
-+    struct ioband_group *head, struct ioband_device *dp, int id, char *param)
++			     struct ioband_group *head,
++			     struct ioband_device *dp, int id, char *param)
 +{
 +	unsigned long flags;
 +	int r;
@@ -1349,7 +1344,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +}
 +
 +static void ioband_group_release(struct ioband_group *head,
-+						struct ioband_group *gp)
++				 struct ioband_group *gp)
 +{
 +	struct ioband_device *dp = gp->c_banddev;
 +
@@ -1363,12 +1358,12 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +static void ioband_group_destroy_all(struct ioband_group *gp)
 +{
 +	struct ioband_device *dp = gp->c_banddev;
-+	struct ioband_group *group;
++	struct ioband_group *p;
 +	unsigned long flags;
 +
 +	spin_lock_irqsave(&dp->g_lock, flags);
-+	while ((group = ioband_group_find(gp, IOBAND_ID_ANY)))
-+		ioband_group_release(gp, group);
++	while ((p = ioband_group_find(gp, IOBAND_ID_ANY)))
++		ioband_group_release(gp, p);
 +	ioband_group_release(NULL, gp);
 +	spin_unlock_irqrestore(&dp->g_lock, flags);
 +}
@@ -1384,16 +1379,12 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	for (node = rb_first(&head->c_group_root); node; node = rb_next(node)) {
 +		p = rb_entry(node, struct ioband_group, c_group_node);
 +		set_group_down(p);
-+		if (suspend) {
++		if (suspend)
 +			set_group_suspended(p);
-+			dprintk(KERN_ERR "ioband suspend: gp(%p)\n", p);
-+		}
 +	}
 +	set_group_down(head);
-+	if (suspend) {
++	if (suspend)
 +		set_group_suspended(head);
-+		dprintk(KERN_ERR "ioband suspend: gp(%p)\n", head);
-+	}
 +	spin_unlock_irqrestore(&dp->g_lock, flags);
 +	queue_delayed_work(dp->g_ioband_wq, &dp->g_conductor, 0);
 +	flush_workqueue(dp->g_ioband_wq);
@@ -1407,16 +1398,13 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	unsigned long flags;
 +
 +	spin_lock_irqsave(&dp->g_lock, flags);
-+	for (node = rb_first(&head->c_group_root); node;
-+							node = rb_next(node)) {
++	for (node = rb_first(&head->c_group_root); node; node = rb_next(node)) {
 +		p = rb_entry(node, struct ioband_group, c_group_node);
 +		clear_group_down(p);
 +		clear_group_suspended(p);
-+		dprintk(KERN_ERR "ioband resume: gp(%p)\n", p);
 +	}
 +	clear_group_down(head);
 +	clear_group_suspended(head);
-+	dprintk(KERN_ERR "ioband resume: gp(%p)\n", head);
 +	spin_unlock_irqrestore(&dp->g_lock, flags);
 +}
 +
@@ -1442,7 +1430,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 + *   parameters:  <device> <device-group-id> <io_throttle> <io_limit>
 + *     <type> <policy> <policy-param...> <group-id:group-param...>
 + */
-+static int ioband_ctr(struct dm_target *ti, unsigned int argc, char **argv)
++static int ioband_ctr(struct dm_target *ti, unsigned argc, char **argv)
 +{
 +	struct ioband_group *gp;
 +	struct ioband_device *dp;
@@ -1451,7 +1439,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	int io_limit;
 +	int i, r, start;
 +	long val, id;
-+	char *param;
++	char *param, *s;
 +
 +	if (argc < POLICY_PARAM_START) {
 +		ti->error = "Requires " __stringify(POLICY_PARAM_START)
@@ -1463,24 +1451,23 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +		ti->error = "Ioband device name is too long";
 +		return -EINVAL;
 +	}
-+	dprintk(KERN_ERR "ioband_ctr ioband device name:%s\n", argv[1]);
 +
 +	r = strict_strtol(argv[2], 0, &val);
-+	if (r || val < 0) {
++	if (r || val < 0 || val > SHORT_MAX) {
 +		ti->error = "Invalid io_throttle";
 +		return -EINVAL;
 +	}
 +	io_throttle = (val == 0) ? DEFAULT_IO_THROTTLE : val;
 +
 +	r = strict_strtol(argv[3], 0, &val);
-+	if (r || val < 0) {
++	if (r || val < 0 || val > SHORT_MAX) {
 +		ti->error = "Invalid io_limit";
 +		return -EINVAL;
 +	}
 +	io_limit = val;
 +
 +	r = dm_get_device(ti, argv[0], 0, ti->len,
-+				dm_table_get_mode(ti->table), &dev);
++			  dm_table_get_mode(ti->table), &dev);
 +	if (r) {
 +		ti->error = "Device lookup failed";
 +		return r;
@@ -1495,15 +1482,11 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +			r = -ENXIO;
 +			goto release_dm_device;
 +		}
-+		dprintk(KERN_ERR "ioband_ctr nr_requests:%lu\n",
-+							q->nr_requests);
 +		io_limit = q->nr_requests;
 +	}
 +
 +	if (io_limit < io_throttle)
 +		io_limit = io_throttle;
-+	dprintk(KERN_ERR "ioband_ctr io_throttle:%d io_limit:%d\n",
-+						io_throttle, io_limit);
 +
 +	dp = alloc_ioband_device(argv[1], io_throttle, io_limit);
 +	if (!dp) {
@@ -1532,9 +1515,11 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	gp->c_dev = dev;
 +
 +	/* Find a default group parameter */
-+	for (start = POLICY_PARAM_START; start < argc; start++)
-+		if (argv[start][0] == ':')
++	for (start = POLICY_PARAM_START; start < argc; start++) {
++		s = strpbrk(argv[start], POLICY_PARAM_DELIM);
++		if (s == argv[start])
 +			break;
++	}
 +	param = (start < argc) ? &argv[start][1] : NULL;
 +
 +	/* Create a default ioband group */
@@ -1607,7 +1592,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	struct page *page = bio_iovec_idx(bio, 0)->bv_page;
 +	/*
 +	 * ToDo: A new flag should be added to struct bio, which indicates
-+	 * 	it contains urgent I/O requests.
++	 *       it contains urgent I/O requests.
 +	 */
 +	if (!PageReclaim(page))
 +		return 0;
@@ -1624,7 +1609,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +		return 0;
 +	if (is_device_blocked(dp))
 +		return 1;
-+	if (dp->g_blocked >= dp->g_io_limit[0] + dp->g_io_limit[1]) {
++	if (dp->g_blocked >= dp->g_io_limit[READ] + dp->g_io_limit[WRITE]) {
 +		set_device_blocked(dp);
 +		return 1;
 +	}
@@ -1657,10 +1642,10 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +		 * partitions.
 +		 */
 +		wait_event_lock_irq(dp->g_waitq, !device_should_block(gp),
-+						dp->g_lock, do_nothing());
++				    dp->g_lock, do_nothing());
 +	} else {
 +		wait_event_lock_irq(gp->c_waitq, !group_should_block(gp),
-+						dp->g_lock, do_nothing());
++				    dp->g_lock, do_nothing());
 +	}
 +}
 +
@@ -1679,8 +1664,8 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +
 +static inline int room_for_bio(struct ioband_device *dp)
 +{
-+	return dp->g_issued[0] < dp->g_io_limit[0]
-+		|| dp->g_issued[1] < dp->g_io_limit[1];
++	return dp->g_issued[READ] < dp->g_io_limit[READ]
++		|| dp->g_issued[WRITE] < dp->g_io_limit[WRITE];
 +}
 +
 +static void hold_bio(struct ioband_group *gp, struct bio *bio)
@@ -1731,7 +1716,8 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +}
 +
 +static int make_issue_list(struct ioband_group *gp, struct bio *bio,
-+		 struct bio_list *issue_list, struct bio_list *pushback_list)
++			   struct bio_list *issue_list,
++			   struct bio_list *pushback_list)
 +{
 +	struct ioband_device *dp = gp->c_banddev;
 +
@@ -1754,13 +1740,14 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +}
 +
 +static void release_urgent_bios(struct ioband_device *dp,
-+		struct bio_list *issue_list, struct bio_list *pushback_list)
++				struct bio_list *issue_list,
++				struct bio_list *pushback_list)
 +{
 +	struct bio *bio;
 +
 +	if (bio_list_empty(&dp->g_urgent_bios))
 +		return;
-+	while (room_for_bio_rw(dp, 1)) {
++	while (room_for_bio_rw(dp, WRITE)) {
 +		bio = bio_list_pop(&dp->g_urgent_bios);
 +		if (!bio)
 +			return;
@@ -1771,7 +1758,8 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +}
 +
 +static int release_prio_bios(struct ioband_group *gp,
-+		struct bio_list *issue_list, struct bio_list *pushback_list)
++			     struct bio_list *issue_list,
++			     struct bio_list *pushback_list)
 +{
 +	struct ioband_device *dp = gp->c_banddev;
 +	struct bio *bio;
@@ -1797,7 +1785,8 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +}
 +
 +static int release_norm_bios(struct ioband_group *gp,
-+		struct bio_list *issue_list, struct bio_list *pushback_list)
++			     struct bio_list *issue_list,
++			     struct bio_list *pushback_list)
 +{
 +	struct ioband_device *dp = gp->c_banddev;
 +	struct bio *bio;
@@ -1826,7 +1815,8 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +}
 +
 +static inline int release_bios(struct ioband_group *gp,
-+		struct bio_list *issue_list, struct bio_list *pushback_list)
++			       struct bio_list *issue_list,
++			       struct bio_list *pushback_list)
 +{
 +	int ret = release_prio_bios(gp, issue_list, pushback_list);
 +	if (ret)
@@ -1835,7 +1825,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +}
 +
 +static struct ioband_group *ioband_group_get(struct ioband_group *head,
-+							struct bio *bio)
++					     struct bio *bio)
 +{
 +	struct ioband_group *gp;
 +
@@ -1854,12 +1844,12 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 + * exceeds the value of "io_throttle".
 + */
 +static int ioband_map(struct dm_target *ti, struct bio *bio,
-+						union map_info *map_context)
++		      union map_info *map_context)
 +{
 +	struct ioband_group *gp = ti->private;
 +	struct ioband_device *dp = gp->c_banddev;
 +	unsigned long flags;
-+	int rw;
++	int direct;
 +
 +	spin_lock_irqsave(&dp->g_lock, flags);
 +
@@ -1869,7 +1859,8 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	 */
 +	if (is_device_suspended(dp))
 +		wait_event_lock_irq(dp->g_waitq_suspend,
-+			!is_device_suspended(dp), dp->g_lock, do_nothing());
++				    !is_device_suspended(dp), dp->g_lock,
++				    do_nothing());
 +
 +	gp = ioband_group_get(gp, bio);
 +	prevent_burst_bios(gp, bio);
@@ -1880,21 +1871,20 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +
 +	bio->bi_bdev = gp->c_dev->bdev;
 +	bio->bi_sector -= ti->begin;
-+	rw = bio_data_dir(bio);
++	direct = bio_data_dir(bio);
 +
-+	if (!gp->c_blocked && room_for_bio_rw(dp, rw)) {
++	if (!gp->c_blocked && room_for_bio_rw(dp, direct)) {
 +		if (dp->g_can_submit(gp)) {
 +			prepare_to_issue(gp, bio);
-+			gp->c_stat[rw].immediate++;
-+			gp->c_stat[rw].sectors += bio_sectors(bio);
++			gp->c_stat[direct].immediate++;
++			gp->c_stat[direct].sectors += bio_sectors(bio);
 +			spin_unlock_irqrestore(&dp->g_lock, flags);
 +			return DM_MAPIO_REMAPPED;
-+		} else if (!dp->g_blocked
-+				&& dp->g_issued[0] + dp->g_issued[1] == 0) {
-+			dprintk(KERN_ERR "ioband_map: token expired "
-+					"gp:%p bio:%p\n", gp, bio);
++		} else if (!dp->g_blocked &&
++			   dp->g_issued[READ] + dp->g_issued[WRITE] == 0) {
++			DMDEBUG("%s: token expired gp:%p", __func__, gp);
 +			queue_delayed_work(dp->g_ioband_wq,
-+							&dp->g_conductor, 1);
++					   &dp->g_conductor, 1);
 +		}
 +	}
 +	hold_bio(gp, bio);
@@ -1910,8 +1900,8 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +{
 +	struct ioband_group *gp;
 +	struct ioband_group *best = NULL;
-+	int	highest = 0;
-+	int	pri;
++	int highest = 0;
++	int pri;
 +
 +	/* Todo: The algorithm should be optimized.
 +	 *       It would be better to use rbtree.
@@ -1919,8 +1909,8 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	list_for_each_entry(gp, &dp->g_groups, c_list) {
 +		if (!gp->c_blocked || !room_for_bio(dp))
 +			continue;
-+		if (gp->c_blocked == gp->c_prio_blocked
-+			&& !room_for_bio_rw(dp, prio_queue_direct(gp))) {
++		if (gp->c_blocked == gp->c_prio_blocked &&
++		    !room_for_bio_rw(dp, prio_queue_direct(gp))) {
 +			continue;
 +		}
 +		pri = dp->g_can_submit(gp);
@@ -1953,28 +1943,28 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	release_urgent_bios(dp, &issue_list, &pushback_list);
 +	if (dp->g_blocked) {
 +		gp = choose_best_group(dp);
-+		if (gp && release_bios(gp, &issue_list, &pushback_list)
-+								== R_YIELD)
++		if (gp &&
++		    release_bios(gp, &issue_list, &pushback_list) == R_YIELD)
 +			queue_delayed_work(dp->g_ioband_wq,
-+							&dp->g_conductor, 0);
++					   &dp->g_conductor, 0);
 +	}
 +
-+	if (is_device_blocked(dp)
-+	    && dp->g_blocked < dp->g_io_limit[0]+dp->g_io_limit[1]) {
++	if (is_device_blocked(dp) &&
++	    dp->g_blocked < dp->g_io_limit[READ] + dp->g_io_limit[WRITE]) {
 +		clear_device_blocked(dp);
 +		wake_up_all(&dp->g_waitq);
 +	}
 +
-+	if (dp->g_blocked && room_for_bio_rw(dp, 0) && room_for_bio_rw(dp, 1) &&
-+		bio_list_empty(&issue_list) && bio_list_empty(&pushback_list) &&
-+		dp->g_restart_bios(dp)) {
-+		dprintk(KERN_ERR "ioband_conduct: token expired dp:%p "
-+			"issued(%d,%d) g_blocked(%d)\n", dp,
-+			 dp->g_issued[0], dp->g_issued[1], dp->g_blocked);
++	if (dp->g_blocked &&
++	    room_for_bio_rw(dp, READ) && room_for_bio_rw(dp, WRITE) &&
++	    bio_list_empty(&issue_list) && bio_list_empty(&pushback_list) &&
++	    dp->g_restart_bios(dp)) {
++		DMDEBUG("%s: token expired dp:%p issued(%d,%d) g_blocked(%d)",
++			__func__, dp, dp->g_issued[READ], dp->g_issued[WRITE],
++			dp->g_blocked);
 +		queue_delayed_work(dp->g_ioband_wq, &dp->g_conductor, 0);
 +	}
 +
-+
 +	spin_unlock_irqrestore(&dp->g_lock, flags);
 +
 +	while ((bio = bio_list_pop(&issue_list)))
@@ -1984,7 +1974,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +}
 +
 +static int ioband_end_io(struct dm_target *ti, struct bio *bio,
-+				int error, union map_info *map_context)
++			 int error, union map_info *map_context)
 +{
 +	struct ioband_group *gp = ti->private;
 +	struct ioband_device *dp = gp->c_banddev;
@@ -2007,12 +1997,12 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +
 +	/*
 +	 * Todo: It would be better to introduce high/low water marks here
-+	 * 	 not to kick the workqueues so often.
++	 *       not to kick the workqueues so often.
 +	 */
 +	if (dp->g_blocked)
 +		queue_delayed_work(dp->g_ioband_wq, &dp->g_conductor, 0);
-+	else if (is_device_suspended(dp)
-+				&& dp->g_issued[0] + dp->g_issued[1] == 0)
++	else if (is_device_suspended(dp) &&
++		 dp->g_issued[READ] + dp->g_issued[WRITE] == 0)
 +		wake_up_all(&dp->g_waitq_flush);
 +	spin_unlock_irqrestore(&dp->g_lock, flags);
 +	return r;
@@ -2038,9 +2028,8 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	mutex_unlock(&dp->g_lock_device);
 +}
 +
-+
 +static void ioband_group_status(struct ioband_group *gp, int *szp,
-+					char *result, unsigned int maxlen)
++				char *result, unsigned maxlen)
 +{
 +	struct ioband_group_stat *stat;
 +	int i, sz = *szp; /* used in DMEMIT() */
@@ -2049,14 +2038,14 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	for (i = 0; i < 2; i++) {
 +		stat = &gp->c_stat[i];
 +		DMEMIT(" %lu %lu %lu",
-+			stat->immediate + stat->deferred, stat->deferred,
-+			stat->sectors);
++		       stat->immediate + stat->deferred, stat->deferred,
++		       stat->sectors);
 +	}
 +	*szp = sz;
 +}
 +
 +static int ioband_status(struct dm_target *ti, status_type_t type,
-+					char *result, unsigned int maxlen)
++			 char *result, unsigned maxlen)
 +{
 +	struct ioband_group *gp = ti->private, *p;
 +	struct ioband_device *dp = gp->c_banddev;
@@ -2072,7 +2061,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +		DMEMIT("%s", dp->g_name);
 +		ioband_group_status(gp, &sz, result, maxlen);
 +		for (node = rb_first(&gp->c_group_root); node;
-+						node = rb_next(node)) {
++		     node = rb_next(node)) {
 +			p = rb_entry(node, struct ioband_group, c_group_node);
 +			ioband_group_status(p, &sz, result, maxlen);
 +		}
@@ -2082,9 +2071,9 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	case STATUSTYPE_TABLE:
 +		spin_lock_irqsave(&dp->g_lock, flags);
 +		DMEMIT("%s %s %d %d %s %s",
-+				gp->c_dev->name, dp->g_name,
-+				dp->g_io_throttle, dp->g_io_limit[0],
-+				gp->c_type->t_name, dp->g_policy->p_name);
++		       gp->c_dev->name, dp->g_name,
++		       dp->g_io_throttle, dp->g_io_limit[READ],
++		       gp->c_type->t_name, dp->g_policy->p_name);
 +		dp->g_show(gp, &sz, result, maxlen);
 +		spin_unlock_irqrestore(&dp->g_lock, flags);
 +		break;
@@ -2217,8 +2206,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 + *		"weight" 0:<value>
 + *		"token"  24:<value>
 + */
-+static int __ioband_message(struct dm_target *ti,
-+					unsigned int argc, char **argv)
++static int __ioband_message(struct dm_target *ti, unsigned argc, char **argv)
 +{
 +	struct ioband_group *gp = ti->private, *p;
 +	struct ioband_device *dp = gp->c_banddev;
@@ -2231,7 +2219,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +		spin_lock_irqsave(&dp->g_lock, flags);
 +		memset(gp->c_stat, 0, sizeof(gp->c_stat));
 +		for (node = rb_first(&gp->c_group_root); node;
-+						 node = rb_next(node)) {
++		     node = rb_next(node)) {
 +			p = rb_entry(node, struct ioband_group, c_group_node);
 +			memset(p->c_stat, 0, sizeof(p->c_stat));
 +		}
@@ -2243,27 +2231,25 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +		DMWARN("Unrecognised band message received.");
 +		return -EINVAL;
 +	}
-+	if (!strcmp(argv[0], "debug")) {
++	if (!strcmp(argv[0], "io_throttle")) {
 +		r = strict_strtol(argv[1], 0, &val);
-+		if (r || val < 0)
++		if (r || val < 0 || val > SHORT_MAX)
 +			return -EINVAL;
-+		ioband_debug = val;
-+		return 0;
-+	} else if (!strcmp(argv[0], "io_throttle")) {
-+		r = strict_strtol(argv[1], 0, &val);
++		if (val == 0)
++			val = DEFAULT_IO_THROTTLE;
 +		spin_lock_irqsave(&dp->g_lock, flags);
-+		if (r || val < 0 ||
-+			val > dp->g_io_limit[0] || val > dp->g_io_limit[1]) {
++		if (val > dp->g_io_limit[READ] ||
++		    val > dp->g_io_limit[WRITE]) {
 +			spin_unlock_irqrestore(&dp->g_lock, flags);
 +			return -EINVAL;
 +		}
-+		dp->g_io_throttle = (val == 0) ? DEFAULT_IO_THROTTLE : val;
++		dp->g_io_throttle = val;
 +		spin_unlock_irqrestore(&dp->g_lock, flags);
 +		ioband_set_param(gp, argv[0], argv[1]);
 +		return 0;
 +	} else if (!strcmp(argv[0], "io_limit")) {
 +		r = strict_strtol(argv[1], 0, &val);
-+		if (r || val < 0)
++		if (r || val < 0 || val > SHORT_MAX)
 +			return -EINVAL;
 +		spin_lock_irqsave(&dp->g_lock, flags);
 +		if (val == 0) {
@@ -2280,7 +2266,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +			spin_unlock_irqrestore(&dp->g_lock, flags);
 +			return -EINVAL;
 +		}
-+		dp->g_io_limit[0] = dp->g_io_limit[1] = val;
++		dp->g_io_limit[READ] = dp->g_io_limit[WRITE] = val;
 +		spin_unlock_irqrestore(&dp->g_lock, flags);
 +		ioband_set_param(gp, argv[0], argv[1]);
 +		return 0;
@@ -2309,7 +2295,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	return 0;
 +}
 +
-+static int ioband_message(struct dm_target *ti, unsigned int argc, char **argv)
++static int ioband_message(struct dm_target *ti, unsigned argc, char **argv)
 +{
 +	struct ioband_group *gp = ti->private;
 +	struct ioband_device *dp = gp->c_banddev;
@@ -2322,7 +2308,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +}
 +
 +static int ioband_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
-+					struct bio_vec *biovec, int max_size)
++			struct bio_vec *biovec, int max_size)
 +{
 +	struct ioband_group *gp = ti->private;
 +	struct request_queue *q = bdev_get_queue(gp->c_dev->bdev);
@@ -2339,7 +2325,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +static struct target_type ioband_target = {
 +	.name	     = "ioband",
 +	.module      = THIS_MODULE,
-+	.version     = {1, 10, 0},
++	.version     = {1, 10, 2},
 +	.ctr	     = ioband_ctr,
 +	.dtr	     = ioband_dtr,
 +	.map	     = ioband_map,
@@ -2377,9 +2363,9 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +MODULE_LICENSE("GPL");
 Index: linux-2.6.29-rc7/drivers/md/dm-ioband-policy.c
 ===================================================================
---- /dev/null	1970-01-01 00:00:00.000000000 +0000
-+++ linux-2.6.29-rc7/drivers/md/dm-ioband-policy.c	2009-03-05 12:09:59.000000000 +0000
-@@ -0,0 +1,460 @@
+--- /dev/null
++++ linux-2.6.29-rc7/drivers/md/dm-ioband-policy.c
+@@ -0,0 +1,457 @@
 +/*
 + * Copyright (C) 2008 VA Linux Systems Japan K.K.
 + *
@@ -2400,7 +2386,6 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 + * It is possible to add a new BIO scheduling policy with it.
 + */
 +
-+
 +/*
 + * Functions for weight balancing policy based on the number of I/Os.
 + */
@@ -2458,13 +2443,13 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	if (gp) {
 +		int iopri = iopriority(gp);
 +		if (iopri * PROCEED_THRESHOLD > IOBAND_IOPRIO_BASE &&
-+			dp->g_issued[0] + dp->g_issued[1] >= dp->g_io_throttle)
++		    dp->g_issued[READ] + dp->g_issued[WRITE] >=
++		    dp->g_io_throttle)
 +			return 0;
 +	}
 +
 +	dp->g_epoch++;
-+	dprintk(KERN_ERR "make_epoch %d --> %d\n",
-+						dp->g_epoch-1, dp->g_epoch);
++	DMDEBUG("make_epoch %d", dp->g_epoch);
 +
 +	/* The leftover tokens will be used in the next epoch. */
 +	dp->g_token_extra = dp->g_token_left;
@@ -2527,20 +2512,18 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	 * tokens on this ioband device from the previous epoch.
 +	 */
 +	extra = dp->g_token_extra * gp->c_token_initial /
-+				 (dp->g_token_bucket - dp->g_token_extra/2);
++	    (dp->g_token_bucket - dp->g_token_extra / 2);
 +	delta += extra;
 +	gp->c_token += delta;
 +	gp->c_consumed = 0;
 +
 +	if (gp == dp->g_current)
 +		dp->g_yield_mark += delta;
-+	dprintk(KERN_ERR "refill token: "
-+		"gp:%p token:%d->%d extra(%d) allowance(%d)\n",
++	DMDEBUG("refill token: gp:%p token:%d->%d extra(%d) allowance(%d)",
 +		gp, gp->c_token - delta, gp->c_token, extra, allowance);
 +	if (gp->c_token > 0)
 +		return iopriority(gp);
-+	dprintk(KERN_ERR "refill token: yet empty gp:%p token:%d\n",
-+						gp, gp->c_token);
++	DMDEBUG("refill token: yet empty gp:%p token:%d", gp, gp->c_token);
 +	return 0;
 +}
 +
@@ -2553,10 +2536,10 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	struct ioband_device *dp = gp->c_banddev;
 +
 +	if (gp->c_consumed * LOCAL_ACTIVE_RATIO < gp->c_token_initial &&
-+		gp->c_consumed * GLOBAL_ACTIVE_RATIO < dp->g_token_bucket) {
++	    gp->c_consumed * GLOBAL_ACTIVE_RATIO < dp->g_token_bucket) {
 +		; /* Do nothing unless this group is really active. */
 +	} else if (!dp->g_dominant ||
-+			get_token(gp) > get_token(dp->g_dominant)) {
++		   get_token(gp) > get_token(dp->g_dominant)) {
 +		/*
 +		 * Regard this group as the dominant group on this
 +		 * ioband device when it has larger number of tokens
@@ -2565,7 +2548,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +		dp->g_dominant = gp;
 +	}
 +	if (dp->g_epoch == gp->c_my_epoch &&
-+			gp->c_token > 0 && gp->c_token - count <= 0) {
++	    gp->c_token > 0 && gp->c_token - count <= 0) {
 +		/* Remember the last group which used up its own tokens. */
 +		dp->g_expired = gp;
 +		if (dp->g_dominant == gp)
@@ -2576,7 +2559,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +		/* This group is the current already. */
 +		dp->g_current = gp;
 +		dp->g_yield_mark =
-+			gp->c_token - (TOKEN_BATCH_UNIT << dp->g_token_unit);
++		    gp->c_token - (TOKEN_BATCH_UNIT << dp->g_token_unit);
 +	}
 +	gp->c_token -= count;
 +	gp->c_consumed += count;
@@ -2628,19 +2611,20 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +			p->c_token = p->c_token_initial =
 +				dp->g_token_bucket * p->c_weight /
 +				dp->g_weight_total + 1;
-+			p->c_limit = (dp->g_io_limit[0] + dp->g_io_limit[1]) *
-+				p->c_weight / dp->g_weight_total /
-+				OVERCOMMIT_RATE + 1;
++			p->c_limit = (dp->g_io_limit[READ] +
++				dp->g_io_limit[WRITE]) * p->c_weight /
++				dp->g_weight_total / OVERCOMMIT_RATE + 1;
 +		}
 +	}
 +}
 +
 +static void init_token_bucket(struct ioband_device *dp,
-+					int token_bucket, int carryover)
++			      int token_bucket, int carryover)
 +{
 +	if (!token_bucket)
-+		dp->g_token_bucket = ((dp->g_io_limit[0] + dp->g_io_limit[1]) *
-+					DEFAULT_BUCKET) << dp->g_token_unit;
++		dp->g_token_bucket =
++			((dp->g_io_limit[READ] + dp->g_io_limit[WRITE]) *
++			DEFAULT_BUCKET) << dp->g_token_unit;
 +	else
 +		dp->g_token_bucket = token_bucket;
 +	if (!carryover)
@@ -2666,14 +2650,14 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +		else
 +			r = -EINVAL;
 +	} else if (!strcmp(cmd, "token")) {
-+		if (!err && val >= 0) {
++		if (!err && 0 <= val && val <= INT_MAX) {
 +			init_token_bucket(dp, val, 0);
 +			set_weight(gp, gp->c_weight);
 +			dp->g_token_extra = 0;
 +		} else
 +			r = -EINVAL;
 +	} else if (!strcmp(cmd, "carryover")) {
-+		if (!err && val >= 0) {
++		if (!err && 0 <= val && val <= INT_MAX) {
 +			init_token_bucket(dp, dp->g_token_bucket, val);
 +			set_weight(gp, gp->c_weight);
 +			dp->g_token_extra = 0;
@@ -2709,12 +2693,12 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +}
 +
 +static void policy_weight_show(struct ioband_group *gp, int *szp,
-+					char *result, unsigned int maxlen)
++			       char *result, unsigned maxlen)
 +{
 +	struct ioband_group *p;
 +	struct ioband_device *dp = gp->c_banddev;
 +	struct rb_node *node;
-+	int sz = *szp; /* used in DMEMIT() */
++	int sz = *szp;	/* used in DMEMIT() */
 +
 +	DMEMIT(" %d :%d", dp->g_token_bucket, gp->c_weight);
 +
@@ -2763,7 +2747,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +		val = 0;
 +	else {
 +		r = strict_strtol(argv[0], 0, &val);
-+		if (r || val < 0)
++		if (r || val < 0 || val > INT_MAX)
 +			return -EINVAL;
 +	}
 +
@@ -2774,7 +2758,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	dp->g_group_dtr = policy_weight_dtr;
 +	dp->g_set_param = policy_weight_param;
 +	dp->g_should_block = is_queue_full;
-+	dp->g_show  = policy_weight_show;
++	dp->g_show = policy_weight_show;
 +
 +	dp->g_epoch = 0;
 +	dp->g_weight_total = 0;
@@ -2788,8 +2772,8 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +
 +	return 0;
 +}
-+/* weight balancing policy based on the number of I/Os. --- End --- */
 +
++/* weight balancing policy based on the number of I/Os. --- End --- */
 +
 +/*
 + * Functions for weight balancing policy based on I/O size.
@@ -2802,7 +2786,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +}
 +
 +static int w2_policy_weight_init(struct ioband_device *dp,
-+							int argc, char **argv)
++				 int argc, char **argv)
 +{
 +	long val;
 +	int r = 0;
@@ -2811,7 +2795,7 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +		val = 0;
 +	else {
 +		r = strict_strtol(argv[0], 0, &val);
-+		if (r || val < 0)
++		if (r || val < 0 || val > INT_MAX)
 +			return -EINVAL;
 +	}
 +
@@ -2825,11 +2809,10 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	dp->g_token_left = dp->g_token_bucket;
 +	return 0;
 +}
-+/* weight balancing policy based on I/O size. --- End --- */
 +
++/* weight balancing policy based on I/O size. --- End --- */
 +
-+static int policy_default_init(struct ioband_device *dp,
-+					int argc, char **argv)
++static int policy_default_init(struct ioband_device *dp, int argc, char **argv)
 +{
 +	return policy_weight_init(dp, argc, argv);
 +}
@@ -2838,13 +2821,13 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +	{"default", policy_default_init},
 +	{"weight", policy_weight_init},
 +	{"weight-iosize", w2_policy_weight_init},
-+	{NULL,     policy_default_init}
++	{NULL, policy_default_init}
 +};
 Index: linux-2.6.29-rc7/drivers/md/dm-ioband-type.c
 ===================================================================
---- /dev/null	1970-01-01 00:00:00.000000000 +0000
-+++ linux-2.6.29-rc7/drivers/md/dm-ioband-type.c	2009-03-05 12:09:59.000000000 +0000
-@@ -0,0 +1,76 @@
+--- /dev/null
++++ linux-2.6.29-rc7/drivers/md/dm-ioband-type.c
+@@ -0,0 +1,77 @@
 +/*
 + * Copyright (C) 2008 VA Linux Systems Japan K.K.
 + *
@@ -2900,32 +2883,33 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +
 +static int ioband_cgroup(struct bio *bio)
 +{
-+  /*
-+   * This function should return the ID of the cgroup which issued "bio".
-+   * The ID of the cgroup which the current process belongs to won't be
-+   * suitable ID for this purpose, since some BIOs will be handled by kernel
-+   * threads like aio or pdflush on behalf of the process requesting the BIOs.
-+   */
++	/*
++	 * This function should return the ID of the cgroup which
++	 * issued "bio". The ID of the cgroup which the current
++	 * process belongs to won't be suitable ID for this purpose,
++	 * since some BIOs will be handled by kernel threads like aio
++	 * or pdflush on behalf of the process requesting the BIOs.
++	 */
 +	return 0;	/* not implemented yet */
 +}
 +
 +struct group_type dm_ioband_group_type[] = {
-+	{"none",   NULL},
-+	{"pgrp",   ioband_process_group},
-+	{"pid",    ioband_process_id},
-+	{"node",   ioband_node},
++	{"none", NULL},
++	{"pgrp", ioband_process_group},
++	{"pid", ioband_process_id},
++	{"node", ioband_node},
 +	{"cpuset", ioband_cpuset},
 +	{"cgroup", ioband_cgroup},
-+	{"user",   ioband_uid},
-+	{"uid",    ioband_uid},
-+	{"gid",    ioband_gid},
-+	{NULL,     NULL}
++	{"user", ioband_uid},
++	{"uid", ioband_uid},
++	{"gid", ioband_gid},
++	{NULL, NULL}
 +};
 Index: linux-2.6.29-rc7/drivers/md/dm-ioband.h
 ===================================================================
---- /dev/null	1970-01-01 00:00:00.000000000 +0000
-+++ linux-2.6.29-rc7/drivers/md/dm-ioband.h	2009-03-05 12:09:59.000000000 +0000
-@@ -0,0 +1,194 @@
+--- /dev/null
++++ linux-2.6.29-rc7/drivers/md/dm-ioband.h
+@@ -0,0 +1,186 @@
 +/*
 + * Copyright (C) 2008 VA Linux Systems Japan K.K.
 + *
@@ -2937,6 +2921,8 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +#include <linux/version.h>
 +#include <linux/wait.h>
 +
++#define DM_MSG_PREFIX "ioband"
++
 +#define DEFAULT_IO_THROTTLE	4
 +#define DEFAULT_IO_LIMIT	128
 +#define IOBAND_NAME_MAX 31
@@ -2945,94 +2931,94 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +struct ioband_group;
 +
 +struct ioband_device {
-+	struct list_head	g_groups;
-+	struct delayed_work     g_conductor;
-+	struct workqueue_struct	*g_ioband_wq;
-+	struct	bio_list	g_urgent_bios;
-+	int	g_io_throttle;
-+	int	g_io_limit[2];
-+	int	g_issued[2];
-+	int	g_blocked;
-+	spinlock_t	g_lock;
-+	struct mutex	g_lock_device;
++	struct list_head g_groups;
++	struct delayed_work g_conductor;
++	struct workqueue_struct *g_ioband_wq;
++	struct bio_list g_urgent_bios;
++	int g_io_throttle;
++	int g_io_limit[2];
++	int g_issued[2];
++	int g_blocked;
++	spinlock_t g_lock;
++	struct mutex g_lock_device;
 +	wait_queue_head_t g_waitq;
 +	wait_queue_head_t g_waitq_suspend;
 +	wait_queue_head_t g_waitq_flush;
 +
-+	int	g_ref;
-+	struct	list_head g_list;
-+	int	g_flags;
-+	char	g_name[IOBAND_NAME_MAX + 1];
-+	struct	policy_type *g_policy;
++	int g_ref;
++	struct list_head g_list;
++	int g_flags;
++	char g_name[IOBAND_NAME_MAX + 1];
++	struct policy_type *g_policy;
 +
 +	/* policy dependent */
-+	int	(*g_can_submit)(struct ioband_group *);
-+	int	(*g_prepare_bio)(struct ioband_group *, struct bio *, int);
-+	int	(*g_restart_bios)(struct ioband_device *);
-+	void	(*g_hold_bio)(struct ioband_group *, struct bio *);
-+	struct bio * (*g_pop_bio)(struct ioband_group *);
-+	int	(*g_group_ctr)(struct ioband_group *, char *);
-+	void	(*g_group_dtr)(struct ioband_group *);
-+	int	(*g_set_param)(struct ioband_group *, char *cmd, char *value);
-+	int	(*g_should_block)(struct ioband_group *);
-+	void	(*g_show)(struct ioband_group *, int *, char *, unsigned int);
++	int (*g_can_submit) (struct ioband_group *);
++	int (*g_prepare_bio) (struct ioband_group *, struct bio *, int);
++	int (*g_restart_bios) (struct ioband_device *);
++	void (*g_hold_bio) (struct ioband_group *, struct bio *);
++	struct bio *(*g_pop_bio) (struct ioband_group *);
++	int (*g_group_ctr) (struct ioband_group *, char *);
++	void (*g_group_dtr) (struct ioband_group *);
++	int (*g_set_param) (struct ioband_group *, char *cmd, char *value);
++	int (*g_should_block) (struct ioband_group *);
++	void (*g_show) (struct ioband_group *, int *, char *, unsigned);
 +
 +	/* members for weight balancing policy */
-+	int	g_epoch;
-+	int	g_weight_total;
-+		/* the number of tokens which can be used in every epoch */
-+	int	g_token_bucket;
-+		/* how many epochs tokens can be carried over */
-+	int	g_carryover;
-+		/* how many tokens should be used for one page-sized I/O */
-+	int	g_token_unit;
-+		/* the last group which used a token */
++	int g_epoch;
++	int g_weight_total;
++	/* the number of tokens which can be used in every epoch */
++	int g_token_bucket;
++	/* how many epochs tokens can be carried over */
++	int g_carryover;
++	/* how many tokens should be used for one page-sized I/O */
++	int g_token_unit;
++	/* the last group which used a token */
 +	struct ioband_group *g_current;
-+		/* give another group a chance to be scheduled when the rest
-+		   of tokens of the current group reaches this mark */
-+	int	g_yield_mark;
-+		/* the latest group which used up its tokens */
++	/* give another group a chance to be scheduled when the rest
++	   of tokens of the current group reaches this mark */
++	int g_yield_mark;
++	/* the latest group which used up its tokens */
 +	struct ioband_group *g_expired;
-+		/* the group which has the largest number of tokens in the
-+		   active groups */
++	/* the group which has the largest number of tokens in the
++	   active groups */
 +	struct ioband_group *g_dominant;
-+		/* the number of unused tokens in this epoch */
-+	int	g_token_left;
-+		/* left-over tokens from the previous epoch */
-+	int	g_token_extra;
++	/* the number of unused tokens in this epoch */
++	int g_token_left;
++	/* left-over tokens from the previous epoch */
++	int g_token_extra;
 +};
 +
 +struct ioband_group_stat {
-+	unsigned long	sectors;
-+	unsigned long	immediate;
-+	unsigned long	deferred;
++	unsigned long sectors;
++	unsigned long immediate;
++	unsigned long deferred;
 +};
 +
 +struct ioband_group {
-+	struct	list_head c_list;
++	struct list_head c_list;
 +	struct ioband_device *c_banddev;
 +	struct dm_dev *c_dev;
 +	struct dm_target *c_target;
-+	struct	bio_list c_blocked_bios;
-+	struct	bio_list c_prio_bios;
-+	struct	rb_root c_group_root;
-+	struct  rb_node c_group_node;
-+	int	c_id;	/* should be unsigned long or unsigned long long */
-+	char	c_name[IOBAND_NAME_MAX + 1];	/* rfu */
-+	int	c_blocked;
-+	int	c_prio_blocked;
++	struct bio_list c_blocked_bios;
++	struct bio_list c_prio_bios;
++	struct rb_root c_group_root;
++	struct rb_node c_group_node;
++	int c_id;	/* should be unsigned long or unsigned long long */
++	char c_name[IOBAND_NAME_MAX + 1];	/* rfu */
++	int c_blocked;
++	int c_prio_blocked;
 +	wait_queue_head_t c_waitq;
-+	int	c_flags;
-+	struct	ioband_group_stat c_stat[2];	/* hold rd/wr status */
-+	struct	group_type *c_type;
++	int c_flags;
++	struct ioband_group_stat c_stat[2];	/* hold rd/wr status */
++	struct group_type *c_type;
 +
 +	/* members for weight balancing policy */
-+	int	c_weight;
-+	int	c_my_epoch;
-+	int	c_token;
-+	int	c_token_initial;
-+	int	c_limit;
-+	int     c_consumed;
++	int c_weight;
++	int c_my_epoch;
++	int c_token;
++	int c_token_initial;
++	int c_limit;
++	int c_consumed;
 +
 +	/* rfu */
 +	/* struct bio_list	c_ordered_tag_bios; */
@@ -3097,26 +3083,16 @@ Index: linux-2.6.29-rc7/drivers/md/dm-io
 +#define is_prio_queue(gp)		((gp)->c_flags & IOG_PRIO_QUEUE)
 +#define prio_queue_direct(gp)		((gp)->c_flags & IOG_PRIO_BIO_WRITE)
 +
-+
 +struct policy_type {
 +	const char *p_name;
-+	int	  (*p_policy_init)(struct ioband_device *, int, char **);
++	int (*p_policy_init) (struct ioband_device *, int, char **);
 +};
 +
 +extern struct policy_type dm_ioband_policy_type[];
 +
 +struct group_type {
 +	const char *t_name;
-+	int	  (*t_getid)(struct bio *);
++	int (*t_getid) (struct bio *);
 +};
 +
 +extern struct group_type dm_ioband_group_type[];
-+
-+/* Just for debugging */
-+extern long ioband_debug;
-+#define dprintk(format, a...) do { \
-+	if (ioband_debug > 0) {	\
-+		ioband_debug--; \
-+		printk(format, ##a); \
-+	} \
-+} while (0)
