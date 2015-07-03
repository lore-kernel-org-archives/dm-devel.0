From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/7] dm-ioctl: join flags DM_PARAMS_KMALLOC and
 DM_PARAMS_VMALLOC
Date: Fri, 3 Jul 2015 16:57:22 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1507031656440.28837@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Join flags DM_PARAMS_KMALLOC and DM_PARAMS_VMALLOC into just one flag
DM_PARAMS_ALLOC. We can determine if the block was allocated with kmalloc
or vmalloc with the function is_vmalloc_addr, so there is no need to have
separate flags for that.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |   17 +++++++++--------
 drivers/md/dm-stats.c |   20 ++++++++++----------
 2 files changed, 19 insertions(+), 18 deletions(-)

Index: linux-4.1/drivers/md/dm-ioctl.c
===================================================================
--- linux-4.1.orig/drivers/md/dm-ioctl.c	2015-07-02 18:24:08.000000000 +0200
+++ linux-4.1/drivers/md/dm-ioctl.c	2015-07-02 18:52:52.000000000 +0200
@@ -1668,8 +1668,7 @@ static int check_version(unsigned int cm
 	return r;
 }
 
-#define DM_PARAMS_KMALLOC	0x0001	/* Params alloced with kmalloc */
-#define DM_PARAMS_VMALLOC	0x0002	/* Params alloced with vmalloc */
+#define DM_PARAMS_ALLOC		0x0001	/* Params alloced with kmalloc or vmalloc */
 #define DM_WIPE_BUFFER		0x0010	/* Wipe input buffer before returning from ioctl */
 
 static void free_params(struct dm_ioctl *param, size_t param_size, int param_flags)
@@ -1677,10 +1676,12 @@ static void free_params(struct dm_ioctl 
 	if (param_flags & DM_WIPE_BUFFER)
 		memset(param, 0, param_size);
 
-	if (param_flags & DM_PARAMS_KMALLOC)
-		kfree(param);
-	if (param_flags & DM_PARAMS_VMALLOC)
-		vfree(param);
+	if (param_flags & DM_PARAMS_ALLOC) {
+		if (is_vmalloc_addr(param))
+			vfree(param);
+		else
+			kfree(param);
+	}
 }
 
 static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kernel,
@@ -1715,7 +1716,7 @@ static int copy_params(struct dm_ioctl _
 	if (param_kernel->data_size <= KMALLOC_MAX_SIZE) {
 		dmi = kmalloc(param_kernel->data_size, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
 		if (dmi)
-			*param_flags |= DM_PARAMS_KMALLOC;
+			*param_flags |= DM_PARAMS_ALLOC;
 	}
 
 	if (!dmi) {
@@ -1724,7 +1725,7 @@ static int copy_params(struct dm_ioctl _
 		dmi = __vmalloc(param_kernel->data_size, GFP_NOIO | __GFP_REPEAT | __GFP_HIGH | __GFP_HIGHMEM, PAGE_KERNEL);
 		memalloc_noio_restore(noio_flag);
 		if (dmi)
-			*param_flags |= DM_PARAMS_VMALLOC;
+			*param_flags |= DM_PARAMS_ALLOC;
 	}
 
 	if (!dmi) {
