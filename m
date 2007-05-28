From: Neil Brown <neilb@suse.de>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Mon, 28 May 2007 12:57:53 +1000
Message-ID: <18010.17713.76863.245176@notabene.brown>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<20070528024559.GA85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Chinner on Monday May 28
Sender: linux-raid-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

On Monday May 28, dgc@sgi.com wrote:
> On Mon, May 28, 2007 at 11:30:32AM +1000, Neil Brown wrote:
> > 
> > Thanks everyone for your input.  There was some very valuable
> > observations in the various emails.
> > I will try to pull most of it together and bring out what seem to be
> > the important points.
> > 
> > 
> > 1/ A BIO_RW_BARRIER request should never fail with -EOPNOTSUP.
> 
> Sounds good to me, but how do we test to see if the underlying
> device supports barriers? Do we just assume that they do and
> only change behaviour if -o nobarrier is specified in the mount
> options?
> 

What exactly do you want to know, and why do you care?

The idea is that every "struct block_device" supports barriers.  If the
underlying hardware doesn't support them directly, then they get
simulated by draining the queue and issuing a flush.
Theoretically there could be devices which have a write-back cache
that cannot be flushed, and you couldn't implement barriers on such a
device.  So throw it out and buy another?

As far as I can tell, the only thing XFS does differently with devices
that don't support barriers is that it prints a warning message to the
kernel logs.  If the underlying device printed the message when it
detected that barriers couldn't be supported, XFS wouldn't need to
care at all.

NeilBrown
