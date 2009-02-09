From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: 2.6.28.2 & dm-snapshot or kcopyd Oops
Date: Mon, 9 Feb 2009 03:13:34 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902090311340.28754@hs20-bc2-1.build.redhat.com>
References: <200901231836184950432@163.com>,
	<Pine.LNX.4.64.0901231514590.9877@hs20-bc2-1.build.redhat.com>,
	<200901301800149019891@163.com>,
	<Pine.LNX.4.64.0901301533390.5744@hs20-bc2-1.build.redhat.com>,
	<200901311416111648168@163.com>,
	<Pine.LNX.4.64.0902031505180.28433@hs20-bc2-1.build.redhat.com>,
	<200902051113011850587@163.com>,
	<Pine.LNX.4.64.0902051749150.5515@hs20-bc2-1.build.redhat.com>,
	<Pine.LNX.4.64.0902052218040.5380@hs20-bc2-1.build.redhat.com>,
	<200902061924107769776@163.com>,
	<Pine.LNX.4.64.0902061815440.11986@hs20-bc2-1.build.redhat.com>
	<200902072041046488539@163.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200902072041046488539@163.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jacky Kim <jcy_2008@163.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Sat, 7 Feb 2009, Jacky Kim wrote:

> Hi
> 
> I create PV over a RAID set, and its stripe size is 64KB.
> The chunk size of the snapshot is 4KB, is it too small? then what size 
> is better?

