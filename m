From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 2] DM Snapshot: insert missing failure
	condition step
Date: Tue, 22 Sep 2009 16:17:31 -0500
Message-ID: <200909222117.n8MLHVMo009008@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Patch name: dm-snap-insert-missing-failure-condition-step.patch

While initializing the snapshot module, if we fail to register
the snapshot target then we must back-out the exception store
module initialization.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -1465,7 +1465,7 @@ static int __init dm_snapshot_init(void)
 	r = dm_register_target(&snapshot_target);
 	if (r) {
 		DMERR("snapshot target register failed %d", r);
-		return r;
+		goto bad_register_target;
 	}
 
 	r = dm_register_target(&origin_target);
@@ -1522,6 +1522,9 @@ bad2:
 	dm_unregister_target(&origin_target);
 bad1:
 	dm_unregister_target(&snapshot_target);
+
+bad_register_target:
+	dm_exception_store_exit();
 	return r;
 }
 
