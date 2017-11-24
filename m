From: monty <monty_pavel@sina.com>
Subject: Re: [PATCH] dm thin: fix NULL pointer exception caused
 by two concurrent "vgchange -ay -K <vg name>" processes.
Date: Sat, 25 Nov 2017 01:43:50 +0800
Message-ID: <39821.3812419728$1511545511@news.gmane.org>
References: <201711241659129513254@sina.com>
	<20171124141258.GH5952@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EVF5PPMfhYS0aIcm"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20171124141258.GH5952@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Yes, it is. New patch is as follows:

We got a NULL pointer exception when testing the two concurrent
 "vgchange -ay -K <vg name>".
 panic call trace:
 PID: 25992 TASK: ffff883cd7d23500 CPU: 4 COMMAND: "vgchange"
  #0 [ffff883cd743d600] machine_kexec at ffffffff81038fa9
  0000001 [ffff883cd743d660] crash_kexec at ffffffff810c5992
  0000002 [ffff883cd743d730] oops_end at ffffffff81515c90
  0000003 [ffff883cd743d760] no_context at ffffffff81049f1b
  0000004 [ffff883cd743d7b0] __bad_area_nosemaphore at ffffffff8104a1a5
  0000005 [ffff883cd743d800] bad_area at ffffffff8104a2ce
  0000006 [ffff883cd743d830] __do_page_fault at ffffffff8104aa6f
  0000007 [ffff883cd743d950] do_page_fault at ffffffff81517bae
  0000008 [ffff883cd743d980] page_fault at ffffffff81514f95
     [exception RIP: kmem_cache_alloc+108]
     RIP: ffffffff8116ef3c RSP: ffff883cd743da38 RFLAGS: 00010046
     RAX: 0000000000000004 RBX: ffffffff81121b90 RCX: ffff881bf1e78cc0
     RDX: 0000000000000000 RSI: 00000000000000d0 RDI: 0000000000000000
     RBP: ffff883cd743da68 R8: ffff881bf1a4eb00 R9: 0000000080042000
     R10: 0000000000002000 R11: 0000000000000000 R12: 00000000000000d0
     R13: 0000000000000000 R14: 00000000000000d0 R15: 0000000000000246
     ORIG_RAX: ffffffffffffffff CS: 0010 SS: 0018
  0000009 [ffff883cd743da70] mempool_alloc_slab at ffffffff81121ba5
 0000010 [ffff883cd743da80] mempool_create_node at ffffffff81122083
 0000011 [ffff883cd743dad0] mempool_create at ffffffff811220f4
 0000012 [ffff883cd743dae0] pool_ctr at ffffffffa08de049 [dm_thin_pool]
 0000013 [ffff883cd743dbd0] dm_table_add_target at ffffffffa0005f2f [dm_mod]
 0000014 [ffff883cd743dc30] table_load at ffffffffa0008ba9 [dm_mod]
 0000015 [ffff883cd743dc90] ctl_ioctl at ffffffffa0009dc4 [dm_mod]
 this bug's scence is as follows:
 process A(vgchange -ay -K):
 	a. send DM_LIST_VERSIONS_CMD ioctl;
 	b. pool_target not registered;
 	c. modprobe dm_thin_pool and wait until end.
 process B(vgchange -ay -K):
 	a. send DM_LIST_VERSIONS_CMD ioctl;
 	b. pool_target registered;
 	c. table_load->dm_table_add_target->pool_ctr;
 	d. _new_mapping_cache is NULL and panic.
 note:
 	1. process A and process B are two concurrent processes.
 	2. pool_target can be detected by process B but
 	_new_mapping_cache initialization has not ended.
 All that we need do is to ensure pool_target registering ops
 is the last ops in dm_thin_init.
 So does the dm-cache, dm-mpath, and dm-snap. Thanks for Alasdair G
 Kergon<agk@redhat.com> reminding me.

