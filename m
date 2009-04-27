From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 8/8] raid1 barriers
Date: Mon, 27 Apr 2009 07:51:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904270751290.18227@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904270701250.12459@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270743540.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270744220.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270745190.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270745510.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270746210.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270749300.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270749570.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270750430.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270751070.18227@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904270751070.18227@hs20-bc2-1.build.redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Implement flush callee. It uses dm_io to send zero-size barrier synchronously
and concurrently to all the mirror legs.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-raid1.c |   39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

Index: linux-2.6.30-rc2-devel/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm-raid1.c	2009-04-27 12:42:02.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm-raid1.c	2009-04-27 12:53:56.000000000 +0200
@@ -237,6 +237,39 @@ out:
 	schedule_work(&ms->trigger_event);
 }
 
+static int mirror_flush(void *ms_)
+{
+	struct mirror_set *ms = ms_;
+	unsigned long error_bits;
+
+	unsigned int i;
+	struct dm_io_region io[ms->nr_mirrors];
+	struct mirror *m;
+	struct dm_io_request io_req = {
+		.bi_rw = WRITE | WRITE_BARRIER,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.bvec = NULL,
+		.client = ms->io_client,
+	};
+
+	for (i = 0, m = ms->mirror; i < ms->nr_mirrors; i++, m++) {
+		io[i].bdev = m->dev->bdev;
+		io[i].sector = 0;
+		io[i].count = 0;
+	}
+
+	error_bits = -1;
+	dm_io(&io_req, ms->nr_mirrors, io, &error_bits);
+	if (unlikely(error_bits != 0)) {
+		for (i = 0; i < ms->nr_mirrors; i++)
+			if (test_bit(i, &error_bits))
+				fail_mirror(ms->mirror + i, DM_RAID1_WRITE_ERROR);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 /*-----------------------------------------------------------------
  * Recovery.
  *
@@ -654,7 +687,7 @@ static void do_writes(struct mirror_set 
 	 */
 	dm_rh_inc_pending(ms->rh, &sync);
 	dm_rh_inc_pending(ms->rh, &nosync);
-	ms->log_failure = dm_rh_flush(ms->rh, NULL, NULL) ? 1 : 0;
+	ms->log_failure = dm_rh_flush(ms->rh, mirror_flush, ms) ? 1 : 0;
 
 	/*
 	 * Dispatch io.
@@ -755,7 +788,7 @@ static void do_mirror(struct work_struct
 	bio_list_init(&ms->failures);
 	spin_unlock_irqrestore(&ms->lock, flags);
 
-	dm_rh_update_states(ms->rh, errors_handled(ms), NULL, NULL);
+	dm_rh_update_states(ms->rh, errors_handled(ms), mirror_flush, ms);
 	do_recovery(ms);
 	do_reads(ms, &reads);
 	do_writes(ms, &writes);
@@ -1211,7 +1244,7 @@ static void mirror_postsuspend(struct dm
 	struct mirror_set *ms = ti->private;
 	struct dm_dirty_log *log = dm_rh_dirty_log(ms->rh);
 
-	if (log->type->postsuspend && log->type->postsuspend(log, NULL, NULL))
+	if (log->type->postsuspend && log->type->postsuspend(log, mirror_flush, ms))
 		/* FIXME: need better error handling */
 		DMWARN("log postsuspend failed");
 }
