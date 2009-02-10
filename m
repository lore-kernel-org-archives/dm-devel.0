From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: 2.6.28.2 & dm-snapshot or kcopyd Oops
Date: Tue, 10 Feb 2009 18:36:51 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902101832050.386@hs20-bc2-1.build.redhat.com>
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
	<Pine.LNX.4.64.0902061815440.11986@hs20-bc2-1.build.redhat.com>,
	<200902072041046488539@163.com>,
	<Pine.LNX.4.64.0902090311340.28754@hs20-bc2-1.build.redhat.com>
	<200902101305353713189@163.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200902101305353713189@163.com>
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



On Tue, 10 Feb 2009, Jacky Kim wrote:

> Hi Mikulas,
> 
> The latest debug messages is as follow:
> 
> [ 2006.004571] ------------[ cut here ]------------
> [ 2006.004576] kernel BUG at drivers/md/dm-exception-store.c:653!
> [ 2006.004583] invalid opcode: 0000 [#1] SMP 
> [ 2006.004585] last sysfs file: /sys/devices/virtual/block/dm-9/dev
> [ 2006.004587] Modules linked in: iscsi_trgt arcmsr bonding e1000
> [ 2006.004590] 
> [ 2006.004593] Pid: 23442, comm: kcopyd Not tainted (2.6.28.2-dm #7) S5000PSL
> [ 2006.004595] EIP: 0060:[<c03c7ede>] EFLAGS: 00010246 CPU: 3
> [ 2006.004605] EIP is at persistent_commit+0x1ce/0x2c0
> [ 2006.004606] EAX: ef347948 EBX: fa7f5000 ECX: 00000001 EDX: 00000007
> [ 2006.004608] ESI: 00000000 EDI: f0f44a40 EBP: ef347948 ESP: efa1df04
> [ 2006.004609]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [ 2006.004611] Process kcopyd (pid: 23442, ti=efa1c000 task=f0c76460 task.ti=efa1c000)
> [ 2006.004613] Stack:
> [ 2006.004614]  c03c6880 ef347948 000174b7 00000000 ef347948 f6f4c080 f0e535e4 f6e71240
> [ 2006.004617]  c03c6853 ef347948 f6e71298 c03c6820 c03c1858 f6e7127c f6e7127c ef347948
> [ 2006.004621]  00000000 00000000 00000202 f0e535e4 f0e535e8 f6e7127c f6e71280 c03c119c
> [ 2006.004625] Call Trace:
> [ 2006.004626]  [<c03c6880>] commit_callback+0x0/0x30
> [ 2006.004629]  [<c03c6853>] copy_callback+0x33/0x60
> [ 2006.004632]  [<c03c6820>] copy_callback+0x0/0x60
> [ 2006.004634]  [<c03c1858>] run_complete_job+0x108/0x140
> [ 2006.004637]  [<c03c119c>] process_jobs+0x4c/0xe0
> [ 2006.004639]  [<c03c1750>] run_complete_job+0x0/0x140
> [ 2006.004641]  [<c03c1230>] do_work+0x0/0x50
> [ 2006.004643]  [<c03c124e>] do_work+0x1e/0x50
> [ 2006.004645]  [<c012ef32>] run_workqueue+0x72/0x100
> [ 2006.004649]  [<c0132570>] prepare_to_wait+0x20/0x60
> [ 2006.004652]  [<c012f840>] worker_thread+0x0/0xb0
> [ 2006.004654]  [<c012f8b9>] worker_thread+0x79/0xb0
> [ 2006.004656]  [<c01323d0>] autoremove_wake_function+0x0/0x50
> [ 2006.004658]  [<c012f840>] worker_thread+0x0/0xb0
> [ 2006.004660]  [<c01320d2>] kthread+0x42/0x70
> [ 2006.004662]  [<c0132090>] kthread+0x0/0x70
> [ 2006.004664]  [<c0103eff>] kernel_thread_helper+0x7/0x18
> [ 2006.004667] Code: fe 8b 4f 28 3b 4f 0c 0f 84 6c ff ff ff 81 7d 00 00 01 10 00 74 4d 81 7d 04 00 02 20 00 0f 84 c8 00 00 00 83 c4 10 5b 5e 5f 5d c3 <0f> 0b eb fe 0f 0b eb fe 0f 0b eb fe 8d b6 00 00 00 00 64 a1 00 
> [ 2006.004686] EIP: [<c03c7ede>] persistent_commit+0x1ce/0x2c0 SS:ESP 0068:efa1df04
> [ 2006.005020] ---[ end trace 6a5aa6c590d2cad7 ]---
> 
> Jacky
> .

Hi

I have found another bug in dm-snapshots, I think it won't fix your crash 
but it is a bug anyway, so it should be fixed. Apply the below patch.

I'll send you some more debug patches to pinpoint the crash you are 
seeing.

Mikulas

---

__find_pending_exception drops the snapshot lock for the time of allocation
(this is correct and required behavior because the lock is held when freeing
the exception into the mempool)

After __find_pending_exception regains the lock, it checks if the exception
was already placed into &s->pending hash and it checks if the snapshot was
already invalidated.

But __find_pending_exception doesn't check if the exception was already
completed and placed into &s->complete hash. If the process waiting in
__find_pending_exception was delayed at this point because of a scheduling
latency and the exception was meanwhile completed, __find_pending_exception
will miss that and allocate another pending exception for already completed
chunk.

It will lead to a situation when two records for the same chunk exist and
it could lead to data corruption because multiple snapshot I/Os to the
affected chunk could be redirected to different locations in the snapshot.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.28-clean/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.28-clean.orig/drivers/md/dm-snap.c	2009-02-11 00:26:47.000000000 +0100
+++ linux-2.6.28-clean/drivers/md/dm-snap.c	2009-02-11 00:27:54.000000000 +0100
@@ -1007,6 +1007,10 @@ static void start_copy(struct dm_snap_pe
  * for this chunk, otherwise it allocates a new one and inserts
  * it into the pending table.
  *
+ * Returns: pointer to a pending exception
+ *	ERR_PTR(-ENOMEM) pointer --- the snapshot is invalidated
+ *	NULL --- the exception was already completed, the caller should recheck
+ *
  * NOTE: a write lock must be held on snap->lock before calling
  * this.
  */
@@ -1037,6 +1041,12 @@ __find_pending_exception(struct dm_snaps
 
 	if (!s->valid) {
 		free_pending_exception(pe);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	e = lookup_exception(&s->complete, chunk);
+	if (e) {
+		free_pending_exception(pe);
 		return NULL;
 	}
 
@@ -1056,7 +1066,7 @@ __find_pending_exception(struct dm_snaps
 
 	if (s->store.prepare_exception(&s->store, &pe->e)) {
 		free_pending_exception(pe);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	get_pending_exception(pe);
@@ -1100,6 +1110,7 @@ static int snapshot_map(struct dm_target
 		goto out_unlock;
 	}
 
+lookup_again:
 	/* If the block is already remapped - use that, else remap it */
 	e = lookup_exception(&s->complete, chunk);
 	if (e) {
@@ -1114,8 +1125,10 @@ static int snapshot_map(struct dm_target
 	 */
 	if (bio_rw(bio) == WRITE) {
 		pe = __find_pending_exception(s, bio);
-		if (!pe) {
-			__invalidate_snapshot(s, -ENOMEM);
+		if (!pe)
+			goto lookup_again;
+		if (IS_ERR(pe)) {
+			__invalidate_snapshot(s, PTR_ERR(pe));
 			r = -EIO;
 			goto out_unlock;
 		}
@@ -1248,8 +1261,10 @@ static int __origin_write(struct list_he
 			goto next_snapshot;
 
 		pe = __find_pending_exception(snap, bio);
-		if (!pe) {
-			__invalidate_snapshot(snap, -ENOMEM);
+		if (!pe)
+			goto next_snapshot;
+		if (IS_ERR(pe)) {
+			__invalidate_snapshot(snap, PTR_ERR(pe));
 			goto next_snapshot;
 		}
 
