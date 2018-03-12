From: wuzhouhui <wuzhouhui14@mails.ucas.ac.cn>
Subject: [RFC PATCH] multipath: flush workqueue only in necessary
Date: Mon, 12 Mar 2018 15:41:41 +0800 (GMT+08:00)
Message-ID: <6e0de469.6172.1621928673a.Coremail.wuzhouhui14@mails.ucas.ac.cn>
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
List-Id: dm-devel.ids

When flush works belong a specific multipath, we flush workqueue only
in necessary.

(That's my first time to send a patch, please remind me if anything
wrong)

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
