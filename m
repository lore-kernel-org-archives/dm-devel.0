From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add HPE StoreVirtual 4000
	family(LEFTHAND) to hwtable
Date: Wed,  5 Oct 2016 23:00:14 +0200
Message-ID: <20161005210014.9104-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

No official documentation, based on field-tested configuration:
https://www.citrix.com/blogs/2013/10/02/hp-p4000-multipath-config-file/
https://community.hpe.com/t5/HPE-StoreVirtual-Storage/StoreVirtual-4000-and-multipath-tools-Linux/m-p/6874775

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 8ecaffb..e1ed7ef 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -146,6 +146,15 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 18,
 		.prio_name     = PRIO_ALUA,
 	},
+	{
+		/* StoreVirtual 4000 family */
+		.vendor        = "LEFTHAND",
+		.product       = "^(P4000|iSCSIDisk)",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 18,
+		.prio_name     = PRIO_ALUA,
+	},
 	/*
 	 * DataDirect Networks
 	 */
-- 
2.10.1
