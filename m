From: David Chinner <dgc@sgi.com>
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device DM devices
Date: Tue, 19 Feb 2008 16:36:40 +1100
Message-ID: <20080219053640.GC155407@sgi.com>
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru> <20080215142010.GA29552@one.firstfloor.org> <20080215141229.GB1788@agk.fab.redhat.com> <47B97E87.6040209@emc.com> <47B9870B.8060005@msgid.tls.msk.ru> <20080218221644.GN155407@sgi.com> <20080219025643.GD4066@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755458AbYBSFh2@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080219025643.GD4066@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>, Michael Tokarev <mjt@tls.msk.ru>, Ric Wheeler <ric@emc.com>, device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, linux-kern
List-Id: dm-devel.ids

On Tue, Feb 19, 2008 at 02:56:43AM +0000, Alasdair G Kergon wrote:
> On Tue, Feb 19, 2008 at 09:16:44AM +1100, David Chinner wrote:
> > Surely any hardware that doesn't support barrier
> > operations can emulate them with cache flushes when they receive a
> > barrier I/O from the filesystem....
>  
> My complaint about having to support them within dm when more than one
> device is involved is because any efficiencies disappear: you can't send
> further I/O to any one device until all the other devices have completed
> their barrier (or else later I/O to that device could overtake the
> barrier on another device).

Right - it's a horrible performance hit.

But - how is what you describe any different to the filesystem doing:

	- flush block device
	- issue I/O
	- wait for completion
	- flush block device

around any I/O that it would otherwise simply tag as a barrier?
That serialisation at the filesystem layer is a horrible, horrible
performance hi.

And then there's the fact that we can't implement that in XFS
because all the barrier I/Os we issue are asynchronous.  We'd
basically have to serialise all metadata operations and now we
are talking about far worse performance hits than implementing
barrier emulation in the block device.

Also, it's instructive to look at the implementation of
blkdev_issue_flush() - the API one is supposed to use to trigger a
full block device flush. It doesn't work on DM/MD either, because
it uses a no-I/O barrier bio:

        bio->bi_end_io = bio_end_empty_barrier;
        bio->bi_private = &wait;
        bio->bi_bdev = bdev;
        submit_bio(1 << BIO_RW_BARRIER, bio);

        wait_for_completion(&wait);

So, if the underlying block device doesn't support barriers,
there's no point in changing the filesystem to issue flushes,
either...

> And then I argue that it would be better
> for the filesystem to have the information that these are not hardware
> barriers so it has the opportunity of tuning its behaviour (e.g.
> flushing less often because it's a more expensive operation).

There is generally no option from the filesystem POV to "flush
less". Either we use barrier I/Os where we need to and are safe with
volatile caches or we corrupt filesystems with volatile caches when
power loss occurs. There is no in-between where "flushing less"
will save us from corruption....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
