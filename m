From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v3 2/3] block: allow gendisk's request_queue
 registration to be deferred
Date: Thu, 11 Jan 2018 11:03:16 -0500
Message-ID: <20180111160316.GA29990@redhat.com>
References: <20180111021256.37490-1-snitzer@redhat.com>
 <20180111021256.37490-3-snitzer@redhat.com>
 <62b01560-8d92-ca03-6b21-0e00052772eb@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <62b01560-8d92-ca03-6b21-0e00052772eb@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: axboe@kernel.dk, Ming Lei <tom.leiming@gmail.com>, hch@lst.de, Bart.VanAssche@wdc.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jan 11 2018 at  2:56am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> Thinking of this a bit more, wouldn't it be better to modify add_disk()
> (or, rather, device_add_disk()) to handle this case?
> You already moved the call to 'blk_register_queue()' to the end of
> device_add_disk(), so it would be trivial to make device_add_disk() a
> wrapper function like
> 
> void device_add_disk(struct device *parent, struct gendisk *disk) {
>   blk_add_disk(parent, disk);
>   blk_register_queue(disk);
> }
> 
> and then call blk_add_disk() from the dm-core.
> That would save us the magic 'you have to set this flag before
> registering' dance in dm.c...

Really not seeing the QUEUE_FLAG I added as "magic", and I think it
useful to have a bit set in the queue that lets us know this variant of
queue registration was used (when debugging in "crash" or something,
avoids needing to mentally know that DM or some other driver uses it).

But if we did do what you're suggesting (see below), we're left with 2
functions that have similar names (leaving block core consumers
wondering which to use).  So I think it best to rename blk_add_disk to
blk_add_disk_no_queue_reg.

I'll run with that and take a look at your other review point (should we
just use test_and_set_bit in del_gendisk).  And then post v4 after
testing.

Thanks,
Mike

diff --git a/block/genhd.c b/block/genhd.c
index 00620e0..bdc3590 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -629,7 +629,7 @@ static void register_disk(struct device *parent, struct gendisk *disk)
 }
 
 /**
- * device_add_disk - add partitioning information to kernel list
+ * blk_add_disk - add partitioning information to kernel list
  * @parent: parent device for the disk
  * @disk: per-device partitioning information
  *
@@ -638,7 +638,7 @@ static void register_disk(struct device *parent, struct gendisk *disk)
  *
  * FIXME: error handling
  */
-void device_add_disk(struct device *parent, struct gendisk *disk)
+void blk_add_disk(struct device *parent, struct gendisk *disk)
 {
 	dev_t devt;
 	int retval;
@@ -682,7 +682,6 @@ void device_add_disk(struct device *parent, struct gendisk *disk)
 				    exact_match, exact_lock, disk);
 	}
 	register_disk(parent, disk);
-	blk_register_queue(disk);
 
 	/*
 	 * Take an extra ref on queue which will be put on disk_release()
@@ -693,6 +692,21 @@ void device_add_disk(struct device *parent, struct gendisk *disk)
 	disk_add_events(disk);
 	blk_integrity_add(disk);
 }
+EXPORT_SYMBOL(blk_add_disk)
+
+/**
+ * device_add_disk - add disk information to kernel list
+ * @parent: parent device for the disk
+ * @disk: per-device disk information
+ *
+ * Adds partitioning information via blk_add_disk() and
+ * also also registers the associated request_queue to @disk.
+ */
+void device_add_disk(struct device *parent, struct gendisk *disk)
+{
+	blk_add_disk(parent, disk);
+	blk_register_queue(disk);
+}
 EXPORT_SYMBOL(device_add_disk);
 
 void del_gendisk(struct gendisk *disk)
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 5144ebe..d83fd25 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -390,6 +390,7 @@ static inline void free_part_info(struct hd_struct *part)
 extern void part_round_stats(struct request_queue *q, int cpu, struct hd_struct *part);
 
 /* block/genhd.c */
+extern void blk_add_disk(struct device *parent, struct gendisk *disk);
 extern void device_add_disk(struct device *parent, struct gendisk *disk);
 static inline void add_disk(struct gendisk *disk)
 {
