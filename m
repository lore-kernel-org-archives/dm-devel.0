From: NeilBrown <neilb@suse.de>
Subject: [PATCH 04/12] dm-raid456: add support for raising events to userspace.
Date: Thu, 15 Apr 2010 16:43:02 +1000
Message-ID: <20100415064302.15646.45823.stgit@notabene.brown>
References: <20100415062909.15646.16.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415062909.15646.16.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: dm-devel.ids

Userspace needs to know about failure events.  DM handles
though through the DM_DEV_WAIT_CMD ioctl.

So allow md_error to be given some work to do on an error,
and arrange that work to signal dm.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/dm-raid456.c |    8 ++++++++
 drivers/md/md.c         |    2 ++
 drivers/md/md.h         |    1 +
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
index 0b89f9a..373784d 100644
--- a/drivers/md/dm-raid456.c
+++ b/drivers/md/dm-raid456.c
@@ -138,6 +138,13 @@ static int dev_parms(struct raid_set *rs, char **argv)
 	return 0;
 }
 
+static void do_table_event(struct work_struct *ws)
+{
+	struct raid_set *rs = container_of(ws, struct raid_set,
+					   md.event_work);
+	dm_table_event(rs->ti->table);
+}
+
 /*
  * Construct a RAID4/5/6 mapping:
  * Args:
@@ -289,6 +296,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (rs->md.raid_disks - in_sync > rt->parity_devs)
 		goto err;
 	
+	INIT_WORK(&rs->md.event_work, do_table_event);
 	ti->split_io = rs->md.chunk_sectors;
 	ti->private = rs;
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6f082bf..2042b1c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6005,6 +6005,8 @@ void md_error(mddev_t *mddev, mdk_rdev_t *rdev)
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
+	if (mddev->event_work.func)
+		schedule_work(&mddev->event_work);
 	md_new_event_inintr(mddev);
 }
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index aaadb53..09a2881 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -309,6 +309,7 @@ struct mddev_s
 	struct bio *barrier;
 	atomic_t flush_pending;
 	struct work_struct barrier_work;
+	struct work_struct event_work;
 };
 
 


