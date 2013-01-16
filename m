From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/13] Add SUN STK6580 to hardware table
Date: Wed, 16 Jan 2013 13:14:10 +0100
Message-ID: <1358338456-1234-8-git-send-email-hare@suse.de>
References: <1358338456-1234-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358338456-1234-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/hwtable.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 9ed3a82..c5b4071 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -957,6 +957,19 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
+		.vendor        = "SUN",
+		.product       = "STK6580_6780",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.checker_name  = TUR,
+		.prio_name     = PRIO_RDAC,
+		.prio_args     = NULL,
+	},
+	{
 		.vendor        = "EUROLOGC",
 		.product       = "FC2502",
 		.features      = DEFAULT_FEATURES,
-- 
1.7.4.2
