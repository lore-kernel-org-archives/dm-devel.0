From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH RFCv2 02/10] dm-dedup: core deduplication
	logic
Date: Mon, 2 Feb 2015 10:23:50 -0500
Message-ID: <20150202152350.GB3588@redhat.com>
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

Hi,

Spend some time looking at this patch. Few comments are inline.

> +static void process_bio(struct dedup_config *dc, struct bio *bio)
> +{
> +	switch (bio_data_dir(bio)) {
> +	case READ:
> +		handle_read(dc, bio);
> +		break;
> +	case WRITE:
> +		handle_write(dc, bio);
> +		break;
> +	default:
> +		DMERR("Unknown request type!");
> +		bio_endio(bio, -EINVAL);
> +	}

I guess some of this error checking could go in map function and if bio is
not of desired type and return error right then and there.

> +}
> +
> +static void do_work(struct work_struct *ws)
> +{
> +	struct dedup_work *data = container_of(ws, struct dedup_work, worker);
> +	struct dedup_config *dc = (struct dedup_config *)data->config;
> +	struct bio *bio = (struct bio *)data->bio;
> +
> +	mempool_free(data, dc->dedup_work_pool);
> +
> +	process_bio(dc, bio);
> +}
> +
> +static void dedup_defer_bio(struct dedup_config *dc, struct bio *bio)
> +{
> +	struct dedup_work *data;
> +
> +	data = mempool_alloc(dc->dedup_work_pool, GFP_NOIO);
> +	if (!data) {
> +		bio_endio(bio, -ENOMEM);
> +		return;
> +	}

So why are we allocating one work struct for each bio. Why not have a 
work struct embedded in say dedup_config and queue incoming bios in a
list and wake up worker. And worker will go through list of bios and
process bios. 

Does not look like there is a need to create one work struct for each
bio.

Please look at other targets how they have handled it.


[..]
> +static int dm_dedup_ctr_fn(struct dm_target *ti, unsigned int argc, char **argv)
> +{
> +	struct dedup_args *da;
> +	struct dedup_config *dc;
> +	struct workqueue_struct *wq;
> +
> +	struct init_param_inram iparam_inram;
> +	struct init_param_cowbtree iparam_cowbtree;
> +	void *iparam;
> +	struct metadata *md = NULL;
> +
> +	uint64_t data_size;
> +	int r;
> +	int crypto_key_size;
> +
> +	struct on_disk_stats *data = NULL;
> +	uint64_t logical_block_counter = 0;
> +	uint64_t physical_block_counter = 0;
> +
> +	uint32_t flushrq = 0;
> +	mempool_t *dedup_work_pool = NULL;
> +
> +	bool unformatted;
> +
> +	da = kzalloc(sizeof(*da), GFP_KERNEL);
> +	if (!da) {
> +		ti->error = "Error allocating memory for dedup arguments";
> +		return -ENOMEM;
> +	}
> +
> +	da->ti = ti;
> +
> +	r = parse_dedup_args(da, argc, argv, &ti->error);
> +	if (r)
> +		goto out;
> +
> +	dc = kmalloc(sizeof(*dc), GFP_NOIO);
> +	if (!dc) {
> +		ti->error = "Error allocating memory for dedup config";
> +		r = -ENOMEM;
> +		goto out;
> +	}
> +
> +	wq = create_singlethread_workqueue("dm-dedup");
> +	if (!wq) {
> +		ti->error = "failed to create workqueue";
> +		r = -ENOMEM;
> +		goto bad_wq;
> +	}
> +
> +	dedup_work_pool = mempool_create_kmalloc_pool(MIN_DEDUP_WORK_IO,
> +						sizeof(struct dedup_work));
> +	if (!dedup_work_pool) {
> +		r = -ENOMEM;
> +		ti->error = "failed to create mempool";
> +		goto bad_mempool;
> +	}
> +
> +	dc->io_client = dm_io_client_create();
> +	if (IS_ERR(dc->io_client)) {
> +		r = PTR_ERR(dc->io_client);
> +		ti->error = "failed to create dm_io_client";
> +		goto bad_io_client;
> +	}
> +
> +	dc->block_size = da->block_size;
> +	dc->sectors_per_block = to_sector(da->block_size);
> +	dc->lblocks = ti->len / dc->sectors_per_block;
> +
> +	data_size = i_size_read(da->data_dev->bdev->bd_inode);
> +	dc->pblocks = data_size / da->block_size;
> +
> +	/* Meta-data backend specific part */
> +	if (da->backend == BKND_INRAM) {
> +		dc->mdops = &metadata_ops_inram;
> +		iparam_inram.blocks = dc->pblocks;
> +		iparam = &iparam_inram;
> +	} else if (da->backend == BKND_COWBTREE) {
> +		r = -EINVAL;
> +		dc->mdops = &metadata_ops_cowbtree;
> +		iparam_cowbtree.blocks = dc->pblocks;
> +		iparam_cowbtree.metadata_bdev = da->meta_dev->bdev;
> +		iparam = &iparam_cowbtree;
> +	} else
> +		BUG();
> +
> +	md = dc->mdops->init_meta(iparam, &unformatted);
> +	if (IS_ERR(md)) {
> +		ti->error = "failed to initialize backend metadata";
> +		r = PTR_ERR(md);
> +		goto bad_metadata_init;
> +	}
> +
> +	dc->desc_table = desc_table_init(da->hash_algo);
> +	if (!dc->desc_table || IS_ERR(dc->desc_table)) {
> +		ti->error = "failed to initialize crypto API";
> +		r = PTR_ERR(dc->desc_table);
> +		goto bad_metadata_init;
> +	}
> +
> +	crypto_key_size = get_hash_digestsize(dc->desc_table);

Looks like this function has been defined in patch3 but used in patch2.
That means compilation will fail only if series is applied till patch 2.
That's not a good idea. You patch series should be bisectable.

So any definitions you want to use, introduce them first.

Seconly I had a quick look at patch 3 and this function also seems to
be doing following.

+
+       slot = get_next_slot(desc_table);
+       desc = slot_to_desc(desc_table, slot);

This is odd. This function is supposed to return the size of hash and
not do extra magic of getting next free slot and then getting to desc
associated with slot.

Break out this logic in separate function appropriately.

[..]
> +static int dm_dedup_message_fn(struct dm_target *ti,
> +				unsigned argc, char **argv)
> +{
> +	int r = 0;
> +

I think we should document these messages in documentation file and
explain what do they do.

Also looks like mark_and sweep has been replaced by garbage_collect later,
why?

> +	struct dedup_config *dc = ti->private;
> +
> +	if (!strcasecmp(argv[0], "mark_and_sweep")) {
> +		r = mark_and_sweep(dc);
> +		if (r < 0)
> +			DMERR("Error in performing mark_and_sweep: %d.", r);
> +	} else if (!strcasecmp(argv[0], "drop_bufio_cache")) {
> +		if (dc->mdops->flush_bufio_cache)
> +			dc->mdops->flush_bufio_cache(dc->bmd);
> +		else
> +			r = -ENOTSUPP;
> +	} else
> +		r = -EINVAL;
> +
> +	return r;
> +}
> +
> +static int dm_dedup_endio_fn(struct dm_target *ti, struct bio *bio, int error)
> +{
> +	if (error || bio_data_dir(bio) != READ)
> +		return 0;
> +
> +	return 0;
> +}

So this function always returns 0. What's the point of that if block then?

Thanks
Vivek