Signed-off-by: monty <monty_pavel@sina.com>
Signed-off-by: Alasdair G Kergon<agk@redhat.com>
---
 drivers/md/dm-cache-target.c |   12 +++++-----
 drivers/md/dm-mpath.c        |   18 +++++++-------
 drivers/md/dm-snap.c         |   48 +++++++++++++++++++++---------------------
 drivers/md/dm-thin.c         |   22 ++++++++----------
 4 files changed, 49 insertions(+), 51 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index cf23a14..47407e4 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -3472,18 +3472,18 @@ static int __init dm_cache_init(void)
 {
 	int r;
 
-	r = dm_register_target(&cache_target);
-	if (r) {
-		DMERR("cache target registration failed: %d", r);
-		return r;
-	}
-
 	migration_cache = KMEM_CACHE(dm_cache_migration, 0);
 	if (!migration_cache) {
 		dm_unregister_target(&cache_target);
 		return -ENOMEM;
 	}
 
+	r = dm_register_target(&cache_target);
+	if (r) {
+		DMERR("cache target registration failed: %d", r);
+		return r;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index c8faa2b..35a2a2f 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1957,13 +1957,6 @@ static int __init dm_multipath_init(void)
 {
 	int r;
 
-	r = dm_register_target(&multipath_target);
-	if (r < 0) {
-		DMERR("request-based register failed %d", r);
-		r = -EINVAL;
-		goto bad_register_target;
-	}
-
 	kmultipathd = alloc_workqueue("kmpathd", WQ_MEM_RECLAIM, 0);
 	if (!kmultipathd) {
 		DMERR("failed to create workqueue kmpathd");
@@ -1985,13 +1978,20 @@ static int __init dm_multipath_init(void)
 		goto bad_alloc_kmpath_handlerd;
 	}
 
+	r = dm_register_target(&multipath_target);
+	if (r < 0) {
+		DMERR("request-based register failed %d", r);
+		r = -EINVAL;
+		goto bad_register_target;
+	}
+
 	return 0;
 
+bad_register_target:
+	destroy_workqueue(kmpath_handlerd);
 bad_alloc_kmpath_handlerd:
 	destroy_workqueue(kmultipathd);
 bad_alloc_kmultipathd:
-	dm_unregister_target(&multipath_target);
-bad_register_target:
 	return r;
 }
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 1113b42..a0613bd 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2411,24 +2411,6 @@ static int __init dm_snapshot_init(void)
 		return r;
 	}
 
-	r = dm_register_target(&snapshot_target);
-	if (r < 0) {
-		DMERR("snapshot target register failed %d", r);
-		goto bad_register_snapshot_target;
-	}
-
-	r = dm_register_target(&origin_target);
-	if (r < 0) {
-		DMERR("Origin target register failed %d", r);
-		goto bad_register_origin_target;
-	}
-
-	r = dm_register_target(&merge_target);
-	if (r < 0) {
-		DMERR("Merge target register failed %d", r);
-		goto bad_register_merge_target;
-	}
-
 	r = init_origin_hash();
 	if (r) {
 		DMERR("init_origin_hash failed.");
@@ -2449,19 +2431,37 @@ static int __init dm_snapshot_init(void)
 		goto bad_pending_cache;
 	}
 
+	r = dm_register_target(&snapshot_target);
+	if (r < 0) {
+		DMERR("snapshot target register failed %d", r);
+		goto bad_register_snapshot_target;
+	}
+
+	r = dm_register_target(&origin_target);
+	if (r < 0) {
+		DMERR("Origin target register failed %d", r);
+		goto bad_register_origin_target;
+	}
+
+	r = dm_register_target(&merge_target);
+	if (r < 0) {
+		DMERR("Merge target register failed %d", r);
+		goto bad_register_merge_target;
+	}
+
 	return 0;
 
-bad_pending_cache:
-	kmem_cache_destroy(exception_cache);
-bad_exception_cache:
-	exit_origin_hash();
-bad_origin_hash:
-	dm_unregister_target(&merge_target);
 bad_register_merge_target:
 	dm_unregister_target(&origin_target);
 bad_register_origin_target:
 	dm_unregister_target(&snapshot_target);
 bad_register_snapshot_target:
+	kmem_cache_destroy(pending_cache);
+bad_pending_cache:
+	kmem_cache_destroy(exception_cache);
+bad_exception_cache:
+	exit_origin_hash();
+bad_origin_hash:
 	dm_exception_store_exit();
 
 	return r;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 89e5dff..f91d771 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4355,30 +4355,28 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static int __init dm_thin_init(void)
 {
-	int r;
+	int r = -ENOMEM;
 
 	pool_table_init();
 
+	_new_mapping_cache = KMEM_CACHE(dm_thin_new_mapping, 0);
+	if (!_new_mapping_cache)
+		return r;
+
 	r = dm_register_target(&thin_target);
 	if (r)
-		return r;
+		goto bad_new_mapping_cache;
 
 	r = dm_register_target(&pool_target);
 	if (r)
-		goto bad_pool_target;
-
-	r = -ENOMEM;
-
-	_new_mapping_cache = KMEM_CACHE(dm_thin_new_mapping, 0);
-	if (!_new_mapping_cache)
-		goto bad_new_mapping_cache;
+		goto bad_thin_target;
 
 	return 0;
 
-bad_new_mapping_cache:
-	dm_unregister_target(&pool_target);
-bad_pool_target:
+bad_thin_target:
 	dm_unregister_target(&thin_target);
+bad_new_mapping_cache:
+	kmem_cache_destroy(_new_mapping_cache);
 
 	return r;
 }
-- 
1.7.1


On Fri, Nov 24, 2017 at 02:12:59PM +0000, Alasdair G Kergon wrote:
> 
> On Fri, Nov 24, 2017 at 04:59:13PM +0800, monty_pavel@sina.com wrote:
> >     All that we need do is to ensure pool_target registering ops
> >     is the last ops in dm_thin_init.
>  
> Any other targets wrong too?  cache?  multipath?  snapshot?
> 
> Alasdair
> 
> 
> 

--EVF5PPMfhYS0aIcm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-We-got-a-NULL-pointer-exception-when-testing-the-two.patch"

From c031cdcd0e88f36e295c60506322279bbaba999b Mon Sep 17 00:00:00 2001
From: monty <monty_pavel@sina.com>
Date: Fri, 24 Nov 2017 10:54:05 -0500
Subject: [PATCH] We got a NULL pointer exception when testing the two concurrent
 "vgchange -ay -K <vg name>".
 panic call trace:
 PID: 25992 TASK: ffff883cd7d23500 CPU: 4 COMMAND: "vgchange"
  #0 [ffff883cd743d600] machine_kexec at ffffffff81038fa9
  0000001 [ffff883cd743d660] crash_kexec at ffffffff810c5992
  0000002 [ffff883cd743d730] oops_end at ffffffff81515c90
  0000003 [ffff883cd743d760] no_context at ffffffff81049f1b
  0000004 [ffff883cd743d7b0] __bad_area_nosemaphore at ffffffff8104a1a5
  0000005 [ffff883cd743d800] bad_area at ffffffff8104a2ce
  0000006 [ffff883cd743d830] __do_page_fault at ffffffff8104aa6f
  0000007 [ffff883cd743d950] do_page_fault at ffffffff81517bae
  0000008 [ffff883cd743d980] page_fault at ffffffff81514f95
     [exception RIP: kmem_cache_alloc+108]
     RIP: ffffffff8116ef3c RSP: ffff883cd743da38 RFLAGS: 00010046
     RAX: 0000000000000004 RBX: ffffffff81121b90 RCX: ffff881bf1e78cc0
     RDX: 0000000000000000 RSI: 00000000000000d0 RDI: 0000000000000000
     RBP: ffff883cd743da68 R8: ffff881bf1a4eb00 R9: 0000000080042000
     R10: 0000000000002000 R11: 0000000000000000 R12: 00000000000000d0
     R13: 0000000000000000 R14: 00000000000000d0 R15: 0000000000000246
     ORIG_RAX: ffffffffffffffff CS: 0010 SS: 0018
  0000009 [ffff883cd743da70] mempool_alloc_slab at ffffffff81121ba5
 0000010 [ffff883cd743da80] mempool_create_node at ffffffff81122083
 0000011 [ffff883cd743dad0] mempool_create at ffffffff811220f4
 0000012 [ffff883cd743dae0] pool_ctr at ffffffffa08de049 [dm_thin_pool]
 0000013 [ffff883cd743dbd0] dm_table_add_target at ffffffffa0005f2f [dm_mod]
 0000014 [ffff883cd743dc30] table_load at ffffffffa0008ba9 [dm_mod]
 0000015 [ffff883cd743dc90] ctl_ioctl at ffffffffa0009dc4 [dm_mod]
 this bug's scence is as follows:
 process A(vgchange -ay -K):
 	a. send DM_LIST_VERSIONS_CMD ioctl;
 	b. pool_target not registered;
 	c. modprobe dm_thin_pool and wait until end.
 process B(vgchange -ay -K):
 	a. send DM_LIST_VERSIONS_CMD ioctl;
 	b. pool_target registered;
 	c. table_load->dm_table_add_target->pool_ctr;
 	d. _new_mapping_cache is NULL and panic.
 note:
 	1. process A and process B are two concurrent processes.
 	2. pool_target can be detected by process B but
 	_new_mapping_cache initialization has not ended.
 All that we need do is to ensure pool_target registering ops
 is the last ops in dm_thin_init.
 So does the dm-cache, dm-mpath, and dm-snap. Thanks for Alasdair G
 Kergon<agk@redhat.com> reminding me.

Signed-off-by: monty <monty_pavel@sina.com>
Signed-off-by: Alasdair G Kergon<agk@redhat.com>
---
 drivers/md/dm-cache-target.c |   12 +++++-----
 drivers/md/dm-mpath.c        |   18 +++++++-------
 drivers/md/dm-snap.c         |   48 +++++++++++++++++++++---------------------
 drivers/md/dm-thin.c         |   22 ++++++++----------
 4 files changed, 49 insertions(+), 51 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index cf23a14..47407e4 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -3472,18 +3472,18 @@ static int __init dm_cache_init(void)
 {
 	int r;
 
-	r = dm_register_target(&cache_target);
-	if (r) {
-		DMERR("cache target registration failed: %d", r);
-		return r;
-	}
-
 	migration_cache = KMEM_CACHE(dm_cache_migration, 0);
 	if (!migration_cache) {
 		dm_unregister_target(&cache_target);
 		return -ENOMEM;
 	}
 
+	r = dm_register_target(&cache_target);
+	if (r) {
+		DMERR("cache target registration failed: %d", r);
+		return r;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index c8faa2b..35a2a2f 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1957,13 +1957,6 @@ static int __init dm_multipath_init(void)
 {
 	int r;
 
-	r = dm_register_target(&multipath_target);
-	if (r < 0) {
-		DMERR("request-based register failed %d", r);
-		r = -EINVAL;
-		goto bad_register_target;
-	}
-
 	kmultipathd = alloc_workqueue("kmpathd", WQ_MEM_RECLAIM, 0);
 	if (!kmultipathd) {
 		DMERR("failed to create workqueue kmpathd");
@@ -1985,13 +1978,20 @@ static int __init dm_multipath_init(void)
 		goto bad_alloc_kmpath_handlerd;
 	}
 
+	r = dm_register_target(&multipath_target);
+	if (r < 0) {
+		DMERR("request-based register failed %d", r);
+		r = -EINVAL;
+		goto bad_register_target;
+	}
+
 	return 0;
 
+bad_register_target:
+	destroy_workqueue(kmpath_handlerd);
 bad_alloc_kmpath_handlerd:
 	destroy_workqueue(kmultipathd);
 bad_alloc_kmultipathd:
-	dm_unregister_target(&multipath_target);
-bad_register_target:
 	return r;
 }
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 1113b42..a0613bd 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2411,24 +2411,6 @@ static int __init dm_snapshot_init(void)
 		return r;
 	}
 
-	r = dm_register_target(&snapshot_target);
-	if (r < 0) {
-		DMERR("snapshot target register failed %d", r);
-		goto bad_register_snapshot_target;
-	}
-
-	r = dm_register_target(&origin_target);
-	if (r < 0) {
-		DMERR("Origin target register failed %d", r);
-		goto bad_register_origin_target;
-	}
-
-	r = dm_register_target(&merge_target);
-	if (r < 0) {
-		DMERR("Merge target register failed %d", r);
-		goto bad_register_merge_target;
-	}
-
 	r = init_origin_hash();
 	if (r) {
 		DMERR("init_origin_hash failed.");
@@ -2449,19 +2431,37 @@ static int __init dm_snapshot_init(void)
 		goto bad_pending_cache;
 	}
 
+	r = dm_register_target(&snapshot_target);
+	if (r < 0) {
+		DMERR("snapshot target register failed %d", r);
+		goto bad_register_snapshot_target;
+	}
+
+	r = dm_register_target(&origin_target);
+	if (r < 0) {
+		DMERR("Origin target register failed %d", r);
+		goto bad_register_origin_target;
+	}
+
+	r = dm_register_target(&merge_target);
+	if (r < 0) {
+		DMERR("Merge target register failed %d", r);
+		goto bad_register_merge_target;
+	}
+
 	return 0;
 
-bad_pending_cache:
-	kmem_cache_destroy(exception_cache);
-bad_exception_cache:
-	exit_origin_hash();
-bad_origin_hash:
-	dm_unregister_target(&merge_target);
 bad_register_merge_target:
 	dm_unregister_target(&origin_target);
 bad_register_origin_target:
 	dm_unregister_target(&snapshot_target);
 bad_register_snapshot_target:
+	kmem_cache_destroy(pending_cache);
+bad_pending_cache:
+	kmem_cache_destroy(exception_cache);
+bad_exception_cache:
+	exit_origin_hash();
+bad_origin_hash:
 	dm_exception_store_exit();
 
 	return r;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 89e5dff..f91d771 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4355,30 +4355,28 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static int __init dm_thin_init(void)
 {
-	int r;
+	int r = -ENOMEM;
 
 	pool_table_init();
 
+	_new_mapping_cache = KMEM_CACHE(dm_thin_new_mapping, 0);
+	if (!_new_mapping_cache)
+		return r;
+
 	r = dm_register_target(&thin_target);
 	if (r)
-		return r;
+		goto bad_new_mapping_cache;
 
 	r = dm_register_target(&pool_target);
 	if (r)
-		goto bad_pool_target;
-
-	r = -ENOMEM;
-
-	_new_mapping_cache = KMEM_CACHE(dm_thin_new_mapping, 0);
-	if (!_new_mapping_cache)
-		goto bad_new_mapping_cache;
+		goto bad_thin_target;
 
 	return 0;
 
-bad_new_mapping_cache:
-	dm_unregister_target(&pool_target);
-bad_pool_target:
+bad_thin_target:
 	dm_unregister_target(&thin_target);
+bad_new_mapping_cache:
+	kmem_cache_destroy(_new_mapping_cache);
 
 	return r;
 }
-- 
1.7.1


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--EVF5PPMfhYS0aIcm--
