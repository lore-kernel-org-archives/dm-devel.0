From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 2/2] dm-delay: add third flush class
Date: Tue, 17 Apr 2018 00:33:14 +0200
Message-ID: <20180416223610.350132415@debian.vm>
References: <20180416223312.122871155@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-delay-flush.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This patch adds a new class for dm-delay that delays flush requests.
Previously, flushes were delayed as writes, but it caused problems if the
user needed to create a device with one or few slow sectors for the
purpose of testing - all flushes would be forwarded to this device and
delayed, and that skews the test results. This patch allows to select 0
delay for flushes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/device-mapper/delay.txt |    2 +-
 drivers/md/dm-delay.c                 |   34 ++++++++++++++++++++++++++++++----
 2 files changed, 31 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/md/dm-delay.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-delay.c	2018-04-17 00:13:44.000000000 +0200
+++ linux-2.6/drivers/md/dm-delay.c	2018-04-17 00:21:11.000000000 +0200
@@ -34,6 +34,7 @@ struct delay_c {
 
 	struct delay_class read;
 	struct delay_class write;
+	struct delay_class flush;
 
 	int argc;
 };
@@ -126,6 +127,8 @@ static void delay_dtr(struct dm_target *
 		dm_put_device(ti, dc->read.dev);
 	if (dc->write.dev)
 		dm_put_device(ti, dc->write.dev);
+	if (dc->flush.dev)
+		dm_put_device(ti, dc->flush.dev);
 
 	mutex_destroy(&dc->timer_lock);
 
@@ -171,8 +174,8 @@ static int delay_ctr(struct dm_target *t
 	struct delay_c *dc;
 	int ret;
 
-	if (argc != 3 && argc != 6) {
-		ti->error = "Requires exactly 3 or 6 arguments";
+	if (argc != 3 && argc != 6 && argc != 9) {
+		ti->error = "Requires exactly 3, 6 or 9 arguments";
 		return -EINVAL;
 	}
 
@@ -198,12 +201,25 @@ static int delay_ctr(struct dm_target *t
 		ret = delay_class_ctr(ti, &dc->write, argv);
 		if (ret)
 			goto bad;
+		ret = delay_class_ctr(ti, &dc->flush, argv);
+		if (ret)
+			goto bad;
 		goto out;
 	}
 
 	ret = delay_class_ctr(ti, &dc->write, argv + 3);
 	if (ret)
 		goto bad;
+	if (argc == 6) {
+		ret = delay_class_ctr(ti, &dc->flush, argv + 3);
+		if (ret)
+			goto bad;
+		goto out;
+	}
+
+	ret = delay_class_ctr(ti, &dc->flush, argv + 6);
+	if (ret)
+		goto bad;
 
 out:
 	dc->kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
@@ -269,7 +285,10 @@ static int delay_map(struct dm_target *t
 	struct dm_delay_info *delayed = dm_per_bio_data(bio, sizeof(struct dm_delay_info));
 
 	if (bio_data_dir(bio) == WRITE) {
-		c = &dc->write;
+		if (unlikely(bio->bi_opf & REQ_PREFLUSH))
+			c = &dc->flush;
+		else
+			c = &dc->write;
 	} else {
 		c = &dc->read;
 	}
@@ -289,7 +308,7 @@ static void delay_status(struct dm_targe
 
 	switch (type) {
 	case STATUSTYPE_INFO:
-		DMEMIT("%u %u", dc->read.ops, dc->write.ops);
+		DMEMIT("%u %u %u", dc->read.ops, dc->write.ops, dc->flush.ops);
 		break;
 
 	case STATUSTYPE_TABLE:
@@ -299,6 +318,10 @@ static void delay_status(struct dm_targe
 			DMEMIT(" ");
 			EMIT_CLASS(&dc->write);
 		}
+		if (dc->argc >= 9) {
+			DMEMIT(" ");
+			EMIT_CLASS(&dc->flush);
+		}
 #undef EMIT_CLASS
 		break;
 	}
@@ -316,6 +339,9 @@ static int delay_iterate_devices(struct
 	ret = fn(ti, dc->write.dev, dc->write.start, ti->len, data);
 	if (ret)
 		goto out;
+	ret = fn(ti, dc->flush.dev, dc->flush.start, ti->len, data);
+	if (ret)
+		goto out;
 
 out:
 	return ret;
Index: linux-2.6/Documentation/device-mapper/delay.txt
===================================================================
--- linux-2.6.orig/Documentation/device-mapper/delay.txt	2017-06-03 00:22:35.000000000 +0200
+++ linux-2.6/Documentation/device-mapper/delay.txt	2018-04-17 00:24:22.000000000 +0200
@@ -5,7 +5,7 @@ Device-Mapper's "delay" target delays re
 and maps them to different devices.
 
 Parameters:
-    <device> <offset> <delay> [<write_device> <write_offset> <write_delay>]
+    <device> <offset> <delay> [<write_device> <write_offset> <write_delay> [<flush_device> <flush_offset> <flush_delay>]]
 
 With separate write parameters, the first set is only used for reads.
 Offsets are specified in sectors.
