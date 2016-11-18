From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 13/14] dm-mpath: Introduce assign_bit()
Date: Fri, 18 Nov 2016 14:29:58 -0800
Message-ID: <66cb96e8-74a0-ecf4-4039-f2e8972c35d1@sandisk.com>
References: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch does not change any functionality but makes the code
easier to read.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-mpath.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index fff5d12..4a3afec 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -683,6 +683,14 @@ static void process_queued_bios(struct work_struct *work)
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
@@ -692,23 +700,12 @@ static int queue_if_no_path(struct multipath *m, bool queue_if_no_path,
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
@@ -1649,10 +1646,8 @@ static void multipath_resume(struct dm_target *ti)
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
2.10.1
