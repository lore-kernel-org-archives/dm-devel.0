From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 10/14] libmultipath: hwtable: multibus for NetApp
	NVMe-FC
Date: Fri, 12 Jan 2018 23:07:39 +0100
Message-ID: <20180112220743.11513-11-mwilck@suse.com>
References: <20180112220743.11513-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180112220743.11513-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Use multibus policy for NetApp NVMe-FC namespace controllers.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/hwtable.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 40c4724fcd1b..bae280c835e6 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1142,6 +1142,19 @@ static struct hwentry default_hw[] = {
 		.checker_name  = NONE,
 		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
 	},
+	/*
+	 * NetApp NVMe-FC namespace devices: MULTIBUS preferred
+	 *
+	 * The table is searched backwards, so place this after generic NVMe
+	 */
+	{
+		.vendor	       = "NVME",
+		.product       = "(NetApp |)ONTAP Controller)",
+		.uid_attribute = "ID_WWN",
+		.checker_name  = NONE,
+		.pgpolicy      = MULTIBUS,
+		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
+	},
 	/*
 	 * Dot Hill Systems - Seagate Technology
 	 */
-- 
2.15.1
