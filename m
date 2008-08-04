From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 7/7] bio-cgroup: Add a cgroup support to dm-ioband
Date: Mon, 04 Aug 2008 18:01:02 +0900 (JST)
Message-ID: <20080804.180102.39161075.ryov@valinux.co.jp>
References: <20080804.175748.189722512.ryov@valinux.co.jp>
	<20080804.175934.112619046.ryov@valinux.co.jp>
	<20080804.180022.183027902.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754555AbYHDJBU@vger.kernel.org>
In-Reply-To: <20080804.180022.183027902.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com
Cc: agk@sourceware.org
List-Id: dm-devel.ids

With this patch, dm-ioband can work with the bio cgroup.

Based on 2.6.27-rc1-mm1
Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>

diff -Ndupr linux-2.6.27-rc1-mm1.cg2/drivers/md/dm-ioband-type.c linux-2.6.27-rc1-mm1.cg3/drivers/md/dm-ioband-type.c
--- linux-2.6.27-rc1-mm1.cg2/drivers/md/dm-ioband-type.c	2008-08-01 16:53:57.000000000 +0900
+++ linux-2.6.27-rc1-mm1.cg3/drivers/md/dm-ioband-type.c	2008-08-01 19:44:36.000000000 +0900
@@ -6,6 +6,7 @@
  * This file is released under the GPL.
  */
 #include <linux/bio.h>
+#include <linux/biocontrol.h>
 #include "dm.h"
 #include "dm-bio-list.h"
 #include "dm-ioband.h"
@@ -53,13 +54,13 @@ static int ioband_node(struct bio *bio)
 
 static int ioband_cgroup(struct bio *bio)
 {
-  /*
-   * This function should return the ID of the cgroup which issued "bio".
-   * The ID of the cgroup which the current process belongs to won't be
-   * suitable ID for this purpose, since some BIOs will be handled by kernel
-   * threads like aio or pdflush on behalf of the process requesting the BIOs.
-   */
-	return 0;	/* not implemented yet */
+	struct io_context *ioc = get_bio_cgroup_iocontext(bio);
+	int id = 0;
+	if (ioc) {
+		id = ioc->id;
+		put_io_context(ioc);
+	}
+	return id;
 }
 
 struct group_type dm_ioband_group_type[] = {
