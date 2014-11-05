From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: don't send KOBJ_REMOVE event
Date: Wed, 5 Nov 2014 08:01:11 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1411050759310.19559@file01.intranet.prod.int.rdu2.redhat.com>
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
To: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

Hi

Here I'm sending a patch for bug 1022876. It is not critical, it can wait 
for 3.19.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

The kernel already sends KOBJ_REMOVE when removing a block device. If we
send it from the device mapper, there will be two KOBJ_REMOVE events.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-3.18-rc3/drivers/md/dm-ioctl.c
===================================================================
--- linux-3.18-rc3.orig/drivers/md/dm-ioctl.c	2014-11-04 16:45:49.000000000 +0100
+++ linux-3.18-rc3/drivers/md/dm-ioctl.c	2014-11-04 16:51:27.000000000 +0100
@@ -864,9 +864,6 @@ static int dev_remove(struct dm_ioctl *p
 
 	param->flags &= ~DM_DEFERRED_REMOVE;
 
-	if (!dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr))
-		param->flags |= DM_UEVENT_GENERATED_FLAG;
-
 	dm_put(md);
 	dm_destroy(md);
 	return 0;
