From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/3] dm-ioctl: don't use PF_MEMALLOC
Date: Thu, 22 Nov 2012 19:19:35 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1211221918270.11244@file.rdu.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-ioctl: don't use PF_MEMALLOC

PF_MEMALLOC is a hack. Remove it and use documented GFP flags instead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

Index: linux-3.7-rc6/drivers/md/dm-ioctl.c
===================================================================
--- linux-3.7-rc6.orig/drivers/md/dm-ioctl.c	2012-11-20 22:44:00.000000000 +0100
+++ linux-3.7-rc6/drivers/md/dm-ioctl.c	2012-11-21 23:49:55.000000000 +0100
@@ -1598,7 +1598,7 @@ static int copy_params(struct dm_ioctl _
 
 	secure_data = tmp.flags & DM_SECURE_DATA_FLAG;
 
-	dmi = vmalloc(tmp.data_size);
+	dmi = __vmalloc(tmp.data_size, GFP_NOIO | __GFP_REPEAT | __GFP_HIGH, PAGE_KERNEL);
 	if (!dmi) {
 		if (secure_data && clear_user(user, tmp.data_size))
 			return -EFAULT;
@@ -1691,18 +1691,10 @@ static int ctl_ioctl(uint command, struc
 	}
 
 	/*
-	 * Trying to avoid low memory issues when a device is
-	 * suspended.
-	 */
-	current->flags |= PF_MEMALLOC;
-
-	/*
 	 * Copy the parameters into kernel space.
 	 */
 	r = copy_params(user, &param);
 
-	current->flags &= ~PF_MEMALLOC;
-
 	if (r)
 		return r;
 
