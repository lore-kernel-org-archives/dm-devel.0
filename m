From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: add secdel target
Date: Thu, 18 Oct 2018 16:01:25 -0400
Message-ID: <20181018200124.GA6996@redhat.com>
References: <20181014112439.8119-1-vt@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181014112439.8119-1-vt@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Chikunov <vt@altlinux.org>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Jonathan Corbet <corbet@lwn.net>, Shaohua Li <shli@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Sun, Oct 14 2018 at  7:24am -0400,
Vitaly Chikunov <vt@altlinux.org> wrote:

> Report to the upper level ability to discard, and translate arriving
> discards to the writes of random or zero data to the underlying level.
> 
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> ---
>   This target is the same as the linear target except that is reports ability to
>   discard to the upper level and translates arriving discards into sector
>   overwrites with random (or zero) data.

There is a fair amount of code duplication between dm-linear.c and this
new target.

Something needs to give, ideally you'd factor out methods that are
shared by both targets, but those methods must _not_ introduce overhead
to dm-linear.

Could be that dm-linear methods just get called by the wrapper
dm-sec-erase target (more on the "dm-sec-erase" name below).
 
>   The target does not try to determine if the underlying drive reliably supports
>   data overwrites, this decision is solely on the discretion of a user.
> 
>   It may be useful to create a secure deletion setup when filesystem when
>   unlinking a file sends discards to its sectors, in this target they are
>   translated to writes that wipe deleted data on the underlying drive.
> 
>   Tested on x86.

All of this extra context and explanation needs to be captured in the
actual patch header.  Not as a tangent in that "cut" section of your
patch header.
 
>  Documentation/device-mapper/dm-secdel.txt |  24 ++
>  drivers/md/Kconfig                        |  14 ++
>  drivers/md/Makefile                       |   2 +
>  drivers/md/dm-secdel.c                    | 399 ++++++++++++++++++++++++++++++
>  4 files changed, 439 insertions(+)
>  create mode 100644 Documentation/device-mapper/dm-secdel.txt
>  create mode 100644 drivers/md/dm-secdel.c

<snip>

Shouldn't this target be implementing all that is needed for
REQ_OP_SECURE_ERASE support?  And the resulting DM device would
advertise its capability using QUEUE_FLAG_SECERASE?

And this is why I think the target should be named "dm-sec-erase" or
even "dm-secure-erase".

> diff --git a/drivers/md/dm-secdel.c b/drivers/md/dm-secdel.c
> new file mode 100644
> index 000000000000..9aeaf3f243c0
> --- /dev/null
> +++ b/drivers/md/dm-secdel.c

<snip>

> +/*
> + * Send amount of masking data to the device
> + * @mode: 0 to write zeros, otherwise to write random data
> + */
> +static int issue_erase(struct block_device *bdev, sector_t sector,
> +		       sector_t nr_sects, gfp_t gfp_mask, enum secdel_mode mode)
> +{
> +	int ret = 0;
> +
> +	while (nr_sects) {
> +		struct bio *bio;
> +		unsigned int nrvecs = min(nr_sects,
> +					  (sector_t)BIO_MAX_PAGES >> 3);
> +
> +		bio = bio_alloc(gfp_mask, nrvecs);

You should probably be using your own bioset to allocate these bios.

> +		if (!bio) {
> +			DMERR("%s %lu[%lu]: no memory to allocate bio (%u)",
> +			      __func__, sector, nr_sects, nrvecs);
> +			ret = -ENOMEM;
> +			break;
> +		}
> +
> +		bio->bi_iter.bi_sector = sector;
> +		bio_set_dev(bio, bdev);
> +		bio->bi_end_io = bio_end_erase;
> +
> +		while (nr_sects != 0) {
> +			unsigned int sn;
> +			struct page *page = NULL;
> +
> +			sn = min((sector_t)PAGE_SIZE >> 9, nr_sects);
> +			if (mode == SECDEL_MODE_RAND) {
> +				page = alloc_page(gfp_mask);
> +				if (!page) {
> +					DMERR("%s %lu[%lu]: no memory to allocate page for random data",
> +					      __func__, sector, nr_sects);
> +					/* will fallback to zero filling */

In general, performing memory allocations to service IO is something all
DM core and DM targets must work to avoid.  This smells bad.

...

> +
> +/* convert discards into writes */
> +static int secdel_map_discard(struct dm_target *ti, struct bio *sbio)
> +{
> +	struct secdel_c *lc = ti->private;
> +	struct block_device *bdev = lc->dev->bdev;
> +	sector_t sector = sbio->bi_iter.bi_sector;
> +	sector_t nr_sects = bio_sectors(sbio);
> +
> +	lc->requests++;
> +	if (!bio_sectors(sbio))
> +		return 0;
> +	if (!op_discard(sbio))
> +		return 0;
> +	lc->discards++;
> +	if (WARN_ON(sbio->bi_vcnt != 0))
> +		return -1;
> +	DMDEBUG("DISCARD %lu: %u sectors M%d", sbio->bi_iter.bi_sector,
> +		bio_sectors(sbio), lc->mode);
> +	bio_endio(sbio);
> +
> +	if (issue_erase(bdev, sector, nr_sects, GFP_NOFS, lc->mode))

At a minimum this should be GFP_NOIO.  You don't want to recurse into
block (and potentially yourself) in the face of low memory.

> +static int secdel_end_io(struct dm_target *ti, struct bio *bio,
> +			 blk_status_t *error)
> +{
> +	struct secdel_c *lc = ti->private;
> +
> +	if (!*error && bio_op(bio) == REQ_OP_ZONE_REPORT)
> +		dm_remap_zone_report(ti, bio, lc->start);
> +
> +	return DM_ENDIO_DONE;
> +}

Perfect example of why this new target shouldn't be doing a point in
time copy of dm-linear code.

With 4.20's upcoming zoned device changes dm-linear no longer even has
an end_io hook (which was introduced purely for REQ_OP_ZONE_REPORT's
benefit).

Mike
