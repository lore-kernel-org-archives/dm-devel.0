From: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Subject: [PATCH]dm-mpath: fix for race condition between
 multipath_dtr and pg_init_done.
Date: Thu, 17 Oct 2013 17:31:16 +0000
Message-ID: <FB8A412F33166C4A930D37BD63236C902AD2A073@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

Whenever multipath_dtr is happening, we should prevent queueing any further path
activation work. There was a kernel panic where after pg_init_done() decrements
pg_init_in_progress to 0, wait_for_pg_init_completion call assumes there are no
more pending path management commands. But if pg_init_required is set by
pg_init_done call due to retriable mode_select errors , then process_queued_ios()
will again queue the path activation work. If free_multipath call has been
completed by the time activate_path work is called, kernel panic was seen on
accessing multipath members.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
RIP: 0010:[<ffffffffa003db1b>]  [<ffffffffa003db1b>] activate_path+0x1b/0x30 [dm_multipath]
[<ffffffff81090ac0>] worker_thread+0x170/0x2a0
[<ffffffff81096c80>] ? autoremove_wake_function+0x0/0x40

This patch will fix the issue by preventing any further path activations when
multipath structures are being freed during table suspend/reload.

Signed-off-by: Shiva Krishna Merla<shivakrishna.merla@netapp.com>
Reviewed-by: Krishnasamy Somasundaram<somasundaram.krishnasamy@netapp.com>
Tested-by: Speagle Andy<Andy.Speagle@netapp.com>

---
--- a/drivers/md/dm-mpath.c	2013-01-29 10:12:10.000000000 -0600
+++ b/drivers/md/dm-mpath.c	2013-10-17 09:23:21.896062928 -0500
@@ -73,6 +73,7 @@ struct multipath {
 
 	wait_queue_head_t pg_init_wait;	/* Wait for pg_init completion */
 
+	unsigned dtr_in_progress;	/* multipath destroy in progress */
 	unsigned pg_init_required;	/* pg_init needs calling? */
 	unsigned pg_init_in_progress;	/* Only one pg_init allowed at once */
 	unsigned pg_init_delay_retry;	/* Delay pg_init retry? */
@@ -498,7 +499,8 @@ static void process_queued_ios(struct wo
 	    (!pgpath && !m->queue_if_no_path))
 		must_queue = 0;
 
-	if (m->pg_init_required && !m->pg_init_in_progress && pgpath)
+	if (m->pg_init_required && !m->pg_init_in_progress && pgpath &&
+	    !m->dtr_in_progress)
 		__pg_init_all_paths(m);
 
 	spin_unlock_irqrestore(&m->lock, flags);
@@ -952,6 +954,7 @@ static void multipath_dtr(struct dm_targ
 {
 	struct multipath *m = ti->private;
 
+	m->dtr_in_progress = 1;
 	flush_multipath_work(m);
 	free_multipath(m);
 }
@@ -1164,7 +1167,7 @@ static int pg_init_limit_reached(struct 
 
 	spin_lock_irqsave(&m->lock, flags);
 
-	if (m->pg_init_count <= m->pg_init_retries)
+	if (m->pg_init_count <= m->pg_init_retries && !m->dtr_in_progress)
 		m->pg_init_required = 1;
 	else
 		limit_reached = 1;
--
