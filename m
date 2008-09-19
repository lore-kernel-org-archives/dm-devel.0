From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 4/5] bio-cgroup: Add a cgroup support to dm-ioband
Date: Fri, 19 Sep 2008 20:03:38 +0900 (JST)
Message-ID: <20080919.200338.189705888.ryov@valinux.co.jp>
References: <20080919.200144.226783261.ryov@valinux.co.jp>
	<20080919.200226.71109122.ryov@valinux.co.jp>
	<20080919.200301.104053955.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080919.200301.104053955.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com
Cc: fernando@oss.ntt.co.jp, xemul@openvz.org, agk@sourceware.org, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

With this patch, dm-ioband can work with the bio cgroup.

Based on 2.6.27-rc1-mm1
Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>

diff -Ndupr linux-2.6.27-rc1-mm1.cg2/drivers/md/dm-ioband-type.c linux-2.6.27-rc1-mm1.cg3/drivers/md/dm-ioband-type.c
--- linux-2.6.27-rc1-mm1.cg2/drivers/md/dm-ioband-type.c	2008-09-19 10:55:46.000000000 +0900
+++ linux-2.6.27-rc1-mm1.cg3/drivers/md/dm-ioband-type.c	2008-09-19 18:51:00.000000000 +0900
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
