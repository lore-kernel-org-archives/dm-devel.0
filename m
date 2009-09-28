From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: lockspace interface
Date: Mon, 28 Sep 2009 14:19:33 -0500
Message-ID: <93DE2626-C027-41FE-BBC3-B925BF87758A@redhat.com>
References: <Pine.LNX.4.64.0909281445570.3880@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0909281445570.3880@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

The first UUID is for the lockspace.  You can have multiple  
lockspaces.  Taking out a lock with the exact same name in two  
different lockspaces would not conflict.

You need to identify your lockspace across the cluster.  In some  
cases, it makes sense to have the lockspace named according to the  
module that uses it - like "dm-clusterized-exception-module".  In  
these cases, there are infrequently used locks - one per device - that  
are named according to the device UUID.  So, if you have 4 cluster  
snapshots, you would have one lockspace with 4 infrequently used locks.

On the other hand, you may have a module (dm-raid45 comes to mind)  
where you are locking on a per sector basis.  You certainly don't want  
locks to conflict from one device to another.  So, you have a unique  
lockspace for each /device/.  The lockspace name could be the UUID of  
the dm device.  The locks would be named by their stripe, e.g. 1, 2,  
3, 576, etc.

So, it is not 2 level locking.  You merely create a cluster-wide known  
name for the lockspace and, once you have the lockspace, create locks  
by name (dm_cluster_lock_by_str) or by number (dm_cluster_lock).

The extra complexity of making the lock ops faster has not yet been  
done because it hasn't been needed.  The implementation I had used the  
locks as little as possible.  I figure I can introduce the lock  
concept in its simple form and improve things when/as necessary.

  brassow

On Sep 28, 2009, at 1:53 PM, Mikulas Patocka wrote:

> Hi
>
> What's the purpose of two-level uuid-locking?
> I.e. you call
> lockspace_handle = dm_cluster_lock_init(char *uuid1)
> and then
> dm_cluster_lock_by_str(void *lockspace_handle, char *uuid2, ...)
>
> Why not use just one uuid?
>
> Also think that locking will be heavily repeated (at least on a single
> node), so it is needed to make lock as fast as possible --- without  
> any
> string operations, hashing, searching, associated spinlocks.
>
> I'd propose to change the interface to
>
> lockspace_handle = dm_cluster_lock_init(char *uuid)
> dm_cluster_lock_by_str(void *lockspace_handle, ...)
>
> --- assume that "uuid" already uniquely identifies the snapshot ---  
> and
> that second uuid is unnecessary. You can then get rid of "find_dcl"
> function and its complexities (spinlock, list walking, strlen,  
> strcmp) ---
> so that they won't be executed on the fast path --- and  
> lockspace_handle
> could be a single pointer to struct dm_cluster_lock.
>
> Mikulas
