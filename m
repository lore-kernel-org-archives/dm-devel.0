From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 06/18] multipath-tools: add IBM/FlashSystem to
	hwtable
Date: Sat, 30 Jul 2016 02:28:14 +0200
Message-ID: <1469838506-15689-6-git-send-email-xose.vazquez@gmail.com>
References: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
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

Based on documentation of the manufacturer:

- FlashSystem 820 and FlashSystem 900:
   http://www.redbooks.ibm.com/redbooks/pdfs/sg248271.pdf

vendor                  "IBM"
product                 "FlashSystem-9840"
path_selector           "queue-length 0"        # Linux 6.2, if available
path_grouping_policy    multibus
path_checker            tur
rr_min_io_rq            4                       # Linux 6.x
rr_weight               uniform
no_path_retry           fail
failback                immediate
dev_loss_tmo            300
fast_io_fail_tmo        25

- FlashSystem 710/810/720/820:
   http://www.ibm.com/support/knowledgecenter/ST2NVR/com.ibm.storage.flashsystem.1.1.doc/rsaa6.pdf

vendor                  "IBM"
product                 "FlashSystem"
path_selector           "round-robin 0"         # Linux 5, Linux 6
path_grouping_policy    multibus
path_checker            tur
rr_min_io_rq            4                       # 6.x,FlashSystem 720/820
rr_min_io_              4                       # 5.x,FlashSystem 720/820
rr_weight               uniform
no_path_retry           fail
failback                immediate
dev_loss_tmo            300
fast_io_fail_tmo        25

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 673148a..6ea20b2 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -465,6 +465,18 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = 15,
 		.minio         = 15,
 	},
+	{
+		/* FlashSystem */
+		.vendor        = "IBM",
+		.product       = "FlashSystem",
+		.selector      = "queue-length 0",
+		.pgpolicy      = MULTIBUS,
+		.minio         = 4,
+		.minio_rq      = 4,
+		.no_path_retry = NO_PATH_RETRY_FAIL,
+		.dev_loss      = 300,
+		.fast_io_fail  = 25,
+	},
 	/*
 	 * IBM Power Virtual SCSI Devices
 	 *
-- 
2.7.4
