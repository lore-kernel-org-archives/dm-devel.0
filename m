From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Barriers still not passing on simple dm devices...
Date: Wed, 25 Mar 2009 18:39:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>
References: <49C7DD3C.2020401@redhat.com>
	<Pine.LNX.4.64.0903241000010.29968@hs20-bc2-1.build.redhat.com>
	<20090324140524.GV27476@kernel.dk>
	<Pine.LNX.4.64.0903241010490.29968@hs20-bc2-1.build.redhat.com>
	<20090324143034.GW27476@kernel.dk>
	<Pine.LNX.4.64.0903241033070.4088@hs20-bc2-1.build.redhat.com>
	<20090324150517.GX27476@kernel.dk>
	<Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com>
	<20090325152751.GV27476@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090325152751.GV27476@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "MASON,
	CHRISTOPHER" <CHRIS.MASON@oracle.com>, Andi Kleen <ak@suse.de>
List-Id: dm-devel.ids

> > > If they can't flush cache, then they must reject barriers unless they
> > > have write through caching.
> > 
> > ... and you suppose that journaled filesystems will use this error and 
> > mark filesystem for fsck if they are running over a device that doesn't 
> > support consistency?
> 
> No, but they can warn that data consistency isn't guarenteed. And they
> all do, if you mount with barriers enabled and the barrier write fails.
> If barriers aren't support, the first one will fail. So either they do
> lazy detect, or they do a trial barrier write at mount time.

The user shouldn't really be required to know what are barriers, which 
drivers support them and which don't, and which drivers maintain 
consistency without barriers and which not.

The user only needs to know if he must run fsck in the case of power 
failure or not. --- and that -EOPNOTSUPP error and warnings about failed 
barriers give him no information about that.

> So yes, I suppose that file systems will use this error. Because that is
> what they do.
> 
> > In theory it would be nice, in practice it doesn't work this way because 
> > many devices *DO* support data consistency don't support barriers (the 
> > most common are DM and MD when run over disk without write cache).
> 
> Your theory is nice, but most dm systems use write back caching. Any

If they do, the filesystem should know about it and fsck the partition in 
the case of crash.

> desktop uses write back caching. Only higher end disks default to
> write-through caching.
> 
> > So I think there should be flag (this device does/doesn't support data 
> > consistency) that the journaled filesystems can use to mark the disk dirty 
> > for fsck. And if you implement this flag, you can accept barriers always 
> > to all kind of devices regardless of whether they support consistency. You 
> > can then get rid of that -EOPNOTSUPP and simplify filesystem code because 
> > they'd no longer need two commit paths and a clumsy way to restart 
> > -EOPNOTSUPPed requests.
> 
> And my point is that this case isn't interesting, because most setups
> don't guarantee proper ordering.

If the ordering isn't guaranteed, the filesystem should know about it, and 
mark the partition for fsck. That's why I'm suggesting to use a flag for 
that. That flag could be also propagated up through md and dm.

The reasoning: "write barriers aren't supported => the device doesn't 
guarantee consistency" isn't valid.

> The error handling is complex, no doubt
> about that. But the trial barrier test is pretty trivial and even could
> be easily abstracted out. If a later barrier write fails, then that's
> really no different than if a normal write fails. Error handling is not
> easy in that case.

I had a discussion with Andi about it some times ago. The conclusion was 
that all the current filesystems handle barriers failing in the middle of 
the operation without functionality loss, but it makes barriers useless 
for any performance-sensitive tasks (commits that wouldn't block 
concurrent activity). Non-blocking commits could only be implemented if 
barriers don't fail.

Mikulas

> -- Jens Axboe
> 
