From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add RDAC SUN/ArrayStorage to
	hwtable
Date: Wed, 11 Apr 2018 15:14:13 +0200
Message-ID: <20180411131413.3963-1-xose.vazquez@gmail.com>
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
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, DM ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Already in scsi_dh: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi/scsi_dh.c#n70

Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 88b4700..827e899 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -889,6 +889,18 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
 	},
+	{
+		.vendor        = "SUN",
+		.product       = "ArrayStorage",
+		.bl_product    = "Universal Xport",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.checker_name  = RDAC,
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.prio_name     = PRIO_RDAC,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 30,
+	},
 	{
 		/* ZFS Storage Appliances */
 		.vendor        = "SUN",
-- 
2.17.0
