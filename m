From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH v2] dm-integrity: Prevent RMW for full metadata
 buffer writes
Date: Mon, 30 Mar 2020 12:34:04 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2003301215050.8032@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200227142601.61f3cd54@luklap>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200227142601.61f3cd54@luklap>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Straub <lukasstraub2@web.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, dm-devel <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

I tested it on my rotational disk:


On Thu, 27 Feb 2020, Lukas Straub wrote:

> If a full metadata buffer is being written, don't read it first. This
> prevents a read-modify-write cycle and increases performance on HDDs
> considerably.
> 
> To do this we now calculate the checksums for all sectors in the bio in one
> go in integrity_metadata and then pass the result to dm_integrity_rw_tag,
> which now checks if we overwrite the whole buffer.
> 
> Benchmarking with a 5400RPM HDD with bitmap mode:
> integritysetup format --no-wipe --batch-mode --interleave-sectors $((64*1024)) -t 4 -s 512 -I crc32c -B /dev/sdc
> integritysetup open --buffer-sectors=1 -I crc32c -B /dev/sdc hdda_integ
> dd if=/dev/zero of=/dev/mapper/hdda_integ bs=64K count=$((16*1024*4)) conv=fsync oflag=direct status=progress
> 
> Without patch:
> 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 400.326 s, 10.7 MB/s

I get 42.3 MB/s. (it seems that my disk has better prefetch than yours).

> With patch:
> 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 41.2057 s, 104 MB/s

I get 110 MB/s.

> Signed-off-by: Lukas Straub <lukasstraub2@web.de>

BUT: when I removed "--buffer-sectors=1" from the command line, I've got 
these numbers:
without the patch: 101 MB/s
with the patch: 101 MB/s

So, you crippled performance with "--buffer-sectors=1" and then made a 
patch to restore it.

The patch only helps 10%.

Mikulas


