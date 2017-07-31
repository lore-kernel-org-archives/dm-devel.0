From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v2] libmultipath: update 3PARdata builtin config
Date: Mon, 31 Jul 2017 13:38:28 +0200
Message-ID: <20170731113828.2316-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

From: Benjamin Marzinski <bmarzins@redhat.com>

This updated config comes from hp.

Here I what I got from HP:

********

We will be changing the recommendation in the next version of the 3PAR
Implementation Guide. I am the owner for these guides.

The reason we want the  dev_loss_tmo "infinity"  is to help in a feature
called Peer Persistence where on primary array power fails and the
device on the remote array (standby array) becomes active. The standby
state of the device paths will automatically change to active state if
the underlying device instances exist so we need infinity setting.

The fast_io_fail_tmo we want to be bumped from 5 to 10 so that it allows
a array feature called persistent port to work well where we want the
want the array path going away failure transient state to be held for
the longer time in the SCSI and FC OS layers (I/O retry) without
multipath reacting to it which allows the array to move the physical
port flogi instance on the switch to move to partner physical port as an
NPIV Port when the array node goes down.  Complete details in this PDF

https://www.hpe.com/h20195/v2/GetPDF.aspx/4AA4-4545ENW.pdf

*******

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index c2ed171..9e14ec1 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -98,6 +98,8 @@ static struct hwentry default_hw[] = {
 		.hwhandler     = "1 alua",
 		.prio_name     = PRIO_ALUA,
 		.no_path_retry = 18,
+		.fast_io_fail  = 10,
+		.dev_loss      = MAX_DEV_LOSS_TMO,
 	},
 	{
 		/* RA8000 / ESA12000 */
-- 
2.13.3
