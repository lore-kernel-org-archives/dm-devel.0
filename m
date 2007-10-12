From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 11/25] kcopyd use mutex instead of
	semaphore
Date: Fri, 12 Oct 2007 18:17:34 +0100
Message-ID: <20071012171734.GV24157@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Matthias Kaehlcke <matthias.kaehlcke@gmail.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Kcopyd uses a semaphore as mutex.  Use the mutex API instead of the (binary)
semaphore,

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/kcopyd.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.23/drivers/md/kcopyd.c
===================================================================
--- linux-2.6.23.orig/drivers/md/kcopyd.c	2007-10-12 12:36:14.000000000 +0100
+++ linux-2.6.23/drivers/md/kcopyd.c	2007-10-12 13:15:41.000000000 +0100
@@ -198,7 +198,7 @@ struct kcopyd_job {
 	 * These fields are only used if the job has been split
 	 * into more manageable parts.
 	 */
-	struct semaphore lock;
+	struct mutex lock;
 	atomic_t sub_jobs;
 	sector_t progress;
 };
@@ -456,7 +456,7 @@ static void segment_complete(int read_er
 	sector_t count = 0;
 	struct kcopyd_job *job = (struct kcopyd_job *) context;
 
-	down(&job->lock);
+	mutex_lock(&job->lock);
 
 	/* update the error */
 	if (read_err)
@@ -480,7 +480,7 @@ static void segment_complete(int read_er
 			job->progress += count;
 		}
 	}
-	up(&job->lock);
+	mutex_unlock(&job->lock);
 
 	if (count) {
 		int i;
@@ -562,7 +562,7 @@ int kcopyd_copy(struct kcopyd_client *kc
 		dispatch_job(job);
 
 	else {
-		init_MUTEX(&job->lock);
+		mutex_init(&job->lock);
 		job->progress = 0;
 		split_job(job);
 	}
