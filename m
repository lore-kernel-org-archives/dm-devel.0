Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06F4DEB64DD
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jun 2023 05:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687497996;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=s5JntsLd1wwOb9RmWmJiRvjfWJkZyC0oxwOIZVteMI8=;
	b=NKi29s705KQlOFdZ5+9Ls7FcYz2da1AhCdaLVphaYs5bDi2oPIaAg0NrmBA9LKCvQOWusf
	7M2PTEf5VwVHlpHAQ8sofeH3UHr8ngjrhoJ7TKbN7IGp+/jSFleQMPUXaqAjK/C280/92l
	qAvM8XQvoRODW2KUPcEtxQPnVqktJdo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581--85YU_X_NAyTURZ9S8T7tQ-1; Fri, 23 Jun 2023 01:26:25 -0400
X-MC-Unique: -85YU_X_NAyTURZ9S8T7tQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CCBD10504BC;
	Fri, 23 Jun 2023 05:25:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4D76DF5AE2;
	Fri, 23 Jun 2023 05:25:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EB4C619451F8;
	Fri, 23 Jun 2023 05:25:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BA4871946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 08:35:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 96B63112132E; Thu, 22 Jun 2023 08:35:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8ED36112132C
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:35:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CC368AB381
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:35:21 +0000 (UTC)
Received: from out-29.mta0.migadu.com (out-29.mta0.migadu.com
 [91.218.175.29]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-uUdhUDN2MU-t3phkjw_vJA-1; Thu, 22 Jun 2023 04:35:19 -0400
X-MC-Unique: uUdhUDN2MU-t3phkjw_vJA-1
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
Date: Thu, 22 Jun 2023 08:24:25 +0000
Message-Id: <20230622082454.4090236-1-qi.zheng@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Fri, 23 Jun 2023 05:25:40 +0000
Subject: [dm-devel] [PATCH 00/29] use refcount+RCU method to implement
 lockless slab shrink
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: mst@redhat.com, jasowang@redhat.com, dri-devel@lists.freedesktop.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org, song@kernel.org,
 dm-devel@redhat.com, ray.huang@amd.com, namit@vmware.com,
 marijn.suijten@somainline.org, airlied@gmail.com, agk@redhat.com,
 robh@kernel.org, senozhatsky@chromium.org, david@redhat.com, clm@fb.com,
 steven.price@arm.com, alyssa.rosenzweig@collabora.com,
 Qi Zheng <zhengqi.arch@bytedance.com>, josef@toxicpanda.com,
 linux-ext4@vger.kernel.org, kent.overstreet@gmail.com,
 xuanzhuo@linux.alibaba.com, linux-arm-msm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, snitzer@kernel.org, quic_abhinavk@quicinc.com,
 colyli@suse.de, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-bcache@vger.kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com,
 sean@poorly.run, linux-nfs@vger.kernel.org, tomeu.vizoso@collabora.com,
 kolga@netapp.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, minchan@kernel.org, robdclark@gmail.com,
 chuck.lever@oracle.com, daniel@ffwll.ch, jack@suse.com,
 dmitry.baryshkov@linaro.org, adilger.kernel@dilger.ca,
 freedreno@lists.freedesktop.org, christian.koenig@amd.com,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.dev
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Qi Zheng <zhengqi.arch@bytedance.com>

Hi all,

1. Background
=============

We used to implement the lockless slab shrink with SRCU [1], but then kernel
test robot reported -88.8% regression in stress-ng.ramfs.ops_per_sec test
case [2], so we reverted it [3].

This patch series aims to re-implement the lockless slab shrink using the
refcount+RCU method proposed by Dave Chinner [4].

[1]. https://lore.kernel.org/lkml/20230313112819.38938-1-zhengqi.arch@bytedance.com/
[2]. https://lore.kernel.org/lkml/202305230837.db2c233f-yujie.liu@intel.com/
[3]. https://lore.kernel.org/all/20230609081518.3039120-1-qi.zheng@linux.dev/
[4]. https://lore.kernel.org/lkml/ZIJhou1d55d4H1s0@dread.disaster.area/

2. Implementation
=================

Currently, the shrinker instances can be divided into the following three types:

a) global shrinker instance statically defined in the kernel, such as
   workingset_shadow_shrinker.

