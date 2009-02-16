From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: 2.6.28.2 & dm-snapshot or kcopyd Oops
Date: Mon, 16 Feb 2009 11:18:18 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902161116150.32249@hs20-bc2-1.build.redhat.com>
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
	<Pine.LNX.4.64.0902090311340.28754@hs20-bc2-1.build.redhat.com>,
	<200902101305353713189@163.com>,
	<Pine.LNX.4.64.0902101832050.386@hs20-bc2-1.build.redhat.com>,
	<Pine.LNX.4.64.0902110552550.20020@hs20-bc2-1.build.redhat.com>,
	<200902121131140773281@163.com>,
	<Pine.LNX.4.64.0902130138400.26381@hs20-bc2-1.build.redhat.com>,
	<Pine.LNX.4.64.0902130229040.2110@hs20-bc2-1.build.redhat.com>,
	<200902131912139165975@163.com>,
	<Pine.LNX.4.64.0902160213010.32560@hs20-bc2-1.build.redhat.com>
	<200902161703497923912@163.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200902161703497923912@163.com>
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

> Hi,
> 
> The debug info is as follow:
> 
> [  424.830790] Bad ref count, pe f0f73f70, pe->magic 12345678, primary_pe ef7d27b8, primary_pe->magic 90abcdef, primary_pe->ref_count 0
> [  424.830805] ------------[ cut here ]------------
> [  424.830806] kernel BUG at drivers/md/dm-snap.c:1361!
> [  424.830808] invalid opcode: 0000 [#1] SMP 
> [  424.830811] last sysfs file: /sys/devices/virtual/block/dm-10/dev
> [  424.830812] Modules linked in: iscsi_trgt arcmsr bonding e1000
> [  424.830816] 
> [  424.830818] Pid: 1486, comm: istiod1 Not tainted (2.6.28.2-storix-mcore #10) S5000PSL
> [  424.830820] EIP: 0060:[<c03c64dc>] EFLAGS: 00010282 CPU: 0
> [  424.830825] EIP is at origin_map+0x33c/0x3d0
> [  424.830827] EAX: 0000008b EBX: f0f73f70 ECX: 00000082 EDX: 00000046
> [  424.830828] ESI: f6cf98c0 EDI: 0023cd0c EBP: 00000000 ESP: f0f5bd50
> [  424.830830]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [  424.830831] Process istiod1 (pid: 1486, ti=f0f5a000 task=eed3a780 task.ti=f0f5a000)
> [  424.830833] Stack:
> [  424.830834]  c0555698 f0f73f70 12345678 ef7d27b8 90abcdef 00000000 f0f5bd80 ef3978c0
> [  424.830837]  00000000 ef7d27b8 00000000 eed2974c f0f5bd80 f0f5bd80 f74b8a40 ef3978c0
> [  424.830841]  f6dabf48 f9d31040 c03bb495 11e683a0 00000000 00000000 f0d6c740 f6dabf58
> [  424.830845] Call Trace:
> [  424.830846]  [<c03bb495>] __map_bio+0x35/0xb0
> [  424.830849]  [<c03bc3ec>] __split_bio+0x36c/0x4b0
> [  424.830852]  [<c03bc917>] dm_request+0x117/0x1b0
> [  424.830854]  [<c02c93e0>] generic_make_request+0x1c0/0x2a0
> [  424.830858]  [<c02ca622>] generic_unplug_device+0x22/0x30
> [  424.830860]  [<c03bc01c>] dm_merge_bvec+0xac/0x110
> [  424.830862]  [<c02ca6ea>] submit_bio+0x4a/0xd0
> [  424.830864]  [<c018b81a>] bio_add_page+0x3a/0x50
> [  424.830868]  [<f87bec55>] blockio_make_request+0x215/0x2f6 [iscsi_trgt]
> [  424.830877]  [<f87bea40>] blockio_make_request+0x0/0x2f6 [iscsi_trgt]
> [  424.830883]  [<f87b5120>] tio_write+0x20/0x60 [iscsi_trgt]
> [  424.830888]  [<f87bce7e>] build_write_response+0x2e/0xb0 [iscsi_trgt]
> [  424.830893]  [<f87b685c>] iscsi_cmnd_create_rsp_cmnd+0x1c/0x60 [iscsi_trgt]
> [  424.830898]  [<f87b81d7>] send_scsi_rsp+0x17/0xd0 [iscsi_trgt]
> [  424.830903]  [<f87bcd2c>] disk_execute_cmnd+0xdc/0x160 [iscsi_trgt]
> [  424.830908]  [<f87b9d02>] worker_thread+0xf2/0x170 [iscsi_trgt]
> [  424.830913]  [<c011a880>] default_wake_function+0x0/0x10
> [  424.830917]  [<f87b9c10>] worker_thread+0x0/0x170 [iscsi_trgt]
> [  424.830922]  [<c01320d2>] kthread+0x42/0x70
> [  424.830925]  [<c0132090>] kthread+0x0/0x70
> [  424.830927]  [<c0103eff>] kernel_thread_helper+0x7/0x18
> [  424.830930] Code: ff 8b 4c 24 24 89 44 24 14 8b 41 48 89 4c 24 0c 89 44 24 10 8b 43 48 89 5c 24 04 c7 04 24 98 56 55 c0 89 44 24 08 e8 54 a7 d5 ff <0f> 0b eb fe 8b 4c 24 1c 8b 44 24 24 89 48 18 eb a3 8b 4c 24 24 
> [  424.830948] EIP: [<c03c64dc>] origin_map+0x33c/0x3d0 SS:ESP 0068:f0f5bd50
> [  424.830953] ---[ end trace e814d4d4e6a134e7 ]---
> 
> Jacky
> .

Thanks.

Here's another one to try (on the top of all those patches):

Mikulas

---
 drivers/md/dm-snap.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

Index: linux-2.6.28-snap-debug/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.28-snap-debug.orig/drivers/md/dm-snap.c	2009-02-16 13:05:12.000000000 +0100
+++ linux-2.6.28-snap-debug/drivers/md/dm-snap.c	2009-02-16 16:30:03.000000000 +0100
@@ -861,6 +861,43 @@ static void __invalidate_snapshot(struct
 	dm_table_event(s->ti->table);
 }
 
+static void check_allocated_chunk(struct block_device *bdev, chunk_t chunk, struct dm_snap_pending_exception *pe, int line)
+{
+	struct dm_snapshot *snap;
+	int i = 0;
+	struct origin *o;
+	down_read(&_origins_lock);
+	o = __lookup_origin(bdev);
+	if (!o) {
+		printk("line %d\n", line);
+		BUG();
+	}
+	list_for_each_entry (snap, &o->snapshots, list) {
+		struct dm_snap_exception *e;
+		down_write(&snap->lock);
+		if (!snap->valid || !snap->active)
+			goto next_snapshot;
+		e = lookup_exception(&snap->complete, chunk);
+		if (e)
+			goto next_snapshot;
+		e = lookup_exception(&snap->pending, chunk);
+		if (e) {
+			struct dm_snap_pending_exception *pe = container_of(e, struct dm_snap_pending_exception, e);
+			if (!pe->primary_pe) {
+				printk(KERN_ALERT "%d: no primary pe %Lx in snapshot %p(%d), copying snapshot %p, pe %p, pe->primary_pe %p, refcount %d\n", line, (unsigned long long)chunk, snap, i, pe->snap, pe, pe->primary_pe, atomic_read(&pe->ref_count));
+				BUG();
+			}
+			goto next_snapshot;
+		}
+		printk(KERN_ALERT "%d: not allocated chunk %Lx in snapshot %p(%d), copying snapshot %p, pe %p, pe->primary_pe %p, refcount %d\n", line, (unsigned long long)chunk, snap, i, pe->snap, pe, pe->primary_pe, atomic_read(&pe->ref_count));
+		BUG();
+next_snapshot:
+		up_write(&snap->lock);
+		i++;
+	}
+	up_read(&_origins_lock);
+}
+
 static void get_pending_exception(struct dm_snap_pending_exception *pe)
 {
 	atomic_inc(&pe->ref_count);
@@ -917,6 +954,8 @@ static void pending_complete(struct dm_s
 	BUG_ON(pe->e.hash_list.next == LIST_POISON1);
 	BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
 
+	check_allocated_chunk(s->origin->bdev, pe->e.old_chunk, pe, __LINE__);
+
 	if (!success) {
 		/* Read/write error - snapshot is unusable */
 		down_write(&s->lock);
@@ -1017,6 +1056,8 @@ static void copy_callback(int read_err, 
 	BUG_ON(pe->e.hash_list.next == LIST_POISON1);
 	BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
 
+	check_allocated_chunk(s->origin->bdev, pe->e.old_chunk, pe, __LINE__);
+
 	if (read_err || write_err) {
 		s->store.check_pending_exception(&s->store, pe, __LINE__);
 		pending_complete(pe, 0);
@@ -1056,6 +1097,8 @@ static void start_copy(struct dm_snap_pe
 	BUG_ON(pe->e.hash_list.next == LIST_POISON1);
 	BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
 
+	check_allocated_chunk(bdev, pe->e.old_chunk, pe, __LINE__);
+
 	/* Hand over to kcopyd */
 	dm_kcopyd_copy(s->kcopyd_client,
 		    &src, 1, &dest, 0, copy_callback, pe);
@@ -1155,6 +1198,11 @@ static int snapshot_map(struct dm_target
 	chunk_t chunk;
 	struct dm_snap_pending_exception *pe = NULL;
 
+	if (bio_rw(bio) == WRITE) {
+		printk(KERN_ALERT "Writing to a snapshot --- not supported!\n");
+		BUG();
+	}
+
 	chunk = sector_to_chunk(s, bio->bi_sector);
 
 	/* Full snapshots are not usable */
@@ -1300,8 +1348,11 @@ static int __origin_write(struct list_he
 			goto next_snapshot;
 
 		/* Nothing to do if writing beyond end of snapshot */
-		if (bio->bi_sector >= dm_table_get_size(snap->ti->table))
+		if (bio->bi_sector >= dm_table_get_size(snap->ti->table)) {
+			printk(KERN_ALERT "over snapshot end - not supported: %Lx >= %Lx\n", (unsigned long long)bio->bi_sector, (unsigned long long)dm_table_get_size(snap->ti->table));
+			BUG();
 			goto next_snapshot;
+		}
 
 		/*
 		 * Remember, different snapshots can have
@@ -1486,8 +1537,13 @@ static void origin_resume(struct dm_targ
 	down_read(&_origins_lock);
 	o = __lookup_origin(dev->bdev);
 	if (o)
-		list_for_each_entry (snap, &o->snapshots, list)
+		list_for_each_entry (snap, &o->snapshots, list) {
+			if (chunk_size && chunk_size != snap->chunk_size) {
+				printk(KERN_ALERT "Different chunk sizes - not supported!\n");
+				BUG();
+			}
 			chunk_size = min_not_zero(chunk_size, snap->chunk_size);
+		}
 	up_read(&_origins_lock);
 
 	ti->split_io = chunk_size;
