From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: Re: 2.6.28.2 & dm-snapshot or kcopyd Oops
Date: Fri, 6 Feb 2009 18:17:42 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902061815440.11986@hs20-bc2-1.build.redhat.com>
References: <200901231836184950432@163.com>,
	<Pine.LNX.4.64.0901231514590.9877@hs20-bc2-1.build.redhat.com>,
	<200901301800149019891@163.com>,
	<Pine.LNX.4.64.0901301533390.5744@hs20-bc2-1.build.redhat.com>,
	<200901311416111648168@163.com>,
	<Pine.LNX.4.64.0902031505180.28433@hs20-bc2-1.build.redhat.com>,
	<200902051113011850587@163.com>,
	<Pine.LNX.4.64.0902051749150.5515@hs20-bc2-1.build.redhat.com>,
	<Pine.LNX.4.64.0902052218040.5380@hs20-bc2-1.build.redhat.com>
	<200902061924107769776@163.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200902061924107769776@163.com>
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



On Fri, 6 Feb 2009, Jacky Kim wrote:

> Hi Mikulas,
> 
> I patch it with kernel 2.6.28.2, but it still has probrem:
> 
> [  493.509650] ------------[ cut here ]------------
> [  493.509654] kernel BUG at drivers/md/dm-snap.c:946!
> [  493.509656] invalid opcode: 0000 [#1] SMP 
> [  493.509658] last sysfs file: /sys/devices/virtual/block/dm-11/dev
> [  493.509660] Modules linked in: iscsi_trgt arcmsr bonding e1000
> [  493.509664] 
> [  493.509666] Pid: 7520, comm: kcopyd Not tainted (2.6.28.2-dm #5) S5000PSL
> [  493.509668] EIP: 0060:[<c03c6726>] EFLAGS: 00010246 CPU: 1
> [  493.509677] EIP is at commit_callback+0x16/0x30
> [  493.509679] EAX: f021f188 EBX: 0000002b ECX: fac54150 EDX: 00000001
> [  493.509680] ESI: 021c44dc EDI: 00000000 EBP: eed384c0 ESP: efacdf10
> [  493.509682]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [  493.509686] Process kcopyd (pid: 7520, ti=efacc000 task=f2c95b40 task.ti=efacc000)
> [  493.509687] Stack:
> [  493.509688]  c03c7799 c03c6710 0005aa3b 00000000 efa8fd48 f75b3ec0 00000000 c03c66b0
> [  493.509692]  c03c66e3 efa8fd48 effca9a0 eed3c1c0 c03c13f8 f2c95b40 efa8fd48 00000000
> [  493.509695]  effca9a0 effca9a4 eed3c1fc eed3c200 c03c119c c03c13a0 eed3c1c0 00000000
> [  493.509699] Call Trace:
> [  493.509701]  [<c03c7799>] persistent_commit+0xb9/0x130
> [  493.509703]  [<c03c6710>] commit_callback+0x0/0x30
> [  493.509709]  [<c03c66b0>] copy_callback+0x0/0x60
> [  493.509712]  [<c03c66e3>] copy_callback+0x33/0x60
> [  493.509714]  [<c03c13f8>] run_complete_job+0x58/0xa0
> [  493.509716]  [<c03c119c>] process_jobs+0x4c/0xe0
> [  493.509718]  [<c03c13a0>] run_complete_job+0x0/0xa0
> [  493.509720]  [<c03c1230>] do_work+0x0/0x50
> [  493.509722]  [<c03c124e>] do_work+0x1e/0x50
> [  493.509724]  [<c012ef32>] run_workqueue+0x72/0x100
> [  493.509728]  [<c0132570>] prepare_to_wait+0x20/0x60
> [  493.509732]  [<c012f840>] worker_thread+0x0/0xb0
> [  493.509734]  [<c012f8b9>] worker_thread+0x79/0xb0
> [  493.509736]  [<c01323d0>] autoremove_wake_function+0x0/0x50
> [  493.509738]  [<c012f840>] worker_thread+0x0/0xb0
> [  493.509741]  [<c01320d2>] kthread+0x42/0x70
> [  493.509742]  [<c0132090>] kthread+0x0/0x70
> [  493.509744]  [<c0103eff>] kernel_thread_helper+0x7/0x18
> [  493.509748] Code: 90 8d 74 26 00 0f 0b eb fe 8d b6 00 00 00 00 8d bf 00 00 00 00 81 38 00 01 10 00 74 0e 81 78 04 00 02 20 00 74 0f e9 6a fc ff ff <0f> 0b eb fe 8d b6 00 00 00 00 0f 0b eb fe 8d b6 00 00 00 00 8d 
> [  493.509766] EIP: [<c03c6726>] commit_callback+0x16/0x30 SS:ESP 0068:efacdf10
> [  493.509794] ---[ end trace 05237464c530eabb ]---
> [  517.575348] iscsi_trgt: Logical Unit Reset (05) issued on tid:1 lun:0 by sid:281475899523136 (Function Complete)
> 
> Jacky
> .

Hi

So apply this on the top of both patches (on 2.6.28.x)

(this is not supposed to fix the bug, it will just add more debug tests)

BTW. what is the chunk size of the snapshot store you are testing?

Mikulas

---
 drivers/md/dm-exception-store.c |   85 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 84 insertions(+), 1 deletion(-)

Index: linux-2.6.28-clean/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.28-clean.orig/drivers/md/dm-exception-store.c	2009-02-06 23:26:55.000000000 +0100
+++ linux-2.6.28-clean/drivers/md/dm-exception-store.c	2009-02-06 23:39:25.000000000 +0100
@@ -131,6 +131,8 @@ struct pstore {
 	struct dm_io_client *io_client;
 
 	struct workqueue_struct *metadata_wq;
+
+	struct task_struct *process;
 };
 
 static unsigned sectors_to_pages(unsigned sectors)
@@ -577,6 +579,48 @@ static int persistent_prepare(struct exc
 	return 0;
 }
 
+struct dm_snap_pending_exception {
+	struct dm_snap_exception e;
+
+	/*
+	 * Origin buffers waiting for this to complete are held
+	 * in a bio list
+	 */
+	struct bio_list origin_bios;
+	struct bio_list snapshot_bios;
+
+	/*
+	 * Short-term queue of pending exceptions prior to submission.
+	 */
+	struct list_head list;
+
+	/*
+	 * The primary pending_exception is the one that holds
+	 * the ref_count and the list of origin_bios for a
+	 * group of pending_exceptions.  It is always last to get freed.
+	 * These fields get set up when writing to the origin.
+	 */
+	struct dm_snap_pending_exception *primary_pe;
+
+	/*
+	 * Number of pending_exceptions processing this chunk.
+	 * When this drops to zero we must complete the origin bios.
+	 * If incrementing or decrementing this, hold pe->snap->lock for
+	 * the sibling concerned and not pe->primary_pe->snap->lock unless
+	 * they are the same.
+	 */
+	atomic_t ref_count;
+
+	/* Pointer back to snapshot context */
+	struct dm_snapshot *snap;
+
+	/*
+	 * 1 indicates the exception has already been sent to
+	 * kcopyd.
+	 */
+	int started;
+};
+
 static void persistent_commit(struct exception_store *store,
 			      struct dm_snap_exception *e,
 			      void (*callback) (void *, int success),
@@ -586,6 +630,16 @@ static void persistent_commit(struct exc
 	struct pstore *ps = get_info(store);
 	struct disk_exception de;
 	struct commit_callback *cb;
+	struct dm_snap_pending_exception *pe;
+
+	if (!ps->process)
+		ps->process = current;
+
+	BUG_ON(ps->process != current);
+
+	pe = callback_context;
+	BUG_ON(pe->e.hash_list.next == LIST_POISON1);
+	BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
 
 	de.old_chunk = e->old_chunk;
 	de.new_chunk = e->new_chunk;
@@ -601,13 +655,30 @@ static void persistent_commit(struct exc
 	cb->callback = callback;
 	cb->context = callback_context;
 
+	for (i = 0; i < ps->callback_count; i++) {
+		cb = ps->callbacks + i;
+		pe = cb->context;
+		BUG_ON(pe->e.hash_list.next == LIST_POISON1);
+		BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
+	}
 	/*
 	 * If there are exceptions in flight and we have not yet
 	 * filled this metadata area there's nothing more to do.
 	 */
 	if (!atomic_dec_and_test(&ps->pending_count) &&
-	    (ps->current_committed != ps->exceptions_per_area))
+	    (ps->current_committed != ps->exceptions_per_area)) {
+		pe = callback_context;
+		BUG_ON(pe->e.hash_list.next == LIST_POISON1);
+		BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
 		return;
+	}
+	for (i = 0; i < ps->callback_count; i++) {
+		cb = ps->callbacks + i;
+		pe = cb->context;
+		BUG_ON(pe->e.hash_list.next == LIST_POISON1);
+		BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
+	}
+
 
 	/*
 	 * If we completely filled the current area, then wipe the next one.
@@ -633,6 +704,16 @@ static void persistent_commit(struct exc
 
 	for (i = 0; i < ps->callback_count; i++) {
 		cb = ps->callbacks + i;
+		pe = cb->context;
+		BUG_ON(pe->e.hash_list.next == LIST_POISON1);
+		BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
+	}
+
+	for (i = 0; i < ps->callback_count; i++) {
+		cb = ps->callbacks + i;
+		pe = cb->context;
+		BUG_ON(pe->e.hash_list.next == LIST_POISON1);
+		BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
 		cb->callback(cb->context, ps->valid);
 	}
 
@@ -668,6 +749,8 @@ int dm_create_persistent(struct exceptio
 	atomic_set(&ps->pending_count, 0);
 	ps->callbacks = NULL;
 
+	ps->process = NULL;
+
 	ps->metadata_wq = create_singlethread_workqueue("ksnaphd");
 	if (!ps->metadata_wq) {
 		kfree(ps);