> ---
> Hello Everyone,
> So here is v2, now checking if we overwrite a whole metadata buffer instead
> of the (buggy) check if we overwrite a whole tag area before.
> Performance stayed the same (with --buffer-sectors=1).
> 
> The only quirk now is that it advertises a very big optimal io size in the
> standard configuration (where buffer_sectors=128). Is this a Problem?
> 
> v2:
>  -fix dm_integrity_rw_tag to check if we overwrite a whole metadat buffer
>  -fix optimal io size to check if we overwrite a whole metadata buffer
> 
> Regards,
> Lukas Straub
> 
>  drivers/md/dm-integrity.c | 81 +++++++++++++++++++++++----------------
>  1 file changed, 47 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index b225b3e445fa..a6d3cf1406df 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -1309,9 +1309,17 @@ static int dm_integrity_rw_tag(struct dm_integrity_c *ic, unsigned char *tag, se
>  		if (unlikely(r))
>  			return r;
> 
> -		data = dm_bufio_read(ic->bufio, *metadata_block, &b);
> -		if (IS_ERR(data))
> -			return PTR_ERR(data);
> +		/* Don't read metadata sectors from disk if we're going to overwrite them completely */
> +		if (op == TAG_WRITE && *metadata_offset == 0 \
> +			&& total_size >= (1U << SECTOR_SHIFT << ic->log2_buffer_sectors)) {
> +			data = dm_bufio_new(ic->bufio, *metadata_block, &b);
> +			if (IS_ERR(data))
> +				return PTR_ERR(data);
> +		} else {
> +			data = dm_bufio_read(ic->bufio, *metadata_block, &b);
> +			if (IS_ERR(data))
> +				return PTR_ERR(data);
> +		}
> 
>  		to_copy = min((1U << SECTOR_SHIFT << ic->log2_buffer_sectors) - *metadata_offset, total_size);
>  		dp = data + *metadata_offset;
> @@ -1514,6 +1522,8 @@ static void integrity_metadata(struct work_struct *w)
>  {
>  	struct dm_integrity_io *dio = container_of(w, struct dm_integrity_io, work);
>  	struct dm_integrity_c *ic = dio->ic;
> +	unsigned sectors_to_process = dio->range.n_sectors;
> +	sector_t sector = dio->range.logical_sector;
> 
>  	int r;
> 
> @@ -1522,16 +1532,14 @@ static void integrity_metadata(struct work_struct *w)
>  		struct bio_vec bv;
>  		unsigned digest_size = crypto_shash_digestsize(ic->internal_hash);
>  		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
> -		char *checksums;
> +		char *checksums, *checksums_ptr;
>  		unsigned extra_space = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
>  		char checksums_onstack[HASH_MAX_DIGESTSIZE];
> -		unsigned sectors_to_process = dio->range.n_sectors;
> -		sector_t sector = dio->range.logical_sector;
> 
>  		if (unlikely(ic->mode == 'R'))
>  			goto skip_io;
> 
> -		checksums = kmalloc((PAGE_SIZE >> SECTOR_SHIFT >> ic->sb->log2_sectors_per_block) * ic->tag_size + extra_space,
> +		checksums = kmalloc((dio->range.n_sectors >> ic->sb->log2_sectors_per_block) * ic->tag_size + extra_space,
>  				    GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN);
>  		if (!checksums) {
>  			checksums = checksums_onstack;
> @@ -1542,49 +1550,45 @@ static void integrity_metadata(struct work_struct *w)
>  			}
>  		}
> 
> +		checksums_ptr = checksums;
>  		__bio_for_each_segment(bv, bio, iter, dio->orig_bi_iter) {
>  			unsigned pos;
> -			char *mem, *checksums_ptr;
> -
> -again:
> +			char *mem;
>  			mem = (char *)kmap_atomic(bv.bv_page) + bv.bv_offset;
>  			pos = 0;
> -			checksums_ptr = checksums;
>  			do {
>  				integrity_sector_checksum(ic, sector, mem + pos, checksums_ptr);
> -				checksums_ptr += ic->tag_size;
> -				sectors_to_process -= ic->sectors_per_block;
> +
> +				if (likely(checksums != checksums_onstack)) {
> +					checksums_ptr += ic->tag_size;
> +				} else {
> +					r = dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->metadata_offset,
> +								ic->tag_size, !dio->write ? TAG_CMP : TAG_WRITE);
> +					if (unlikely(r))
> +						goto internal_hash_error;
> +				}
> +
>  				pos += ic->sectors_per_block << SECTOR_SHIFT;
>  				sector += ic->sectors_per_block;
> -			} while (pos < bv.bv_len && sectors_to_process && checksums != checksums_onstack);
> +				sectors_to_process -= ic->sectors_per_block;
> +			} while (pos < bv.bv_len && sectors_to_process);
>  			kunmap_atomic(mem);
> 
> -			r = dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->metadata_offset,
> -						checksums_ptr - checksums, !dio->write ? TAG_CMP : TAG_WRITE);
> -			if (unlikely(r)) {
> -				if (r > 0) {
> -					DMERR_LIMIT("Checksum failed at sector 0x%llx",
> -						    (unsigned long long)(sector - ((r + ic->tag_size - 1) / ic->tag_size)));
> -					r = -EILSEQ;
> -					atomic64_inc(&ic->number_of_mismatches);
> -				}
> -				if (likely(checksums != checksums_onstack))
> -					kfree(checksums);
> -				goto error;
> -			}
> -
>  			if (!sectors_to_process)
>  				break;
> +		}
> 
> -			if (unlikely(pos < bv.bv_len)) {
> -				bv.bv_offset += pos;
> -				bv.bv_len -= pos;
> -				goto again;
> +		if (likely(checksums != checksums_onstack)) {
> +			r = dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->metadata_offset,
> +						(dio->range.n_sectors >> ic->sb->log2_sectors_per_block) * ic->tag_size,
> +						!dio->write ? TAG_CMP : TAG_WRITE);
> +			if (unlikely(r)) {
> +				kfree(checksums);
> +				goto internal_hash_error;
>  			}
> +			kfree(checksums);
>  		}
> 
> -		if (likely(checksums != checksums_onstack))
> -			kfree(checksums);
>  	} else {
>  		struct bio_integrity_payload *bip = dio->orig_bi_integrity;
> 
> @@ -1615,6 +1619,13 @@ static void integrity_metadata(struct work_struct *w)
>  skip_io:
>  	dec_in_flight(dio);
>  	return;
> +internal_hash_error:
> +	if (r > 0) {
> +		DMERR_LIMIT("Checksum failed at sector 0x%llx",
> +				(unsigned long long)(sector - ((r + ic->tag_size - 1) / ic->tag_size)));
> +		r = -EILSEQ;
> +		atomic64_inc(&ic->number_of_mismatches);
> +	}
>  error:
>  	dio->bi_status = errno_to_blk_status(r);
>  	dec_in_flight(dio);
> @@ -3019,6 +3030,8 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
>  		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
>  		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
>  	}
> +
> +	blk_limits_io_opt(limits, 1U << SECTOR_SHIFT << ic->log2_buffer_sectors >> ic->log2_tag_size << SECTOR_SHIFT );
>  }
> 
>  static void calculate_journal_section_size(struct dm_integrity_c *ic)
> --
> 2.20.1
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
