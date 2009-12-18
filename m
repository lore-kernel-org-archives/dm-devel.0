From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: eliminate some holes in data structures
Date: Fri, 18 Dec 2009 17:28:33 -0500
Message-ID: <20091218222830.GA12859@redhat.com>
References: <20091216034940.GA11003@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091216034940.GA11003@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Dec 15 2009 at 10:49pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> Eliminate 1 4-byte hole in 'struct dm_io_memory' by moving 'offset'
> above the 'ptr' to which it applies (size reduced from 24 to 16 bytes).
> And by association, 1 4 byte hole is eliminated in 'struct
> dm_io_request' (size reduced from 56 to 48 bytes).
> 
> Eliminate all (3 4-byte) holes (and one cache-line) in 'struct
> dm_snapshot' by moving 'pending_pool' after 'pending_exceptions_count'
> and moving 'merge_failed' lower (size reduced from 648 to 632 bytes).

As it happens, I had compiled with CONFIG_DEBUG_SPINLOCK et al.  That
explains why dm_snapshot was so large.  If I use a "production" .config
I need the following incremental patch to eliminate all 6 4-byte holes
in 'struct dm_snapshot' (reduces size from 392 to 368 bytes):

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 0435442..ab9822e 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -96,6 +96,11 @@ struct dm_snapshot {
 	 */
 	spinlock_t pe_lock;
 
+	/* Chunks with outstanding reads */
+	spinlock_t tracked_chunk_lock;
+	mempool_t *tracked_chunk_pool;
+	struct hlist_head tracked_chunk_hash[DM_TRACKED_CHUNK_HASH_SIZE];
+
 	/* The on disk metadata handler */
 	struct dm_exception_store *store;
 
@@ -105,11 +110,6 @@ struct dm_snapshot {
 	struct bio_list queued_bios;
 	struct work_struct queued_bios_work;
 
-	/* Chunks with outstanding reads */
-	mempool_t *tracked_chunk_pool;
-	spinlock_t tracked_chunk_lock;
-	struct hlist_head tracked_chunk_hash[DM_TRACKED_CHUNK_HASH_SIZE];
-
 	/* Wait for events based on state_bits */
 	unsigned long state_bits;
 