It means that there is another bug besides the one I have just fixed :-(

So try another patch (on the top of them all) with even more debug points.

Mikulas

> I test with kernel 2.6.28.2, and get the follow message:
> 
> [  531.209879] ------------[ cut here ]------------
> [  531.209884] kernel BUG at drivers/md/dm-exception-store.c:715!
> [  531.209886] invalid opcode: 0000 [#1] SMP 
> [  531.209888] last sysfs file: /sys/devices/virtual/block/dm-11/dev
> [  531.209890] Modules linked in: iscsi_trgt arcmsr bonding e1000
> [  531.209893] 
> [  531.209896] Pid: 8241, comm: kcopyd Not tainted (2.6.28.2-dm #6) S5000PSL
> [  531.209898] EIP: 0060:[<c03c7dc2>] EFLAGS: 00010246 CPU: 1
> [  531.209903] EIP is at persistent_commit+0x222/0x280
> [  531.209905] EAX: f5385708 EBX: 00000006 ECX: fabab030 EDX: 00000000
> [  531.209906] ESI: 00000000 EDI: ef35f840 EBP: 00000075 ESP: f4fc3f14
> [  531.209908]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [  531.209910] Process kcopyd (pid: 8241, ti=f4fc2000 task=f4f16800 task.ti=f4fc2000)
> [  531.209911] Stack:
> [  531.209912]  c03c6710 000165da 00000000 f5015348 f482f2c0 00000000 c03c66b0 c03c66e3
> [  531.209916]  f5015348 f487f160 ef52e1c0 c03c13f8 f4f16800 f5015348 00000000 f487f160
> [  531.209919]  f487f164 ef52e1fc ef52e200 c03c119c c03c13a0 ef52e1c0 00000001 ef52e1ec
> [  531.209923] Call Trace:
> [  531.209925]  [<c03c6710>] commit_callback+0x0/0x30
> [  531.209928]  [<c03c66b0>] copy_callback+0x0/0x60
> [  531.209935]  [<c03c66e3>] copy_callback+0x33/0x60
> [  531.209938]  [<c03c13f8>] run_complete_job+0x58/0xa0
> [  531.209945]  [<c03c119c>] process_jobs+0x4c/0xe0
> [  531.209947]  [<c03c13a0>] run_complete_job+0x0/0xa0
> [  531.209950]  [<c03c1230>] do_work+0x0/0x50
> [  531.209951]  [<c03c124e>] do_work+0x1e/0x50
> [  531.209953]  [<c012ef32>] run_workqueue+0x72/0x100
> [  531.209962]  [<c0132570>] prepare_to_wait+0x20/0x60
> [  531.209965]  [<c012f840>] worker_thread+0x0/0xb0
> [  531.209972]  [<c012f8b9>] worker_thread+0x79/0xb0
> [  531.209974]  [<c01323d0>] autoremove_wake_function+0x0/0x50
> [  531.209976]  [<c012f840>] worker_thread+0x0/0xb0
> [  531.209978]  [<c01320d2>] kthread+0x42/0x70
> [  531.209980]  [<c0132090>] kthread+0x0/0x70
> [  531.209982]  [<c0103eff>] kernel_thread_helper+0x7/0x18
> [  531.209984] Code: 0b eb fe 0f 0b eb fe ba 01 00 00 00 89 f8 e8 d6 f8 ff ff 85 c0 0f 84 18 ff ff ff c7 47 08 00 00 00 00 e9 0c ff ff ff 0f 0b eb fe <0f> 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 83 
> [  531.210006] EIP: [<c03c7dc2>] persistent_commit+0x222/0x280 SS:ESP 0068:f4fc3f14
> [  531.210010] ---[ end trace fc1bc1bb8712a6ff ]---
> [  556.042136] iscsi_trgt: Logical Unit Reset (05) issued on tid:1 lun:0 by sid:281475899523136 (Function Complete)
> 
> Jacky
> .

---
 drivers/md/dm-exception-store.c |    7 +++++++
 drivers/md/dm-kcopyd.c          |   34 +++++++++++++++++++++++++++++++++-
 drivers/md/dm-snap.c            |    4 ++++
 3 files changed, 44 insertions(+), 1 deletion(-)

Index: linux-2.6.28-clean/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.28-clean.orig/drivers/md/dm-exception-store.c	2009-02-09 08:43:40.000000000 +0100
+++ linux-2.6.28-clean/drivers/md/dm-exception-store.c	2009-02-09 08:43:46.000000000 +0100
@@ -645,6 +645,13 @@ static void persistent_commit(struct exc
 	de.new_chunk = e->new_chunk;
 	write_exception(ps, ps->current_committed++, &de);
 
+	for (i = 0; i < ps->callback_count; i++) {
+		cb = ps->callbacks + i;
+		pe = cb->context;
+		BUG_ON(pe->e.hash_list.next == LIST_POISON1);
+		BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
+		BUG_ON(pe == callback_context);
+	}
 	/*
 	 * Add the callback to the back of the array.  This code
 	 * is the only place where the callback array is
Index: linux-2.6.28-clean/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.28-clean.orig/drivers/md/dm-snap.c	2009-02-09 08:43:40.000000000 +0100
+++ linux-2.6.28-clean/drivers/md/dm-snap.c	2009-02-09 08:43:46.000000000 +0100
@@ -979,6 +979,10 @@ static void start_copy(struct dm_snap_pe
 	struct dm_io_region src, dest;
 	struct block_device *bdev = s->origin->bdev;
 	sector_t dev_size;
+	BUG_ON(!pe->started);
+	BUG_ON(pe->started == 2);
+	BUG_ON(pe->started != 1);
+	pe->started = 2;
 
 	dev_size = get_dev_size(bdev);
 
Index: linux-2.6.28-clean/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.28-clean.orig/drivers/md/dm-kcopyd.c	2009-02-09 08:43:40.000000000 +0100
+++ linux-2.6.28-clean/drivers/md/dm-kcopyd.c	2009-02-09 08:44:47.000000000 +0100
@@ -60,6 +60,7 @@ struct dm_kcopyd_client {
 	struct list_head complete_jobs;
 	struct list_head io_jobs;
 	struct list_head pages_jobs;
+	struct list_head all_jobs;
 };
 
 static void wake(struct dm_kcopyd_client *kc)
@@ -209,6 +210,8 @@ struct kcopyd_job {
 	dm_kcopyd_notify_fn fn;
 	void *context;
 
+	struct list_head list_all;
+
 	/*
 	 * These fields are only used if the job has been split
 	 * into more manageable parts.
@@ -280,6 +283,9 @@ static void push_head(struct list_head *
 	spin_unlock_irqrestore(&kc->job_lock, flags);
 }
 
+static void segment_complete(int read_err, unsigned long write_err,
+			     void *context);
+
 /*
  * These three functions process 1 item from the corresponding
  * job list.
@@ -291,6 +297,8 @@ static void push_head(struct list_head *
  */
 static int run_complete_job(struct kcopyd_job *job)
 {
+	struct kcopyd_job *jobb;
+	unsigned long flags;
 	void *context = job->context;
 	int read_err = job->read_err;
 	unsigned long write_err = job->write_err;
@@ -299,6 +307,18 @@ static int run_complete_job(struct kcopy
 
 	if (job->pages)
 		kcopyd_put_pages(kc, job->pages);
+
+	if (fn != segment_complete) {
+		spin_lock_irqsave(&kc->job_lock, flags);
+		list_del(&job->list_all);
+		spin_unlock_irqrestore(&kc->job_lock, flags);
+
+		spin_lock_irqsave(&kc->job_lock, flags);
+		list_for_each_entry(jobb, &kc->all_jobs, list_all)
+			BUG_ON(jobb->fn == fn && jobb->context == context);
+		spin_unlock_irqrestore(&kc->job_lock, flags);
+	}
+
 	mempool_free(job, kc->job_pool);
 	fn(read_err, write_err, context);
 
@@ -535,7 +555,8 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 		   unsigned int num_dests, struct dm_io_region *dests,
 		   unsigned int flags, dm_kcopyd_notify_fn fn, void *context)
 {
-	struct kcopyd_job *job;
+	struct kcopyd_job *job, *jobb;
+	unsigned long fflags;
 
 	/*
 	 * Allocate a new job.
@@ -563,6 +584,15 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 	job->fn = fn;
 	job->context = context;
 
+	spin_lock_irqsave(&kc->job_lock, fflags);
+	list_for_each_entry(jobb, &kc->all_jobs, list_all)
+		BUG_ON(jobb->fn == fn && jobb->context == context);
+	spin_unlock_irqrestore(&kc->job_lock, fflags);
+
+	spin_lock_irqsave(&kc->job_lock, fflags);
+	list_add_tail(&job->list_all, &kc->all_jobs);
+	spin_unlock_irqrestore(&kc->job_lock, fflags);
+
 	if (job->source.count < SUB_JOB_SIZE)
 		dispatch_job(job);
 
@@ -603,6 +633,7 @@ int dm_kcopyd_client_create(unsigned int
 
 	spin_lock_init(&kc->lock);
 	spin_lock_init(&kc->job_lock);
+	INIT_LIST_HEAD(&kc->all_jobs);
 	INIT_LIST_HEAD(&kc->complete_jobs);
 	INIT_LIST_HEAD(&kc->io_jobs);
 	INIT_LIST_HEAD(&kc->pages_jobs);
@@ -652,6 +683,7 @@ void dm_kcopyd_client_destroy(struct dm_
 	/* Wait for completion of all jobs submitted by this client. */
 	wait_event(kc->destroyq, !atomic_read(&kc->nr_jobs));
 
+	BUG_ON(!list_empty(&kc->all_jobs));
 	BUG_ON(!list_empty(&kc->complete_jobs));
 	BUG_ON(!list_empty(&kc->io_jobs));
 	BUG_ON(!list_empty(&kc->pages_jobs));
