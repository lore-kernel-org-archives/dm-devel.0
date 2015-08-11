From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH v5 01/11] block: make generic_make_request handle
 arbitrarily sized bios
Date: Mon, 10 Aug 2015 19:38:51 -0800
Message-ID: <20150811033851.GA28533@kmo-pixel>
References: <1439099990.7880.0.camel@hasee>
 <20150809064128.GB2436@infradead.org>
 <1439103347.7880.3.camel@hasee>
 <20150809070128.GA25739@infradead.org>
 <1439104707.7880.8.camel@hasee>
 <20150810150216.GA22719@redhat.com>
 <yq1si7rgllc.fsf@sermon.lab.mkp.net>
 <1439230696.26458.6.camel@ssi>
 <yq1bneeh9df.fsf@sermon.lab.mkp.net>
 <20150811024154.GA26351@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150811024154.GA26351@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ming Lin <mlin@kernel.org>, axboe@fb.com, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Ming Lei <ming.lei@canonical.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Lars Ellenberg <drbd-dev@lists.linbit.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Nitin Gupta <ngupta@vflare.org>, Ming Lin <ming.l@ssi.samsung.com>, Oleg Drokin <oleg.drokin@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, Andreas Dilger <andreas.dilger@intel.com>, Geoff Levand <geoff@infradead.org>, Jiri Kosina <jkosina@suse.cz>, lkml <linux-kernel@vger.kernel.org>, Jim Paris <jim@jtan.com>, Minchan Kim <minchan@kernel.org>, Dongsu Park <dpark@posteo.net>, drbd-user@lists.linbit.com, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Mon, Aug 10, 2015 at 10:41:55PM -0400, Mike Snitzer wrote:
> On Mon, Aug 10 2015 at 10:00pm -0400,
> Martin K. Petersen <martin.petersen@oracle.com> wrote:
> 
> > >>>>> "Ming" == Ming Lin <mlin@kernel.org> writes:
> > 
> > Ming> Did you mean still use (UINT_MAX >> 9) in blkdev_issue_discard()?
> > 
> > Ming> But that doesn't work for dm-thinp. See Kent's suggestion to use
> > Ming> 1<<31.
> > 
> > I'm not sure why things are not working for dm-thinp. Presumably Kent's
> > code would split the discard at a granularity boundary so why would that
> > cause problems for dm?
> 
> DM-thinp processes discards internally before it passes them down (if
> configured to do so).  If a discard is smaller than the granularity of a
> thinp block (whose size is configurable) or if the start and end of the
> discard's extent is misaligned (relative to the thinp blocks mapped to
> the logical extent) then the discard won't actually discard partial
> thinp blocks.

This kind of logic really doesn't belong in dm - if it's needed, it really
belongs in bio_split() (which is supposed to work correctly for discards - so if
it is needed, then bio_split() needs fixing...)

IMO though it belongs in the driver - if a discard needs to be dropped because
it's too small and the hardware can't do it, that should be the driver's
responsibility.
