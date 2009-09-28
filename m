From: Mikulas Patocka <mpatocka@redhat.com>
Subject: lockspace interface
Date: Mon, 28 Sep 2009 14:53:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0909281445570.3880@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
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

Hi

What's the purpose of two-level uuid-locking?
I.e. you call
lockspace_handle = dm_cluster_lock_init(char *uuid1)
and then
dm_cluster_lock_by_str(void *lockspace_handle, char *uuid2, ...)

Why not use just one uuid?

Also think that locking will be heavily repeated (at least on a single 
node), so it is needed to make lock as fast as possible --- without any 
string operations, hashing, searching, associated spinlocks.

I'd propose to change the interface to

lockspace_handle = dm_cluster_lock_init(char *uuid)
dm_cluster_lock_by_str(void *lockspace_handle, ...)

--- assume that "uuid" already uniquely identifies the snapshot --- and 
that second uuid is unnecessary. You can then get rid of "find_dcl" 
function and its complexities (spinlock, list walking, strlen, strcmp) --- 
so that they won't be executed on the fast path --- and lockspace_handle 
could be a single pointer to struct dm_cluster_lock.

Mikulas
