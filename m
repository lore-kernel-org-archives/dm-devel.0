From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: [dm-devel] [PATCH 4/9] block: Make generic_make_request handle
 arbitrary sized bios
Date: Mon, 4 Nov 2013 16:55:32 -0800
Message-ID: <20131105005532.GC27733@kmo>
References: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
 <1383608187-27368-5-git-send-email-kmo@daterainc.com>
 <52783444.8070309@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52783444.8070309@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 04, 2013 at 03:56:52PM -0800, Mike Christie wrote:
> On 11/04/2013 03:36 PM, Kent Overstreet wrote:
> > @@ -1822,6 +1820,14 @@ void generic_make_request(struct bio *bio)
> >  		 */
> >  		blk_queue_bounce(q, &bio);
> >  
> > +		if (!blk_queue_largebios(q))
> > +			split = blk_bio_segment_split(q, bio, q->bio_split);
> 
> 
> Is it assumed bios coming down this path are created using bio_add_page?
> If not, does blk_bio_segment_split need a queue_max_sectors or
> queue_max_hw_sectors check? I only saw a segment count check below.

Shoot, you're absolutely right - thanks, I'll have this fixed in the next
version.
