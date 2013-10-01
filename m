From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] dm-mpath: requeue I/O during pg_init
Date: Tue,  1 Oct 2013 11:49:56 +0200
Message-ID: <1380620996-110162-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

When pg_init is running no I/O can be submitted to the underlying
devices, as the path priority etc might change.
When using queue_io for this requests will be piling up within
multipath as the block I/O scheduler just sees a _very fast_
device.
All of these queued I/O has to be resubmitted from within
multipathing once pg_init is done.

This approach has the problem that it's virtually impossible to
abort I/O when pg_init is running, and we're adding heavy load
to the devices after pg_init as all of these queued I/O need
to be resubmitted _before_ any requests can be pulled of the
request queue and normal operation continues.

This patch will requeue the I/O which has been triggering
the pg_init call, and return 'busy' when pg_init is in progress.
With these changes the blk I/O scheduler will stop submitting
I/O during pg_init, resulting in a quicker path switch and
less I/O pressure (and memory consumption) after pg_init.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 5adede1..a1aaac9 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -390,7 +390,11 @@ static int map_io(struct multipath *m, struct request *clone,
 	if (was_queued)
 		m->queue_size--;
 
-	if ((pgpath && m->queue_io) ||
+	if (m->pg_init_required) {
+		if (!m->pg_init_in_progress)
+			queue_work(kmultipathd, &m->process_queued_ios);
+		r = DM_MAPIO_REQUEUE;
+	} else if ((pgpath && m->queue_io) ||
 	    (!pgpath && m->queue_if_no_path)) {
 		/* Queue for the daemon to resubmit */
 		list_add_tail(&clone->queuelist, &m->queued_ios);
@@ -1641,6 +1645,11 @@ static int multipath_busy(struct dm_target *ti)
 
 	spin_lock_irqsave(&m->lock, flags);
 
+	/* pg_init in progress, requeue until done */
+	if (m->pg_init_in_progress) {
+		busy = 1;
+		goto out;
+	}
 	/* Guess which priority_group will be used at next mapping time */
 	if (unlikely(!m->current_pgpath && m->next_pg))
 		pg = m->next_pg;
-- 
1.7.12.4
