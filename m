From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Device-mapper cluster locking
Date: Wed, 07 Apr 2010 08:50:58 -0500
Message-ID: <1270648258.25738.18.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

I've been working on a cluster locking mechanism to be primarily used by
device-mapper targets.  The main goals are API simplicity and an ability
to tell if a resource has been modified remotely while a lock for the
resource was not held locally.  (IOW, Has the resource I am acquiring the
lock for changed since the last time I held the lock.)

The original API (header file below) required 4 locking modes: UNLOCK,
MONITOR, SHARED, and EXCLUSIVE.  The unfamiliar one, MONITOR, is similar to
UNLOCK; but it keeps some state associated with the lock so that the next
time the lock is acquired it can be determined whether the lock was
acquired EXCLUSIVE by another machine.

The original implementation did not cache cluster locks.  Cluster locks
were simply released (or put into a non-conflicting state) when the lock
was put into the UNLOCK or MONITOR mode.  I now have an implementation
that always caches cluster locks - releasing them only if needed by another
machine.  (A user may want to choose the appropriate implementation for
their workload - in which case, I can probably provide both implementations
through one API.)  The interesting thing about the new caching approach is
that I probably do not need this extra "MONITOR" state.  (If a lock that
is cached in the SHARED state is revoked, then obviously someone is looking
to alter the resource.  We don't need to have extra state to give us what
can already be inferred and returned from cached resources.)

I've also been re-thinking some of my assumptions about whether we
/really/ need separate lockspaces and how best to release resources
associated with each lock (i.e. get rid of a lock and its memory
because it will not be used again, rather than caching unnecessarily).
The original API (which is the same between the cached and non-caching
implementations) only operates by way of lock names.  This means a
couple of things:
1) Memory associated with a lock is allocated at the time the lock is
   needed instead of at the time the structure/resource it is protecting
   is allocated/initialized.
2) The locks will have to be tracked by the lock implementation.  This
   means hash tables, lookups, overlapping allocation checks, etc.
We can avoid these hazards and slow-downs if we separate the allocation
of a lock from the actual locking action.  We would then have a lock
life-cycle as follows:
- lock_ptr = dmcl_alloc_lock(name, property_flags)
- dmcl_write_lock(lock_ptr)
- dmcl_unlock(lock_ptr)
- dmcl_read_lock(lock_ptr)
- dmcl_unlock(lock_ptr)
- dmcl_free_lock(lock_ptr)
where 'property flags' is, for example:
PREALLOC_DLM: Get DLM lock in an unlocked state to prealloc necessary structs
CACHE_RD_LK: Cache DLM lock when unlocking read locks for later acquisitions
CACHE_WR_LK: Cache DLM lock when unlocking write locks for later acquisitions
USE_SEMAPHORE: also acquire a semaphore when acquiring cluster lock

Since the 'name' of the lock - which is used to uniquely identify a lock by
name cluster-wide - could conflict with the same name used by someone else,
we could allow locks to be allocated from a new lockspace as well.  So, the
option of creating your own lockspace would be available in addition to the
default lockspace.

The code has been written, I just need to arrange it into the right functional
layout...  Would this new locking API make more sense to people?  Mikulas,
what would you prefer for cluster snapshots?

 brassow

<Original locking API>
enum dm_cluster_lock_mode {
        DM_CLUSTER_LOCK_UNLOCK,

        /*
         * DM_CLUSTER_LOCK_MONITOR
         *
         * Aquire the lock in this mode to monitor if another machine
         * aquires this lock in the DM_CLUSTER_LOCK_EXCLUSIVE mode.  Later,
         * when aquiring the lock in DM_CLUSTER_LOCK_EXCLUSIVE or
         * DM_CLUSTER_LOCK_SHARED mode, dm_cluster_lock will return '1' if
         * the lock had been aquired DM_CLUSTER_LOCK_EXCLUSIVE.
         *
         * This is useful because it gives the programmer a way of knowing if
         * they need to perform an operation (invalidate cache, read additional
         * metadata, etc) after aquiring the cluster lock.
         */
        DM_CLUSTER_LOCK_MONITOR,

        DM_CLUSTER_LOCK_SHARED,

        DM_CLUSTER_LOCK_EXCLUSIVE,
};

/**
 * dm_cluster_lock_init
 * @uuid: The name given to this lockspace
 *
 * Returns: handle pointer on success, ERR_PTR(-EXXX) on failure
 **/
void *dm_cluster_lock_init(char *uuid);

/**
 * dm_cluster_lock_exit
 * @h: The handle returned from dm_cluster_lock_init
 */
void dm_cluster_lock_exit(void *h);

/**
 * dm_cluster_lock
 * @h      : The handle returned from 'dm_cluster_lock_init'
 * @lock_nr: The lock number
 * @mode   : One of DM_CLUSTER_LOCK_* (how to hold the lock)
 * @callback: If provided, function will be non-blocking and use this
 *           to notify caller when the lock is aquired.  If not provided,
 *           this function will block until the lock is aquired.
 * @callback_data: User context data that will be provided via the callback fn.
 *
 * Returns: -EXXX on error or 0 on success for DM_CLUSTER_LOCK_*
 *         1 is a possible return if EXCLUSIVE/SHARED is the lock action,
 *         the lock operation is successful, and an exlusive lock was aquired
 *         by another machine while the lock was held in the
 *         DM_CLUSTERED_LOCK_MONITOR state.
 **/
int dm_cluster_lock(void *h, uint64_t lock_nr, enum dm_cluster_lock_mode mode,
                    void (*callback)(void *data, int rtn), void *data);

/*
 * dm_cluster_lock_by_name
 * @lock_name: The lock name (up to 128 characters)
 *
 * Otherwise, the same as 'dm_cluster_lock'
 */
int dm_cluster_lock_by_str(void *h, const char *lock_name,
                           enum dm_cluster_lock_mode mode,
                           void (*callback)(void *data, int rtn), void *data);
</Original locking API>
