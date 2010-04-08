From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: Device-mapper cluster locking
Date: Thu, 8 Apr 2010 11:38:03 -0500
Message-ID: <D9522CD5-2AFA-4567-97E1-E0CA8A312236@redhat.com>
References: <1270648258.25738.18.camel@hydrogen.msp.redhat.com>
	<Pine.LNX.4.64.1004071332130.20373@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1004071332130.20373@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Thanks for your response.  Comments in-lined.

On Apr 7, 2010, at 12:49 PM, Mikulas Patocka wrote:

> Hi
>
> On Wed, 7 Apr 2010, Jonathan Brassow wrote:
>
>> I've been working on a cluster locking mechanism to be primarily  
>> used by
>> device-mapper targets.  The main goals are API simplicity and an  
>> ability
>> to tell if a resource has been modified remotely while a lock for the
>> resource was not held locally.  (IOW, Has the resource I am  
>> acquiring the
>> lock for changed since the last time I held the lock.)
>>
>> The original API (header file below) required 4 locking modes:  
>> UNLOCK,
>> MONITOR, SHARED, and EXCLUSIVE.  The unfamiliar one, MONITOR, is  
>> similar to
>> UNLOCK; but it keeps some state associated with the lock so that  
>> the next
>> time the lock is acquired it can be determined whether the lock was
>> acquired EXCLUSIVE by another machine.
>>
>> The original implementation did not cache cluster locks.  Cluster  
>> locks
>> were simply released (or put into a non-conflicting state) when the  
>> lock
>> was put into the UNLOCK or MONITOR mode.  I now have an  
>> implementation
>> that always caches cluster locks - releasing them only if needed by  
>> another
>> machine.  (A user may want to choose the appropriate implementation  
>> for
>> their workload - in which case, I can probably provide both  
>> implementations
>> through one API.)
>
> Maybe you can think about autotuning it --- i.e. count how many times
> caching "won" (the lock was taken by the same node) or "lost" (the  
> lock
> was acquired by another node) and keep or release the lock based on  
> the
> ratio of these two counts. Decay the counts over time, so that it  
> adjusts
> on workload change.

Certainly, that sounds like a sensible thing to do; and I think there  
is some precedent out there for this.

>
> How does that dlm protocol work? When a node needs a lock, what  
> happens?
> It sends all the nodes message about the lock? Or is there some master
> node as an arbiter?

Yes, all nodes receive a message.  No, there is no central arbiter.   
For example, if 4 nodes have a lock SHARED and the 5th one wants the  
lock EXCLUSIVE, the 4 nodes will get a notice requesting them to drop  
(or at least demote) the lock.

>
>> The interesting thing about the new caching approach is
>> that I probably do not need this extra "MONITOR" state.  (If a lock  
>> that
>> is cached in the SHARED state is revoked, then obviously someone is  
>> looking
>> to alter the resource.  We don't need to have extra state to give  
>> us what
>> can already be inferred and returned from cached resources.)
>
> Yes, MONITOR and UNLOCK could be joined.
>
>> I've also been re-thinking some of my assumptions about whether we
>> /really/ need separate lockspaces and how best to release resources
>> associated with each lock (i.e. get rid of a lock and its memory
>> because it will not be used again, rather than caching  
>> unnecessarily).
>> The original API (which is the same between the cached and non- 
>> caching
>> implementations) only operates by way of lock names.  This means a
>> couple of things:
>> 1) Memory associated with a lock is allocated at the time the lock is
>>   needed instead of at the time the structure/resource it is  
>> protecting
>>   is allocated/initialized.
>> 2) The locks will have to be tracked by the lock implementation.   
>> This
>>   means hash tables, lookups, overlapping allocation checks, etc.
>> We can avoid these hazards and slow-downs if we separate the  
>> allocation
>> of a lock from the actual locking action.  We would then have a lock
>> life-cycle as follows:
>> - lock_ptr = dmcl_alloc_lock(name, property_flags)
>> - dmcl_write_lock(lock_ptr)
>> - dmcl_unlock(lock_ptr)
>> - dmcl_read_lock(lock_ptr)
>> - dmcl_unlock(lock_ptr)
>> - dmcl_free_lock(lock_ptr)
>
> I think it is good --- way better than passing the character string on
> every call, parsing the string, hashinh it and comparing.
>
> If you do it this way, you speed up lock acquires and releases.
>
>> where 'property flags' is, for example:
>> PREALLOC_DLM: Get DLM lock in an unlocked state to prealloc  
>> necessary structs
>
> How would it differ from non-PREALLOC_DLM behavior?