b) global shrinker instance statically defined in the kernel modules, such as
   mmu_shrinker in x86.

c) shrinker instance embedded in other structures.

For *case a*, the memory of shrinker instance is never freed. For *case b*, the
memory of shrinker instance will be freed after the module is unloaded. But we
will call synchronize_rcu() in free_module() to wait for RCU read-side critical
section to exit. For *case c*, we need to dynamically allocate these shrinker
instances, then the memory of shrinker instance can be dynamically freed alone
by calling kfree_rcu(). Then we can use rcu_read_{lock,unlock}() to ensure that
the shrinker instance is valid.

The shrinker::refcount mechanism ensures that the shrinker instance will not be
run again after unregistration. So the structure that records the pointer of
shrinker instance can be safely freed without waiting for the RCU read-side
critical section.

In this way, while we implement the lockless slab shrink, we don't need to be
blocked in unregister_shrinker() to wait RCU read-side critical section.

PATCH 1 ~ 2: infrastructure for dynamically allocating shrinker instances
PATCH 3 ~ 21: dynamically allocate the shrinker instances in case c
PATCH 22: introduce pool_shrink_rwsem to implement private synchronize_shrinkers()
PATCH 23 ~ 28: implement the lockless slab shrink
PATCH 29: move shrinker-related code into a separate file

3. Testing
==========

3.1 slab shrink stress test
---------------------------

We can reproduce the down_read_trylock() hotspot through the following script:

```

DIR="/root/shrinker/memcg/mnt"

do_create()
{
    mkdir -p /sys/fs/cgroup/memory/test
    mkdir -p /sys/fs/cgroup/perf_event/test
    echo 4G > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
    for i in `seq 0 $1`;
    do
        mkdir -p /sys/fs/cgroup/memory/test/$i;
        echo $$ > /sys/fs/cgroup/memory/test/$i/cgroup.procs;
        echo $$ > /sys/fs/cgroup/perf_event/test/cgroup.procs;
        mkdir -p $DIR/$i;
    done
}

do_mount()
{
    for i in `seq $1 $2`;
    do
        mount -t tmpfs $i $DIR/$i;
    done
}

do_touch()
{
    for i in `seq $1 $2`;
    do
        echo $$ > /sys/fs/cgroup/memory/test/$i/cgroup.procs;
        echo $$ > /sys/fs/cgroup/perf_event/test/cgroup.procs;
            dd if=/dev/zero of=$DIR/$i/file$i bs=1M count=1 &
    done
}

case "$1" in
  touch)
    do_touch $2 $3
    ;;
  test)
    do_create 4000
    do_mount 0 4000
    do_touch 0 3000
    ;;
  *)
    exit 1
    ;;
esac
```

Save the above script, then run test and touch commands. Then we can use the
following perf command to view hotspots:

perf top -U -F 999 [-g]

1) Before applying this patchset:

  35.34%  [kernel]             [k] down_read_trylock
  18.44%  [kernel]             [k] shrink_slab
  15.98%  [kernel]             [k] pv_native_safe_halt
  15.08%  [kernel]             [k] up_read
   5.33%  [kernel]             [k] idr_find
   2.71%  [kernel]             [k] _find_next_bit
   2.21%  [kernel]             [k] shrink_node
   1.29%  [kernel]             [k] shrink_lruvec
   0.66%  [kernel]             [k] do_shrink_slab
   0.33%  [kernel]             [k] list_lru_count_one
   0.33%  [kernel]             [k] __radix_tree_lookup
   0.25%  [kernel]             [k] mem_cgroup_iter

