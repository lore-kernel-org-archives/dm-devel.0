From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/1] multipath-tools: Change path checker for IBM
	IPR devices
Date: Wed, 24 Sep 2014 14:57:22 -0500
Message-ID: <20140924195752.289011902@linux.vnet.ibm.com>
References: <20140924195721.148637349@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=ipr_multipath
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
Cc: Wen Xiong <wenxiong@linux.vnet.ibm.com>
List-Id: dm-devel.ids

We would like to change path checker to directio for IBM IPR devices.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 libmultipath/hwtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/libmultipath/hwtable.c
===================================================================
--- a/libmultipath/hwtable.c	2014-09-23 17:39:27.000000000 -0500
+++ b/libmultipath/hwtable.c	2014-09-23 17:40:31.419667000 -0500
@@ -630,7 +630,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = TUR,
+		.checker_name  = DIRECTIO,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},

-- 
