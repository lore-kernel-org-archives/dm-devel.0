From: bmarzins@sourceware.org
Subject: multipath-tools libcheckers/emc_clariion.c pat ...
Date: 16 Apr 2007 18:32:54 -0000
Message-ID: <20070416183254.3314.qmail@sourceware.org>
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
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2007-04-16 19:32:53

Modified files:
	libcheckers    : emc_clariion.c 
	path_priority/pp_emc: pp_emc.c 

Log message:
	Added patch from comment #5 of bz 231545. This allows compatability with
	the new EMC arrays.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/emc_clariion.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6&r2=1.6.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_emc/pp_emc.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1&r2=1.1.4.1

--- multipath-tools/libcheckers/emc_clariion.c	2006/09/15 17:55:40	1.6
+++ multipath-tools/libcheckers/emc_clariion.c	2007/04/16 18:32:52	1.6.2.1
@@ -75,8 +75,12 @@
 
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
 		MSG(c, "emc_clariion_checker: Path not correctly configured for failover");
--- multipath-tools/path_priority/pp_emc/pp_emc.c	2005/04/19 13:26:49	1.1
+++ multipath-tools/path_priority/pp_emc/pp_emc.c	2007/04/16 18:32:53	1.1.4.1
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
