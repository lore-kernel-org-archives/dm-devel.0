From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] FIX "libmultipath: hwtable: multibus for NetApp
	NVMe-FC"
Date: Fri, 19 Jan 2018 12:52:23 +0100
Message-ID: <20180119115223.4625-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

There was an extra parenthesis in the patch I submitted
previously.

Fixes: "libmultipath: hwtable: multibus for NetApp NVMe-FC"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 4f3290123f09..918db7b0d019 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -687,7 +687,7 @@ static struct hwentry default_hw[] = {
 	 */
 	{
 		.vendor	       = "NVME",
-		.product       = "(NetApp |)ONTAP Controller)",
+		.product       = "(NetApp |)ONTAP Controller",
 		.uid_attribute = "ID_WWN",
 		.checker_name  = NONE,
 		.pgpolicy      = MULTIBUS,
-- 
2.15.1
