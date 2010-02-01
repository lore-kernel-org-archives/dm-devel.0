From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 1/4] dm-mpath: don't clear m->queue_io until all
 activations complete
Date: Mon, 01 Feb 2010 13:19:11 +0900
Message-ID: <4B66563F.1060609@ct.jp.nec.com>
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

m->queue_io is set to block processing I/Os, and it needs to be kept
while pg-init, which issues multiple path activations, is in progress.
But m->queue is cleared when a path activation completes without error
in pg_init_done(), even while other path activations are in progress.
That may cause undesired -EIO on paths which are not complete activation.

This patch fixes that by not clearing m->queue_io until all path
activations complete.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-mpath.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

Index: 2.6.33-rc6/drivers/md/dm-mpath.c
===================================================================
--- 2.6.33-rc6.orig/drivers/md/dm-mpath.c
+++ 2.6.33-rc6/drivers/md/dm-mpath.c
@@ -1181,14 +1181,19 @@ static void pg_init_done(void *data, int
 			m->current_pgpath = NULL;
 			m->current_pg = NULL;
 		}
-	} else if (!m->pg_init_required) {
-		m->queue_io = 0;
+	} else if (!m->pg_init_required)
 		pg->bypassed = 0;
-	}
 
-	m->pg_init_in_progress--;
-	if (!m->pg_init_in_progress)
-		queue_work(kmultipathd, &m->process_queued_ios);
+	if (--m->pg_init_in_progress)
+		/* Activations of other paths are still on going */
+		goto out;
+
+	if (!m->pg_init_required)
+		m->queue_io = 0;
+
+	queue_work(kmultipathd, &m->process_queued_ios);
+
+out:
 	spin_unlock_irqrestore(&m->lock, flags);
 }
 
