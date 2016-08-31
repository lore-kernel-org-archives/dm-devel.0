From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 4/9] dm: Convert wait loops
Date: Wed, 31 Aug 2016 15:16:43 -0700
Message-ID: <e4673fd2-3155-7147-33b7-759657b965fc@sandisk.com>
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

Use autoremove_wake_function() instead of default_wake_function()
to make the dm wait loops more similar to other wait loops in the
kernel. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-mpath.c | 10 +++-------
 drivers/md/dm.c       | 10 +++-------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index ac734e5..8df7b12 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1193,21 +1193,17 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 static void multipath_wait_for_pg_init_completion(struct multipath *m)
 {
-	DECLARE_WAITQUEUE(wait, current);
-
-	add_wait_queue(&m->pg_init_wait, &wait);
+	DEFINE_WAIT(wait);
 
 	while (1) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
+		prepare_to_wait(&m->pg_init_wait, &wait, TASK_UNINTERRUPTIBLE);
 
 		if (!atomic_read(&m->pg_init_in_progress))
 			break;
 
 		io_schedule();
 	}
-	set_current_state(TASK_RUNNING);
-
-	remove_wait_queue(&m->pg_init_wait, &wait);
+	finish_wait(&m->pg_init_wait, &wait);
 }
 
 static void flush_multipath_work(struct multipath *m)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7cce09e..090ef31 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1938,12 +1938,10 @@ EXPORT_SYMBOL_GPL(dm_put);
 static int dm_wait_for_completion(struct mapped_device *md, int sleep_state)
 {
 	int r = 0;
-	DECLARE_WAITQUEUE(wait, current);
-
-	add_wait_queue(&md->wait, &wait);
+	DEFINE_WAIT(wait);
 
 	while (1) {
-		set_current_state(sleep_state);
+		prepare_to_wait(&md->wait, &wait, sleep_state);
 
 		if (!md_in_flight(md))
 			break;
@@ -1955,9 +1953,7 @@ static int dm_wait_for_completion(struct mapped_device *md, int sleep_state)
 
 		io_schedule();
 	}
-	set_current_state(TASK_RUNNING);
-
-	remove_wait_queue(&md->wait, &wait);
+	finish_wait(&md->wait, &wait);
 
 	return r;
 }
-- 
2.9.3
