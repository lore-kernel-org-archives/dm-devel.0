From: Jing Xia <jing.xia.mail@gmail.com>
Subject: [PATCH] dm bufio: Reduce dm_bufio_lock contention
Date: Tue, 12 Jun 2018 16:03:28 +0800
Message-ID: <1528790608-19557-1-git-send-email-jing.xia@unisoc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Performance test in android reports that the phone sometimes gets
hanged and shows black screen for about several minutes.The sysdump shows:
1. kswapd and other tasks who enter the direct-reclaim path are waiting
on the dm_bufio_lock;
2. the task who gets the dm_bufio_lock is stalled for IO completions,
the relevant stack trace as :

PID: 22920  TASK: ffffffc0120f1a00  CPU: 1   COMMAND: "kworker/u8:2"
 #0 [ffffffc0282af3d0] __switch_to at ffffff8008085e48
 #1 [ffffffc0282af3f0] __schedule at ffffff8008850cc8
 #2 [ffffffc0282af450] schedule at ffffff8008850f4c
 #3 [ffffffc0282af470] schedule_timeout at ffffff8008853a0c
 #4 [ffffffc0282af520] schedule_timeout_uninterruptible at ffffff8008853aa8
 #5 [ffffffc0282af530] wait_iff_congested at ffffff8008181b40
 #6 [ffffffc0282af5b0] shrink_inactive_list at ffffff8008177c80
 #7 [ffffffc0282af680] shrink_lruvec at ffffff8008178510
 #8 [ffffffc0282af790] mem_cgroup_shrink_node_zone at ffffff80081793bc
 #9 [ffffffc0282af840] mem_cgroup_soft_limit_reclaim at ffffff80081b6040

This patch aims to reduce the dm_bufio_lock contention when multiple
tasks do shrink_slab() at the same time.It is acceptable that task
will be allowed to reclaim from other shrinkers or reclaim from dm-bufio
next time, rather than stalled for the dm_bufio_lock.

Signed-off-by: Jing Xia <jing.xia@unisoc.com>
Signed-off-by: Jing Xia <jing.xia.mail@gmail.com>
---
 drivers/md/dm-bufio.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index c546b56..402a028 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1647,10 +1647,19 @@ static unsigned long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
 static unsigned long
 dm_bufio_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
+	unsigned long count;
+	unsigned long retain_target;
+
 	struct dm_bufio_client *c = container_of(shrink, struct dm_bufio_client, shrinker);
-	unsigned long count = READ_ONCE(c->n_buffers[LIST_CLEAN]) +
+
+	if (!dm_bufio_trylock(c))
+		return 0;
+
+	count = READ_ONCE(c->n_buffers[LIST_CLEAN]) +
 			      READ_ONCE(c->n_buffers[LIST_DIRTY]);
-	unsigned long retain_target = get_retain_buffers(c);
+	retain_target = get_retain_buffers(c);
+
+	dm_bufio_unlock(c);
 
 	return (count < retain_target) ? 0 : (count - retain_target);
 }
-- 
1.9.1
