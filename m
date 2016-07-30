From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 17/18] multipath-tools: add HPE StoreVirtual
	P4000 family to hwtable
Date: Sat, 30 Jul 2016 02:28:25 +0200
Message-ID: <1469838506-15689-17-git-send-email-xose.vazquez@gmail.com>
References: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
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

No official documentation. Based on field-tested configuration:
https://www.citrix.com/blogs/2013/10/02/hp-p4000-multipath-config-file/

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index e4c7b7d..51e115d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -139,6 +139,14 @@ static struct hwentry default_hw[] = {
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
 	},
+		/* StoreVirtual P4000 family */
+	{
+		.vendor        = "LEFTHAND",
+		.product       = "^(P4000.*|iSCSIDisk)",
+		.no_path_retry = 18,
+		.minio         = 100,
+		.prio_name     = PRIO_ALUA,
+	},
 	/*
 	 * DataDirect Networks
 	 */
-- 
2.7.4
