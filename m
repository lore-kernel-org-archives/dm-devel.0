From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 08/10] multipath-tools: remove
	USER_FRIENDLY_NAMES_OFF
Date: Fri, 17 Jun 2016 16:52:46 +0200
Message-ID: <1466175169-16684-8-git-send-email-xose.vazquez@gmail.com>
References: <1466175169-16684-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466175169-16684-1-git-send-email-xose.vazquez@gmail.com>
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

This is up to sysadmins, and it is already off by default.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 598b9b8..bef8d31 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -794,7 +794,6 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ONTAP,
 		.prio_args     = NULL,
 		.retain_hwhandler = RETAIN_HWHANDLER_ON,
-		.user_friendly_names = USER_FRIENDLY_NAMES_OFF,
 		.detect_prio   = DETECT_PRIO_ON,
 	},
 	/*
@@ -1133,7 +1132,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.checker_name  = TUR,
 		.fast_io_fail  = 10,
-		.user_friendly_names = USER_FRIENDLY_NAMES_OFF,
 		.prio_name     = DEFAULT_PRIO,
 		.no_path_retry = 0,
 		.dev_loss      = 60,
-- 
2.5.5
