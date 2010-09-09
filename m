From: Ryan Harper <ryanh@us.ibm.com>
Subject: Re: [REGRESSION][BISECTED] virtio-blk serial attribute causes guest to hang [Was: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA support for request-based dm]
Date: Thu, 9 Sep 2010 15:30:52 -0500
Message-ID: <20100909203052.GL30086@us.ibm.com>
References: <20100902032246.GA31484@redhat.com> <20100909152658.GA8118@redhat.com> <20100909154442.GI30086@us.ibm.com> <20100909155726.GA9081@redhat.com> <20100909160324.GJ30086@us.ibm.com> <20100909175537.GA9589@redhat.com> <20100909183554.GK30086@us.ibm.com> <20100909191555.GA14486@redhat.com> <20100909194300.GA16908@redhat.com> <20100909201445.GA19656@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100909201445.GA19656@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ryan Harper <ryanh@us.ibm.com>, Tejun Heo <tj@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>, john.cooper@redhat.com, rusty@rustcorp.com.au, hch@infradead.org, kvm@vger.kernel.org
List-Id: dm-devel.ids

* Mike Snitzer <snitzer@redhat.com> [2010-09-09 15:15]:
> On Thu, Sep 09 2010 at  3:43pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > Interestingly, just this loop:
> > 
> > while true ; do cat /sys/block/vda/serial && date && sleep 1 ; done
> > Thu Sep  9 15:29:30 EDT 2010
> > ...
> > Thu Sep  9 15:31:19 EDT 2010
> > 
> > caused the following hang:
> ...
> > So it seems like the virtio requests aren't being properly cleaned up?
> 
> Yeap, here is the result with the attached debug patch that Vivek wrote
> last week to help chase this issue (which adds 'nr_requests_used').  We
> thought the mpath device might be leaking requests; concern for other
> devices wasn't on our radar:
> 
> # cat /sys/block/vda/queue/nr_requests
> 128
> 
> # while true ; do cat /sys/block/vda/queue/nr_requests_used && cat /sys/block/vda/serial && date && sleep 1 ; done
> 10
> Thu Sep  9 16:04:40 EDT 2010
> 11
> Thu Sep  9 16:04:41 EDT 2010
> ...
> Thu Sep  9 16:06:38 EDT 2010
> 127
> Thu Sep  9 16:06:39 EDT 2010
> 128
> 
> I'll have a quick look at the virtio-blk code to see if I can spot where
> the request isn't getting cleaned up.  But I welcome others to have a
> look too (I've already spent entirely way to much time on this issue).

The qemu on the host isn't new enough to handle the request.  This
serial attribute should have had a feature bit with it (it did at one
point in one of the previous forms of the virtio-blk serial patch
series, but it isn't present now) so we don't expose the attribute
unless backend can handle the request type.

For immediate relief, it's probably easiest to revert the kernel-side
commit (or comment out the device_create_file() call after add_disk() in
virtblk_probe().


-- 
Ryan Harper
Software Engineer; Linux Technology Center
IBM Corp., Austin, Tx
ryanh@us.ibm.com
