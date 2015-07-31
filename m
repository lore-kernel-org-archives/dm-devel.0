From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Fri, 31 Jul 2015 17:38:32 -0400
Message-ID: <20150731213831.GA16464@redhat.com>
References: <1436168690-32102-1-git-send-email-mlin@kernel.org>
	<20150731192337.GA8907@redhat.com>
	<CAF1ivSZbMDgyo_-wFGusSNSZ1fonSMWmNU9aVavGFaQsmEyYmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAF1ivSZbMDgyo_-wFGusSNSZ1fonSMWmNU9aVavGFaQsmEyYmQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, Philip Kelleher <pjk1939-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joshua Morris <josh.h.morris-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andreas Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Paris <jim-XrPbb/hENzg@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

On Fri, Jul 31 2015 at  5:19pm -0400,
Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> On Fri, Jul 31, 2015 at 12:23 PM, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Mon, Jul 06 2015 at  3:44P -0400,
> > Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> >> From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >> The way the block layer is currently written, it goes to great lengths
> >> to avoid having to split bios; upper layer code (such as bio_add_page())
> >> checks what the underlying device can handle and tries to always create
> >> bios that don't need to be split.
> >>
> >> But this approach becomes unwieldy and eventually breaks down with
> >> stacked devices and devices with dynamic limits, and it adds a lot of
> >> complexity. If the block layer could split bios as needed, we could
> >> eliminate a lot of complexity elsewhere - particularly in stacked
> >> drivers. Code that creates bios can then create whatever size bios are
> >> convenient, and more importantly stacked drivers don't have to deal with
> >> both their own bio size limitations and the limitations of the
> >> (potentially multiple) devices underneath them.  In the future this will
> >> let us delete merge_bvec_fn and a bunch of other code.
> >>
> >> We do this by adding calls to blk_queue_split() to the various
> >> make_request functions that need it - a few can already handle arbitrary
> >> size bios. Note that we add the call _after_ any call to
> >> blk_queue_bounce(); this means that blk_queue_split() and
> >> blk_recalc_rq_segments() don't need to be concerned with bouncing
> >> affecting segment merging.
> >>
> >> Some make_request_fn() callbacks were simple enough to audit and verify
> >> they don't need blk_queue_split() calls. The skipped ones are:
> >>
> >>  * nfhd_make_request (arch/m68k/emu/nfblock.c)
> >>  * axon_ram_make_request (arch/powerpc/sysdev/axonram.c)
> >>  * simdisk_make_request (arch/xtensa/platforms/iss/simdisk.c)
> >>  * brd_make_request (ramdisk - drivers/block/brd.c)
> >>  * mtip_submit_request (drivers/block/mtip32xx/mtip32xx.c)
> >>  * loop_make_request
> >>  * null_queue_bio
> >>  * bcache's make_request fns
> >>
> >> Some others are almost certainly safe to remove now, but will be left
> >> for future patches.
> >>
> >> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> >> Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> >> Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> >> Cc: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> >> Cc: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
> >> Cc: Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> >> Cc: Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
> >> Cc: drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
> >> Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> >> Cc: Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> >> Cc: Jim Paris <jim-XrPbb/hENzg@public.gmane.org>
> >> Cc: Joshua Morris <josh.h.morris-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >> Cc: Philip Kelleher <pjk1939-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> >> Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >> Cc: Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>
> >> Cc: Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >> Cc: Andreas Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >> Acked-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org> (for the 'md/md.c' bits)
> >> Signed-off-by: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> [dpark: skip more mq-based drivers, resolve merge conflicts, etc.]
> >> Signed-off-by: Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>
> >> Signed-off-by: Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>
> > ...
> >> diff --git a/block/blk-merge.c b/block/blk-merge.c
> >> index 30a0d9f..3707f30 100644
> >> --- a/block/blk-merge.c
> >> +++ b/block/blk-merge.c
> >> @@ -9,12 +9,158 @@
> >>
> >>  #include "blk.h"
> >>
> >> +static struct bio *blk_bio_discard_split(struct request_queue *q,
> >> +                                      struct bio *bio,
> >> +                                      struct bio_set *bs)
> >> +{
> >> +     unsigned int max_discard_sectors, granularity;
> >> +     int alignment;
> >> +     sector_t tmp;
> >> +     unsigned split_sectors;
> >> +
> >> +     /* Zero-sector (unknown) and one-sector granularities are the same.  */
> >> +     granularity = max(q->limits.discard_granularity >> 9, 1U);
> >> +
> >> +     max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
> >> +     max_discard_sectors -= max_discard_sectors % granularity;
> >> +
> >> +     if (unlikely(!max_discard_sectors)) {
> >> +             /* XXX: warn */
> >> +             return NULL;
> >> +     }
> >> +
> >> +     if (bio_sectors(bio) <= max_discard_sectors)
> >> +             return NULL;
> >> +
> >> +     split_sectors = max_discard_sectors;
> >> +
> >> +     /*
> >> +      * If the next starting sector would be misaligned, stop the discard at
> >> +      * the previous aligned sector.
> >> +      */
> >> +     alignment = (q->limits.discard_alignment >> 9) % granularity;
> >> +
> >> +     tmp = bio->bi_iter.bi_sector + split_sectors - alignment;
> >> +     tmp = sector_div(tmp, granularity);
> >> +
> >> +     if (split_sectors > tmp)
> >> +             split_sectors -= tmp;
> >> +
> >> +     return bio_split(bio, split_sectors, GFP_NOIO, bs);
> >> +}
> >
> > This code to stop the discard at the previous aligned sector could be
> > the reason why I have 2 device-mapper-test-suite tests in the
> > 'thin-provisioning' testsuite failing due to this patchset:
> 
> I'm setting up the testsuite to debug.

OK, once setup, to run the 2 tests in question directly you'd do
something like:

dmtest run --suite thin-provisioning -n discard_a_fragmented_device

dmtest run --suite thin-provisioning -n discard_fully_provisioned_device_benchmark

Again, these tests pass without this patchset.
