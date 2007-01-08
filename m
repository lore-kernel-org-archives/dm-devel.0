From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] dm-mp: revalidate paths with zero size prior to
	use
Date: Mon, 8 Jan 2007 14:59:38 -0800
Message-ID: <20070108225938.GB3966@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
List-Id: dm-devel.ids

From: Mike Anderson <andmike@us.ibm.com>

Revalidate zero size path prior to using.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
---

This patch currently only does a revalidate if the size is zero to reduce
impact to existing configurations.

Visual change to the user is the dmesg will contain revalidate info for
each device.

 drivers/md/dm-mpath.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

Index: linux-2.6-patched/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6-patched.orig/drivers/md/dm-mpath.c	2007-01-08 14:35:14.000000000 -0800
+++ linux-2.6-patched/drivers/md/dm-mpath.c	2007-01-08 14:35:37.000000000 -0800
@@ -107,6 +107,27 @@
 static void process_queued_ios(struct work_struct *work);
 static void trigger_event(struct work_struct *work);
 
+static void dm_check_dev_size(struct priority_group *pg)
+{
+	struct pgpath *pgpath;
+	struct block_device *bdev;
+	sector_t dev_size;
+
+	if (!pg)
+		return;
+
+	list_for_each_entry(pgpath, &pg->pgpaths, list) {
+		bdev = pgpath->path.dev->bdev;
+		dev_size = bdev->bd_inode->i_size >> SECTOR_SHIFT;
+
+		if (!dev_size) {
+			struct gendisk *gd = bdev->bd_disk;
+			if (gd->fops->revalidate_disk)
+				gd->fops->revalidate_disk(gd);
+			bd_set_size(bdev, (loff_t)get_capacity(gd)<<9);
+		}
+	}
+}
 
 /*-----------------------------------------------
  * Allocation routines
@@ -224,6 +245,7 @@
 	} else {
 		m->pg_init_required = 0;
 		m->queue_io = 0;
+		dm_check_dev_size(m->current_pg);
 	}
 }
 
@@ -1002,6 +1024,8 @@
 	} else if (!m->pg_init_required)
 		m->queue_io = 0;
 
+	dm_check_dev_size(m->current_pg);
+
 	m->pg_init_in_progress = 0;
 	queue_work(kmultipathd, &m->process_queued_ios);
 	spin_unlock_irqrestore(&m->lock, flags);
