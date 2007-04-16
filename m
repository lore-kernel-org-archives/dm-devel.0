From: bmarzins@sourceware.org
Subject: multipath-tools libcheckers/emc_clariion.c pat ...
Date: 16 Apr 2007 18:44:50 -0000
Message-ID: <20070416184450.10242.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2007-04-16 19:44:50

Modified files:
	libcheckers    : emc_clariion.c 
	path_priority/pp_emc: pp_emc.c 

Log message:
	Applied patch from comment #5 of bz #231546. This allows compatablity with the
	new EMC arrays.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/emc_clariion.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.3&r2=1.3.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_emc/pp_emc.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.1&r2=1.1.2.1

--- multipath-tools/libcheckers/emc_clariion.c	2005/11/16 20:24:57	1.3
+++ multipath-tools/libcheckers/emc_clariion.c	2007/04/16 18:44:50	1.3.2.1
@@ -99,8 +99,12 @@
 
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
 		MSG("emc_clariion_checker: Path not correctly configured for failover");
--- multipath-tools/path_priority/pp_emc/pp_emc.c	2005/04/19 13:26:49	1.1
+++ multipath-tools/path_priority/pp_emc/pp_emc.c	2007/04/16 18:44:50	1.1.2.1
@@ -60,8 +60,12 @@
 	
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
