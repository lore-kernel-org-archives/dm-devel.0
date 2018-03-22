From: wuzhouhui <wuzhouhui14@mails.ucas.ac.cn>
Subject: [PATCH] dm/mpath: flush workqueue only in necessary
Date: Thu, 22 Mar 2018 22:22:38 +0800
Message-ID: <1521728558-10695-1-git-send-email-wuzhouhui14@mails.ucas.ac.cn>
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
To: dm-devel@redhat.com
Cc: wuzhouhui14@mails.ucas.ac.cn, ge.changwei@h3c.com
List-Id: dm-devel.ids

The workqueue are shared by many multipath devices, we just need to flush
whole workqueue when it is necessary. Otherwise, we just flush works.

Signed-off-by: wuzhouhui <wuzhouhui14@mails.ucas.ac.cn>
---
 drivers/md/dm-mpath.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f7810cc..0f14732 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1154,9 +1154,10 @@ static void flush_multipath_work(struct multipath *m)
 	set_bit(MPATHF_PG_INIT_DISABLED, &m->flags);
 	smp_mb__after_atomic();
 
-	flush_workqueue(kmpath_handlerd);
+	if (atomic_read(&m->pg_init_in_progress))
+		flush_workqueue(kmpath_handlerd);
 	multipath_wait_for_pg_init_completion(m);
-	flush_workqueue(kmultipathd);
+	flush_work(&m->process_queued_bios);
 	flush_work(&m->trigger_event);
 
 	clear_bit(MPATHF_PG_INIT_DISABLED, &m->flags);
-- 
1.9.1
