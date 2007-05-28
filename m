From: David Chinner <dgc@sgi.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Date: Mon, 28 May 2007 14:29:26 +1000
Message-ID: <20070528042926.GC85884050@sgi.com>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<20070528024559.GA85884050@sgi.com>
	<18010.17713.76863.245176@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <18010.17713.76863.245176@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: Tejun Heo <htejun@gmail.com>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

On Mon, May 28, 2007 at 12:57:53PM +1000, Neil Brown wrote:
> On Monday May 28, dgc@sgi.com wrote:
> > On Mon, May 28, 2007 at 11:30:32AM +1000, Neil Brown wrote:
> > > Thanks everyone for your input.  There was some very valuable
> > > observations in the various emails.
> > > I will try to pull most of it together and bring out what seem to be
> > > the important points.
> > > 
> > > 1/ A BIO_RW_BARRIER request should never fail with -EOPNOTSUP.
> > 
> > Sounds good to me, but how do we test to see if the underlying
> > device supports barriers? Do we just assume that they do and
> > only change behaviour if -o nobarrier is specified in the mount
> > options?
> 
> What exactly do you want to know, and why do you care?

If someone explicitly mounts "-o barrier" and the underlying device
cannot do it, then we want to issue a warning or reject the
mount.

> The idea is that every "struct block_device" supports barriers.  If the
> underlying hardware doesn't support them directly, then they get
> simulated by draining the queue and issuing a flush.

Ok. But you also seem to be implying that there will be devices that
cannot support barriers.

Even if all devices do eventually support barriers, it may take some
time before we reach that goal.  Why not start by making it easy to
determine what the capabilities of each device are. This can then be
removed once we reach the holy grail....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
