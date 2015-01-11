From: Johannes Thumshirn <morbidrsa@gmail.com>
Subject: [PATCH] dm mpath: simplify failure path of dm_miltipath_init()
Date: Sun, 11 Jan 2015 12:45:23 +0100
Message-ID: <1420976723-20905-1-git-send-email-morbidrsa@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Thumshirn <morbidrsa@gmail.com>
List-Id: dm-devel.ids

simplify failure path of dm_miltipath_init(). Currently the cleanup of all error
cases are open-coded. Introduce a common exit path and lables.

Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
---
 drivers/md/dm-mpath.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 7b6b0f0..5cc3438 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1694,16 +1694,15 @@ static int __init dm_multipath_init(void)
 	r = dm_register_target(&multipath_target);
 	if (r < 0) {
 		DMERR("register failed %d", r);
-		kmem_cache_destroy(_mpio_cache);
-		return -EINVAL;
+		r = -EINVAL;
+		goto out_mpio_cache;
 	}
 
 	kmultipathd = alloc_workqueue("kmpathd", WQ_MEM_RECLAIM, 0);
 	if (!kmultipathd) {
 		DMERR("failed to create workqueue kmpathd");
-		dm_unregister_target(&multipath_target);
-		kmem_cache_destroy(_mpio_cache);
-		return -ENOMEM;
+		r = -ENOMEM;
+		goto out_kmultipathd;
 	}
 
 	/*
@@ -1716,16 +1715,23 @@ static int __init dm_multipath_init(void)
 						  WQ_MEM_RECLAIM);
 	if (!kmpath_handlerd) {
 		DMERR("failed to create workqueue kmpath_handlerd");
-		destroy_workqueue(kmultipathd);
-		dm_unregister_target(&multipath_target);
-		kmem_cache_destroy(_mpio_cache);
-		return -ENOMEM;
+		r = -ENOMEM;
+		goto out_kmpath_handlerd;
 	}
 
 	DMINFO("version %u.%u.%u loaded",
 	       multipath_target.version[0], multipath_target.version[1],
 	       multipath_target.version[2]);
 
+	return 0;
+
+out_kmpath_handlerd:
+	destroy_workqueue(kmultipathd);
+out_kmultipathd:
+	dm_unregister_target(&multipath_target);
+out_mpio_cache:
+	kmem_cache_destroy(_mpio_cache);
+
 	return r;
 }
 
-- 
2.1.0
