From: Teng-Feng Yang <shinrairis@gmail.com>
Subject: Possible bug when releasing metadata snapshot in dm-thin
Date: Wed, 19 Nov 2014 17:21:52 +0800
Message-ID: <CAKTMprOM+0dZV_XhvkLJCNuq6kmAbg-9uor7wkin5v3MGXRVJg@mail.gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi all,

I accidentally run into this weird situation which looks like a bug to me.
This bug can be reproduced every time with the following steps.

1) Create a thin pool and a thin volume.
2) Write some data to this thin volume.
3) Reserve metadata snapshot by sending "reserve_metadata_snap" to pool.
4) Create a snapshot for the thin volume.
5) Release metadata snapshot by sending "release_metadata_snap" to pool
6) Remove both the snapshot and thin volume.

After these steps, pool blocks allocated to the thin volume are never
returned to the pool. I trace the code of releasing metadata snapshot,
and I might find the root cause of this. When reserving metadata
snapshot, we will increase the reference count of data mapping root by
1. However, the subsequent changes to the data mapping tree will split
the data mapping tree which results in increasing reference counts of
all bottom level roots. When releasing metadata snapshot, we simply
decrease the reference count of the old data mapping root without
propagating these reference count decrements all the way down. IMHO,
maybe we should call dm_btree_del() on the old data mapping root
instead of dm_sm_dec_refcount().

Any help would be grateful.
Best Regards,

Dennis
