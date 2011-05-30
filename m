From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-kcopyd: use throttle
Date: Mon, 30 May 2011 12:41:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1105301241170.26092@hs20-bc2-1.build.redhat.com>
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

dm-kcopyd: use throttle

The variable "dm_kcopyd_throttle" is used to throttle kcopyd.

If dm_kcopyd_throttle >= 100, accounting is disabled, otherwise limit kcopyd
to use less than dm_kcopyd_throttle percent of time.

We sleep for 100ms if we overrun the allocated percentage of time.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-05-30 18:09:45.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-05-30 18:13:34.000000000 +0200
@@ -22,6 +22,7 @@
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <linux/delay.h>
 #include <linux/device-mapper.h>
 #include <linux/dm-kcopyd.h>
 
@@ -88,12 +89,35 @@ static unsigned last_jiffies = 0;
  */
 #define ACOUNT_INTERVAL_SHIFT		SHIFT_HZ
 
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
 static void io_job_start(void)
 {
 	unsigned now, difference;
+	int slept = 0;
+	int skew;
 
+try_again:
 	spin_lock_irq(&activity_spinlock);
 
+	if (likely(dm_kcopyd_throttle >= 100))
+		goto skip_limit;
+
 	now = jiffies;
 	difference = now - last_jiffies;
 	last_jiffies = now;
@@ -107,6 +131,16 @@ static void io_job_start(void)
 		io_period >>= shift;
 	}
 
+	skew = io_period - dm_kcopyd_throttle * total_period / 100;
+	/* skew = io_period * 100 / dm_kcopyd_throttle - total_period; */
+	if (unlikely(skew > 0) && slept < MAX_SLEEPS) {
+		slept++;
+		spin_unlock_irq(&activity_spinlock);
+		msleep(SLEEP_MSEC);
+		goto try_again;
+	}
+
+skip_limit:
 	num_io_jobs++;
 
 	spin_unlock_irq(&activity_spinlock);
@@ -120,6 +154,9 @@ static void io_job_finish(void)
 
 	num_io_jobs--;
 
+	if (likely(dm_kcopyd_throttle >= 100))
+		goto skip_limit;
+
 	if (!num_io_jobs) {
 		unsigned now, difference;
 
@@ -131,6 +168,7 @@ static void io_job_finish(void)
 		total_period += difference;
 	}
 
+skip_limit:
 	spin_unlock_irqrestore(&activity_spinlock, flags);
 }
 
