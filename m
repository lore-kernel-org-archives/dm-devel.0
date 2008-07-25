From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [Patch] dm-raid1.c: Conditionally ignore kcopyd
	errors depending on whether mirror handles
Date: Fri, 25 Jul 2008 11:26:28 -0500
Message-ID: <1217003188.17218.9.camel@hydrogen>
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

Second attempt at header... patch work is still the same.

 brassow

dm-raid1 is setting the 'DM_KCOPYD_IGNORE_ERROR' flag unconditionally
when assigning kcopyd work.  kcopyd is responsible for copying an
assigned section of disk to one or more other disks.  The
'DM_KCOPYD_IGNORE_ERROR' flag affects kcopyd in the following way:

When not set:
kcopyd will immediately stop the copy operation when an error is
encountered.

When set:
kcopyd will try to procede regardless of errors and try to continue
copying any remaining amount.

Since dm-raid1 tracts regions of the address space that are (or
are not) in sync and it now has the ability to handle these
errors, we can safely enable this optimization.  This optimization
is conditional on whether mirror error handling has been enabled.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6.26-rc8/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.26-rc8.orig/drivers/md/dm-raid1.c
+++ linux-2.6.26-rc8/drivers/md/dm-raid1.c
@@ -842,7 +842,9 @@ static int recover(struct mirror_set *ms
 	}
 
 	/* hand to kcopyd */
-	set_bit(DM_KCOPYD_IGNORE_ERROR, &flags);
+	if (!errors_handled(ms))
+		set_bit(DM_KCOPYD_IGNORE_ERROR, &flags);
+
 	r = dm_kcopyd_copy(ms->kcopyd_client, &from, ms->nr_mirrors - 1, to,
 			   flags, recovery_complete, reg);
 
