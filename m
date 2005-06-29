From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: mirroring: [patch 7 of 8] device failure tolerance
Date: Wed, 29 Jun 2005 13:43:24 -0500
Message-ID: <04246838eadfc3f40a2394d6b2728cc5@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Kergon Alasdair <agk@redhat.com>
List-Id: dm-devel.ids

This patch is necessary _only_ to enable cluster capable mirrors.  It 
also requires changes to multipath if it is to be included.  You could 
safely running mirroring on a single machine without this patch.

In cluster mirroring, if a device failure occurs, an end_io can not be 
issued until a suspend has taken place.  This is because another 
machine could still be able to see the device that the first machine 
got a write failure on, and read it - getting inconsistent results.  
Because the mirror is waiting for a suspend before issuing the 
end_io's, the lock_fs call in dm_suspend must come after the 
presuspend.

  brassow

diff -urN linux-2.6.12-002/drivers/md/dm.c 
linux-2.6.12-003/drivers/md/dm.c
--- linux-2.6.12-002/drivers/md/dm.c	2005-06-17 14:48:29.000000000 -0500
+++ linux-2.6.12-003/drivers/md/dm.c	2005-06-28 16:05:45.118194654 -0500
@@ -1055,14 +1055,14 @@
  	if (test_bit(DMF_BLOCK_IO, &md->flags))
  		goto out_read_unlock;

-	error = __lock_fs(md);
-	if (error)
-		goto out_read_unlock;
-
  	map = dm_get_table(md);
  	if (map)
  		dm_table_presuspend_targets(map);

+	error = __lock_fs(md);
+	if (error)
+		goto out_read_unlock;
+
  	up_read(&md->lock);

  	/*
