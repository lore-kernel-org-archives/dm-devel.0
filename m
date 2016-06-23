From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 4/4] multipath-tools: replace DIRECTIO with
	DEFAULT_CHECKER in hwtable
Date: Thu, 23 Jun 2016 15:42:20 +0200
Message-ID: <1466689340-5590-5-git-send-email-xose.vazquez@gmail.com>
References: <1466689340-5590-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466689340-5590-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Matthias Rudolph <matthias.rudolph@hds.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Yacine Kheddache <yacine@alyseo.com>, device-mapper development <dm-devel@redhat.com>, "Brian King,
	IBM" <brking@linux.vnet.ibm.com>, Srinivasan Ramani <srinivas.ramani@oracle.com>, Sean Stewart <sean.stewart@netapp.com>, Shyam Sundar <g.shyamsundar@yahoo.co.in>, "Bart Brooks,
	Pivot3" <bartb@pivot3.com>, "Edward Goggin, EMC" <egoggin@emc.com>
List-Id: dm-devel.ids

DIRECTIO is unreliable under high load.

Cc: Shyam Sundar <g.shyamsundar@yahoo.co.in>
Cc: Edward Goggin, EMC <egoggin@emc.com>
Cc: Matthias Rudolph <matthias.rudolph@hds.com>
Cc: Brian King, IBM <brking@linux.vnet.ibm.com>
Cc: Yacine Kheddache <yacine@alyseo.com>
Cc: Srinivasan Ramani <srinivas.ramani@oracle.com>
Cc: Bart Brooks, Pivot3 <bartb@pivot3.com>
Cc: Martin George <marting@netapp.com>
Cc: Sean Stewart <sean.stewart@netapp.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 6e73e67..38487c1 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -95,7 +95,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
-		.checker_name  = DIRECTIO,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -245,7 +245,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = DIRECTIO,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -324,7 +324,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = DIRECTIO,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -388,7 +388,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = DIRECTIO,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -622,7 +622,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = DIRECTIO,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -638,7 +638,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = DIRECTIO,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -702,7 +702,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
-		.checker_name  = DIRECTIO,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -816,7 +816,7 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
-		.checker_name  = DIRECTIO,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ONTAP,
 		.prio_args     = NULL,
 	},
@@ -836,7 +836,7 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 30,
 		.minio         = 128,
-		.checker_name  = DIRECTIO,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -871,7 +871,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = DIRECTIO,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -949,7 +949,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = DIRECTIO,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
-- 
2.5.5
