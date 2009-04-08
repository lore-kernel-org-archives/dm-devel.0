From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Barriers still not passing on simple dm devices...
Date: Wed, 8 Apr 2009 08:36:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904080821060.28196@hs20-bc2-1.build.redhat.com>
References: <20090324150517.GX27476@kernel.dk>
	<Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com>
	<20090325152751.GV27476@kernel.dk>
	<Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>
	<20090326084205.GG27476@kernel.dk>
	<Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com>
	<20090331104933.GJ5178@kernel.dk>
	<Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com>
	<20090403081131.GP5178@kernel.dk> <49D77AC3.3020207@redhat.com>
	<20090405012839.GF7553@mit.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090405012839.GF7553@mit.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Theodore Tso <tytso@mit.edu>
Cc: ak@linux.intel.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Ric Wheeler <rwheeler@redhat.com>, "MASON,
	CHRISTOPHER" <CHRIS.MASON@oracle.com>
List-Id: dm-devel.ids

> Even now, the reason why ext3 doesn't have barriers enabled by default
> (although we did make them the default for ext4) is because Andrew
> doesn't believe Chris's replication case is likely to be true for most
> users in practice, and he's concerned about the performance
> degradation of barriers.  He's basically depending on the fact that
> "usually" you can get away without using barriers.  Sigh....

What is the performance degradation of barriers?

If the disk doesn't have write cache, performance of barrier-filesystem 
should be equal or better than performance of the same filesystem not 
using barriers. If barriers degrade performance, there is something 
seriously broken, either in the filesystem (XFS...) or in the block layer.

If the disk has write cache and you disable barriers, you might get some 
performance improvement. But you are getting this performance improvement 
from the fact that the disk illegaly reorders writes that should be 
ordered. And you are going to damage your data on power failure.

--- definitely, very few admins want this "high-performance & damage" 
setup (maybe for /tmp or /var/log?) --- such condition sould be only 
enabled with admin fully knowning what's going on. And where should the 
admin get the knowledge?

In hdparm manpage, there is just:
-W     Get/set the IDE/SATA drive's write-caching feature.

> 						- Ted
> 
> P.S.  Of course, distributions should feel free to consider changing
> the default on their kernels.  SLES has already if memory serves
> correctly.  I don't know if RHEL has yet.

RHEL doesn't enable write cache by default. And doesn't use barriers (it 
uses lvm2/device mapper and they won't get through).

Mikulas
