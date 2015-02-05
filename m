From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH RFCv2 02/10] dm-dedup: core deduplication
	logic
Date: Thu, 5 Feb 2015 15:21:01 -0500
Message-ID: <20150205202101.GA407@redhat.com>
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
> +static void handle_read(struct dedup_config *dc, struct bio *bio)
> +{
> +	uint64_t lbn;
> +	uint32_t vsize;
> +	struct lbn_pbn_value lbnpbn_value;
> +	int r;
> +
> +	lbn = bio_lbn(dc, bio);
> +
> +	r = dc->kvs_lbn_pbn->kvs_lookup(dc->kvs_lbn_pbn, (void *)&lbn,
> +			sizeof(lbn), (void *)&lbnpbn_value, &vsize);
> +	if (r == 0)
> +		bio_zero_endio(bio);
> +	else if (r == 1)
> +		do_io(dc, bio, lbnpbn_value.pbn);
> +	else
> +		BUG();

kvs_lookup() return values look little odd to me. I am wondering how
this function will ever return any errors. Because if it returns error,
we will call BUG().

I think this function should return 0 upon success and negative error
code in case of error. And that error code should be propagated upwards.

To differentiate between whether key was found or not, may be you
can set vsize to zero before calling the function and check vsize
value after the call. If it is non zero, you know key has been
found.

> +}
> +
> +static int allocate_block(struct dedup_config *dc, uint64_t *pbn_new)
> +{
> +	int r;
> +
> +	r = dc->mdops->alloc_data_block(dc->bmd, pbn_new);
> +
> +	if (!r) {
> +		dc->logical_block_counter++;

I am not sure why we are bumping up logical_block_counter here. Right
now we are just allocating a physical block and that has nothing to
do with bumping up logical block count.

> +		dc->physical_block_counter++;
> +	}
> +
> +	return r;
> +}
> +
> +static int write_to_new_block(struct dedup_config *dc, uint64_t *pbn_new,
> +				struct bio *bio, uint64_t lbn)
> +{
> +	int r = 0;
> +	struct lbn_pbn_value lbnpbn_value;
> +
> +	r = allocate_block(dc, pbn_new);
> +	if (r < 0) {
> +		r = -EIO;

Is this a common practice to overwrite error code with -EIO?

> +		return r;
> +	}
> +
> +	lbnpbn_value.pbn = *pbn_new;
> +
> +	do_io(dc, bio, *pbn_new);
> +
> +	r = dc->kvs_lbn_pbn->kvs_insert(dc->kvs_lbn_pbn, (void *)&lbn,
> +		sizeof(lbn), (void *)&lbnpbn_value, sizeof(lbnpbn_value));
> +	if (r < 0)
> +		BUG();
> +

I think everywhere we need to fix this BUG() thing. If there is an error
propagate it upwards instead of saying bug. Let the IO fail but why
crash the OS?

Also I am assuming that kvs_insert() is going to allocate memory. What
if that memory allocation fails. Write to block will succeed but we will
never create an entry in lbn to pbn kvs and next time read comes, we can't
read that data and lost the data?

I think this needs to be though through more properly and one needs to
think about all the corner error cases.

Thanks
Vivek
