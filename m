From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 01/11] block: make generic_make_request handle
	arbitrarily sized bios
Date: Mon, 18 May 2015 19:22:59 +0200
Message-ID: <20150518172259.GA8116@lst.de>
References: <1430980461-5235-1-git-send-email-mlin@kernel.org> <1430980461-5235-2-git-send-email-mlin@kernel.org> <x49twv9kevg.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49twv9kevg.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Ming Lin <mlin@kernel.org>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: dm-devel.ids

On Mon, May 18, 2015 at 12:52:03PM -0400, Jeff Moyer wrote:
> > +	return bio_split(bio, split_sectors, GFP_NOIO, bs);
> 
> Much of this function is cut-n-paste from blk-lib.c.  Is there any way
> to factor it out?

The code in blk-lib.c can go away now that any driver that cares
does the split.

> > +static struct bio *blk_bio_segment_split(struct request_queue *q,
> > +					 struct bio *bio,
> > +					 struct bio_set *bs)
> > +{
> 
> Funny name for a function that also merges segments.  ;-)  I admit I am
> at a loss for coming up with a better name that won't overflow 80
> columns.

I'd keep the name and add a funny comment instead.
