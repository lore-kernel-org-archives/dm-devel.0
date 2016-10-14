From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add missing hardware handler to
	ALUA devices
Date: Fri, 14 Oct 2016 18:44:59 +0200
Message-ID: <20161014164459.7158-1-xose.vazquez@gmail.com>
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

Nimble/Server and TEGILE/(ZEBI-(FC|ISCSI)|INTELLIFLASH)

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index dc3010a..aca46ab 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -888,6 +888,7 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "Nimble",
 		.product       = "Server",
+		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
@@ -907,6 +908,7 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "TEGILE",
 		.product       = "(ZEBI-(FC|ISCSI)|INTELLIFLASH)",
+		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
-- 
2.10.1
