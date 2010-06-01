From: NeilBrown <neilb@suse.de>
Subject: [PATCH 08/24] dm-raid456: add support for raising events to userspace.
Date: Tue, 01 Jun 2010 19:56:19 +1000
Message-ID: <20100601095619.565.20123.stgit@notabene.brown>
References: <20100601094414.565.3638.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100601094414.565.3638.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
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
index 5185a8f..d54f901 100644
--- a/drivers/md/dm-raid456.c
+++ b/drivers/md/dm-raid456.c
@@ -139,6 +139,13 @@ static int dev_parms(struct raid_set *rs, char **argv)
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
@@ -290,6 +297,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (rs->md.raid_disks - in_sync > rt->parity_devs)
 		goto err;
 
+	INIT_WORK(&rs->md.event_work, do_table_event);
 	ti->split_io = rs->md.chunk_sectors;
 	ti->private = rs;
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4eccf4e..da860f7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6039,6 +6039,8 @@ void md_error(mddev_t *mddev, mdk_rdev_t *rdev)
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
+	if (mddev->event_work.func)
+		schedule_work(&mddev->event_work);
 	md_new_event_inintr(mddev);
 }
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 8e19e86..6318175 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -315,6 +315,7 @@ struct mddev_s
 	struct bio *barrier;
 	atomic_t flush_pending;
 	struct work_struct barrier_work;
+	struct work_struct event_work;
 };
 
 


