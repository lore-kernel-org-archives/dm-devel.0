From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
Date: Wed, 25 Mar 2009 16:27:51 +0100
Message-ID: <20090325152751.GV27476@kernel.dk>
References: <49C7DD3C.2020401@redhat.com> <Pine.LNX.4.64.0903241000010.29968@hs20-bc2-1.build.redhat.com> <20090324140524.GV27476@kernel.dk> <Pine.LNX.4.64.0903241010490.29968@hs20-bc2-1.build.redhat.com> <20090324143034.GW27476@kernel.dk> <Pine.LNX.4.64.0903241033070.4088@hs20-bc2-1.build.redhat.com> <20090324150517.GX27476@kernel.dk> <Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762961AbZCYP2f@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>
List-Id: dm-devel.ids

On Wed, Mar 25 2009, Mikulas Patocka wrote:
> > > > Over time we should have support everywhere, but it needs to be checked, 
> > > > audited, and trusted.
> > > 
> > > BTW. What is the rule for barriers if the device can't prevent the 
> > > requests from being delayed or reordered? (for example ATA<=3 disks with 
> > > cache that lack cache-flush command ... or flash cards that do 
> > > write-caching anyway and it can't be turned off). Should they support 
> > > barriers and try to make best effort? Or should they reject barriers to 
> > > inform the caller code that they have no data consistency?
> > 
> > If they can't flush cache, then they must reject barriers unless they
> > have write through caching.
> 
> ... and you suppose that journaled filesystems will use this error and 
> mark filesystem for fsck if they are running over a device that doesn't 
> support consistency?

No, but they can warn that data consistency isn't guarenteed. And they
all do, if you mount with barriers enabled and the barrier write fails.
If barriers aren't support, the first one will fail. So either they do
lazy detect, or they do a trial barrier write at mount time.

So yes, I suppose that file systems will use this error. Because that is
what they do.

> In theory it would be nice, in practice it doesn't work this way because 
> many devices *DO* support data consistency don't support barriers (the 
> most common are DM and MD when run over disk without write cache).

Your theory is nice, but most dm systems use write back caching. Any
desktop uses write back caching. Only higher end disks default to
write-through caching.

> So I think there should be flag (this device does/doesn't support data 
> consistency) that the journaled filesystems can use to mark the disk dirty 
> for fsck. And if you implement this flag, you can accept barriers always 
> to all kind of devices regardless of whether they support consistency. You 
> can then get rid of that -EOPNOTSUPP and simplify filesystem code because 
> they'd no longer need two commit paths and a clumsy way to restart 
> -EOPNOTSUPPed requests.

And my point is that this case isn't interesting, because most setups
don't guarantee proper ordering. The error handling is complex, no doubt
about that. But the trial barrier test is pretty trivial and even could
be easily abstracted out. If a later barrier write fails, then that's
really no different than if a normal write fails. Error handling is not
easy in that case.

-- 
Jens Axboe
