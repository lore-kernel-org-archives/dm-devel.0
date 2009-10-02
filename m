From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: clustered snapshots
Date: Fri, 2 Oct 2009 13:55:57 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0910021351100.14067@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0909281906510.16904@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0909291734020.12870@hs20-bc2-1.build.redhat.com>
	<20091002172656.GA13491@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091002172656.GA13491@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

> I have done some light snapshot-merge testing to verify that this
> updated snapshot-merge quilt tree builds and works as expected.  I'll be
> testing more extensively shortly (particularly back-merge).
> 
> I have also updated the LVM2 snapshot-merge patches to work on 2.02.54-cvs:
> http://people.redhat.com/msnitzer/patches/snapshot-merge/lvm2/LVM2-2.02.54/
> 
> One thing to note is dm-snapshot now depends on dm_cluster_locking; when I
> tried to insmod dm-snapshot.ko I got:
> dm_snapshot: Unknown symbol dm_cluster_lock_exit
> dm_snapshot: Unknown symbol dm_cluster_lock_by_str
> dm_snapshot: Unknown symbol dm_cluster_lock_init

That is expected and it shouldn't make problems (modprobe handles 
dependences, just insmod doesn't). If you compile the kernel without 
dm_cluster_locking, it would not use it and it would have clustering 
disabled.

> I'm also seeing:
> DLM (built Sep 11 2009 23:48:05) installed
> dlm: no local IP address has been set
> dlm: cannot start dlm lowcomms -107
> device-mapper: dm-cluster-locking: Failed to create lockspace: dm-snap
> 
> Am I just missing the relevant LVM2 bits to push down proper args to the
> snapshot_ctr()?  Seems to me that we could do better about defaulting to
> _not_ triggering DLM/clustered calls...

That just means that you can't use clustering because you didn't configure 
DLM, otherwise it is harmless. I will redo the patch so that it tries to 
initialized dlm only if cluster arguments are supplied --- so that the 
message won't scare people.

> Also, I have no idea if I somehow messed up the clustered-locking
> patches when I refreshed them to work with my quilt tree.  I had a quick
> review of the patch changes I made and the only one that needs a closer
> look was dm-snapshot-clustered-locking-optimize.patch.

You didn't mess it, I get the same message too. But it is harmless.

> Mikulas please review/rebase your tree using my updated quilt tree and
> let me know if you see any issues.  Maybe you have newer patches at this
> point?
> 
> Thanks,
> Mike

Mikulas
