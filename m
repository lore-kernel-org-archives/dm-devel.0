From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC] Multiple Snapshots - Manageability problem
Date: Fri, 12 Jan 2007 15:59:17 -0600
Message-ID: <20070112215917.GB7441@ether.msp.redhat.com>
References: <45A6CC0F.A9E3.000B.0@novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <45A6CC0F.A9E3.000B.0@novell.com>
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

On Thu, Jan 11, 2007 at 11:18:13AM -0700, Vijai Babu Madhavan wrote:
> Hi,
> 
> The problem of DM snapshots with multiple snapshots have been discussed 
> in the lists quiet a bit (Most recently @ 
> https://www.redhat.com/archives/dm-devel/2006-October/msg00034.html).
> 
> We are currently in the process of building a DM snapshot target that scales 
> well with many snapshots (so that the changed blocks don't get copied to each 
> snapshot). In this process, I would also like to validate an assumption.
> 
> Today, when a single snapshot gets created, a new cow device of a given size 
> is also created. IMO, there are two problems with this approach:
> 
> a) It is difficult to predict the size of the cow device, which requires a prediction 
> of the number of writes would go into the origin volume during the snapshot 
> life cycle. It is difficult to get this prediction right, as very high value reduces 
> utilization and low value increases the chances of snapshot becoming full.
> 
> b) A new cow device needs to be created every time.
> 
> This really gets messy and creates a management problem once many 
> snapshots of a given origin are created, and gets worse with multiple origins.
> 
> I am thinking, having a single device that would hold the cow blocks of any 
> number of snapshots of a given origin (or more) would help solve this issue 
> (Apart from this, having a single device helps share the cow blocks among 
> snapshots very effectively in a variety of scenarios).
> 
> But, it does require that LVM and EVMS be changed to suit this model and 
> also makes the snapshot target quiet complex.
> 
> I would like to receive some comments about what users, developers 
> and others think about this.
> 

Have you taken a look at Daniel Phillips cluster snapshot work?

http://sources.redhat.com/cluster/csnap/index.html

The code is not complete, and am not sure if Daniel is doing any work on it at
all, but it has a nice design to store the cow data, and that URL contains the
design documents. In brief:

There is one device that stores all cow data (the snapstore). It has three
main parts, an allocation bitmap, a superblock that stores metadata, and
an exception btree. The exception btree is indexed by the location of the data
on the origin. For each chuck on the origin device that has cow data for one or
more snapshots, there is an exception in the btree that lists the location of
the cow data on the snapstore device, and the snapshots which are using that
exception.  This list of snapshots is stored as a bitmask.

This means that no matter now many snapshots you have, all you need to do to
write to the origin is check the btree.

1. If every snapshot has an exception at that location, you're free to write.
And you can put that location in a cache, so you never need to check the btree
again until a new snapshot is created.

2. If there are snapshots that don't have an exception in the btree, you
allocate space on the disk, copy the data from the origin, and add an exception
to the btree, with a bitmask containing every snapshot that doesn't already
have an exception. You can then cache this location, so you don't have to
check the btree again until a new snapshot is created.

This saves both space and time over the existing implementation.  Daniel's
code has a lot of stuff that is related to making the device clustered, which
you can ignore for the single machine case. But it is very nice to have a design
that is easily clusterable, so that switching between a single machine and
clustered snapshot can be done by simply flipping some bits instead of having to
convert between different ondisk formats.

-Ben

> Thanks,
> Vijai
> P.S:- BTW, apologizes for cross posting.
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
