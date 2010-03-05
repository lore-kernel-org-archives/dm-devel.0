From: Neil Brown <neilb@suse.de>
Subject: Re: [dm-devel] [PATCH 1/2] blkdev: fix merge_bvec_fn return value
 checks
Date: Sat, 6 Mar 2010 10:52:37 +1100
Message-ID: <20100306105237.0a8621ed@notabene.brown>
References: <170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com>
	<87wrxtkzwu.fsf@openvz.org>
	<20100303191613.GB18480@redhat.com>
	<87lje9kx9i.fsf@openvz.org>
	<20100303200734.GW5768@kernel.dk>
	<Pine.LNX.4.64.1003040629230.990@hs20-bc2-1.build.redhat.com>
	<20100304121931.GB5768@kernel.dk>
	<Pine.LNX.4.64.1003041615120.17032@hs20-bc2-1.build.redhat.com>
	<20100305073059.GI5768@kernel.dk>
	<20100306085651.1a571571@notabene.brown>
	<20100305222748.GT27852@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100305222748.GT27852@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Dmitry Monakhov <dmonakhov@openvz.org>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

On Fri, 5 Mar 2010 22:27:48 +0000
Alasdair G Kergon <agk@redhat.com> wrote:

> On Sat, Mar 06, 2010 at 08:56:51AM +1100, Neil Brown wrote:
> > My preferred end-game would be to allow a bio of any size to be submitted to
> > any device.  The device would be responsible for cutting it up if necessary.
> 
> >From the dm point of view, splitting is undesirable - memory allocations from
> separate mempools, submitting the split-off parts could reorder/delay but must
> still respect barrier constraints etc.  Splitting is the 'slow and complicated'
> path for us.  We support it, but it is simpler and more efficient if the bio is
> created a suitable size in the first place - and the merge_bvec_fn does this
> for us most of the time.

I hadn't thought about barriers in this context previously, but on reflection
I don't think splitting makes barriers noticeably more complex than they are
already.
If you have multiple devices, then you pretty much have to handle a barrier
as:
  - stall new requests
  - send zero length barrier to all devices
  - write the barrier request, either with the barrier flag set,
    or followed by a zero-length barrier

I don't think splitting adds complexity.
I guess if you have a single device, but still wont to split a request, there
might be some optimisations you have to forego...

But my first suggestion, that splitting could be made easier, still stands.
Maybe it doesn't have to be so complicated - then it wouldn't be so slow?

And do you honour merge_bvec_fn's of underlying devices?  A quick grep
suggests you do only for dm-linear and dm-crypt.  This suggests to me that it
is actually a hard interface to support completely in a stacked device, so we
might be better off without it.
In md, I check if merge_bvec_fn is defined and if it is, I just drop
max_sectors to 4K so it will never be needed.  I figure that a performance
drop is better than a correctness error.

Yes, splitting is undesirable, and if we can arrange that most requests don't
get split, then that is good.  But there will always be some requests that
have to be split - whether by bio_add_page or something lower - and I think
that it makes sense to only require that the lowest level does the
splitting, as that is where the specifics on what might be required exists.

Thanks,
NeilBrown
