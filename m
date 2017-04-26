From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 12/13] dm-mpath: Introduce assign_bit()
Date: Wed, 26 Apr 2017 11:37:27 -0700
Message-ID: <20170426183728.10821-13-bart.vanassche@sandisk.com>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170426183728.10821-1-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

This patch does not change any functionality but makes the code
easier to read.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/md/dm-mpath.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 0eafe7a2070b..57b467207741 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -613,6 +613,14 @@ static void process_queued_bios(struct work_struct *work)
 	blk_finish_plug(&plug);
 }
 
+static void assign_bit(bool value, long nr, unsigned long *addr)
+{
+	if (value)
+		set_bit(nr, addr);
+	else
+		clear_bit(nr, addr);
+}
+
 /*
  * If we run out of usable paths, should we queue I/O or error it?
  */
@@ -622,23 +630,12 @@ static int queue_if_no_path(struct multipath *m, bool queue_if_no_path,
 	unsigned long flags;
 
 	spin_lock_irqsave(&m->lock, flags);
-
-	if (save_old_value) {
-		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
-			set_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
-		else
-			clear_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
-	} else {
-		if (queue_if_no_path)
-			set_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
-		else
-			clear_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
-	}
-	if (queue_if_no_path || dm_noflush_suspending(m->ti))
-		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
-	else
-		clear_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
-
+	assign_bit((save_old_value &&
+		    test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) ||
+		   (!save_old_value && queue_if_no_path),
+		   MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
+	assign_bit(queue_if_no_path || dm_noflush_suspending(m->ti),
+		   MPATHF_QUEUE_IF_NO_PATH, &m->flags);
 	spin_unlock_irqrestore(&m->lock, flags);
 
 	if (!queue_if_no_path) {
@@ -1593,10 +1590,8 @@ static void multipath_resume(struct dm_target *ti)
 	unsigned long flags;
 
 	spin_lock_irqsave(&m->lock, flags);
-	if (test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags))
-		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
-	else
-		clear_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
+	assign_bit(test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags),
+		   MPATHF_QUEUE_IF_NO_PATH, &m->flags);
 	spin_unlock_irqrestore(&m->lock, flags);
 }
 
-- 
2.12.2
