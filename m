From: Christoph Hellwig <hch@lst.de>
Subject: Re: WARNING: at fs/block_dev.c:5 when removing LV on removed device
Date: Fri, 19 Jun 2015 08:47:21 +0200
Message-ID: <20150619064721.GA1183@lst.de>
References: <20150618165713.GB19417@two.firstfloor.org> <20150618180408.GD2321@redhat.com> <20150618180804.GC19417@two.firstfloor.org> <20150618181619.GE2321@redhat.com> <20150618190815.GA6390@redhat.com> <20150618192821.GA4027@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150618192821.GA4027@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Thu, Jun 18, 2015 at 03:28:21PM -0400, Mike Snitzer wrote:
> > WARN_ON_ONCE(write_inode_now(inode, true))
> > 
> > If we failed to write back inode, then warning about it sounds right?
> 
> A warning is fine.. not a WARN_ON().  Pretty alarming backtrace spew but
> maybe I'm missing something and DM's blkdev refcount mgmt couldn't
> trigger this WARN_ON()?  I fail to see how to avoid it given the device
> isn't thre so write_inode_now() fails.
> 
> > What's wrong with that? Should it be just a kernel log of level KERN_WARN
> > instead?
> 
> Ideally, but I honestly don't have all the details paged in my head to
> say definitively.  First need to answer how vitrio-blk isn't hitting
> this (and DM is).  Could it be that __blkdev_put isn't getting called
> for virtio-blk!?

Just a warnings if fine.  In fact we can probably remove that as well
as it will happen after a hot removal all the time.
