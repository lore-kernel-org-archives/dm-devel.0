From: "Haripriya S" <SHARIPRIYA@novell.com>
Subject: Re: dm-snapshot scalability - chained delta
	snapshots approach
Date: Tue, 26 Sep 2006 23:24:23 -0600
Message-ID: <451A5915.F25D.00B6.0@novell.com>
References: <44DA246B020000B60000BD22@lucius.provo.novell.com>
	<44DB5BDD020000B60000BD96@lucius.provo.novell.com>
	<44DB5C21.F25D.00B6.0@novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44DB5C21.F25D.00B6.0@novell.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

I had previously put out some performance numbers for origin writes
where performance goes down drastically w.r.t. the number of snapshots.
Going further, we identified one of the reasons for the performance drop
with increase in number of snapshots as the COW copies that happen to
every snapshot COW device when an origin write happens.

We have currently experimented with dm-snapshot code with two different
approaches and have got good performance numbers. I describe the first
approach and the results here and appreciate your opinions and inputs on
this.

Approach 1 - Chained delta snapshots

In the current design, each snapshot COW device contains all the diffs
from the origin as exceptions. In the new scheme, each snapshot COW
device contains only delta diffs from previous snapshot. So, assuming an
origin has 16 snapshots, with the current design 16 COW copies will be
done. With the new scheme, only 1 COW copy will be done, which means the
performance will not degrade so rapidly when the number of snapshots
increases.

Lets assume the snapshots for a given origin volume are chained based
on the order of creation. We define two chains, read chain is the same
as the snapshot creation order, and write chain is in the reverse
order.

Origin write: 
When an origin write happens, for the copy-on-write, the current scheme
creates pending   exceptions to every snapshot in the chain. In the new
scheme, we create copy-on-write exceptions for that block only to the
first snapshot in the write chain (the most recent snapshot).

Snapshot write:
If the snapshot already contains an exception for the given block, and
it was created due to a copy-on-write, then that block is copied to the
previous snapshot (the next snapshot in the write chain). Otherwise the
exception is created or block is overwritten.

Snapshot read:
If an exception for the block is found in the current snapshot's COW,
then use that. Else traverse through the read chain and use the first
exception for that block. If the block is not found in any of them, then
use the origin.

Origin read:
No change

Advantages:
1. Very simple, adds very few lines of code to existing dm-snap code.
2. Does not change the dm-snapshot architecture, and no changes
required in LVM or EVMS
3. Since the COW copies due to origin write will always go to the most
recent snapshot, snapshot COW devices can be created with less size.
Whenever the COW allocation increase beyond say 90%, a new snapshot can
be created which will take all the subsequent COW copies. This may avoid
making COW devices invalid.

Disadvantages:
1. snapshots which were independent previously are now dependent on
each other. Corruption of one COW device will affect the other snapshots
as well.
2. Will have a small impact in snapshot read performance, currently (if
I understood right) since exceptions are in memory this may not be big.
3. There is a need to change the disk exception structure (we need at
least a bit to indicate that a particular exception was created because
of COW copy, instead of due to a snapshot write). But the comments in
exception-store.c say 
    * There is no backward or forward compatibility implemented,
    * snapshots with different disk versions than the kernel will
    * not be usable.  It is expected that "lvcreate" will blank out
    * the start of a fresh COW device before calling the snapshot
   * constructor.
so this may not be a huge problem.
4. When snapshots are deleted the COW exceptions have to be transferred
to the next snapshot in the write chain.

I have prototype code for this approach which works ok for the
read/write paths, but has not been tested very thoroughly. There is
still more work to be done in terms of snapshot deletion etc.
Preliminary results using this code has suggested that the scalability
of origin writes w.r.t. snapshots has improved tremendously.

Preliminary numbers:

Origin Write(using dd)    Chained delta snapshot prototype    Current
DM design
  1 snapshot                                      933 KB/s             
            950KB/s
  4 snapshots                                    932 KB/s              
           720 KB/s
  8 snapshots                                    927 KB/s              
           470 KB/s
  16 snapshots                                  905 KB/s               
          257 KB/s

We would love to hear your comments on this approach.
                    
Thanks and Regards,
Haripriya S.
 
>>> "Haripriya S" <SHARIPRIYA@novell.com> 08/10/06 4:16 PM >>> 
Hi,

A co- worker recently did some tests on DM snapshots using bonnie, and
here is a rough summary of what he got as write throughput:

No Snapshots     -  373 MB/s
One Snapshots   -  55 MB/s
Two Snapshots  -  16 MB/s
Four Snapshots  -  14 MB/s
Eight Snapshots  -  6.5 MB/s

He is doing some more tests now to verify these results, but I wanted
to quickly check with the dm snapshot community. Are there any current
known scalability limits on snapshots and do the numbers mentioned
here
look normal ?

Thanks and Regards,
Haripriya



--
dm- devel mailing list
dm- devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm- devel
