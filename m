From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] dm: eliminate some holes in data structures
Date: Wed, 16 Dec 2009 13:25:23 -0600
Message-ID: <C2396898-128F-4603-A21B-ECDD04981339@redhat.com>
References: <20091216034940.GA11003@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

ACK  (Reviewed-by)

  brassow

On Dec 15, 2009, at 9:49 PM, Mike Snitzer wrote:

> Eliminate 1 4-byte hole in 'struct dm_io_memory' by moving 'offset'
> above the 'ptr' to which it applies (size reduced from 24 to 16  
> bytes).
> And by association, 1 4 byte hole is eliminated in 'struct
> dm_io_request' (size reduced from 56 to 48 bytes).
>
> Eliminate all (3 4-byte) holes (and one cache-line) in 'struct
> dm_snapshot' by moving 'pending_pool' after 'pending_exceptions_count'
> and moving 'merge_failed' lower (size reduced from 648 to 632 bytes).
>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
> drivers/md/dm-snap.c  |   18 +++++++++---------
> include/linux/dm-io.h |    4 ++--
> 2 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
> index ee8eb28..0435442 100644
> --- a/drivers/md/dm-snap.c
> +++ b/drivers/md/dm-snap.c
> @@ -83,10 +83,10 @@ struct dm_snapshot {
> 	/* Whether or not owning mapped_device is suspended */
> 	int suspended;
>
> -	mempool_t *pending_pool;
> -
> 	atomic_t pending_exceptions_count;
>
> +	mempool_t *pending_pool;
> +
> 	struct dm_exception_table pending;
> 	struct dm_exception_table complete;
>
> @@ -110,6 +110,13 @@ struct dm_snapshot {
> 	spinlock_t tracked_chunk_lock;
> 	struct hlist_head tracked_chunk_hash[DM_TRACKED_CHUNK_HASH_SIZE];
>
> +	/* Wait for events based on state_bits */
> +	unsigned long state_bits;
> +
> +	/* Range of chunks currently being merged. */
> +	chunk_t first_merging_chunk;
> +	int num_merging_chunks;
> +
> 	/*
> 	 * The merge operation failed if this flag is set.
> 	 * Failure modes are handled as follows:
> @@ -125,13 +132,6 @@ struct dm_snapshot {
> 	 */
> 	int merge_failed;
>
> -	/* Wait for events based on state_bits */
> -	unsigned long state_bits;
> -
> -	/* Range of chunks currently being merged. */
> -	chunk_t first_merging_chunk;
> -	int num_merging_chunks;
> -
> 	/*
> 	 * Incoming bios that overlap with chunks being merged must wait
> 	 * for them to be committed.
> diff --git a/include/linux/dm-io.h b/include/linux/dm-io.h
> index b6bf17e..5c9186b 100644
> --- a/include/linux/dm-io.h
> +++ b/include/linux/dm-io.h
> @@ -37,14 +37,14 @@ enum dm_io_mem_type {
> struct dm_io_memory {
> 	enum dm_io_mem_type type;
>
> +	unsigned offset;
> +
> 	union {
> 		struct page_list *pl;
> 		struct bio_vec *bvec;
> 		void *vma;
> 		void *addr;
> 	} ptr;
> -
> -	unsigned offset;
> };
>
> struct dm_io_notify {
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
