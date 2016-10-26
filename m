From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: alua: replace output for
	reserved return codes
Date: Wed, 26 Oct 2016 19:23:24 +0200
Message-ID: <20161026172324.11421-1-xose.vazquez@gmail.com>
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

Show an explicit error.
The current message could be misread, it is not related to the state of the port.

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/prioritizers/alua.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index 5636974..cfbf7df 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -32,7 +32,7 @@ static const char * aas_string[] = {
 	[AAS_STANDBY]		= "standby",
 	[AAS_UNAVAILABLE]	= "unavailable",
 	[AAS_LBA_DEPENDENT]	= "lba dependent",
-	[AAS_RESERVED]		= "invalid/reserved",
+	[AAS_RESERVED]		= "ARRAY BUG: invalid TPGs state!",
 	[AAS_OFFLINE]		= "offline",
 	[AAS_TRANSITIONING]	= "transitioning between states",
 };
-- 
2.10.1
