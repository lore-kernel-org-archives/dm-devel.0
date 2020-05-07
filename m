From: Kjetil Orbekk <kj@orbekk.com>
Subject: [PATCH] dm: track io errors per mapped device
Date: Thu,  7 May 2020 19:05:33 -0400
Message-ID: <20200507230532.5733-1-kj@orbekk.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
Cc: harshads@google.com, Khazhismel Kumykov <khazhy@google.com>, Kjetil Orbekk <kj@orbekk.com>
List-Id: dm-devel.ids

From: Khazhismel Kumykov <khazhy@google.com>

This will track ioerr_cnt on all dm targets and expose it as
<device>/dm/ioerr_cnt.

Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
[kj@orbekk.com: added support for bio based devices in dm.c]
Signed-off-by: Kjetil Orbekk <kj@orbekk.com>
---
 drivers/md/dm-core.h  |  2 ++
 drivers/md/dm-rq.c    |  4 ++++
 drivers/md/dm-sysfs.c |  8 ++++++++
 drivers/md/dm.c       | 10 ++++++++++
 drivers/md/dm.h       |  1 +
 5 files changed, 25 insertions(+)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index c4ef1fceead6..c6cc0f9e4d9a 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -108,6 +108,8 @@ struct mapped_device {
 
 	struct dm_stats stats;
 
+	atomic_t ioerr_cnt;
+
 	/* for blk-mq request-based DM support */
 	struct blk_mq_tag_set *tag_set;
 	bool init_tio_pdu:1;
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 3f8577e2c13b..1c1fe96ca7a4 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -171,6 +171,8 @@ static void dm_end_request(struct request *clone, blk_status_t error)
 	tio->ti->type->release_clone_rq(clone, NULL);
 
 	rq_end_stats(md, rq);
+	if (error)
+		atomic_inc(&md->ioerr_cnt);
 	blk_mq_end_request(rq, error);
 	rq_completed(md);
 }
@@ -268,6 +270,8 @@ static void dm_softirq_done(struct request *rq)
 		struct mapped_device *md = tio->md;
 
 		rq_end_stats(md, rq);
+		if (tio->error)
+			atomic_inc(&md->ioerr_cnt);
 		blk_mq_end_request(rq, tio->error);
 		rq_completed(md);
 		return;
diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index a05fcd50e1b9..5d59790b4b17 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -74,6 +74,12 @@ static ssize_t dm_attr_name_show(struct mapped_device *md, char *buf)
 	return strlen(buf);
 }
 
+static ssize_t dm_attr_ioerr_cnt_show(struct mapped_device *md, char *buf)
+{
+	sprintf(buf, "%d\n", dm_ioerr_cnt(md));
+	return strlen(buf);
+}
+
 static ssize_t dm_attr_uuid_show(struct mapped_device *md, char *buf)
 {
 	if (dm_copy_name_and_uuid(md, NULL, buf))
@@ -99,6 +105,7 @@ static ssize_t dm_attr_use_blk_mq_show(struct mapped_device *md, char *buf)
 }
 
 static DM_ATTR_RO(name);
+static DM_ATTR_RO(ioerr_cnt);
 static DM_ATTR_RO(uuid);
 static DM_ATTR_RO(suspended);
 static DM_ATTR_RO(use_blk_mq);
@@ -106,6 +113,7 @@ static DM_ATTR_RW(rq_based_seq_io_merge_deadline);
 
 static struct attribute *dm_attrs[] = {
 	&dm_attr_name.attr,
+	&dm_attr_ioerr_cnt.attr,
 	&dm_attr_uuid.attr,
 	&dm_attr_suspended.attr,
 	&dm_attr_use_blk_mq.attr,
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index db9e46114653..7a264379473e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1017,6 +1017,9 @@ static void clone_endio(struct bio *bio)
 			disable_write_zeroes(md);
 	}
 
+	if (error)
+		atomic_inc(&md->ioerr_cnt);
+
 	if (endio) {
 		int r = endio(tio->ti, bio, &error);
 		switch (r) {
@@ -1304,6 +1307,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
 		break;
 	case DM_MAPIO_KILL:
 		free_tio(tio);
+		atomic_inc(&md->ioerr_cnt);
 		dec_pending(io, BLK_STS_IOERR);
 		break;
 	case DM_MAPIO_REQUEUE:
@@ -2014,6 +2018,7 @@ static struct mapped_device *alloc_dev(int minor)
 		goto bad;
 
 	dm_stats_init(&md->stats);
+	atomic_set(&md->ioerr_cnt, 0);
 
 	/* Populate the mapping, nobody knows we exist yet */
 	spin_lock(&_minor_lock);
@@ -2992,6 +2997,11 @@ int dm_noflush_suspending(struct dm_target *ti)
 }
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
+int dm_ioerr_cnt(struct mapped_device *md)
+{
+	return atomic_read(&md->ioerr_cnt);
+}
+
 struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_queue_mode type,
 					    unsigned integrity, unsigned per_io_data_size,
 					    unsigned min_pool_size)
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index d7c4f6606b5f..fafb9d379ce9 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -82,6 +82,7 @@ void dm_unlock_md_type(struct mapped_device *md);
 void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type);
 enum dm_queue_mode dm_get_md_type(struct mapped_device *md);
 struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
+int dm_ioerr_cnt(struct mapped_device *md);
 
 int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
 
-- 
2.25.4
