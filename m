From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 08/10] dm-integrity: add a bitmap mode
Date: Wed, 8 May 2019 13:53:50 -0400
Message-ID: <20190508175350.GA29513@redhat.com>
References: <20190429125746.036036640@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190429125746.036036640@debian-a64.vm>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Mon, Apr 29 2019 at  8:57am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Add a new bitmap mode for dm-integrity.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  Documentation/device-mapper/dm-integrity.txt |   23 +
>  drivers/md/dm-integrity.c                    |  534 +++++++++++++++++++++++++--
>  2 files changed, 525 insertions(+), 32 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-integrity.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-integrity.c	2019-04-27 10:28:49.000000000 +0200
> +++ linux-2.6/drivers/md/dm-integrity.c	2019-04-29 11:43:38.000000000 +0200
> @@ -24,6 +24,7 @@
>  
>  #define DEFAULT_INTERLEAVE_SECTORS	32768
>  #define DEFAULT_JOURNAL_SIZE_FACTOR	7
> +#define DEFAULT_SECTORS_PER_BITMAP_BIT	32768
>  #define DEFAULT_BUFFER_SECTORS		128
>  #define DEFAULT_JOURNAL_WATERMARK	50
>  #define DEFAULT_SYNC_MSEC		10000
> @@ -33,6 +34,8 @@
>  #define METADATA_WORKQUEUE_MAX_ACTIVE	16
>  #define RECALC_SECTORS			8192
>  #define RECALC_WRITE_SUPER		16
> +#define BITMAP_BLOCK_SIZE		4096	/* don't change it */
> +#define BITMAP_FLUSH_INTERVAL		(10 * HZ)
>  
>  /*
>   * Warning - DEBUG_PRINT prints security-sensitive data to the log,
> @@ -48,6 +51,7 @@
>  #define SB_MAGIC			"integrt"
>  #define SB_VERSION_1			1
>  #define SB_VERSION_2			2
> +#define SB_VERSION_3			3
>  #define SB_SECTORS			8
>  #define MAX_SECTORS_PER_BLOCK		8
>  
> @@ -60,12 +64,14 @@ struct superblock {
>  	__u64 provided_data_sectors;	/* userspace uses this value */
>  	__u32 flags;
>  	__u8 log2_sectors_per_block;
> -	__u8 pad[3];
> +	__u8 log2_blocks_per_bitmap_bit;
> +	__u8 pad[2];
>  	__u64 recalc_sector;
>  };
>  
>  #define SB_FLAG_HAVE_JOURNAL_MAC	0x1
>  #define SB_FLAG_RECALCULATING		0x2
> +#define SB_FLAG_DIRTY_BITMAP		0x4
>  
>  #define	JOURNAL_ENTRY_ROUNDUP		8
>  
> @@ -155,9 +161,16 @@ struct dm_integrity_c {
>  	struct workqueue_struct *metadata_wq;
>  	struct superblock *sb;
>  	unsigned journal_pages;
> +	unsigned n_bitmap_blocks;
> +
>  	struct page_list *journal;
>  	struct page_list *journal_io;
>  	struct page_list *journal_xor;
> +	struct page_list *recalc_bitmap;
> +	struct page_list *may_write_bitmap;
> +	struct bitmap_block_status *bbs;
> +	unsigned bitmap_flush_interval;
> +	struct delayed_work bitmap_flush_work;
>  
>  	struct crypto_skcipher *journal_crypt;
>  	struct scatterlist **journal_scatterlist;
> @@ -184,6 +197,7 @@ struct dm_integrity_c {
>  	__s8 log2_metadata_run;
>  	__u8 log2_buffer_sectors;
>  	__u8 sectors_per_block;
> +	__u8 log2_blocks_per_bitmap_bit;
>  
>  	unsigned char mode;
>  	int suspending;
> @@ -236,6 +250,7 @@ struct dm_integrity_c {
>  
>  	bool journal_uptodate;
>  	bool just_formatted;
> +	bool recalculate_flag;
>  
>  	struct alg_spec internal_hash_alg;
>  	struct alg_spec journal_crypt_alg;
> @@ -292,6 +307,16 @@ struct journal_io {
>  	struct journal_completion *comp;
>  };
>  
> +struct bitmap_block_status {
> +	struct work_struct work;
> +	struct dm_integrity_c *ic;
> +	unsigned idx;
> +	unsigned long *bitmap;
> +	struct bio_list bio_queue;
> +	spinlock_t bio_queue_lock;
> +
> +};
> +
>  static struct kmem_cache *journal_io_cache;
>  
>  #define JOURNAL_IO_MEMPOOL	32
> @@ -427,7 +452,9 @@ static void wraparound_section(struct dm
>  
>  static void sb_set_version(struct dm_integrity_c *ic)
>  {
> -	if (ic->meta_dev || ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))
> +	if (ic->mode == 'B' || ic->sb->flags & cpu_to_le32(SB_FLAG_DIRTY_BITMAP))
> +		ic->sb->version = SB_VERSION_3;
> +	else if (ic->meta_dev || ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))
>  		ic->sb->version = SB_VERSION_2;
>  	else
>  		ic->sb->version = SB_VERSION_1;
> @@ -451,6 +478,135 @@ static int sync_rw_sb(struct dm_integrit
>  	return dm_io(&io_req, 1, &io_loc, NULL);
>  }
>  
> +#define BITMAP_OP_TEST_ALL_SET		0
> +#define BITMAP_OP_TEST_ALL_CLEAR	1
> +#define BITMAP_OP_SET			2
> +#define BITMAP_OP_CLEAR			3
> +
> +static bool block_bitmap_op(struct dm_integrity_c *ic, struct page_list *bitmap, sector_t sector, sector_t n_sectors, int mode)
> +{
> +	unsigned long bit, end_bit, this_end_bit, page, end_page;
> +	unsigned long *data;
> +
> +	if (unlikely(((sector | n_sectors) & ((1 << ic->sb->log2_sectors_per_block) - 1)) != 0)) {
> +		DMCRIT("invalid bitmap access (%llx,%llx,%d,%d,%d)\n",
> +			(unsigned long long)sector,
> +			(unsigned long long)n_sectors,
> +			ic->sb->log2_sectors_per_block,
> +			ic->log2_blocks_per_bitmap_bit,
> +			mode);
> +		BUG();
> +	}

<snip>

> +
> +	if (unlikely(!n_sectors))
> +		return true;
> +
> +	bit = sector >> (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit);
> +	end_bit = (sector + n_sectors - 1) >> (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit);
> +
> +	page = bit / (PAGE_SIZE * 8);
> +	bit %= PAGE_SIZE * 8;
> +
> +	end_page = end_bit / (PAGE_SIZE * 8);
> +	end_bit %= PAGE_SIZE * 8;
> +
> +repeat:
> +	if (page < end_page) {
> +		this_end_bit = PAGE_SIZE * 8 - 1;
> +	} else {
> +		this_end_bit = end_bit;
> +	}
> +
> +	data = lowmem_page_address(bitmap[page].page);
> +
> +	if (mode == BITMAP_OP_TEST_ALL_SET) {
> +		while (bit <= this_end_bit) {
> +			if (!(bit % BITS_PER_LONG) && this_end_bit >= bit + BITS_PER_LONG - 1) {
> +				do {
> +					if (data[bit / BITS_PER_LONG] != -1)
> +						return false;
> +					bit += BITS_PER_LONG;
> +				} while (this_end_bit >= bit + BITS_PER_LONG - 1);
> +				continue;
> +			}
> +			if (!test_bit(bit, data))
> +				return false;
> +			bit++;
> +		}
> +	} else if (mode == BITMAP_OP_TEST_ALL_CLEAR) {
> +		while (bit <= this_end_bit) {
> +			if (!(bit % BITS_PER_LONG) && this_end_bit >= bit + BITS_PER_LONG - 1) {
> +				do {
> +					if (data[bit / BITS_PER_LONG] != 0)
> +						return false;
> +					bit += BITS_PER_LONG;
> +				} while (this_end_bit >= bit + BITS_PER_LONG - 1);
> +				continue;
> +			}
> +			if (test_bit(bit, data))
> +				return false;
> +			bit++;
> +		}
> +	} else if (mode == BITMAP_OP_SET) {
> +		while (bit <= this_end_bit) {
> +			if (!(bit % BITS_PER_LONG) && this_end_bit >= bit + BITS_PER_LONG - 1) {
> +				do {
> +					data[bit / BITS_PER_LONG] = -1;
> +					bit += BITS_PER_LONG;
> +				} while (this_end_bit >= bit + BITS_PER_LONG - 1);
> +				continue;
> +			}
> +			__set_bit(bit, data);
> +			bit++;
> +		}
> +	} else if (mode == BITMAP_OP_CLEAR) {
> +		if (!bit && this_end_bit == PAGE_SIZE * 8 - 1)
> +			clear_page(data);
> +		else while (bit <= this_end_bit) {
> +			if (!(bit % BITS_PER_LONG) && this_end_bit >= bit + BITS_PER_LONG - 1) {
> +				do {
> +					data[bit / BITS_PER_LONG] = 0;
> +					bit += BITS_PER_LONG;
> +				} while (this_end_bit >= bit + BITS_PER_LONG - 1);
> +				continue;
> +			}
> +			__clear_bit(bit, data);
> +			bit++;
> +		}
> +	} else {
> +		BUG();
> +	}

<snip>

> +static struct bitmap_block_status *sector_to_bitmap_block(struct dm_integrity_c *ic, sector_t sector)
> +{
> +	unsigned bit = sector >> (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit);
> +	unsigned bitmap_block = bit / (BITMAP_BLOCK_SIZE * 8);
> +
> +	BUG_ON(bitmap_block >= ic->n_bitmap_blocks);
> +	return &ic->bbs[bitmap_block];
> +}
> +

Too many BUG()s and BUG_ON.  The BUG_ON could be left if you think it
sufficiently unlikely.

But in general I'd prefer factoring out an &error return but needing to
check for such a return would slow things down.. so that's probably not
an option.

Maybe we just set a new 'invalid' flag and disallow all operations and
fail IO?  Point is it is really bad to crash the system because
dm-integrity lost its way.  Instead we should just mark the device
invalid (like dm-snapshot does).

Mike
