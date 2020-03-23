From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH RFC 0/2] dm-zoned: add cache device
Date: Mon, 23 Mar 2020 12:52:37 -0400
Message-ID: <20200323165237.GA27972@redhat.com>
References: <20200323150352.107826-1-hare@suse.de>
	<20200323151538.GA27573@redhat.com>
	<69ce4dd2-81d3-0ac6-933b-a1f781836597@suse.de>
	<20200323153944.GA27615@redhat.com>
	<7e92a106-b072-126f-fda5-80a8d4abc296@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7e92a106-b072-126f-fda5-80a8d4abc296@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Hannes Reinecke <hare@suse.de>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 23 2020 at 12:10pm -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 3/23/20 4:39 PM, Mike Snitzer wrote:
> >On Mon, Mar 23 2020 at 11:26am -0400,
> >Hannes Reinecke <hare@suse.de> wrote:
> >
> >>On 3/23/20 4:15 PM, Mike Snitzer wrote:
> >>>On Mon, Mar 23 2020 at 11:03am -0400,
> >>>Hannes Reinecke <hare@suse.de> wrote:
> >>>
> >>>>Hi Damien,
> >>>>
> >>>>as my original plan to upgrade bcache to work for SMR devices
> >>>>turned out to be more complex than anticipated I went for the
> >>>>simpler approach and added a 'cache' device for dm-zoned.
> >>>>It is using a normal device (eg '/dev/pmem0' :-), split it
> >>>>into zones of the same size of the original SMR device, and
> >>>>makes those 'virtual' zones avialable to dm-zoned in a similar
> >>>>manner than the existing 'random write' zoned.
> >>>>
> >>>>The implementation is still a bit rough (one would need to add
> >>>>metadata to the cache device, too), but so far it seems to work
> >>>>quite well; still running after copying 300GB of data back and forth.
> >>>>
> >>>>As usual, comments and reviews are welcome.
> >>>
> >>>Not seeing why this needs to be so specialized (natively implemented in
> >>>dm-zoned).  Did you try stacking dm-writecache on dm-zoned?
> >>>
> >>dm-zoned is using the random-write zones internally to stage writes
> >>to the sequential zones, so in effect it already has an internal
> >>caching.
> >>All this patch does is to use a different device for the already present
> >>mechanism.
> >>Using dm-writecache would be ignorant of that mechanism, leading to
> >>double caching and detrimental results.
> >
> >If dm-writecache were effective at submitting larger IO then dm-zoned
> >shouldn't be resorting to caching in random-write zones at all -- that
> >is a big if, so not saying it'll "just work".  But if both layers are
> >working then it should.
> >
> Well, by the looks of it dm-writecache suffers from the same problem
> bcache has; it allows for blocks up to 64k sectors to be submitted.
> Sadly for SMR drives I would need to submit block of 256M...
> But before discussing any further I'll give it a go and see where I end up.

Chatted with Mikulas quickly: dm-writecache currently imposes that the
blocksize is <= page size.  So 256M requirement is a non-starter for
dm-writecache at the moment.  I asked Mikulas what he thought about
relaxing that constraint in SSD mode.  He suggested rather hack dm-cache
to always promote on writes... which I hold to _not_ be a good rabbit
hole to staart running down :(

So at the moment work is needed in the DM caching layers to allow for
pure 256M buffering when layered on dm-zoned.

As such, your dm-zoned specific separate cache device changes would
scratch your itch sooner than dm-writecache could be trained/verified to
work with 256M in SSD mode.

Mike
