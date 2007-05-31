From: Neil Brown <neilb@suse.de>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Date: Thu, 31 May 2007 13:31:00 +1000
Message-ID: <18014.16756.192137.738569@notabene.brown>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.47701.751118.336431@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nikita Danilov on Monday May 28
Sender: linux-raid-owner@vger.kernel.org
To: Nikita Danilov <nikita@clusterfs.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

On Monday May 28, nikita@clusterfs.com wrote:
> Neil Brown writes:
>  > 
> 
> [...]
> 
>  > Thus the general sequence might be:
>  > 
>  >   a/ issue all "preceding writes".
>  >   b/ issue the commit write with BIO_RW_BARRIER
>  >   c/ wait for the commit to complete.
>  >          If it was successful - done.
>  >          If it failed other than with EOPNOTSUPP, abort
>  >          else continue
>  >   d/ wait for all 'preceding writes' to complete
>  >   e/ call blkdev_issue_flush
>  >   f/ issue commit write without BIO_RW_BARRIER
>  >   g/ wait for commit write to complete
>  >        if it failed, abort
>  >   h/ call blkdev_issue
>  >   DONE
>  > 
>  > steps b and c can be left out if it is known that the device does not
>  > support barriers.  The only way to discover this to try and see if it
>  > fails.
>  > 
>  > I don't think any filesystem follows all these steps.
> 
> It seems that steps b/ -- h/ are quite generic, and can be implemented
> once in a generic code (with some synchronization mechanism like
> wait-queue at d/).

Yes and no.
It depends on what you mean by "preceding write".

If you implement this in the filesystem, the filesystem can wait only
for those writes where it has an ordering dependency.   If you
implement it in common code, then you have to wait for all writes
that were previously issued.

e.g.
  If you have two different filesystems on two different partitions on
  the one device, why should writes in one filesystem wait for a
  barrier issued in the other filesystem.
  If you have a single filesystem with one thread doing lot of
  over-writes (no metadata changes) and the another doing lots of
  metadata changes (requiring journalling and barriers) why should the
  data write be held up by the metadata updates?

So I'm not actually convinced that doing this is common code is the
best approach.  But it is the easiest.  The common code should provide
the barrier and flushing primitives, and the filesystem gets to use
them however it likes.

NeilBrown
