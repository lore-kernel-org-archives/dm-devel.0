From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] dm-multipath: patch to keep multipath working
	with new Clariion firmware
Date: Thu, 26 Apr 2007 15:20:01 -0500
Message-ID: <20070426202001.GC28331@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is the patch that EMC posted in the redhat bugzilla #231545, to deal with
their new Clariion firmware that supports ALUA mode. It simply allows multipath
to continue running with in the way in currently does.

-Ben

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ALUA-mode-CLARiiON.cg-diff.patch"

diff -urpN a/libcheckers/emc_clariion.c b/libcheckers/emc_clariion.c
--- a/libcheckers/emc_clariion.c	2006-11-27 17:16:40.000000000 -0600
+++ b/libcheckers/emc_clariion.c	2007-04-26 15:08:22.000000000 -0500
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
diff -urpN a/path_priority/pp_emc/pp_emc.c b/path_priority/pp_emc/pp_emc.c
--- a/path_priority/pp_emc/pp_emc.c	2006-02-02 19:54:58.000000000 -0600
+++ b/path_priority/pp_emc/pp_emc.c	2007-04-26 15:08:22.000000000 -0500
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

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--n8g4imXOkfNTN/H1--
