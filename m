From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] dm: fix an error code in local_init()
Date: Tue, 8 Jul 2014 13:55:36 +0300
Message-ID: <20140708105536.GC19737@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

We return success if we can't allocate a work queue but we should return
-ENOMEM.  The code was a bit messy so that's why this small bug was
introduced and I have cleaned that as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3281615..aa2b12e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -263,12 +263,12 @@ EXPORT_SYMBOL_GPL(dm_get_reserved_rq_based_ios);
 
 static int __init local_init(void)
 {
-	int r = -ENOMEM;
+	int r;
 
 	/* allocate a slab for the dm_ios */
 	_io_cache = KMEM_CACHE(dm_io, 0);
 	if (!_io_cache)
-		return r;
+		return -ENOMEM;
 
 	_rq_tio_cache = KMEM_CACHE(dm_rq_target_io, 0);
 	if (!_rq_tio_cache)
@@ -279,8 +279,10 @@ static int __init local_init(void)
 		goto out_free_rq_tio_cache;
 
 	deferred_remove_workqueue = alloc_workqueue("kdmremove", WQ_UNBOUND, 1);
-	if (!deferred_remove_workqueue)
+	if (!deferred_remove_workqueue) {
+		r = -ENOMEM;
 		goto out_uevent_exit;
+	}
 
 	_major = major;
 	r = register_blkdev(_major, _name);