When a cluster lock is allocated, it could also acquire the DLM lock  
in the UNLOCKed state.  This forces the dlm to create the necessary  
structures for the lock and create entries in the global index.  This  
involves memory allocation (on multiple machines) and inter-machine  
communication.  The only reason you wouldn't want to do this is if the  
DLM module or the cluster infrastructure was not available at the time  
you are allocating the lock.

I could envision something like this if you were allocating the lock  
on module init for some reason.  In this case, you would want to delay  
the actions of the DLM until you needed the lock.

This seems like it would be a rare occurrence, so perhaps I could  
negate that flag to 'DELAY_DLM_INTERACTION' or some such thing.

>
>> CACHE_RD_LK: Cache DLM lock when unlocking read locks for later  
>> acquisitions
>
> OK.
>
>> CACHE_WR_LK: Cache DLM lock when unlocking write locks for later  
>> acquisitions
>
> OK.
>
>> USE_SEMAPHORE: also acquire a semaphore when acquiring cluster lock
>
> Which semaphore? If the user needs a specific semaphore, he can just
> acquire it with down() --- there is no need to overload dm-locking  
> with
> that. Or is there any other reason why it is needed?

Ok, I thought this might bring a degree of convenience; but I will  
happily not include this option if it makes things bloated.  I will  
simply leave this out in any initial version.

>> Since the 'name' of the lock - which is used to uniquely identify a  
>> lock by
>> name cluster-wide - could conflict with the same name used by  
>> someone else,
>> we could allow locks to be allocated from a new lockspace as well.   
>> So, the
>> option of creating your own lockspace would be available in  
>> addition to the
>> default lockspace.
>
> What is the exact lockspace-lockname relationship? You create
> locspace "dm-snap" and lockname will be UUID of the logical volume?

The lockspace can be thought of as the location from which you acquire  
locks.  When simply using UUIDs as names of locks, a single default  
lockspace would suffice.  However, if you are using block numbers or  
inode numbers as your lock names, these names may conflict if you were  
locking the same block number on two different devices.  In that case,  
you might create a lockspace for each device (perhaps named by the  
UUID) and acquire locks from these independent lock spaces based on  
block numbers.  Since the locks are being sourced from independent  
lockspaces, there is no chance of overloading/conflict.

IOW, if your design uses names for locks that could be used by other  
users of the DLM, you should consider creating your own lockspace.  In  
fact, the default lockspace that would be available through the this  
API would actually be a lockspace created specifically for the users  
of this new API - to prevent any possible conflict with other DLM  
users.  So in actuality, you would only need to create a new lockspace  
if you thought your lock names might conflict with those from other  
device-mapper target instances (including your own if you are using  
block numbers as the lock names).

>
>> The code has been written, I just need to arrange it into the right  
>> functional
>> layout...  Would this new locking API make more sense to people?   
>> Mikulas,
>> what would you prefer for cluster snapshots?
>>
>> brassow
>
> I think using alloc/free interface is good.
>
> BTW. also, think about failure handling. If there is a communication
> problem, the lock may fail. What to do? Detach the whole exception  
> store
> and stop touching it? Can unlock fail?

Yes, dlm operations can fail or stall (due to quorum issues or network  
outage).  I'll talk with some of the other users (GFS) to see how they  
cope with these issues.

The caching aspect may help limit some of the failure cases.  If you  
unlock, the DLM lock will not be release until it is needed.  A  
machine will be notified of the need to release the lock only if  
communication is working properly.

The locking API can always return failure from the functions and leave  
the decision up to the user; but perhaps there are better solutions  
already in play by other users of the DLM.  I will ask them.

  brassow
