From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 3/9] dm: Introduce signal_pending_state()
Date: Wed, 31 Aug 2016 15:16:22 -0700
Message-ID: <9a148110-236f-2162-4229-fc2bc54995a6@sandisk.com>
References: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
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

Use signal_pending_state() instead of open-coding it. This patch does
not change any functionality but makes it possible to pass TASK_KILLABLE
as the second argument of dm_wait_for_completion(). See also commit
16882c1e962b ("sched: fix TASK_WAKEKILL vs SIGKILL race").

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>.
---
 drivers/md/dm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1d3627c..7cce09e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1948,8 +1948,7 @@ static int dm_wait_for_completion(struct mapped_device *md, int sleep_state)
 		if (!md_in_flight(md))
 			break;
 
-		if (sleep_state == TASK_INTERRUPTIBLE &&
-		    signal_pending(current)) {
+		if (signal_pending_state(sleep_state, current)) {
 			r = -EINTR;
 			break;
 		}
-- 
2.9.3
