From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: mirroring: [patch 6 of 6] device failure tolerance
Date: Thu, 30 Jun 2005 03:04:21 -0500
Message-ID: <01e61ce296a442e0f399a4bf4864b79e@redhat.com>
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

This patch changes how suspend works in dm.c (dm_suspend).  As a 
result, it breaks multipath.  It is necessary for cluster mirroring to 
ensure that a suspend happens before other nodes have a chance at 
getting an inconsistent read.

  brassow

diff -urN linux-2.6.12-00005/drivers/md/dm.c 
linux-2.6.12-00006/drivers/md/dm.c
--- linux-2.6.12-00005/drivers/md/dm.c	2005-06-17 14:48:29.000000000 
-0500
+++ linux-2.6.12-00006/drivers/md/dm.c	2005-06-30 01:06:36.146154215 
-0500
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
