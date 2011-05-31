From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm-kcopyd: use throttle
Date: Tue, 31 May 2011 18:04:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1105311803430.9322@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

dm-kcopyd: use throttle

This patch allows the administrator to limit kcopyd rate.

We maintain a history of kcopyd usage in variables io_period and
total_period. The actual kcopyd activity is "(100 * io_period /
total_period)" percent of time. If we exceed user-defined percentage
threshold, we sleep.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |  108 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-05-31 22:46:40.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-05-31 23:40:05.000000000 +0200
@@ -22,6 +22,7 @@
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <linux/delay.h>
 #include <linux/device-mapper.h>
 #include <linux/dm-kcopyd.h>
 
@@ -51,6 +52,8 @@ struct dm_kcopyd_client {
 	struct workqueue_struct *kcopyd_wq;
 	struct work_struct kcopyd_work;
 
+	struct dm_kcopyd_throttle *throttle;
+
 /*
  * We maintain three lists of jobs:
  *
@@ -66,6 +69,106 @@ struct dm_kcopyd_client {
 	struct list_head pages_jobs;
 };
 
+static DEFINE_SPINLOCK(throttle_spinlock);
+
+/*
+ * IO/IDLE accounting slowly decays after (1 << ACOUNT_INTERVAL_SHIFT) period.
+ * When total_period >= (1 << ACOUNT_INTERVAL_SHIFT) the counters are divided
+ * by 2.
+ */
+#define ACOUNT_INTERVAL_SHIFT		SHIFT_HZ
+
+/*
+ * Sleep this number of milliseconds.
+ *
+ * It is experimentally found value.
+ * Smaller values cause increased copy rate above the limit. The reason for
+ * this is unknown. A possible explanations could be jiffies rounding errors
+ * or read/write cache inside the disk.
+ */
+#define SLEEP_MSEC			100
+
+/*
+ * Maximum number of sleep events. There is a theoretical livelock if more
+ * kcopyd clients do work simultaneously, this limit allows us to get out of
+ * the livelock.
+ */
+#define MAX_SLEEPS			10
+
+static void io_job_start(struct dm_kcopyd_throttle *t)
+{
+	unsigned now, difference;
+	int slept, skew;
+
+	if (unlikely(!t))
+		return;
+
+	slept = 0;
+
+try_again:
+	spin_lock_irq(&throttle_spinlock);
+
+	if (likely(t->throttle >= 100))
+		goto skip_limit;
+
+	now = jiffies;
+	difference = now - t->last_jiffies;
+	t->last_jiffies = now;
+	if (t->num_io_jobs)
+		t->io_period += difference;
+	t->total_period += difference;
+
+	if (unlikely(t->total_period >= (1 << ACOUNT_INTERVAL_SHIFT))) {
+		int shift = fls(t->total_period >> ACOUNT_INTERVAL_SHIFT);
+		t->total_period >>= shift;
+		t->io_period >>= shift;
+	}
+
+	skew = t->io_period - t->throttle * t->total_period / 100;
+	/* skew = t->io_period * 100 / t->throttle - t->total_period; */
+	if (unlikely(skew > 0) && slept < MAX_SLEEPS) {
+		slept++;
+		spin_unlock_irq(&throttle_spinlock);
+		msleep(SLEEP_MSEC);
+		goto try_again;
+	}
+
+skip_limit:
+	t->num_io_jobs++;
+
+	spin_unlock_irq(&throttle_spinlock);
+}
+
+static void io_job_finish(struct dm_kcopyd_throttle *t)
+{
+	unsigned long flags;
+
+	if (unlikely(!t))
+		return;
+
+	spin_lock_irqsave(&throttle_spinlock, flags);
+
+	t->num_io_jobs--;
+
+	if (likely(t->throttle >= 100))
+		goto skip_limit;
+
+	if (!t->num_io_jobs) {
+		unsigned now, difference;
+
+		now = jiffies;
+		difference = now - t->last_jiffies;
+		t->last_jiffies = now;
+
+		t->io_period += difference;
+		t->total_period += difference;
+	}
+
+skip_limit:
+	spin_unlock_irqrestore(&throttle_spinlock, flags);
+}
+
+
 static void wake(struct dm_kcopyd_client *kc)
 {
 	queue_work(kc->kcopyd_wq, &kc->kcopyd_work);
@@ -324,6 +427,8 @@ static void complete_io(unsigned long er
 	struct kcopyd_job *job = (struct kcopyd_job *) context;
 	struct dm_kcopyd_client *kc = job->kc;
 
+	io_job_finish(kc->throttle);
+
 	if (error) {
 		if (job->rw == WRITE)
 			job->write_err |= error;
@@ -365,6 +470,8 @@ static int run_io_job(struct kcopyd_job 
 		.client = job->kc->io_client,
 	};
 
+	io_job_start(job->kc->throttle);
+
 	if (job->rw == READ)
 		r = dm_io(&io_req, 1, &job->source, NULL);
 	else
@@ -630,6 +737,7 @@ struct dm_kcopyd_client *dm_kcopyd_clien
 	INIT_LIST_HEAD(&kc->complete_jobs);
 	INIT_LIST_HEAD(&kc->io_jobs);
 	INIT_LIST_HEAD(&kc->pages_jobs);
+	kc->throttle = throttle;
 
 	kc->job_pool = mempool_create_slab_pool(MIN_JOBS, _job_cache);
 	if (!kc->job_pool)
