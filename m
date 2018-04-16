From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 1/2] dm-delay: refactor repetitive code
Date: Tue, 17 Apr 2018 00:33:13 +0200
Message-ID: <20180416223609.120430207@debian.vm>
References: <20180416223312.122871155@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-delay-refactor.patch
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

dm-delay has a lot of code that is repeated for delaying read and write
bios. Repetitive code is generally bad; I intend to add another class for
flush bios, so I refactor out the repetitive code, so that the new class
can be added easily.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-delay.c |  226 +++++++++++++++++++++++---------------------------
 1 file changed, 104 insertions(+), 122 deletions(-)

Index: linux-2.6/drivers/md/dm-delay.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-delay.c	2018-04-16 21:21:12.000000000 +0200
+++ linux-2.6/drivers/md/dm-delay.c	2018-04-17 00:13:17.000000000 +0200
@@ -17,6 +17,13 @@
 
 #define DM_MSG_PREFIX "delay"
 
+struct delay_class {
+	struct dm_dev *dev;
+	sector_t start;
+	unsigned delay;
+	unsigned ops;
+};
+
 struct delay_c {
 	struct timer_list delay_timer;
 	struct mutex timer_lock;
@@ -25,19 +32,15 @@ struct delay_c {
 	struct list_head delayed_bios;
 	atomic_t may_delay;
 
-	struct dm_dev *dev_read;
-	sector_t start_read;
-	unsigned read_delay;
-	unsigned reads;
-
-	struct dm_dev *dev_write;
-	sector_t start_write;
-	unsigned write_delay;
-	unsigned writes;
+	struct delay_class read;
+	struct delay_class write;
+
+	int argc;
 };
 
 struct dm_delay_info {
 	struct delay_c *context;
+	struct delay_class *class;
 	struct list_head list;
 	unsigned long expires;
 };
@@ -77,7 +80,7 @@ static struct bio *flush_delayed_bios(st
 {
 	struct dm_delay_info *delayed, *next;
 	unsigned long next_expires = 0;
-	int start_timer = 0;
+	unsigned long start_timer = 0;
 	struct bio_list flush_bios = { };
 
 	mutex_lock(&delayed_bios_lock);
@@ -87,10 +90,7 @@ static struct bio *flush_delayed_bios(st
 						sizeof(struct dm_delay_info));
 			list_del(&delayed->list);
 			bio_list_add(&flush_bios, bio);
-			if ((bio_data_dir(bio) == WRITE))
-				delayed->context->writes--;
-			else
-				delayed->context->reads--;
+			delayed->class->ops--;
 			continue;
 		}
 
@@ -100,7 +100,6 @@ static struct bio *flush_delayed_bios(st
 		} else
 			next_expires = min(next_expires, delayed->expires);
 	}
-
 	mutex_unlock(&delayed_bios_lock);
 
 	if (start_timer)
@@ -117,6 +116,48 @@ static void flush_expired_bios(struct wo
 	flush_bios(flush_delayed_bios(dc, 0));
 }
 
+static void delay_dtr(struct dm_target *ti)
+{
+	struct delay_c *dc = ti->private;
+
+	destroy_workqueue(dc->kdelayd_wq);
+
+	if (dc->read.dev)
+		dm_put_device(ti, dc->read.dev);
+	if (dc->write.dev)
+		dm_put_device(ti, dc->write.dev);
+
+	mutex_destroy(&dc->timer_lock);
+
+	kfree(dc);
+}
+
+static int delay_class_ctr(struct dm_target *ti, struct delay_class *c, char **argv)
+{
+	int ret;
+	unsigned long long tmpll;
+	char dummy;
+
+	if (sscanf(argv[1], "%llu%c", &tmpll, &dummy) != 1) {
+		ti->error = "Invalid device sector";
+		return -EINVAL;
+	}
+	c->start = tmpll;
+
+	if (sscanf(argv[2], "%u%c", &c->delay, &dummy) != 1) {
+		ti->error = "Invalid delay";
+		return -EINVAL;
+	}
+
+	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &c->dev);
+	if (ret) {
+		ti->error = "Device lookup failed";
+		return ret;
+	}
+
+	return 0;
+}
+
 /*
  * Mapping parameters:
  *    <device> <offset> <delay> [<write_device> <write_offset> <write_delay>]
@@ -128,8 +169,6 @@ static void flush_expired_bios(struct wo
 static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct delay_c *dc;
-	unsigned long long tmpll;
-	char dummy;
 	int ret;
 
 	if (argc != 3 && argc != 6) {
@@ -137,125 +176,69 @@ static int delay_ctr(struct dm_target *t
 		return -EINVAL;
 	}
 
-	dc = kmalloc(sizeof(*dc), GFP_KERNEL);
+	dc = kzalloc(sizeof(*dc), GFP_KERNEL);
 	if (!dc) {
 		ti->error = "Cannot allocate context";
 		return -ENOMEM;
 	}
 
-	dc->reads = dc->writes = 0;
-
-	ret = -EINVAL;
-	if (sscanf(argv[1], "%llu%c", &tmpll, &dummy) != 1) {
-		ti->error = "Invalid device sector";
-		goto bad;
-	}
-	dc->start_read = tmpll;
-
-	if (sscanf(argv[2], "%u%c", &dc->read_delay, &dummy) != 1) {
-		ti->error = "Invalid delay";
-		goto bad;
-	}
+	ti->private = dc;
+	timer_setup(&dc->delay_timer, handle_delayed_timer, 0);
+	INIT_WORK(&dc->flush_expired_bios, flush_expired_bios);
+	INIT_LIST_HEAD(&dc->delayed_bios);
+	mutex_init(&dc->timer_lock);
+	atomic_set(&dc->may_delay, 1);
+	dc->argc = argc;
 
-	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
-			    &dc->dev_read);
-	if (ret) {
-		ti->error = "Device lookup failed";
+	ret = delay_class_ctr(ti, &dc->read, argv);
+	if (ret)
 		goto bad;
-	}
 
-	ret = -EINVAL;
-	dc->dev_write = NULL;
-	if (argc == 3)
+	if (argc == 3) {
+		ret = delay_class_ctr(ti, &dc->write, argv);
+		if (ret)
+			goto bad;
 		goto out;
-
-	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1) {
-		ti->error = "Invalid write device sector";
-		goto bad_dev_read;
 	}
-	dc->start_write = tmpll;
 
-	if (sscanf(argv[5], "%u%c", &dc->write_delay, &dummy) != 1) {
-		ti->error = "Invalid write delay";
-		goto bad_dev_read;
-	}
-
-	ret = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
-			    &dc->dev_write);
-	if (ret) {
-		ti->error = "Write device lookup failed";
-		goto bad_dev_read;
-	}
+	ret = delay_class_ctr(ti, &dc->write, argv + 3);
+	if (ret)
+		goto bad;
 
 out:
-	ret = -EINVAL;
 	dc->kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
 	if (!dc->kdelayd_wq) {
+		ret = -EINVAL;
 		DMERR("Couldn't start kdelayd");
-		goto bad_queue;
+		goto bad;
 	}
 
-	timer_setup(&dc->delay_timer, handle_delayed_timer, 0);
-
-	INIT_WORK(&dc->flush_expired_bios, flush_expired_bios);
-	INIT_LIST_HEAD(&dc->delayed_bios);
-	mutex_init(&dc->timer_lock);
-	atomic_set(&dc->may_delay, 1);
-
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->per_io_data_size = sizeof(struct dm_delay_info);
-	ti->private = dc;
 	return 0;
 
-bad_queue:
-	if (dc->dev_write)
-		dm_put_device(ti, dc->dev_write);
-bad_dev_read:
-	dm_put_device(ti, dc->dev_read);
 bad:
-	kfree(dc);
+	delay_dtr(ti);
 	return ret;
 }
 
-static void delay_dtr(struct dm_target *ti)
-{
-	struct delay_c *dc = ti->private;
-
-	destroy_workqueue(dc->kdelayd_wq);
-
-	dm_put_device(ti, dc->dev_read);
-
-	if (dc->dev_write)
-		dm_put_device(ti, dc->dev_write);
-
-	mutex_destroy(&dc->timer_lock);
-
-	kfree(dc);
-}
-
-static int delay_bio(struct delay_c *dc, int delay, struct bio *bio)
+static int delay_bio(struct delay_c *dc, struct delay_class *c, struct bio *bio)
 {
 	struct dm_delay_info *delayed;
 	unsigned long expires = 0;
 
-	if (!delay || !atomic_read(&dc->may_delay))
+	if (!c->delay || !atomic_read(&dc->may_delay))
 		return DM_MAPIO_REMAPPED;
 
 	delayed = dm_per_bio_data(bio, sizeof(struct dm_delay_info));
 
 	delayed->context = dc;
-	delayed->expires = expires = jiffies + msecs_to_jiffies(delay);
+	delayed->expires = expires = jiffies + msecs_to_jiffies(c->delay);
 
 	mutex_lock(&delayed_bios_lock);
-
-	if (bio_data_dir(bio) == WRITE)
-		dc->writes++;
-	else
-		dc->reads++;
-
+	c->ops++;
 	list_add_tail(&delayed->list, &dc->delayed_bios);
-
 	mutex_unlock(&delayed_bios_lock);
 
 	queue_timeout(dc, expires);
@@ -282,21 +265,20 @@ static void delay_resume(struct dm_targe
 static int delay_map(struct dm_target *ti, struct bio *bio)
 {
 	struct delay_c *dc = ti->private;
+	struct delay_class *c;
+	struct dm_delay_info *delayed = dm_per_bio_data(bio, sizeof(struct dm_delay_info));
 
-	if ((bio_data_dir(bio) == WRITE) && (dc->dev_write)) {
-		bio_set_dev(bio, dc->dev_write->bdev);
-		if (bio_sectors(bio))
-			bio->bi_iter.bi_sector = dc->start_write +
-				dm_target_offset(ti, bio->bi_iter.bi_sector);
-
-		return delay_bio(dc, dc->write_delay, bio);
-	}
-
-	bio_set_dev(bio, dc->dev_read->bdev);
-	bio->bi_iter.bi_sector = dc->start_read +
-		dm_target_offset(ti, bio->bi_iter.bi_sector);
+	if (bio_data_dir(bio) == WRITE) {
+		c = &dc->write;
+	} else {
+		c = &dc->read;
+	}
+	delayed->class = c;
+	bio_set_dev(bio, c->dev->bdev);
+	if (bio_sectors(bio))
+		bio->bi_iter.bi_sector = c->start + dm_target_offset(ti, bio->bi_iter.bi_sector);
 
-	return delay_bio(dc, dc->read_delay, bio);
+	return delay_bio(dc, c, bio);
 }
 
 static void delay_status(struct dm_target *ti, status_type_t type,
@@ -307,17 +289,17 @@ static void delay_status(struct dm_targe
 
 	switch (type) {
 	case STATUSTYPE_INFO:
-		DMEMIT("%u %u", dc->reads, dc->writes);
+		DMEMIT("%u %u", dc->read.ops, dc->write.ops);
 		break;
 
 	case STATUSTYPE_TABLE:
-		DMEMIT("%s %llu %u", dc->dev_read->name,
-		       (unsigned long long) dc->start_read,
-		       dc->read_delay);
-		if (dc->dev_write)
-			DMEMIT(" %s %llu %u", dc->dev_write->name,
-			       (unsigned long long) dc->start_write,
-			       dc->write_delay);
+#define EMIT_CLASS(c) DMEMIT("%s %llu %u", (c)->dev->name, (unsigned long long)(c)->start, (c)->delay)
+		EMIT_CLASS(&dc->read);
+		if (dc->argc >= 6) {
+			DMEMIT(" ");
+			EMIT_CLASS(&dc->write);
+		}
+#undef EMIT_CLASS
 		break;
 	}
 }
@@ -328,12 +310,12 @@ static int delay_iterate_devices(struct
 	struct delay_c *dc = ti->private;
 	int ret = 0;
 
-	ret = fn(ti, dc->dev_read, dc->start_read, ti->len, data);
+	ret = fn(ti, dc->read.dev, dc->read.start, ti->len, data);
+	if (ret)
+		goto out;
+	ret = fn(ti, dc->write.dev, dc->write.start, ti->len, data);
 	if (ret)
 		goto out;
-
-	if (dc->dev_write)
-		ret = fn(ti, dc->dev_write, dc->start_write, ti->len, data);
 
 out:
 	return ret;
