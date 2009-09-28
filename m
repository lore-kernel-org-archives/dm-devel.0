From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: lockspace interface
Date: Mon, 28 Sep 2009 16:56:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0909281646510.25182@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0909281445570.3880@hs20-bc2-1.build.redhat.com>
	<93DE2626-C027-41FE-BBC3-B925BF87758A@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <93DE2626-C027-41FE-BBC3-B925BF87758A@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids



On Mon, 28 Sep 2009, Jonathan Brassow wrote:

> The first UUID is for the lockspace.  You can have multiple lockspaces.
> Taking out a lock with the exact same name in two different lockspaces would
> not conflict.
> 
> You need to identify your lockspace across the cluster.  In some cases, it
> makes sense to have the lockspace named according to the module that uses it -
> like "dm-clusterized-exception-module".  In these cases, there are
> infrequently used locks - one per device - that are named according to the
> device UUID.  So, if you have 4 cluster snapshots, you would have one
> lockspace with 4 infrequently used locks.
> 
> On the other hand, you may have a module (dm-raid45 comes to mind) where you
> are locking on a per sector basis.  You certainly don't want locks to conflict
> from one device to another.  So, you have a unique lockspace for each
> /device/.  The lockspace name could be the UUID of the dm device.  The locks
> would be named by their stripe, e.g. 1, 2, 3, 576, etc.
> 
> So, it is not 2 level locking.

I know. It's two level naming.

> You merely create a cluster-wide known name
> for the lockspace and, once you have the lockspace, create locks by name
> (dm_cluster_lock_by_str) or by number (dm_cluster_lock).

Seems that DLM is already overengeneered.

For our use: UUID is supposed to be unique, so we don't need to identify 
by a module name. If we consider non-unique UUIDs, we can identify the 
lock by some string like "dm-snap:uuid" or so.

So I'd simply use plain one-level naming interface.

It seems easiest to create one lockspace handle per one snapshot, then you 
wouldn't have to pass strings to dm_cluster_lock_by_str and dlm_lock. And 
simply make lockspace_handle point to struct dm_cluster_lock. And pass an 
empty string to dlm_lock.

> The extra complexity of making the lock ops faster has not yet been done
> because it hasn't been needed.  The implementation I had used the locks as
> little as possible.  I figure I can introduce the lock concept in its simple
> form and improve things when/as necessary.

This is not an extra complexity, if you simplify the interface, then you 
simplify the implementation as well AND make it faster. So you cut down 
both programming time and execution time.

If you do it with one-level naming, you can remove struct 
dm_lockspace_instance, remove __lookup_dcl, find_dcl, join 
dm_cluster_lock_init+allocate_dcl and join dm_cluster_lock_exit+free_dcl.

> brassow

Mikulas