-   82.19%    19.49%  [kernel]                  [k] shrink_slab
   - 62.00% shrink_slab
        36.37% down_read_trylock
        15.52% up_read
        5.48% idr_find
        3.38% _find_next_bit
      + 0.98% do_shrink_slab

2) After applying this patchset:

  46.83%  [kernel]           [k] shrink_slab
  20.52%  [kernel]           [k] pv_native_safe_halt
   8.85%  [kernel]           [k] do_shrink_slab
   7.71%  [kernel]           [k] _find_next_bit
   1.72%  [kernel]           [k] xas_descend
   1.70%  [kernel]           [k] shrink_node
   1.44%  [kernel]           [k] shrink_lruvec
   1.43%  [kernel]           [k] mem_cgroup_iter
   1.28%  [kernel]           [k] xas_load
   0.89%  [kernel]           [k] super_cache_count
   0.84%  [kernel]           [k] xas_start
   0.66%  [kernel]           [k] list_lru_count_one

-   65.50%    40.44%  [kernel]                  [k] shrink_slab
   - 22.96% shrink_slab
        13.11% _find_next_bit
      - 9.91% do_shrink_slab
         - 1.59% super_cache_count
              0.92% list_lru_count_one

We can see that the first perf hotspot becomes shrink_slab, which is what we
expect.

3.2 registeration and unregisteration stress test
-------------------------------------------------

Run the command below to test:

stress-ng --timeout 60 --times --verify --metrics-brief --ramfs 9 &

1) Before applying this patchset:

 setting to a 60 second run per stressor
 dispatching hogs: 9 ramfs
 stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s
                           (secs)    (secs)    (secs)   (real time) (usr+sys time)
 ramfs            880623     60.02      7.71    226.93     14671.45        3753.09
 ramfs:
          1 System Management Interrupt
 for a 60.03s run time:
    5762.40s available CPU time
       7.71s user time   (  0.13%)
     226.93s system time (  3.94%)
     234.64s total time  (  4.07%)
 load average: 8.54 3.06 2.11
 passed: 9: ramfs (9)
 failed: 0
 skipped: 0
 successful run completed in 60.03s (1 min, 0.03 secs)

2) After applying this patchset:

 setting to a 60 second run per stressor
 dispatching hogs: 9 ramfs
 stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s
                           (secs)    (secs)    (secs)   (real time) (usr+sys time)
 ramfs            847562     60.02      7.44    230.22     14120.66        3566.23
 ramfs:
          4 System Management Interrupts
 for a 60.12s run time:
    5771.95s available CPU time
       7.44s user time   (  0.13%)
     230.22s system time (  3.99%)
     237.66s total time  (  4.12%)
 load average: 8.18 2.43 0.84
 passed: 9: ramfs (9)
 failed: 0
 skipped: 0
 successful run completed in 60.12s (1 min, 0.12 secs)

We can see that the ops/s has hardly changed.

This series is based on next-20230613.

Comments and suggestions are welcome.

Thanks,
Qi.

