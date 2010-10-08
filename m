From: Mike Snitzer <snitzer@redhat.com>
Subject: [2.6.36 REGRESSION] Re: virtio-blk: put request that was created to
 retrieve the device id
Date: Fri, 8 Oct 2010 12:06:44 -0400
Message-ID: <20101008160643.GA32005@redhat.com>
References: <20100909175537.GA9589@redhat.com>
 <20100909183554.GK30086@us.ibm.com>
 <20100909191555.GA14486@redhat.com>
 <20100909194300.GA16908@redhat.com>
 <20100909201445.GA19656@redhat.com>
 <20100909203052.GL30086@us.ibm.com>
 <20100909210042.GA22092@redhat.com>
 <20100909211504.GA24506@infradead.org>
 <20100917145848.GK30086@us.ibm.com>
 <20100921210033.GA24729@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100921210033.GA24729@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: rusty@rustcorp.com.au
Cc: Christoph Hellwig <hch@infradead.org>, Ryan Harper <ryanh@us.ibm.com>, Tejun Heo <tj@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>, john.cooper@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Rusty,

On Tue, Sep 21 2010 at  5:00pm -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Sep 17, 2010 at 09:58:48AM -0500, Ryan Harper wrote:
> > Since __bio_map_kern() sets up bio->bi_end_io = bio_map_kern_endio
> > (which does a bio_put(bio)) doesn't that ensure we don't leak?
> 
> Indeed, that should take care of it.
> 

We need to fix this regression for 2.6.36.  Not sure what else I need to
do to get this on your radar.  It's a pretty significant show-stopper
for 2.6.36 guests that use virtio-blk with a udev enabled distro.

Here is a reference to my original patch (which Ryan and hch have both
reviewed): https://patchwork.kernel.org/patch/165571/

Thanks,
Mike
