From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [dm-devel] WARNING: at fs/block_dev.c:5 when removing LV on
 removed device
Date: Thu, 18 Jun 2015 21:53:31 +0200
Message-ID: <20150618195331.GD19417@two.firstfloor.org>
References: <20150618165713.GB19417@two.firstfloor.org>
 <20150618180408.GD2321@redhat.com>
 <20150618180804.GC19417@two.firstfloor.org>
 <20150618181619.GE2321@redhat.com>
 <20150618190815.GA6390@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150618190815.GA6390@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Andi Kleen <andi@firstfloor.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

> In that case if I do umount after device has gone away, I can see above
> WARN(). And it does seem to be coming from.
> 
> WARN_ON_ONCE(write_inode_now(inode, true))
> 
> If we failed to write back inode, then warning about it sounds right?

WARN() is for detecting kernel internal consistency problems, like
potential bugs.  It's not for handling IO errors or really
everything that can happen on a non buggy kernel.


> What's wrong with that? Should it be just a kernel log of level KERN_WARN
> instead?

Yes. Something like that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
