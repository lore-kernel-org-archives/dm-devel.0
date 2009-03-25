From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Barriers still not passing on simple dm devices...
Date: Wed, 25 Mar 2009 11:15:14 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com>
References: <49C7DD3C.2020401@redhat.com>
	<Pine.LNX.4.64.0903241000010.29968@hs20-bc2-1.build.redhat.com>
	<20090324140524.GV27476@kernel.dk>
	<Pine.LNX.4.64.0903241010490.29968@hs20-bc2-1.build.redhat.com>
	<20090324143034.GW27476@kernel.dk>
	<Pine.LNX.4.64.0903241033070.4088@hs20-bc2-1.build.redhat.com>
	<20090324150517.GX27476@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090324150517.GX27476@kernel.dk>
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

> > > Over time we should have support everywhere, but it needs to be checked, 
> > > audited, and trusted.
> > 
> > BTW. What is the rule for barriers if the device can't prevent the 
> > requests from being delayed or reordered? (for example ATA<=3 disks with 
> > cache that lack cache-flush command ... or flash cards that do 
> > write-caching anyway and it can't be turned off). Should they support 
> > barriers and try to make best effort? Or should they reject barriers to 
> > inform the caller code that they have no data consistency?
> 
> If they can't flush cache, then they must reject barriers unless they
> have write through caching.

... and you suppose that journaled filesystems will use this error and 
mark filesystem for fsck if they are running over a device that doesn't 
support consistency?

In theory it would be nice, in practice it doesn't work this way because 
many devices *DO* support data consistency don't support barriers (the 
most common are DM and MD when run over disk without write cache).


So I think there should be flag (this device does/doesn't support data 
consistency) that the journaled filesystems can use to mark the disk dirty 
for fsck. And if you implement this flag, you can accept barriers always 
to all kind of devices regardless of whether they support consistency. You 
can then get rid of that -EOPNOTSUPP and simplify filesystem code because 
they'd no longer need two commit paths and a clumsy way to restart 
-EOPNOTSUPPed requests.

Mikulas

> -- 
> Jens Axboe
> 
