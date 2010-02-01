From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 4/4] dm-mpath: move initial pg-init kick into
	__switch_pg()
Date: Mon, 01 Feb 2010 13:24:08 +0900
Message-ID: <4B665768.40307@ct.jp.nec.com>
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

This patch moves initial pg-init kick into __switch_pg().
This has 2 meanings below:
  - Fix the issue that ioctl isn't processed until any I/O is issued.
    multipath_ioctl() doesn't kick pg-init even if it selects a path
    in a new pg, so it returns with -EAGAIN.  That state never be
    changed and ioctl is always returns with -EAGAIN until any I/O is
    issued and pg-init is kicked.
    By this patch, multipath_ioctl() kicks pg-init when it selects
    a path in a new pg, so following ioctl will be processed in
    the near future without any I/O.

  - By this patch, process_queued_ios() has no pg-init handling and
    it works just for queued I/Os in the multipath internal queue.
    So this patch makes removing multipath internal queue easy.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-mpath.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

Index: 2.6.33-rc6/drivers/md/dm-mpath.c
===================================================================
--- 2.6.33-rc6.orig/drivers/md/dm-mpath.c
+++ 2.6.33-rc6/drivers/md/dm-mpath.c
@@ -256,14 +256,22 @@ static void __switch_pg(struct multipath
 
 	/* Must we initialise the PG first, and queue I/O till it's ready? */
 	if (m->hw_handler_name) {
-		m->pg_init_required = 1;
 		m->queue_io = 1;
+
+		/* Reset pg_init_count in 0 anyway to start a new pg-init */
+		m->pg_init_count = 0;
+		if (!m->pg_init_in_progress)
+			__pg_init(m);
+		else
+			/*
+			 * Mark to start a pg-init again when the current one
+			 * completes.
+			 */
+			m->pg_init_required = 1;
 	} else {
 		m->pg_init_required = 0;
 		m->queue_io = 0;
 	}
-
-	m->pg_init_count = 0;
 }
 
 static int __choose_path_in_pg(struct multipath *m, struct priority_group *pg,
@@ -365,9 +373,7 @@ static int map_io(struct multipath *m, s
 		/* Queue for the daemon to resubmit */
 		list_add_tail(&clone->queuelist, &m->queued_ios);
 		m->queue_size++;
-		if (m->pg_init_required && !m->pg_init_in_progress && pgpath)
-			__pg_init(m);
-		else if (!m->queue_io)
+		if (!m->queue_io)
 			queue_work(kmultipathd, &m->process_queued_ios);
 		pgpath = NULL;
 		r = DM_MAPIO_SUBMITTED;
@@ -473,9 +479,6 @@ static void process_queued_ios(struct wo
 	    (!pgpath && !m->queue_if_no_path))
 		must_queue = 0;
 
-	if (m->pg_init_required && !m->pg_init_in_progress && pgpath)
-		__pg_init(m);
-
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
 	if (!must_queue)
