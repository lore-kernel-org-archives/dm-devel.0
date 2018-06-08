From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 16/28] libmultipath/hwtable: remove inherited
	props from ONTAP NVMe
Date: Fri,  8 Jun 2018 12:20:29 +0200
Message-ID: <20180608102041.22904-17-mwilck@suse.com>
References: <20180608102041.22904-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180608102041.22904-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

With the new hwtable code, properties inherited from generic NVMe
don't need to be duplicated.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/hwtable.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 148f0ba2..d20ed194 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -746,11 +746,8 @@ static struct hwentry default_hw[] = {
 		 */
 		.vendor	       = "NVME",
 		.product       = "^NetApp ONTAP Controller",
-		.uid_attribute = "ID_WWN",
-		.checker_name  = NONE,
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
 	},
 	/*
 	 * Nexenta
-- 
2.17.0
