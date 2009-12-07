From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: snapshot merging: change timeout to a sequence count
Date: Mon, 7 Dec 2009 10:52:58 -0500
Message-ID: <20091207155258.GD8917@redhat.com>
References: <Pine.LNX.4.64.0912070816120.15633@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912070816120.15633@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Dec 07 2009 at  8:19am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> This changes the timeout to a sequence count. And adds a comment.
> 
> Mikulas
> 
> ---
> 
> Avoit the timeout.
> 
> Use a sequence count to resolve the race. The count increases each time
> an exception reallocation finishes. Use wait_event() to wait until the count
> changes.
> 
> The chunk-reallocation logic is explained in the comment in the patch.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Here is an updated patch that falls at the end of my snapshot-merge
series here:
http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel/2.6.33/

---

dm snapshot: change the snapshot reallocation timeout to a sequence count

Use a sequence count to resolve the race between I/O to chunks that are
about to be merged.  The count increases each time an exception
reallocation finishes.  Use wait_event() to wait until the count
changes.

The chunk-reallocation logic is now explained in snapshot_merge_process()

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-snap.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

Index: linux-rhel6/drivers/md/dm-snap.c
===================================================================
--- linux-rhel6.orig/drivers/md/dm-snap.c
+++ linux-rhel6/drivers/md/dm-snap.c
@@ -271,6 +271,8 @@ static struct list_head *_origins;
 static struct rw_semaphore _origins_lock;
 
 static DECLARE_WAIT_QUEUE_HEAD(_pending_exception_done);
+static DEFINE_SPINLOCK(_pending_exception_done_spinlock);
+static u64 _pending_exception_done_count = 0;
 
 static int init_origin_hash(void)
 {
@@ -770,6 +772,17 @@ static int __origin_write(struct list_he
 static void merge_callback(int read_err, unsigned long write_err,
 			   void *context);
 
+static u64 read_pending_exception_done_count(void)
+{
+	u64 current_count;
+
+	spin_lock(&_pending_exception_done_spinlock);
+	current_count = _pending_exception_done_count;
+	spin_unlock(&_pending_exception_done_spinlock);
+
+	return current_count;
+}
+
 static void snapshot_merge_process(struct dm_snapshot *s)
 {
 	int r, i, linear_chunks;
@@ -778,6 +791,7 @@ static void snapshot_merge_process(struc
 	int must_wait;
 	struct dm_io_region src, dest;
 	sector_t io_size;
+	u64 previous_count;
 
 	BUG_ON(!test_bit(MERGE_RUNNING, &s->bits));
 	if (unlikely(test_bit(SHUTDOWN_MERGE, &s->bits)))
@@ -818,9 +832,32 @@ static void snapshot_merge_process(struc
 	src.sector = chunk_to_sector(s->store, new_chunk);
 	src.count = dest.count;
 
+	/*
+	 * Reallocate the other snapshots:
+	 *
+	 * The chunk size of the merging snapshot may be larger than the chunk
+	 * size of some other snapshot. So we may need to reallocate multiple
+	 * chunks in a snapshot.
+	 *
+	 * We don't do linking of pending exceptions and waiting for the last
+	 * one --- that would complicate code too much and it would also be
+	 * bug-prone.
+	 *
+	 * Instead, we try to scan all the overlapping exceptions in all
+	 * non-merging snapshots and if something was reallocated then wait
+	 * for any pending exception to complete. Retry after the wait, until
+	 * all exceptions are done.
+	 *
+	 * This may seem ineffective, but in practice, people hardly use more
+	 * than one or two snapshots. In case of two snapshots (one merging and
+	 * one non-merging) with the same chunksize, wait and wakeup is done
+	 * only once.
+	 */
+
 test_again:
-	/* Reallocate other snapshots; must account for all 'linear_chunks' */
+	previous_count = read_pending_exception_done_count();
 	must_wait = 0;
+
 	/*
 	 * Merging snapshot already has the origin's __minimum_chunk_size()
 	 * stored in split_io (see: snapshot_merge_resume); avoid rediscovery
@@ -835,7 +872,8 @@ test_again:
 	}
 	up_read(&_origins_lock);
 	if (must_wait) {
-		sleep_on_timeout(&_pending_exception_done, HZ / 100 + 1);
+		wait_event(_pending_exception_done,
+			   read_pending_exception_done_count() != previous_count);
 		goto test_again;
 	}
 
@@ -1371,6 +1409,9 @@ static void pending_complete(struct dm_s
 	origin_bios = bio_list_get(&pe->origin_bios);
 	free_pending_exception(pe);
 
+	spin_lock(&_pending_exception_done_spinlock);
+	_pending_exception_done_count++;
+	spin_unlock(&_pending_exception_done_spinlock);
 	wake_up_all(&_pending_exception_done);
 
 	up_write(&s->lock);
