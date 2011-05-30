From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-kcopyd: monitor io activity
Date: Mon, 30 May 2011 12:40:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1105301238460.26092@hs20-bc2-1.build.redhat.com>
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
To: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi

Here I'm sending three patches that limit kcopyd speed. There is global 
limit for all kcopyds running in a system. The user can set percentage of 
kcopyd speed in /sys/module/dm_mod/parameters/dm_kcopyd_throttle

Mikulas

---

dm-kcopyd: monitor io activity

There are two activity counters, "total_period" and "io_period".
total_period counts all time ticks, io_period counts timer ticks when
some I/O is active.

Thus, (100 * io_period / total_period) represents the percentage of
time when kcopyd is active.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-05-30 18:04:08.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-05-30 18:07:36.000000000 +0200
@@ -66,6 +66,69 @@ struct dm_kcopyd_client {
 	struct list_head pages_jobs;
 };
 
+static DEFINE_SPINLOCK(activity_spinlock);
+static unsigned long num_io_jobs = 0;
+
+/*
+ * kcopyd is active (100 * io_period / total_period) percent of time.
+ */
+static unsigned io_period = 0;
+static unsigned total_period = 0;
+static unsigned last_jiffies = 0;
+
+/*
+ * IO/IDLE accounting slowly decays after (1 << ACOUNT_INTERVAL_SHIFT) period.
+ * When total_period >= (1 << ACOUNT_INTERVAL_SHIFT) the counters are divided
+ * by 2.
+ */
+#define ACOUNT_INTERVAL_SHIFT		SHIFT_HZ
+
+static void io_job_start(void)
+{
+	unsigned now, difference;
+
+	spin_lock_irq(&activity_spinlock);
+
+	now = jiffies;
+	difference = now - last_jiffies;
+	last_jiffies = now;
+	if (num_io_jobs)
+		io_period += difference;
+	total_period += difference;
+
+	if (unlikely(total_period >= (1 << ACOUNT_INTERVAL_SHIFT))) {
+		int shift = fls(total_period >> ACOUNT_INTERVAL_SHIFT);
+		total_period >>= shift;
+		io_period >>= shift;
+	}
+
+	num_io_jobs++;
+
+	spin_unlock_irq(&activity_spinlock);
+}
+
+static void io_job_finish(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&activity_spinlock, flags);
+
+	num_io_jobs--;
+
+	if (!num_io_jobs) {
+		unsigned now, difference;
+
+		now = jiffies;
+		difference = now - last_jiffies;
+		last_jiffies = now;
+
+		io_period += difference;
+		total_period += difference;
+	}
+
+	spin_unlock_irqrestore(&activity_spinlock, flags);
+}
+
 static void wake(struct dm_kcopyd_client *kc)
 {
 	queue_work(kc->kcopyd_wq, &kc->kcopyd_work);
@@ -324,6 +387,8 @@ static void complete_io(unsigned long er
 	struct kcopyd_job *job = (struct kcopyd_job *) context;
 	struct dm_kcopyd_client *kc = job->kc;
 
+	io_job_finish();
+
 	if (error) {
 		if (job->rw == WRITE)
 			job->write_err |= error;
@@ -365,6 +430,8 @@ static int run_io_job(struct kcopyd_job 
 		.client = job->kc->io_client,
 	};
 
+	io_job_start();
+
 	if (job->rw == READ)
 		r = dm_io(&io_req, 1, &job->source, NULL);
 	else
