From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: virtio_blk: fix defaults for max_hw_sectors and max_segment_size
Date: Wed, 26 Nov 2014 18:00:55 -0500
Message-ID: <20141126230055.GA32363@redhat.com>
References: <20141120190058.GA31214@redhat.com>
 <20141121095456.GB8866@infradead.org>
 <20141121154920.GA7644@redhat.com>
 <54762E9A.2070007@kernel.dk>
 <20141126205106.GA31815@redhat.com>
 <54763DEC.3050207@kernel.dk>
 <20141126215108.GA32077@redhat.com>
 <54764BD1.2070804@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54764BD1.2070804@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: martin.petersen@oracle.com, mst@redhat.com, rusty@rustcorp.com.au, qemu-devel@nongnu.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 26 2014 at  4:53pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 11/26/2014 02:51 PM, Mike Snitzer wrote:
> > 
> > But while you're here, I wouldn't mind getting your take on virtio-blk
> > setting max_hw_sectors to -1U.
> > 
> > As I said in my original reply to mst: it only makes sense to set a
> > really high initial upper bound like that in a driver if that driver
> > goes on to stack an underlying device's limit.
> 
> -1U should just work, IMHO, there's no reason we should need to cap it
> at some synthetic value.  That said, it seems it should be one of
> those parameters that should be negotiated up and set appropriately. 

I'm saying set it to the underlying device's value for max_hw_sectors --
not some synthetic value.  So I think we're saying the same thing.

But it isn't immediately clear (to me) how that benefits virtio-blk
users (obviously they are getting by today).  So until that is pinned
down I imagine nobody will care to extend the virtio-blk protocol to
allow stacking max_hw_sectors and max_sectors up.
