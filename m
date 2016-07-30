From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 16/18] multipath-tools: Use ALUA for HP 3PAR
Date: Sat, 30 Jul 2016 02:28:24 +0200
Message-ID: <1469838506-15689-16-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

Original patch from Hannes Reinecke <hare@suse.de>:

 		.vendor        = "3PARdata",
 		.product       = "VV",
 		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
-		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
+		.hwhandler     = "1 alua",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = DEFAULT_CHECKER,
-		.prio_name     = DEFAULT_PRIO,
+		.no_path_retry = 18,
+		.checker_name  = TUR,
+		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,

Sebastian was not convinced with this change, full thread: https://marc.info/?t=146175638600002
But there is no automatic way to change .pgpolicy from MULTIBUS to GROUP_BY_PRIO.
So we should stick to latest manufacturer's recommendations:

"With 3PAR OS 3.1.3 or later, Hewlett Packard Enterprise recommends host persona
2 (ALUA). Advantages of Host Persona 2 (ALUA):
o A single VV migration can be performed by using 3PAR Peer Motion if the
  source and destination 3PAR StoreServ Storage array uses host persona 2
  (required by the 3PAR OS).
o Host persona 2 is required for Storage Federation (required by the 3PAR OS).

*3PAR plans to support additional features in later HPE 3PAR OS releases only at
  Generic-ALUA Persona 2

Persona_Number Persona_Name   Host_Operating_System       Additional_Capabilities
============== ============== ==========================  =======================
1              Generic        Linux, Windows and Solaris  UARepLun, SESLun
2              Generic-ALUA   Linux, Windows and Solaris  UARepLun, SESLun, ALUA
6              Generic-Legacy Linux, Windows and Solaris  None

o UARepLun -  Notifies the host of newly exported VLUNs and should trigger a LUN
              discovery request on the host, making the VLUN automatically
              available on format.
o SESLun   -  Enables iSCSI Enclosure Services (SES) LUN ID 254 for Host Explorer
              agent support.
o ALUA     -  Enables the Asymmetric Logical Unit Access (ALUA) command and
              asymmetric state change unit attention when path counts change
              due to adding or removing ports in the host's definition."

HPE 3PAR docs: http://www.hpe.com/info/storage/docs

Cc: Sebastian Herbszt <herbszt@gmx.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a9e65fc..e4c7b7d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -42,8 +42,9 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "3PARdata",
 		.product       = "VV",
-		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
+		.hwhandler     = "1 alua",
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 18,
 	},
 	{
 		.vendor        = "DEC",
-- 
2.7.4
