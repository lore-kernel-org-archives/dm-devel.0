From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm mpath: fix race condition between
 multipath_dtr and pg_init_done
Date: Thu, 31 Oct 2013 10:48:13 -0400
Message-ID: <20131031144811.GA15712@redhat.com>
References: <FB8A412F33166C4A930D37BD63236C902AD3247A@SACEXCMBX02-PRD.hq.netapp.com>
	<11AF7C027C4C02408624617A49860784EDC174@BPXM12GP.gisp.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <11AF7C027C4C02408624617A49860784EDC174@BPXM12GP.gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>, Shiva Krishna Merla <shivakrishna.merla@netapp.com>
Cc: device-mapper development <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Oct 31 2013 at  5:03am -0400,
Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> 
> Hi,
> 
> how about moving this to flush_multipath_work(), which is supposed
> to silence background activities?
> I.e.
>   flush_multipath_work() {
>      <disable pg_init retry>
>      ...
>      <enable pg_init retry>
>   }
> 
> Then it not only fixes the crash you hit, it also fixes the hidden bug
> that pg_init continues retrying while the device is suspended.

I ran with your suggestion.  Please see below.

To be clear, pg_init isn't disabled while mpath device is suspended
(meaning m->pg_init_disabled isn't set until the device is resumed).
But flush_multipath_work() will no longer start pg_init during suspend
-- which could otherwise occur while the mpath device is suspended.  So
in practice it accomplishes the stated goal.

Thanks for the suggestion Junichi.  Are you OK with this?  If so please
provide your Ack.

Shiva, can you please verify that this patch resolves the race, should
accomplish the same: just pushes the disabling of pg_init inside
flush_multipath_work().


From: Shiva Krishna Merla <shivakrishna.merla@netapp.com>
Subject: dm mpath: fix race condition between multipath_dtr and pg_init_done
Date: Wed, 30 Oct 2013 03:26:38 +0000

Whenever multipath_dtr() is happening we must prevent queueing any
further path activation work.  Implement this by adding a new
'pg_init_disabled' flag to the multipath structure that denotes future
path activation work should be skipped if it is set.  By disabling
pg_init and then re-enabling in flush_multipath_work() we also avoid the
potential for pg_init to be initiated while suspending an mpath device.

Without this patch a race condition exists that may result in a kernel
panic:

1) If after pg_init_done() decrements pg_init_in_progress to 0, a call
   to wait_for_pg_init_completion() assumes there are no more pending path
   management commands.
2) If pg_init_required is set by pg_init_done(), due to retryable
   mode_select errors, then process_queued_ios() will again queue the
   path activation work.
3) If free_multipath() completes before activate_path() work is called a
   NULL pointer dereference like the following can be seen when
   accessing members of the recently destructed multipath:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
RIP: 0010:[<ffffffffa003db1b>]  [<ffffffffa003db1b>] activate_path+0x1b/0x30 [dm_multipath]
[<ffffffff81090ac0>] worker_thread+0x170/0x2a0
[<ffffffff81096c80>] ? autoremove_wake_function+0x0/0x40

[switched to disabling pg_init in flush_multipath_work, header edited by Mike Snitzer]
Suggested-by: Junichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Shiva Krishna Merla <shivakrishna.merla@netapp.com>
Reviewed-by: Krishnasamy Somasundaram <somasundaram.krishnasamy@netapp.com>
Tested-by: Speagle Andy <Andy.Speagle@netapp.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-mpath.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

Index: linux/drivers/md/dm-mpath.c
===================================================================
--- linux.orig/drivers/md/dm-mpath.c
+++ linux/drivers/md/dm-mpath.c
@@ -87,6 +87,7 @@ struct multipath {
 	unsigned queue_if_no_path:1;	/* Queue I/O if last path fails? */
 	unsigned saved_queue_if_no_path:1; /* Saved state during suspension */
 	unsigned retain_attached_hw_handler:1; /* If there's already a hw_handler present, don't change it. */
+	unsigned pg_init_disabled:1;	/* pginit is currently not allowed */
 
 	unsigned pg_init_retries;	/* Number of times to retry pg_init */
 	unsigned pg_init_count;		/* Number of times pg_init called */
@@ -497,7 +498,8 @@ static void process_queued_ios(struct wo
 	    (!pgpath && !m->queue_if_no_path))
 		must_queue = 0;
 
-	if (m->pg_init_required && !m->pg_init_in_progress && pgpath)
+	if (m->pg_init_required && !m->pg_init_in_progress && pgpath &&
+	    !m->pg_init_disabled)
 		__pg_init_all_paths(m);
 
 	spin_unlock_irqrestore(&m->lock, flags);
@@ -942,10 +944,20 @@ static void multipath_wait_for_pg_init_c
 
 static void flush_multipath_work(struct multipath *m)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&m->lock, flags);
+	m->pg_init_disabled = 1;
+	spin_unlock_irqrestore(&m->lock, flags);
+
 	flush_workqueue(kmpath_handlerd);
 	multipath_wait_for_pg_init_completion(m);
 	flush_workqueue(kmultipathd);
 	flush_work(&m->trigger_event);
+
+	spin_lock_irqsave(&m->lock, flags);
+	m->pg_init_disabled = 0;
+	spin_unlock_irqrestore(&m->lock, flags);
 }
 
 static void multipath_dtr(struct dm_target *ti)
@@ -1164,7 +1176,7 @@ static int pg_init_limit_reached(struct
 
 	spin_lock_irqsave(&m->lock, flags);
 
-	if (m->pg_init_count <= m->pg_init_retries)
+	if (m->pg_init_count <= m->pg_init_retries && !m->pg_init_disabled)
 		m->pg_init_required = 1;
 	else
 		limit_reached = 1;
@@ -1714,7 +1726,7 @@ out:
  *---------------------------------------------------------------*/
 static struct target_type multipath_target = {
 	.name = "multipath",
-	.version = {1, 5, 1},
+	.version = {1, 6, 0},
 	.module = THIS_MODULE,
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,
