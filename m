From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Date: Tue, 19 Apr 2011 08:38:13 +1000
Message-ID: <20110419083813.5c61aa99@notabene.brown>
References: <4DA2E03A.2080607@fusionio.com>
	<20110411212635.7959de70@notabene.brown>
	<4DA2E7F0.9010904@fusionio.com>
	<20110411220505.1028816e@notabene.brown>
	<4DA2F00E.6010907@fusionio.com>
	<20110418081922.1651474a@notabene.brown>
	<4DABDC60.2090009@fusionio.com>
	<20110418172551.55629fc6@notabene.brown>
	<4DABF1EA.3070301@fusionio.com>
	<20110418183343.036f412e@notabene.brown>
	<20110418213048.GA21852@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110418213048.GA21852@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, 18 Apr 2011 17:30:48 -0400 "hch@infradead.org" <hch@infradead.org>
wrote:

> >       md: provide generic support for handling unplug callbacks.
> 
> This looks like some horribly ugly code to me.  The real fix is to do
> the plugging in the block layers for bios instead of requests.  The
> effect should be about the same, except that merging will become a
> little easier as all bios will be on the list now when calling into
> __make_request or it's equivalent, and even better if we extent the
> list sort callback to also sort by the start block it will actually
> simplify the merge algorithm a lot as it only needs to do front merges
> and no back merges for the on-stack merging.
> 
> In addition it should also allow for much more optimal queue_lock
> roundtrips - we can keep it locked at the end of what's currently
> __make_request to have it available for the next bio that's been
> on the list.  If it either can be merged now that we have the lock
> and/or we optimize get_request_wait not to sleep in the fast path
> we could get down to a single queue_lock roundtrip for each unplug.

Does the following match with your thinking?  I'm trying to make for a more
concrete understanding...

 - We change the ->make_request_fn interface so that it takes a list of
   bios rather than a single bio - linked on ->bi_next.
   These bios must all have the same ->bi_bdev.  They *might* be sorted
   by bi_sector (that needs to be decided).


 - generic_make_request currently queues bios if there is already an active
   request (this limits recursion).  We enhance this to also queue requests
   when code calls blk_start_plug.
   In effect, generic_make_request becomes:
        if (current->plug)
		blk_add_to_plug(current->plug, bio);
	else {
		struct blk_plug plug;
		blk_start_plug(&plug);
		__generic_make_request(bio);
		blk_finish_plug(&plug);
	}

 - __generic_make_request would sort the list of bios by bi_bdev (and maybe 
   bi_sector) and pass them along to the different ->make_request_fn
   functions.

   As there are likely to be only a few different bi_bdev values (often 1) but
   hopefully lots and lots of bios it might be more efficient to do a linear
   bucket sort based on bi_bdev, and only sort those buckets on bi_sector if
   required.

Then make_request_fn handlers can expect to get lots of bios at once, can
optimise their handling as seems appropriate, and not require any further
plugging.


Is that at all close to what you are thinking?

NeilBrown
