From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 28/30] multipath: fix setting of fast_io_fail_tmo
Date: Tue, 16 Jul 2013 09:13:19 +0200
Message-ID: <1373958801-103613-29-git-send-email-hare@suse.de>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373958801-103613-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Petr Uzel <petr.uzel@suse.cz>
List-Id: dm-devel.ids

From: Petr Uzel <petr.uzel@suse.cz>

Setting fast_io_fail_tmo to the same value as dev_loss_tmo is
not allowed by the kernel. Increase dev_loss_tmo by 1 in such
cases to make it strictly greated than fast_io_fail_tmo.

Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index adfb1ba..e2b4f56 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -367,7 +367,7 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 			goto out;
 		}
 		if (mpp->fast_io_fail >= tmo) {
-			snprintf(value, 16, "%u", mpp->fast_io_fail);
+			snprintf(value, 16, "%u", mpp->fast_io_fail + 1);
 		}
 	} else if (mpp->dev_loss > 600) {
 		condlog(3, "%s: limiting dev_loss_tmo to 600, since "
-- 
1.7.12.4
