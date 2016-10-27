From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: alua: replace lba state message
Date: Thu, 27 Oct 2016 16:00:22 +0200
Message-ID: <20161027140022.6874-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Change to "logical block dependent" as in spec.

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/prioritizers/alua.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index cfbf7df..f5456ee 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -31,7 +31,7 @@ static const char * aas_string[] = {
 	[AAS_NON_OPTIMIZED]	= "active/non-optimized",
 	[AAS_STANDBY]		= "standby",
 	[AAS_UNAVAILABLE]	= "unavailable",
-	[AAS_LBA_DEPENDENT]	= "lba dependent",
+	[AAS_LBA_DEPENDENT]	= "logical block dependent",
 	[AAS_RESERVED]		= "ARRAY BUG: invalid TPGs state!",
 	[AAS_OFFLINE]		= "offline",
 	[AAS_TRANSITIONING]	= "transitioning between states",
-- 
2.10.1
