From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 09/11] multipath-tools: delete failback from
	IBM/2810XIV
Date: Thu, 11 Aug 2016 20:32:25 +0200
Message-ID: <1470940345-4441-9-git-send-email-xose.vazquez@gmail.com>
References: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
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

nonsense with multibus as path_grouping_policy

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 8114d3e..62633b1 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -517,7 +517,7 @@ static struct hwentry default_hw[] = {
 		.product       = "2810XIV",
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = 15,
+		.pgfailback    = FAILBACK_UNDEF,
 	},
 		/*
 		 * IBM Power Virtual SCSI Devices
-- 
2.7.4
