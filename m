From: Mike Galbraith <efault@gmx.de>
Subject: Re: IO scheduler based IO controller V10
Date: Sat, 03 Oct 2009 07:56:18 +0200
Message-ID: <1254549378.8299.21.camel@marge.simson.net>
References: <20091002092839.GA26962@kernel.dk>
	 <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain>
	 <20091002145610.GD31616@kernel.dk>
	 <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
	 <20091002171129.GG31616@kernel.dk> <20091002172046.GA2376@elte.hu>
	 <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu>
	 <20091002173732.GK31616@kernel.dk>
	 <1254507215.8667.7.camel@marge.simson.net>
	 <20091002181903.GN31616@kernel.dk>
	 <1254548931.8299.18.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753713AbZJCF4X@vger.kernel.org>
In-Reply-To: <1254548931.8299.18.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, riel@redhat.com
List-Id: dm-devel.ids

On Sat, 2009-10-03 at 07:49 +0200, Mike Galbraith wrote:
> On Fri, 2009-10-02 at 20:19 +0200, Jens Axboe wrote:
> 
> > If you could do a cleaned up version of your overload patch based on
> > this:
> > 
> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=1d2235152dc745c6d94bedb550fea84cffdbf768
> > 
> > then lets take it from there.

Note to self: build the darn thing after last minute changes.

Block:  Delay overloading of CFQ queues to improve read latency.

Introduce a delay maximum dispatch timestamp, and stamp it when:
        1. we encounter a known seeky or possibly new sync IO queue.
        2. the current queue may go idle and we're draining async IO.
        3. we have sync IO in flight and are servicing an async queue.
        4  we are not the sole user of disk.
Disallow exceeding quantum if any of these events have occurred recently.

Protect this behavioral change with a "desktop_dispatch" knob and default
it to "on".. providing an easy means of regression verification prior to
hate-mail dispatch :) to CC list.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
... others who let somewhat hacky tweak slip by

---
 block/cfq-iosched.c |   45 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c
+++ linux-2.6/block/cfq-iosched.c
@@ -174,6 +174,9 @@ struct cfq_data {
 	unsigned int cfq_slice_async_rq;
 	unsigned int cfq_slice_idle;
 	unsigned int cfq_desktop;
+	unsigned int cfq_desktop_dispatch;
+
+	unsigned long desktop_dispatch_ts;
 
 	struct list_head cic_list;
 
@@ -1283,6 +1286,7 @@ static int cfq_dispatch_requests(struct
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_queue *cfqq;
 	unsigned int max_dispatch;
+	unsigned long delay;
 
 	if (!cfqd->busy_queues)
 		return 0;
@@ -1297,19 +1301,26 @@ static int cfq_dispatch_requests(struct
 	/*
 	 * Drain async requests before we start sync IO
 	 */
-	if (cfq_cfqq_idle_window(cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
+	if (cfq_cfqq_idle_window(cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC]) {
+		cfqd->desktop_dispatch_ts = jiffies;
 		return 0;
+	}
 
 	/*
 	 * If this is an async queue and we have sync IO in flight, let it wait
 	 */
-	if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
+	if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq)) {
+		cfqd->desktop_dispatch_ts = jiffies;
 		return 0;
+	}
 
 	max_dispatch = cfqd->cfq_quantum;
 	if (cfq_class_idle(cfqq))
 		max_dispatch = 1;
 
+	if (cfqd->busy_queues > 1)
+		cfqd->desktop_dispatch_ts = jiffies;
+
 	/*
 	 * Does this cfqq already have too much IO in flight?
 	 */
@@ -1327,6 +1338,16 @@ static int cfq_dispatch_requests(struct
 			return 0;
 
 		/*
+		 * Don't start overloading until we've been alone for a bit.
+		 */
+		if (cfqd->cfq_desktop_dispatch) {
+			delay = cfqd->desktop_dispatch_ts + cfq_slice_sync;
+
+			if (time_before(jiffies, max_delay))
+				return 0;
+		}
+
+		/*
 		 * we are the only queue, allow up to 4 times of 'quantum'
 		 */
 		if (cfqq->dispatched >= 4 * max_dispatch)
@@ -1942,7 +1963,7 @@ static void
 cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		       struct cfq_io_context *cic)
 {
-	int old_idle, enable_idle;
+	int old_idle, enable_idle, seeky = 0;
 
 	/*
 	 * Don't idle for async or idle io prio class
@@ -1950,10 +1971,20 @@ cfq_update_idle_window(struct cfq_data *
 	if (!cfq_cfqq_sync(cfqq) || cfq_class_idle(cfqq))
 		return;
 
+	if (cfqd->hw_tag) {
+		if (CIC_SEEKY(cic))
+			seeky = 1;
+		/*
+		 * If seeky or incalculable seekiness, delay overloading.
+		 */
+		if (seeky || !sample_valid(cic->seek_samples))
+			cfqd->desktop_dispatch_ts = jiffies;
+	}
+
 	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
 
 	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-	    (!cfqd->cfq_desktop && cfqd->hw_tag && CIC_SEEKY(cic)))
+	    (!cfqd->cfq_desktop && seeky))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime_samples)) {
 		if (cic->ttime_mean > cfqd->cfq_slice_idle)
@@ -2483,6 +2514,9 @@ static void *cfq_init_queue(struct reque
 	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
 	cfqd->cfq_slice_idle = cfq_slice_idle;
 	cfqd->cfq_desktop = 1;
+	cfqd->cfq_desktop_dispatch = 1;
+
+	cfqd->desktop_dispatch_ts = INITIAL_JIFFIES;
 	cfqd->hw_tag = 1;
 
 	return cfqd;
@@ -2553,6 +2587,7 @@ SHOW_FUNCTION(cfq_slice_sync_show, cfqd-
 SHOW_FUNCTION(cfq_slice_async_show, cfqd->cfq_slice[0], 1);
 SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
 SHOW_FUNCTION(cfq_desktop_show, cfqd->cfq_desktop, 0);
+SHOW_FUNCTION(cfq_desktop_dispatch_show, cfqd->cfq_desktop_dispatch, 0);
 #undef SHOW_FUNCTION
 
 #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
@@ -2585,6 +2620,7 @@ STORE_FUNCTION(cfq_slice_async_store, &c
 STORE_FUNCTION(cfq_slice_async_rq_store, &cfqd->cfq_slice_async_rq, 1,
 		UINT_MAX, 0);
 STORE_FUNCTION(cfq_desktop_store, &cfqd->cfq_desktop, 0, 1, 0);
+STORE_FUNCTION(cfq_desktop_dispatch_store, &cfqd->cfq_desktop_dispatch, 0, 1, 0);
 #undef STORE_FUNCTION
 
 #define CFQ_ATTR(name) \
@@ -2601,6 +2637,7 @@ static struct elv_fs_entry cfq_attrs[] =
 	CFQ_ATTR(slice_async_rq),
 	CFQ_ATTR(slice_idle),
 	CFQ_ATTR(desktop),
+	CFQ_ATTR(desktop_dispatch),
 	__ATTR_NULL
 };
 
