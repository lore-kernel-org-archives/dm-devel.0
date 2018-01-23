From: Martin Wilck <mwilck@suse.com>
Subject: [FIX PATCH v2 09/20] libmultipath: hwtable:
	no_path_retry="queue" for NetApp NVMe
Date: Tue, 23 Jan 2018 18:07:04 +0100
Message-ID: <20180123170704.15037-1-mwilck@suse.com>
References: <20180113211938.31552-10-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180113211938.31552-10-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Netapp requested this default setting for NetApp E-Series NVMe in addition to "multibus".
Also, finalize the product ID regex after consulting with NetApp (the FW reporting just
"ONTAP Controller" was beta only).

This obsoletes my previous "FIX" patch
'FIX "libmultipath: hwtable: multibus for NetApp NVMe-FC'

Fixes: "libmultipath: hwtable: multibus for NetApp NVMe-FC"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/hwtable.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 1cde60a6a41d..0915ea4dfa56 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -681,16 +681,17 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 24,
 	},
 	/*
-	 * NetApp NVMe-FC namespace devices: MULTIBUS preferred
+	 * NetApp NVMe-FC namespace devices: MULTIBUS, queueing preferred
 	 *
 	 * The table is searched backwards, so place this after generic NVMe
 	 */
 	{
 		.vendor	       = "NVME",
-		.product       = "(NetApp |)ONTAP Controller)",
+		.product       = "^NetApp ONTAP Controller",
 		.uid_attribute = "ID_WWN",
 		.checker_name  = NONE,
 		.pgpolicy      = MULTIBUS,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
 	},
 	/*
-- 
2.15.1
