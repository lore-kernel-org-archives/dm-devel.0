From: akpm@osdl.org
Subject: - dm-raid1-fix-waiting-for-io-on-suspend-fix.patch
	removed from -mm tree
Date: Wed, 08 Nov 2006 17:25:02 -0800
Message-ID: <200611090125.kA91P2Q5032448@shell0.pdx.osdl.net>
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
To: akpm@osdl.org, agk@redhat.com, dm-devel@redhat.com, jbrassow@redhat.com, mm-commits@vger.kernel.org
List-Id: dm-devel.ids


The patch titled
     dm-raid1-fix-waiting-for-io-on-suspend-fix
has been removed from the -mm tree.  Its filename was
     dm-raid1-fix-waiting-for-io-on-suspend-fix.patch

This patch was dropped because it was folded into dm-raid1-fix-waiting-for-io-on-suspend.patch

------------------------------------------------------
Subject: dm-raid1-fix-waiting-for-io-on-suspend-fix
From: Andrew Morton <akpm@osdl.org>

Give _kmirrord_recovery_stopped static scope.

Cc: Jonathan E Brassow <jbrassow@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: <dm-devel@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm-raid1.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/dm-raid1.c~dm-raid1-fix-waiting-for-io-on-suspend-fix drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c~dm-raid1-fix-waiting-for-io-on-suspend-fix
+++ a/drivers/md/dm-raid1.c
@@ -24,7 +24,7 @@
 
 static struct workqueue_struct *_kmirrord_wq;
 static struct work_struct _kmirrord_work;
-DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
+static DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
 
 static inline void wake(void)
 {
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
dm-raid1-fix-waiting-for-io-on-suspend.patch
dm-raid1-fix-waiting-for-io-on-suspend-fix.patch
