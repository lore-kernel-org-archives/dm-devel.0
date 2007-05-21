From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22-rc1-mm1 PATCH 8/10]
	dm-raid1-handle-recovery-read-failures.patch
Date: Mon, 21 May 2007 17:08:00 -0500
Message-ID: <1179785280.13913.34.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

 brassow

Index: linux-2.6.22-rc1-mm1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.22-rc1-mm1.orig/drivers/md/dm-raid1.c
+++ linux-2.6.22-rc1-mm1/drivers/md/dm-raid1.c
@@ -674,9 +674,11 @@ static void recovery_complete(int read_e
 	struct mirror_set *ms = reg->rh->ms;
 	int m, bit = 0;
 
-	if (read_err)
+	if (read_err) {
 		/* Read error means the failure of default mirror. */
 		DMERR_LIMIT("Unable to read primary mirror during recovery");
+		fail_mirror(ms->default_mirror);
+	}
 
 	if (write_err) {
 		DMERR_LIMIT("Write error during recovery (error = 0x%x)",
