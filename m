From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/2] multipath-tools: blacklist UX for RDAC arrays
Date: Tue, 14 Jun 2016 22:59:35 +0200
Message-ID: <1465937975-13055-2-git-send-email-xose.vazquez@gmail.com>
References: <1465937975-13055-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1465937975-13055-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

"Universal Xport" must be hidden for all RDAC arrays:
https://docs.oracle.com/cd/E19373-01/E24026/E24026-01.html
https://docs.oracle.com/cd/E19537-01/E24027/E24027-02.html

It was missing in: SUN STK6580_6780 and SUN_6180

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 1c0ad06..f6a168b 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -975,6 +975,7 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "SUN",
 		.product       = "STK6580_6780",
+		.bl_product    = "Universal Xport",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -1051,6 +1052,7 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "SUN",
 		.product       = "SUN_6180",
+		.bl_product    = "Universal Xport",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-- 
2.5.5
