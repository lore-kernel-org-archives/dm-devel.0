From: Mike Galbraith <efault@gmx.de>
Subject: Re: IO scheduler based IO controller V10
Date: Wed, 30 Sep 2009 21:58:50 +0200
Message-ID: <1254340730.7695.32.camel@marge.simson.net>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	 <4ABC28DE.7050809@datenparkplatz.de> <20090925202636.GC15007@redhat.com>
	 <1253976676.7005.40.camel@marge.simson.net>
	 <1254034500.7933.6.camel@marge.simson.net>
	 <20090927164235.GA23126@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754427AbZI3T65@vger.kernel.org>
In-Reply-To: <20090927164235.GA23126@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
List-Id: dm-devel.ids

On Sun, 2009-09-27 at 18:42 +0200, Jens Axboe wrote:

> It's a given that not merging will provide better latency. We can't
> disable that or performance will suffer A LOT on some systems. There are
> ways to make it better, though. One would be to make the max request
> size smaller, but that would also hurt for streamed workloads. Can you
> try whether the below patch makes a difference? It will basically
> disallow merges to a request that isn't the last one.

Thoughts about something like the below?

The problem with the dd vs konsole -e exit type load seems to be
kjournald overloading the disk between reads.  When userland is blocked,
kjournald is free to stuff 4*quantum into the queue instantly.

Taking the hint from Vivek's fairness tweakable patch, I stamped the
queue when a seeker was last seen, and disallowed overload within
CIC_SEEK_THR of that time.  Worked well.

dd competing against perf stat -- konsole -e exec timings, 5 back to back runs
                                                           Avg
before         9.15    14.51     9.39    15.06     9.90   11.6
after          1.76     1.54     1.93     1.88     1.56    1.7

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e2a9b92..4a00129 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -174,6 +174,8 @@ struct cfq_data {
 	unsigned int cfq_slice_async_rq;
 	unsigned int cfq_slice_idle;
 
+	unsigned long last_seeker;
+
 	struct list_head cic_list;
 
 	/*
@@ -1326,6 +1328,12 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
 			return 0;
 
 		/*
+		 * We may have seeky queues, don't throttle up just yet.
+		 */
+		if (time_before(jiffies, cfqd->last_seeker + CIC_SEEK_THR))
+			return 0;
+
+		/*
 		 * we are the only queue, allow up to 4 times of 'quantum'
 		 */
 		if (cfqq->dispatched >= 4 * max_dispatch)
@@ -1941,7 +1949,7 @@ static void
 cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		       struct cfq_io_context *cic)
 {
-	int old_idle, enable_idle;
+	int old_idle, enable_idle, seeky = 0;
 
 	/*
 	 * Don't idle for async or idle io prio class
@@ -1951,8 +1959,12 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
 
-	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-	    (cfqd->hw_tag && CIC_SEEKY(cic)))
+	if (cfqd->hw_tag && CIC_SEEKY(cic)) {
+		cfqd->last_seeker = jiffies;
+		seeky = 1;
+	}
+
+	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle || seeky)
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime_samples)) {
 		if (cic->ttime_mean > cfqd->cfq_slice_idle)
@@ -2482,6 +2494,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
 	cfqd->cfq_slice_idle = cfq_slice_idle;
 	cfqd->hw_tag = 1;
+	cfqd->last_seeker = jiffies;
 
 	return cfqd;
 }
