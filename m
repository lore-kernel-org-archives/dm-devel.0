From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH RFCv2 02/10] dm-dedup: core deduplication
	logic
Date: Fri, 6 Feb 2015 11:53:42 -0500
Message-ID: <20150206165342.GB9165@redhat.com>
References: <53ffb64e.4443320a.4df1.28ed@mx.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <53ffb64e.4443320a.4df1.28ed@mx.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vasily Tarasov <tarasov@vasily.name>
Cc: Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

On Thu, Aug 28, 2014 at 06:02:11PM -0400, Vasily Tarasov wrote:

[..]
> +/*
> + * Creates a bitmap of all PBNs in use by walking through
> + * kvs_lbn_pbn. Then walks through kvs_hash_pbn and deletes
> + * any entries which do not have an lbn-to-pbn mapping.
> + */
> +static int mark_and_sweep(struct dedup_config *dc)
> +{
> +	int err = 0;
> +	uint64_t data_size = 0;
> +	uint64_t bitmap_size = 0;
> +	struct mark_and_sweep_data ms_data;
> +
> +	BUG_ON(!dc);
> +
> +	data_size = i_size_read(dc->data_dev->bdev->bd_inode);
> +	bitmap_size = data_size / dc->block_size;
> +
> +	memset(&ms_data, 0, sizeof(struct mark_and_sweep_data));
> +
> +	ms_data.bitmap = vmalloc(BITS_TO_LONGS(bitmap_size) *
> +			sizeof(unsigned long));
> +	if (!ms_data.bitmap) {
> +		DMERR("Could not vmalloc ms_data.bitmap");
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +	bitmap_zero(ms_data.bitmap, bitmap_size);
> +
> +	ms_data.bitmap_len = bitmap_size;
> +	ms_data.cleanup_count = 0;
> +	ms_data.dc = dc;
> +
> +	/* Create bitmap of used pbn blocks */
> +	err = dc->kvs_lbn_pbn->kvs_iterate(dc->kvs_lbn_pbn,
> +			&mark_lbn_pbn_bitmap, (void *)&ms_data);
> +	if (err < 0)
> +		goto out_free;
> +
> +	/* Cleanup hashes based on above bitmap of used pbn blocks */
> +	err = dc->kvs_hash_pbn->kvs_iterate(dc->kvs_hash_pbn,
> +			&cleanup_hash_pbn, (void *)&ms_data);

How does the locking work in general for this target. So far I have not
seen any locks being taken anywhere. I want to know what's the thought
process and what locks are where and what are they protecting.

For example, here, we create a bitmap of unused pbn first and then
go on to remove those pbn. How do we know that some unused pbn
did not get reused again by the time we called cleanup_hash_pbn.

I see that last patch in the series removed mark_and_sweep logic
and replaced with garbage_collect. Please rework the series so that
mark_and_sweep is not introduced to begin with.

Thanks
Vivek
