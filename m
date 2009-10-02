From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: clustered snapshots
Date: Fri, 2 Oct 2009 13:26:56 -0400
Message-ID: <20091002172656.GA13491@redhat.com>
References: <Pine.LNX.4.64.0909281906510.16904@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0909291734020.12870@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909291734020.12870@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Sep 29 2009 at  5:39pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> I uploaded a new version there. It has selective re-read and it has 
> optimized locking --- it does no remote communication if the chunk already 
> exists, so it should be as efficient as Jon's approach.
> 
> Jon, please look at it and review the patches, if you find out that this 
> approach can't work at all, we can drop it and go with your approach. If 
> it is OK, we can consider adopting it, it looks simpler than making 
> clustered-exception-store.
> 
> Mikulas
> 
> 
> On Mon, 28 Sep 2009, Mikulas Patocka wrote:
> 
> > Hi
> > 
> > I uploaded my test clustered snapshots to 
> > http://people.redhat.com/mpatocka/patches/kernel/clustered-snapshots-preview/

I have updated the following quilt tree and folded Mikulas' clustered
snapshots patches into the end:
http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel/2.6.31/

Changes include:
. check for {prepare,commit}_merge not {prepare,commit}_exception in
  snapshot_merge_process (dm-snapshot-merge-process.patch)
. removed kernel/dm-exception-store-return-zero-when-empty.patch
  - adjusted dm-exception-store-merge-accounting.patch to preserve
    established kernel<->userspace interface
  - adjusted a few other patches
. removed kernel/dm-snapshot-dont-insert-before-existing-chunk.patch
. moved proper cleanup of memory exceptions in merge_callback() from
  dm-snapshot-merge-use-larger-io-when-merging.patch to
  dm-snapshot-merge-interlock-writes.patch
  - this merge_callback() code walks exceptions in reverse but has not
    been tested on a larger merge to know whether the 'back-merge' of
    exceptions is properly being accounted for when cleaning up the
    in-core snapshot exceptions.
    - I think the fact that the exception cleanup is 2 stage (first
      disk, then all in memory exceptions in reverse) may make
      back-merge "just work"...
. added agk's pending patches to the front of the series
  - this works on 2.6.31
  - I haven't rebased to 2.6.32-rc1 yet

I have done some light snapshot-merge testing to verify that this
updated snapshot-merge quilt tree builds and works as expected.  I'll be
testing more extensively shortly (particularly back-merge).

I have also updated the LVM2 snapshot-merge patches to work on 2.02.54-cvs:
http://people.redhat.com/msnitzer/patches/snapshot-merge/lvm2/LVM2-2.02.54/

One thing to note is dm-snapshot now depends on dm_cluster_locking; when I
tried to insmod dm-snapshot.ko I got:
dm_snapshot: Unknown symbol dm_cluster_lock_exit
dm_snapshot: Unknown symbol dm_cluster_lock_by_str
dm_snapshot: Unknown symbol dm_cluster_lock_init

I'm also seeing:
DLM (built Sep 11 2009 23:48:05) installed
dlm: no local IP address has been set
dlm: cannot start dlm lowcomms -107
device-mapper: dm-cluster-locking: Failed to create lockspace: dm-snap

Am I just missing the relevant LVM2 bits to push down proper args to the
snapshot_ctr()?  Seems to me that we could do better about defaulting to
_not_ triggering DLM/clustered calls...

Also, I have no idea if I somehow messed up the clustered-locking
patches when I refreshed them to work with my quilt tree.  I had a quick
review of the patch changes I made and the only one that needs a closer
look was dm-snapshot-clustered-locking-optimize.patch.

Mikulas please review/rebase your tree using my updated quilt tree and
let me know if you see any issues.  Maybe you have newer patches at this
point?

Thanks,
Mike
