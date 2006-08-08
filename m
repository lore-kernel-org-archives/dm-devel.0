From: egoggin@emc.com
Subject: preventing block I/O to EMC CLARiiON LUNZ paths
Date: Tue, 8 Aug 2006 10:22:45 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1351@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: dm-devel@redhat.com
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids

Christophe,

This patch simply reports a PATH_DOWN status for paths to an EMC CLARiiON
LUNZ (or an unbound) block device since these paths cannot possibly be used
to issue I/O to such a device.  In fact, allowing block I/O to a LUNZ
dm-multipath device will cause the process to hang until the no_path_retry
timeout is incurred.  This is not desirable.

Thanks,

Ed


diff --git a/libcheckers/emc_clariion.c b/libcheckers/emc_clariion.c
index 462117b..a883e3d 100644
--- a/libcheckers/emc_clariion.c
+++ b/libcheckers/emc_clariion.c
@@ -89,14 +89,11 @@ int emc_clariion(struct checker * c)
 		return PATH_SHAKY;
 	}
 
-#if 0
-	/* This is not actually an error as the failover to this group
-	 * _would_ bind the path */
-	if ( /* LUN should at least be bound somewhere */
-		sense_buffer[4] != 0x00) {
-		return PATH_UP;
+	if ( /* LUN should at least be bound somewhere and not be LUNZ */
+		sense_buffer[4] == 0x00) {
+		MSG(c, "emc_clariion_checker: Logical Unit is unbound or
LUNZ");
+		return PATH_DOWN;
 	}
-#endif	
 	
 	/*
 	 * store the LUN WWN there and compare that it indeed did not
