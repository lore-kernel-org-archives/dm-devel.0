From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Device-mapper cluster locking
Date: Mon, 12 Apr 2010 03:14:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1004120249480.19024@hs20-bc2-1.build.redhat.com>
References: <1270648258.25738.18.camel@hydrogen.msp.redhat.com>
	<Pine.LNX.4.64.1004071332130.20373@hs20-bc2-1.build.redhat.com>
	<D9522CD5-2AFA-4567-97E1-E0CA8A312236@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D9522CD5-2AFA-4567-97E1-E0CA8A312236@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> > How does that dlm protocol work? When a node needs a lock, what happens?
> > It sends all the nodes message about the lock? Or is there some master
> > node as an arbiter?
> 
> Yes, all nodes receive a message.  No, there is no central arbiter.  For
> example, if 4 nodes have a lock SHARED and the 5th one wants the lock
> EXCLUSIVE, the 4 nodes will get a notice requesting them to drop (or at least
> demote) the lock.

It would be good if the protocol worked only with two packet exchange --- 
i.e. node 1 holds the lock in cached mode, node 2 wants to get the lock, 
so it sends a message to node 1, node 1 sends the message to node 2 and 
now ndoe 2 owns the lock.

Is it this way in your implementation? Can/can't it be achieved with dlm? 
Or would it require a different locking protocol than dlm?

Please describe the packet exchange that it hapenning.

> > > where 'property flags' is, for example:
> > > PREALLOC_DLM: Get DLM lock in an unlocked state to prealloc necessary
> > > structs
> > 
> > How would it differ from non-PREALLOC_DLM behavior?
> 
> When a cluster lock is allocated, it could also acquire the DLM lock in the
> UNLOCKed state.  This forces the dlm to create the necessary structures for
> the lock and create entries in the global index.  This involves memory
> allocation (on multiple machines) and inter-machine communication.  The only
> reason you wouldn't want to do this is if the DLM module or the cluster
> infrastructure was not available at the time you are allocating the lock.
> 
> I could envision something like this if you were allocating the lock on module
> init for some reason.  In this case, you would want to delay the actions of
> the DLM until you needed the lock.
> 
> This seems like it would be a rare occurrence, so perhaps I could negate that
> flag to 'DELAY_DLM_INTERACTION' or some such thing.

One general rule: don't specify interface, if you can't find a user for 
this interface. Because there is a big chance that the interface will be 
misdesigned and you'll have to support the misdesigned interface for ages.

I.e. if you run snapshots always without "DELAY_DLM_INTERACTION", then 
don't make this flag at all. You can add it later when soneone needs it 
for his code.

> > > Since the 'name' of the lock - which is used to uniquely identify a lock
> > > by
> > > name cluster-wide - could conflict with the same name used by someone
> > > else,
> > > we could allow locks to be allocated from a new lockspace as well.  So,
> > > the
> > > option of creating your own lockspace would be available in addition to
> > > the
> > > default lockspace.
> > 
> > What is the exact lockspace-lockname relationship? You create
> > locspace "dm-snap" and lockname will be UUID of the logical volume?
> 
> The lockspace can be thought of as the location from which you acquire locks.
> When simply using UUIDs as names of locks, a single default lockspace would
> suffice.  However, if you are using block numbers or inode numbers as your
> lock names, these names may conflict if you were locking the same block number
> on two different devices.  In that case, you might create a lockspace for each
> device (perhaps named by the UUID) and acquire locks from these independent
> lock spaces based on block numbers.  Since the locks are being sourced from
> independent lockspaces, there is no chance of overloading/conflict.
> 
> IOW, if your design uses names for locks that could be used by other users of
> the DLM, you should consider creating your own lockspace.  In fact, the
> default lockspace that would be available through the this API would actually
> be a lockspace created specifically for the users of this new API - to prevent
> any possible conflict with other DLM users.  So in actuality, you would only
> need to create a new lockspace if you thought your lock names might conflict
> with those from other device-mapper target instances (including your own if
> you are using block numbers as the lock names).

So, every lock is identified by "lockspace,lockname" and it must be 
unique.

The best thing is to use UUID to guarantee this uniformity.

You can use static lockspace and UUID as a lockname.
Or UUID as a lockspace and static lockname.

Or you can stuff module name into the lockspace --- module name is 
guarateed to be unique. So that when different modules lock the same 
volume for different purposes, they won't be touching each other's locks.

Look how other dlm users do it --- do they use UUID, module name or other 
things?

Mikulas
