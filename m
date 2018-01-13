From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 09/20] libmultipath: hwtable: multibus for
	NetApp NVMe-FC
Date: Sat, 13 Jan 2018 22:19:27 +0100
Message-ID: <20180113211938.31552-10-mwilck@suse.com>
References: <20180113211938.31552-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180113211938.31552-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Use multibus policy for NetApp NVMe-FC namespace controllers.
The search logic in find_hwe() looks for vendor/product matches backwards, and
quits if a match is found. Therefore specific sub-entries of a generic entry
have to be listed below the generic ones. Therefore, pull the generic NVME
entry with ".*" product name match on top. The NetApp-specific one is put
into the NetApp section. This way, more vendor-specific exceptions for NVME
may be added later.
---
 libmultipath/hwtable.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 448effe3c859..1cde60a6a41d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -77,6 +77,20 @@
 #endif
 
 static struct hwentry default_hw[] = {
+       /*
+	* Generic NVMe devices
+	*
+	* Due to the parsing logic in find_hwe(), generic entries
+	* have to be put on top of this list, and more specific ones
+	* below.
+	*/
+	{
+		.vendor        = "NVME",
+		.product       = ".*",
+		.uid_attribute = "ID_WWN",
+		.checker_name  = NONE,
+		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
+	},
 	/*
 	 * Apple
 	 *
@@ -666,6 +680,19 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 24,
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
 	 * Nexenta
 	 *
@@ -1133,16 +1160,6 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.no_path_retry = 30,
 	},
-	/*
-	 * Generic NVMe devices
-	 */
-	{
-		.vendor        = "NVME",
-		.product       = ".*",
-		.uid_attribute = "ID_WWN",
-		.checker_name  = NONE,
-		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
-	},
 	/*
 	 * Dot Hill Systems - Seagate Technology
 	 */
-- 
2.15.1
