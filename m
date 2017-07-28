From: josef@toxicpanda.com
Subject: [PATCH 1/2] dm-log-writes: don't use all the cpu
Date: Fri, 28 Jul 2017 10:42:24 -0400
Message-ID: <1501252945-20615-1-git-send-email-jbacik@fb.com>
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
To: kernel-team@fb.com, dm-devel@redhat.com
Cc: Josef Bacik <jbacik@fb.com>
List-Id: dm-devel.ids

From: Josef Bacik <jbacik@fb.com>

The check to see if the logging kthread needs to go to sleep is wrong,
it checks lc->pending_blocks, which will be non-0 if there are any
blocks that are pending, whether they are ready to be logged or not.
What we really want is to go to sleep until it's time to log blocks, so
change this check so we do actually go to sleep in between flushes.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 drivers/md/dm-log-writes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index a1da0eb..9aab510 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -399,7 +399,7 @@ static int log_writes_kthread(void *arg)
 		if (!try_to_freeze()) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (!kthread_should_stop() &&
-			    !atomic_read(&lc->pending_blocks))
+			    list_empty(&lc->logging_blocks))
 				schedule();
 			__set_current_state(TASK_RUNNING);
 		}
-- 
2.7.4
