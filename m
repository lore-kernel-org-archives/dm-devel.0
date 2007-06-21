From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22-rc4-mm2 PATCH 8/11]
	dm-raid1-handle-recovery-read-failures.patch
Date: Thu, 21 Jun 2007 16:01:12 -0500
Message-ID: <1182459672.13518.25.camel@hydrogen.msp.redhat.com>
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

add header!

 brassow

This patch adds the ability detect read failures during
recovery and flag the device as failed.

We add a call to fail_mirror() when 'read_err' is set
upon recovery completion.  This sets the error_count
on the device.  It maintains backwards compatibility
(does nothing) if the DM_RAID1_HANDLE_ERRORS flag is
not set during mirror device creation.

Using the same code put in place to handle write failures,
it ensures that the region is marked as 'not-in-sync'
and that this is reflected in the log.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6.22-rc4-mm2/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/md/dm-raid1.c
+++ linux-2.6.22-rc4-mm2/drivers/md/dm-raid1.c
@@ -673,9 +673,11 @@ static void recovery_complete(int read_e
 	unsigned long write_err_ulong = (unsigned long)write_err;
 	int m, bit = 0;
 
-	if (read_err)
+	if (read_err) {
 		/* Read error means the failure of default mirror. */
 		DMERR_LIMIT("Unable to read primary mirror during recovery");
+		fail_mirror(ms->default_mirror);
+	}
 
 	if (!write_err)
 		goto out;
