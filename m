From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 3/21] [libmultipath] Fixup EMC ALUA mode handling
Date: Mon, 21 May 2007 11:23:21 +0200
Message-ID: <20070521092321.96EFFD44CB@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Modern EMC machines support ALUA in addition to the vendor-specific
PNR (passive/not ready) method. Machines in ALUA mode will understand
PNR commands, too, so we only need to relax the check to operate
them correctly.

Signed-off-by: Ed Goggin <egoggin@vmware.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libcheckers/emc_clariion.c    |    8 ++++++--
 path_priority/pp_emc/pp_emc.c |    8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/libcheckers/emc_clariion.c b/libcheckers/emc_clariion.c
index 384a943..d801b42 100644
--- a/libcheckers/emc_clariion.c
+++ b/libcheckers/emc_clariion.c
@@ -129,8 +129,12 @@ int emc_clariion(struct checker * c)
 
 	if ( /* Effective initiator type */
 	    	sense_buffer[27] != 0x03
-		/* Failover mode should be set to 1 */        
-		|| (sense_buffer[28] & 0x07) != 0x04
+		/*
+		 * Failover mode should be set to 1 (PNR failover mode)
+		 * or 4 (ALUA failover mode).
+		 */
+		|| (((sense_buffer[28] & 0x07) != 0x04) &&
+		    ((sense_buffer[28] & 0x07) != 0x06))
 		/* Arraycommpath should be set to 1 */
 		|| (sense_buffer[30] & 0x04) != 0x04) {
 		MSG(c, "emc_clariion_checker: Path not correctly configured "
diff --git a/path_priority/pp_emc/pp_emc.c b/path_priority/pp_emc/pp_emc.c
index dd58424..4031720 100644
--- a/path_priority/pp_emc/pp_emc.c
+++ b/path_priority/pp_emc/pp_emc.c
@@ -60,8 +60,12 @@ int emc_clariion_prio(const char *dev)
 	
 	if ( /* Effective initiator type */
 	    	sense_buffer[27] != 0x03
-		/* Failover mode should be set to 1 */        
-		|| (sense_buffer[28] & 0x07) != 0x04
+		/*
+		 * Failover mode should be set to 1 (PNR failover mode)
+		 * or 4 (ALUA failover mode).
+		 */
+		|| (((sense_buffer[28] & 0x07) != 0x04) &&
+		    ((sense_buffer[28] & 0x07) != 0x06))
 		/* Arraycommpath should be set to 1 */
 		|| (sense_buffer[30] & 0x04) != 0x04) {
 		fprintf(stderr, "Path not correctly configured for failover");
-- 
1.4.3.4
