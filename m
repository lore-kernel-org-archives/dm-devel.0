From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC] Out of order snapshot deletion
Date: Fri, 12 Jan 2007 16:26:42 -0600
Message-ID: <20070112222642.GC7441@ether.msp.redhat.com>
References: <45A766F3.A9E3.000B.0@novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <45A766F3.A9E3.000B.0@novell.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 11, 2007 at 10:19:06PM -0700, Vijai Babu Madhavan wrote:
> Hi,
> 
> I thought I would bring this topic in a separate thread so that 
> it can be discussed independently.
> 
> As users start taking a bunch of snapshots and keep them as 
> backups, we see the following use pattern when the snapshots 
> get recycled.
> 
> Different snapshots have different life cycle. When some one 
> decides to keep 'x' snapshots, at the recycle phase, the least 
> recent does not necessarily get deleted.
> 
> As users want to keep the daily snapshots for a much longer period
> than the bi-hourly snapshots. In the same way, weekly snapshots 
> live longer than daily snapshots.
> 
> I think this is pretty much similar to the way the current backup tapes
> are managed.
> 
> I want to know if this is the kind of use case that users are having or 
> the developers are thinking.
> 
> The reason why I am posting this is that this out of snapshot deletion
> scenario, poses some interesting challenges in the design on the solution 
> of multiple snapshots that share blocks with each other, as it is a lot easier> to design a solution where the least recent gets deleted always.

Here are my best recollections of how it does (or at least could)
work in Daniel's design that I mentioned in the last thread.

The list of currently valid snapshots is stored as a bitmask, both in the
exceptions, and in the snapstore superblock.  There are two ways to deal with
deletion.

The easy (and slower) way, is to halt all writes that need to use the btree.
Then you turn off that device's bit in the snapstore superblock, and walkt the
btree, freeing up exceptions that are unique to that device, or removing from
the bitmap of shared exceptions. Then you let access to the btree continue.

There is a more complicated method that seems like it should still be doable,
and allows you to do a lazy deletion.  To start with, you just turn off that
device's bit in the snapstore superblock. When the origin checks to see if
all the snapshots have exceptions, or a snapshot checks if it is the only
holder of an exception, they can simply mask the exception bitmask with the
origin bitmask. This will cause the deleted snapshot to be ignored.  Then
a daemon could lazily go through and clear that bit from all the exceptions.
Of course, until the bit is cleared up from all the exceptions, that bit must
not be used by any newly created snapshots. This could be done by simply storing
two bitmaps. The first would clear the deleted snapshot's bit on deletion as
described above. The second would only clear the deleted snapshot's bit after
it had been cleared from the exception btree.

In both of these methods, it is just as easy to delete any snapshot as any other
one. I don't know if snapshots get deleted often enough for the added complexityof the second method to be worth it.

-Ben


> Vijai
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
