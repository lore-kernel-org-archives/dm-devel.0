From: Neil Brown <neilb@suse.de>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Thu, 31 May 2007 10:46:04 +1000
Message-ID: <18014.6860.989819.665778@notabene.brown>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<20070528024559.GA85884050@sgi.com>
	<18010.17713.76863.245176@notabene.brown>
	<20070528042926.GC85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: message from David Chinner on Monday May 28
Sender: linux-fsdevel-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

On Monday May 28, dgc@sgi.com wrote:
> On Mon, May 28, 2007 at 12:57:53PM +1000, Neil Brown wrote:
> > What exactly do you want to know, and why do you care?
> 
> If someone explicitly mounts "-o barrier" and the underlying device
> cannot do it, then we want to issue a warning or reject the
> mount.

I guess that makes sense.
But apparently you cannot tell what a device supports until you write
to it.
So maybe you need to write some metadata with as a barrier, then ask
the device what it's barrier status is.  The options might be:
  YES - barriers are fully handled
  NO  - best effort, but due to missing device features, it might not
        work
  DISABLED - admin has requested that barriers be ignored.

??
 
> 
> > The idea is that every "struct block_device" supports barriers.  If the
> > underlying hardware doesn't support them directly, then they get
> > simulated by draining the queue and issuing a flush.
> 
> Ok. But you also seem to be implying that there will be devices that
> cannot support barriers.

It seems there will always be hardware that doesn't meet specs.  If a
device doesn't support SYNCHRONIZE_CACHE or FUA, then implementing
barriers all the way to the media would be hard..

> 
> Even if all devices do eventually support barriers, it may take some
> time before we reach that goal.  Why not start by making it easy to
> determine what the capabilities of each device are. This can then be
> removed once we reach the holy grail....

I'd rather not add something that we plan to remove.  We currently
have -EOPNOTSUP.  I don't think there is much point having more than
that.

I would really like to get to the stage where -EOPNOTSUP is never
returned.  If a filesystem cares, it could 'ask' as suggested above.
What would be a good interface for asking?
What if the truth changes (as can happen with md or dm)?

NeilBrown
