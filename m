From: Martin George <marting@netapp.com>
Subject: [PATCH] multipath: Set 'tur' as the default path checker
	for NetApp LUNs
Date: Mon, 12 Mar 2012 13:52:11 +0530
Message-ID: <201203121352.11340.marting@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
Cc: christophe.varoqui@gmail.com
List-Id: dm-devel.ids

In our tests, we've noticed that the 'tur' checker provides
better performance compared to 'directio' primarily because 'tur'
does not use FS-based requests unlike 'directio'. Moreover with
Hannes' recent async tur enhancement, the 'tur' checker is more
efficient now than before.

So we'd prefer using 'tur' as the default path checker for NetApp
LUNs now. The below patch enables the same by updating the
.checker_name in the hwtable for NetApp LUNs.

Signed-off-by: Martin George <marting@netapp.com>
---
 libmultipath/hwtable.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 020c8aa..b8a62dd 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -955,7 +955,7 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
-		.checker_name  = DIRECTIO,
+		.checker_name  = TUR,
 		.prio_name     = PRIO_ONTAP,
 		.prio_args     = NULL,
 	},
-- 
1.6.3.3
