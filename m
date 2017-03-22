From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] block: trace completion of all bios.
Date: Wed, 22 Mar 2017 05:51:49 -0700
Message-ID: <20170322125149.GA29606@infradead.org>
References: <877f3iave6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877f3iave6.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Mar 22, 2017 at 01:38:09PM +1100, NeilBrown wrote:
> 
> Currently only dm and md/raid5 bios trigger trace_block_bio_complete().
> Now that we have bio_chain(), it is not possible, in general, for a
> driver to know when the bio is really complete.  Only bio_endio()
> knows that.
> 
> So move the trace_block_bio_complete() call to bio_endio().

This will cause duplicate events for request based drivers.  You'll
need to have a bio_endio_notrace or similar without that the request
completion path can call.
