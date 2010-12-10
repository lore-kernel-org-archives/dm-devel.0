From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH <missing> of 8: MD new mddev flag value
Date: Fri, 10 Dec 2010 17:37:16 -0600
Message-ID: <1292024236.15299.29.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

Sorry, I missed a patch that should have gone in-between the MD and DM
patches:

	md-backout-dm-dirty-log.patch
	md-minor-updates.patch
	md-fix-null-pointer-deref.patch

->	md-new-mddev-flag-value.patch

	dm-raid-seed-module.patch
	dm-target-callbacks-and-congestion-fn.patch
	dm-unplug-callback.patch
	dm-raid-iterate_devices-and-io_hints.patch
	dm-raid-suspend-and-resume-fns.patch

Mea Culpa,
 brassow

Add a new possible flag for the mddev structure.

The flag is used by device-mapper to tell MD to override the
information it finds in the superblock/bitmap WRT the
overall [re]sync of the array.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.h
===================================================================
--- linux-2.6.orig/drivers/md/md.h
+++ linux-2.6/drivers/md/md.h
@@ -140,6 +140,7 @@ struct mddev_s
 #define MD_CHANGE_DEVS	0	/* Some device status has changed */
 #define MD_CHANGE_CLEAN 1	/* transition to or from 'clean' */
 #define MD_CHANGE_PENDING 2	/* switch from 'clean' to 'active' in progress */
+#define MD_SYNC_STATE_FORCED 4  /* recovery_cp is set and must be honored */
 
 	int				suspended;
 	atomic_t			active_io;
