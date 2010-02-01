From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 3/4] dm-mpath: separate pg-init handling from
	process_queued_ios()
Date: Mon, 01 Feb 2010 13:22:23 +0900
Message-ID: <4B6656FF.5000701@ct.jp.nec.com>
References: <4B665507.8080205@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B665507.8080205@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This patch is a preparation of the next patch, which fixes the issue
that ioctl isn't processed until any I/O is issued.  (And also it is
a preparation of another patch-set to remove multipath internal queue.)
No functional change.

This patch changes pg-init kickers to use activate_path() directly
instead of using process_queued_ios().

process_queued_ios() has been used for pg-init handling, which needs
a kthread context.
However, recent development introduced a special work, activate_path(),
for that purpose.  So there is no need to use process_queued_ios().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-mpath.c |   55 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 16 deletions(-)

Index: 2.6.33-rc6/drivers/md/dm-mpath.c
===================================================================
--- 2.6.33-rc6.orig/drivers/md/dm-mpath.c
+++ 2.6.33-rc6/drivers/md/dm-mpath.c
@@ -235,6 +235,21 @@ static void free_multipath(struct multip
  * Path selection
  *-----------------------------------------------*/
 
+static void __pg_init(struct multipath *m)
+{
+	struct pgpath *pgpath;
+
+	m->pg_init_count++;
+	m->pg_init_required = 0;
+	list_for_each_entry(pgpath, &m->current_pg->pgpaths, list) {
+		/* Skip failed paths */
+		if (!pgpath->is_active)
+			continue;
+		if (queue_work(kmpath_handlerd, &pgpath->activate_path))
+			m->pg_init_in_progress++;
+	}
+}
+
 static void __switch_pg(struct multipath *m, struct pgpath *pgpath)
 {
 	m->current_pg = pgpath->pg;
@@ -350,8 +365,9 @@ static int map_io(struct multipath *m, s
 		/* Queue for the daemon to resubmit */
 		list_add_tail(&clone->queuelist, &m->queued_ios);
 		m->queue_size++;
-		if ((m->pg_init_required && !m->pg_init_in_progress) ||
-		    !m->queue_io)
+		if (m->pg_init_required && !m->pg_init_in_progress && pgpath)
+			__pg_init(m);
+		else if (!m->queue_io)
 			queue_work(kmultipathd, &m->process_queued_ios);
 		pgpath = NULL;
 		r = DM_MAPIO_SUBMITTED;
@@ -439,7 +455,7 @@ static void process_queued_ios(struct wo
 {
 	struct multipath *m =
 		container_of(work, struct multipath, process_queued_ios);
-	struct pgpath *pgpath = NULL, *tmp;
+	struct pgpath *pgpath = NULL;
 	unsigned must_queue = 1;
 	unsigned long flags;
 
@@ -457,17 +473,9 @@ static void process_queued_ios(struct wo
 	    (!pgpath && !m->queue_if_no_path))
 		must_queue = 0;
 
-	if (m->pg_init_required && !m->pg_init_in_progress && pgpath) {
-		m->pg_init_count++;
-		m->pg_init_required = 0;
-		list_for_each_entry(tmp, &pgpath->pg->pgpaths, list) {
-			/* Skip failed paths */
-			if (!tmp->is_active)
-				continue;
-			if (queue_work(kmpath_handlerd, &tmp->activate_path))
-				m->pg_init_in_progress++;
-		}
-	}
+	if (m->pg_init_required && !m->pg_init_in_progress && pgpath)
+		__pg_init(m);
+
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
 	if (!must_queue)
@@ -1215,9 +1223,24 @@ static void pg_init_done(void *data, int
 		/* Activations of other paths are still on going */
 		goto out;
 
-	if (!m->pg_init_required)
-		m->queue_io = 0;
+	if (m->pg_init_required) {
+		/* Requested retry or a new pg-init */
+		if (likely(m->current_pgpath)) {
+			__pg_init(m);
+			goto out;
+		}
+
+		/*
+		 * The condition requiring pg-init has been changed by someone
+		 * after the pg-init had been requested.
+		 * Cancel m->pg_init_required here explicitly, and start over
+		 * from path selection.
+		 */
+		m->pg_init_required = 0;
+		m->current_pg = NULL;
+	}
 
+	m->queue_io = 0;
 	queue_work(kmultipathd, &m->process_queued_ios);
 
 	/*
