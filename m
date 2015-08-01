From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v5 01/11] block: make generic_make_request handle
 arbitrarily sized bios
Date: Sat, 1 Aug 2015 12:33:57 -0400
Message-ID: <20150801163356.GA21478@redhat.com>
References: <1436168690-32102-1-git-send-email-mlin@kernel.org>
 <20150731192337.GA8907@redhat.com>
 <CAF1ivSZbMDgyo_-wFGusSNSZ1fonSMWmNU9aVavGFaQsmEyYmQ@mail.gmail.com>
 <20150731213831.GA16464@redhat.com>
 <1438412290.26596.14.camel@hasee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438412290.26596.14.camel@hasee>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, Ming Lin <ming.l@ssi.samsung.com>
List-Id: dm-devel.ids

On Sat, Aug 01 2015 at  2:58am -0400,
Ming Lin <mlin@kernel.org> wrote:

> On Fri, 2015-07-31 at 17:38 -0400, Mike Snitzer wrote:
> > 
> > OK, once setup, to run the 2 tests in question directly you'd do
> > something like:
> > 
> > dmtest run --suite thin-provisioning -n discard_a_fragmented_device
> > 
> > dmtest run --suite thin-provisioning -n discard_fully_provisioned_device_benchmark
> > 
> > Again, these tests pass without this patchset.
> 
> It's caused by patch 4.
> When discard size >=4G, the bio->bi_iter.bi_size overflows.

Thanks for tracking this down!

> Below is the new patch.
> 
> Christoph,
> Could you also help to review it?
> 
> Now we still do "misaligned" check in blkdev_issue_discard().
> So the same code in blk_bio_discard_split() was removed.

But I don't agree with this approach.  One of the most meaningful
benefits of late bio splitting is the upper layers shouldn't _need_ to
depend on the intermediate devices' queue_limits being stacked properly.
Your solution to mix discard granularity/alignment checks at the upper
layer(s) but then split based on max_discard_sectors at the lower layer
defeats that benefit for discards.

This will translate to all intermediate layers that might split
discards needing to worry about granularity/alignment
too (e.g. how dm-thinp will have to care because it must generate
discard mappings with associated bios based on how blocks were mapped to
thinp).

Also, it is unfortunate that IO that doesn't have a payload is being
artificially split simply because bio->bi_iter.bi_size is 32bits.

Mike
