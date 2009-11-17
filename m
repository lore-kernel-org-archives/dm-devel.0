From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 1/7] dm: use __GFP_HIGH instead PF_MEMALLOC
Date: Tue, 17 Nov 2009 16:17:07 +0900 (JST)
Message-ID: <20091117161616.3DD7.A69D9226@jp.fujitsu.com>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
memory, anyone must not prevent it. Otherwise the system cause
mysterious hang-up and/or OOM Killer invokation.

Cc: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/md/dm-ioctl.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index a679429..4d24b0a 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1396,7 +1396,13 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param)
 	if (tmp.data_size < (sizeof(tmp) - sizeof(tmp.data)))
 		return -EINVAL;
 
-	dmi = vmalloc(tmp.data_size);
+
+	/*
+	 * We use __vmalloc(__GFP_HIGH) instead vmalloc() because trying to
+	 * avoid low memory issues when a device is suspended.
+	 */
+	dmi = __vmalloc(tmp.data_size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_HIGH,
+			PAGE_KERNEL);
 	if (!dmi)
 		return -ENOMEM;
 
@@ -1473,20 +1479,10 @@ static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
 		DMWARN("dm_ctl_ioctl: unknown command 0x%x", command);
 		return -ENOTTY;
 	}
-
-	/*
-	 * Trying to avoid low memory issues when a device is
-	 * suspended.
-	 */
-	current->flags |= PF_MEMALLOC;
-
 	/*
 	 * Copy the parameters into kernel space.
 	 */
 	r = copy_params(user, &param);
-
-	current->flags &= ~PF_MEMALLOC;
-
 	if (r)
 		return r;
 
-- 
1.6.2.5



--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
