From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v5 01/11] block: make generic_make_request handle
 arbitrarily sized bios
Date: Fri, 31 Jul 2015 15:23:38 -0400
Message-ID: <20150731192337.GA8907@redhat.com>
References: <1436168690-32102-1-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436168690-32102-1-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, Ming Lin <ming.l@ssi.samsung.com>
List-Id: dm-devel.ids

On Mon, Jul 06 2015 at  3:44P -0400,
Ming Lin <mlin@kernel.org> wrote:

> From: Kent Overstreet <kent.overstreet@gmail.com>
> 
> The way the block layer is currently written, it goes to great lengths
> to avoid having to split bios; upper layer code (such as bio_add_page())
> checks what the underlying device can handle and tries to always create
> bios that don't need to be split.
> 
> But this approach becomes unwieldy and eventually breaks down with
> stacked devices and devices with dynamic limits, and it adds a lot of
> complexity. If the block layer could split bios as needed, we could
> eliminate a lot of complexity elsewhere - particularly in stacked
> drivers. Code that creates bios can then create whatever size bios are
> convenient, and more importantly stacked drivers don't have to deal with
> both their own bio size limitations and the limitations of the
> (potentially multiple) devices underneath them.  In the future this will
> let us delete merge_bvec_fn and a bunch of other code.
> 
> We do this by adding calls to blk_queue_split() to the various
> make_request functions that need it - a few can already handle arbitrary
> size bios. Note that we add the call _after_ any call to
> blk_queue_bounce(); this means that blk_queue_split() and
> blk_recalc_rq_segments() don't need to be concerned with bouncing
> affecting segment merging.
> 
> Some make_request_fn() callbacks were simple enough to audit and verify
> they don't need blk_queue_split() calls. The skipped ones are:
> 
>  * nfhd_make_request (arch/m68k/emu/nfblock.c)
>  * axon_ram_make_request (arch/powerpc/sysdev/axonram.c)
>  * simdisk_make_request (arch/xtensa/platforms/iss/simdisk.c)
>  * brd_make_request (ramdisk - drivers/block/brd.c)
>  * mtip_submit_request (drivers/block/mtip32xx/mtip32xx.c)
>  * loop_make_request
>  * null_queue_bio
>  * bcache's make_request fns
> 
> Some others are almost certainly safe to remove now, but will be left
> for future patches.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Ming Lei <ming.lei@canonical.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
> Cc: drbd-user@lists.linbit.com
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Jim Paris <jim@jtan.com>
> Cc: Joshua Morris <josh.h.morris@us.ibm.com>
> Cc: Philip Kelleher <pjk1939@linux.vnet.ibm.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Oleg Drokin <oleg.drokin@intel.com>
> Cc: Andreas Dilger <andreas.dilger@intel.com>
> Acked-by: NeilBrown <neilb@suse.de> (for the 'md/md.c' bits)
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> [dpark: skip more mq-based drivers, resolve merge conflicts, etc.]
> Signed-off-by: Dongsu Park <dpark@posteo.net>
> Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
...
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 30a0d9f..3707f30 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -9,12 +9,158 @@
>  
>  #include "blk.h"
>  
> +static struct bio *blk_bio_discard_split(struct request_queue *q,
> +					 struct bio *bio,
> +					 struct bio_set *bs)
> +{
> +	unsigned int max_discard_sectors, granularity;
> +	int alignment;
> +	sector_t tmp;
> +	unsigned split_sectors;
> +
> +	/* Zero-sector (unknown) and one-sector granularities are the same.  */
> +	granularity = max(q->limits.discard_granularity >> 9, 1U);
> +
> +	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
> +	max_discard_sectors -= max_discard_sectors % granularity;
> +
> +	if (unlikely(!max_discard_sectors)) {
> +		/* XXX: warn */
> +		return NULL;
> +	}
> +
> +	if (bio_sectors(bio) <= max_discard_sectors)
> +		return NULL;
> +
> +	split_sectors = max_discard_sectors;
> +
> +	/*
> +	 * If the next starting sector would be misaligned, stop the discard at
> +	 * the previous aligned sector.
> +	 */
> +	alignment = (q->limits.discard_alignment >> 9) % granularity;
> +
> +	tmp = bio->bi_iter.bi_sector + split_sectors - alignment;
> +	tmp = sector_div(tmp, granularity);
> +
> +	if (split_sectors > tmp)
> +		split_sectors -= tmp;
> +
> +	return bio_split(bio, split_sectors, GFP_NOIO, bs);
> +}

This code to stop the discard at the previous aligned sector could be
the reason why I have 2 device-mapper-test-suite tests in the
'thin-provisioning' testsuite failing due to this patchset:

  4) Failure:
test_discard_a_fragmented_device(DiscardQuickTests)
    [/root/snitm/git/device-mapper-test-suite/lib/dmtest/tests/thin-provisioning/discard_tests.rb:49:in `block in assert_no_mappings'
     /root/snitm/git/device-mapper-test-suite/lib/dmtest/tests/thin-provisioning/discard_tests.rb:43:in `call'
     /root/snitm/git/device-mapper-test-suite/lib/dmtest/tests/thin-provisioning/discard_tests.rb:43:in `block in with_dev_md'
     /root/snitm/git/device-mapper-test-suite/lib/dmtest/tests/thin-provisioning/discard_tests.rb:40:in `each'
     /root/snitm/git/device-mapper-test-suite/lib/dmtest/tests/thin-provisioning/discard_tests.rb:40:in `with_dev_md'
     /root/snitm/git/device-mapper-test-suite/lib/dmtest/tests/thin-provisioning/discard_tests.rb:48:in `assert_no_mappings'
     /root/snitm/git/device-mapper-test-suite/lib/dmtest/tests/thin-provisioning/discard_tests.rb:263:in `test_discard_a_fragmented_device']:
<0> expected but was
<131072>.

  5) Failure:
test_discard_fully_provisioned_device_benchmark(DiscardQuickTests)
    [/root/snitm/git/device-mapper-test-suite/lib/dmtest/tests/thin-provisioning/discard_tests.rb:49:in `block in assert_no_mappings'
     /root/snitm/git/device-mapper-test-suite/lib/dmtest/tests/thin-provisioning/discard_tests.rb:43:in `call'
     /root/snitm/git/device-mapper-test-suite/lib/dmtest/tests/thin-provisioning/discard_tests.rb:43:in `block in with_dev_md'
     /root/snitm/git/device-mapper-test-suite/lib/dmtest/tests/thin-provisioning/discard_tests.rb:40:in `each'
     /root/snitm/git/device-mapper-test-suite/lib/dmtest/tests/thin-provisioning/discard_tests.rb:40:in `with_dev_md'
     /root/snitm/git/device-mapper-test-suite/lib/dmtest/tests/thin-provisioning/discard_tests.rb:48:in `assert_no_mappings'
     /root/snitm/git/device-mapper-test-suite/lib/dmtest/tests/thin-provisioning/discard_tests.rb:225:in `test_discard_fully_provisioned_device_benchmark']:
<0> expected but was
<262144>.

But I haven't yet figured out where the blk_bio_discard_split code, or
elsewhere, is going wrong.

Mike
