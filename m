From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] dm raid1,
	do not allow 'log_failure' variable to unset after being set
Date: Tue, 28 Jul 2009 10:43:31 -0500
Message-ID: <1248795811.25220.7.camel@hydrogen.msp.redhat.com>
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

This patch fixes a bug which was triggering a case where
the primary leg could not be changed (even when the mirror was
in-sync) on failure.

The case involves the failure of the primary device along with
the transient failure of the log device.  The problem is that
bios can be put on the 'failures' list (due to log failure)
before 'fail_mirror' is called due to the primary device failure.
Normally, this is fine, but if the log device failure is transient,
a subsequent iteration of the work thread, 'do_mirror', will
reset 'log_failure'.  The 'do_failures' function then resets
the 'in_sync' variable when processing bios on the failures list.
The 'in_sync' variable is what is used to determine if the
primary device can be switched in the event of a failure.  Since
this has been reset, the primary device is incorrectly assumed
to be not switchable.

The case has been seen in the cluster mirror context, where one
machine realizes the log device is dead before the other machines.
As the responsibilities of the server migrate from one node to
another (because the mirror is being reconfigured due to the failure),
the new server may think for a moment that the log device is fine -
thus resetting the 'log_failure' variable.

In any case, it is inappropiate for us to reset the 'log_failure'
variable.  The above bug simply illustrates that it can actually
hurt us.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid1.c
+++ linux-2.6/drivers/md/dm-raid1.c
@@ -647,7 +647,13 @@ static void do_writes(struct mirror_set 
 	 */
 	dm_rh_inc_pending(ms->rh, &sync);
 	dm_rh_inc_pending(ms->rh, &nosync);
-	ms->log_failure = dm_rh_flush(ms->rh) ? 1 : 0;
+
+	/*
+	 * If the flush fails on a previous call and succeeds here,
+	 * we must not reset the log_failure variable.  We need
+	 * userspace interaction to do that.
+	 */
+	ms->log_failure = dm_rh_flush(ms->rh) ? 1 : ms->log_failure;
 
 	/*
 	 * Dispatch io.
