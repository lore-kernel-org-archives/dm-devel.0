From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: remove pointless comparison
Date: Mon, 6 Jan 2014 22:53:28 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401062249200.17811@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Remove pointless comparison in dm_get_from_kobject. The comparison is
always true and the compiler optimizes it out anyway.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-3.13-rc7/drivers/md/dm.c
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm.c	2014-01-07 01:28:27.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm.c	2014-01-07 01:28:39.000000000 +0100
@@ -2922,8 +2922,6 @@ struct mapped_device *dm_get_from_kobjec
 	struct mapped_device *md;
 
 	md = container_of(kobj, struct mapped_device, kobj);
-	if (&md->kobj != kobj)
-		return NULL;
 
 	if (test_bit(DMF_FREEING, &md->flags) ||
 	    dm_deleting_md(md))
