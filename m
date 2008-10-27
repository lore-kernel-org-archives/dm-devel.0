From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: [PATCH 7/9] dm snapshot: add shared exception store
Date: Mon, 27 Oct 2008 12:55:38 -0400
Message-ID: <20081027165538.GA27667@mars.virtualiron.com>
References: <1225109276-16491-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1225109276-16491-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Mon, Oct 27, 2008 at 09:07:54PM +0900, FUJITA Tomonori wrote:
> This adds a new exception store implementation, shared exception
> store. The important design differences from the current two exception
> store implementations:
> 
> - It uses one exception store (cow disk) per origin device that is
>   shared by all snapshots.
> - It doesn't keep the complete exception tables in memory.
> 
> The shared exception store uses struct pstore, which the persistent
> exception store uses because there are many useful functions that
> struct pstore works with. The shared exception adds some variants to
> struct pstore, but not many.

Thank you for posting this. I've just two questions:

... 
> +static unsigned long shared_allocate_chunk(struct pstore *ps)
> +{
> +	unsigned long idx;
> +	unsigned long limit;
> +	unsigned long start_chunk;
> +	unsigned long nr = (ps->snap->chunk_size << SECTOR_SHIFT) * 8;
> +
> +	start_chunk = ps->cur_bitmap_chunk;
> +again:
> +	if (ps->cur_bitmap_chunk == ps->nr_bitmap_chunks)
> +		limit = ps->nr_chunks - (nr * (ps->nr_bitmap_chunks - 1));

Is this correct? If the chunk size is 16 the nr_chunks would be the bit-shift
value (5). Hence you are subtracting 8192*(some positivie number)-1 from 5 -
is that what you intend to do?

> +	else
> +		limit = nr;
> +
> +	idx = find_next_zero_bit(ps->bitmap, limit, ps->cur_bitmap_index);
> +	if (idx < limit) {
> +		set_bit(idx, ps->bitmap);
> +
> +		if (idx == limit - 1) {
> +			ps->cur_bitmap_index = 0;
> +
> +			read_new_bitmap_chunk(ps);
> +		} else
> +			ps->cur_bitmap_index++;
> +	} else {
> +		chunk_io(ps, ps->cur_bitmap_chunk, WRITE, 1, ps->bitmap);
> +
> +		read_new_bitmap_chunk(ps);
> +
> +		/* todo: check # free chunks */
> +		if (start_chunk == ps->cur_bitmap_chunk) {
> +			DMERR("%s %d: fail to find a new chunk",
> +			      __func__, __LINE__);
> +			return 0;
> +		}
> +
> +		goto again;
> +	}
> +
> +	return idx + (ps->cur_bitmap_chunk - FIRST_BITMAP_CHUNK) * nr;

.. snip..
> +static int shared_create_bitmap(struct exception_store *store)
> +{
> +	struct pstore *ps = get_info(store);
> +	int i, r, rest, this;
> +	chunk_t chunk;
> +
> +	/* bitmap + superblock */
> +	rest = ps->nr_bitmap_chunks + 1;
> +
> +	for (chunk = 0; chunk < ps->nr_bitmap_chunks; chunk++) {
> +		memset(ps->area, 0, ps->snap->chunk_size << SECTOR_SHIFT);
> +
> +		this = min_t(int, rest, ps->snap->chunk_size * 512 * 8);

512? Why not do the << SECTOR_SHIFT as in the other places?

> +		if (this) {
> +			rest -= this;
> +
> +			memset(ps->area, 0xff, this / 8);
> +
> +			for (i = 0; i < this % 8; i++)
> +				set_bit(i, (unsigned long *)ps->area + this / 8);
> +		}
> +
> +		r = chunk_io(ps, chunk + FIRST_BITMAP_CHUNK, WRITE, 1,
> +			     ps->area);
> +		if (r)
> +			return r;
> +	}
> +
> +	return 0;
