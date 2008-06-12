From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] dm-mpath: move the place of decrementing
	repeat_count
Date: Thu, 12 Jun 2008 11:04:29 -0400 (EDT)
Message-ID: <20080612.110429.41628864.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Alasdair,

'repeat_count' counting code is a little bit difficult to understand
why decrementing it before using m->current_pgpath.
'repeat_count' should be decremented only when an I/O is mapped to
m->current_pgpath.
This patch changes the place of decrementing 'repeat_count'
for easy understanding.

Basically, no functional change, but there is a minor behavior change
when '0' is specified for 'repeat_count':
    before: No path switching happens
    after : Path switching happens everytime
I think that no one should specify '0'.

This patch can be applied on top of 2.6.26-rc5.
Please review and apply.

Thanks,
Kiyoshi Ueda


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-mpath.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

Index: 2.6.26-rc5/drivers/md/dm-mpath.c
===================================================================
--- 2.6.26-rc5.orig/drivers/md/dm-mpath.c
+++ 2.6.26-rc5/drivers/md/dm-mpath.c
@@ -314,8 +314,7 @@ static int map_io(struct multipath *m, s
 	spin_lock_irqsave(&m->lock, flags);
 
 	/* Do we need to select a new pgpath? */
-	if (!m->current_pgpath ||
-	    (!m->queue_io && (m->repeat_count && --m->repeat_count == 0)))
+	if (!m->current_pgpath || (!m->queue_io && m->repeat_count == 0))
 		__choose_pgpath(m);
 
 	pgpath = m->current_pgpath;
@@ -333,9 +332,11 @@ static int map_io(struct multipath *m, s
 			queue_work(kmultipathd, &m->process_queued_ios);
 		pgpath = NULL;
 		r = DM_MAPIO_SUBMITTED;
-	} else if (pgpath)
+	} else if (pgpath) {
 		bio->bi_bdev = pgpath->path.dev->bdev;
-	else if (__must_push_back(m))
+		if (m->repeat_count)
+			--m->repeat_count;
+	} else if (__must_push_back(m))
 		r = DM_MAPIO_REQUEUE;
 	else
 		r = -EIO;	/* Failed */
