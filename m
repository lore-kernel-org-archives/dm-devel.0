From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: update netapp config
Date: Mon, 7 Jan 2013 23:44:43 -0600
Message-ID: <20130108054443.GZ19059@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

The netapp config now used the retain_attached_hwhandler and
detect_prio options to automatically configure correctly for both ALUA and
non-ALUA setups. NetApp also requested that dev_loss_tmo be set to
the maximum for netapp devices.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c |    3 +++
 1 file changed, 3 insertions(+)

Index: multipath-tools-120821/libmultipath/hwtable.c
===================================================================
--- multipath-tools-120821.orig/libmultipath/hwtable.c
+++ multipath-tools-120821/libmultipath/hwtable.c
@@ -871,9 +871,12 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
+		.dev_loss      = MAX_DEV_LOSS_TMO,
 		.checker_name  = TUR,
 		.prio_name     = PRIO_ONTAP,
 		.prio_args     = NULL,
+		.retain_hwhandler = RETAIN_HWHANDLER_ON,
+		.detect_prio   = DETECT_PRIO_ON,
 	},
 	/*
 	 * NEXENTA/COMSTAR controller family
