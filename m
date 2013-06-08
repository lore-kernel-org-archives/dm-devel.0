From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: avoid a possible __vmalloc deadlock
Date: Sat, 8 Jun 2013 19:23:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1306081922230.19670@file.rdu.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

dm: avoid a possible __vmalloc deadlock

__vmalloc doesn't fully respect gfp flags (see commit
502624bdad3dba45dfaacaf36b7d83e39e74b2d2) for explanation.

So we need to set noio flag with memalloc_noio_save().

This should be backported to stable kernels 3.8 and newer. The kernel 3.8
doesn't have memalloc_noio_save(), so we should set and restore process
flag PF_MEMALLOC instead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org

---
 drivers/md/dm-ioctl.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-3.9.4-fast/drivers/md/dm-ioctl.c
===================================================================
--- linux-3.9.4-fast.orig/drivers/md/dm-ioctl.c	2013-06-07 15:28:59.000000000 +0200
+++ linux-3.9.4-fast/drivers/md/dm-ioctl.c	2013-06-07 15:29:46.000000000 +0200
@@ -1686,7 +1686,10 @@ static int copy_params(struct dm_ioctl _
 	}
 
 	if (!dmi) {
+		unsigned noio_flag;
+		noio_flag = memalloc_noio_save();
 		dmi = __vmalloc(param_kernel->data_size, GFP_NOIO | __GFP_REPEAT | __GFP_HIGH, PAGE_KERNEL);
+		memalloc_noio_restore(noio_flag);
 		if (dmi)
 			*param_flags |= DM_PARAMS_VMALLOC;
 	}