Qi Zheng (29):
  mm: shrinker: add shrinker::private_data field
  mm: vmscan: introduce some helpers for dynamically allocating shrinker
  drm/i915: dynamically allocate the i915_gem_mm shrinker
  drm/msm: dynamically allocate the drm-msm_gem shrinker
  drm/panfrost: dynamically allocate the drm-panfrost shrinker
  dm: dynamically allocate the dm-bufio shrinker
  dm zoned: dynamically allocate the dm-zoned-meta shrinker
  md/raid5: dynamically allocate the md-raid5 shrinker
  bcache: dynamically allocate the md-bcache shrinker
  vmw_balloon: dynamically allocate the vmw-balloon shrinker
  virtio_balloon: dynamically allocate the virtio-balloon shrinker
  mbcache: dynamically allocate the mbcache shrinker
  ext4: dynamically allocate the ext4-es shrinker
  jbd2,ext4: dynamically allocate the jbd2-journal shrinker
  NFSD: dynamically allocate the nfsd-client shrinker
  NFSD: dynamically allocate the nfsd-reply shrinker
  xfs: dynamically allocate the xfs-buf shrinker
  xfs: dynamically allocate the xfs-inodegc shrinker
  xfs: dynamically allocate the xfs-qm shrinker
  zsmalloc: dynamically allocate the mm-zspool shrinker
  fs: super: dynamically allocate the s_shrink
  drm/ttm: introduce pool_shrink_rwsem
  mm: shrinker: add refcount and completion_wait fields
  mm: vmscan: make global slab shrink lockless
  mm: vmscan: make memcg slab shrink lockless
  mm: shrinker: make count and scan in shrinker debugfs lockless
  mm: vmscan: hold write lock to reparent shrinker nr_deferred
  mm: shrinkers: convert shrinker_rwsem to mutex
  mm: shrinker: move shrinker-related code into a separate file

 drivers/gpu/drm/i915/gem/i915_gem_shrinker.c  |  27 +-
 drivers/gpu/drm/i915/i915_drv.h               |   3 +-
 drivers/gpu/drm/msm/msm_drv.h                 |   2 +-
 drivers/gpu/drm/msm/msm_gem_shrinker.c        |  25 +-
 drivers/gpu/drm/panfrost/panfrost_device.h    |   2 +-
 .../gpu/drm/panfrost/panfrost_gem_shrinker.c  |  24 +-
 drivers/gpu/drm/ttm/ttm_pool.c                |  15 +
 drivers/md/bcache/bcache.h                    |   2 +-
 drivers/md/bcache/btree.c                     |  23 +-
 drivers/md/bcache/sysfs.c                     |   2 +-
 drivers/md/dm-bufio.c                         |  23 +-
 drivers/md/dm-cache-metadata.c                |   2 +-
 drivers/md/dm-thin-metadata.c                 |   2 +-
 drivers/md/dm-zoned-metadata.c                |  25 +-
 drivers/md/raid5.c                            |  28 +-
 drivers/md/raid5.h                            |   2 +-
 drivers/misc/vmw_balloon.c                    |  16 +-
 drivers/virtio/virtio_balloon.c               |  26 +-
 fs/btrfs/super.c                              |   2 +-
 fs/ext4/ext4.h                                |   2 +-
 fs/ext4/extents_status.c                      |  21 +-
 fs/jbd2/journal.c                             |  32 +-
 fs/kernfs/mount.c                             |   2 +-
 fs/mbcache.c                                  |  39 +-
 fs/nfsd/netns.h                               |   4 +-
 fs/nfsd/nfs4state.c                           |  20 +-
 fs/nfsd/nfscache.c                            |  33 +-
 fs/proc/root.c                                |   2 +-
 fs/super.c                                    |  40 +-
 fs/xfs/xfs_buf.c                              |  25 +-
 fs/xfs/xfs_buf.h                              |   2 +-
 fs/xfs/xfs_icache.c                           |  27 +-
 fs/xfs/xfs_mount.c                            |   4 +-
 fs/xfs/xfs_mount.h                            |   2 +-
 fs/xfs/xfs_qm.c                               |  24 +-
 fs/xfs/xfs_qm.h                               |   2 +-
 include/linux/fs.h                            |   2 +-
 include/linux/jbd2.h                          |   2 +-
 include/linux/shrinker.h                      |  35 +-
 mm/Makefile                                   |   4 +-
 mm/shrinker.c                                 | 750 ++++++++++++++++++
 mm/shrinker_debug.c                           |  26 +-
 mm/vmscan.c                                   | 702 ----------------
 mm/zsmalloc.c                                 |  28 +-
 44 files changed, 1128 insertions(+), 953 deletions(-)
 create mode 100644 mm/shrinker.c

-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

