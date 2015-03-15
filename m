From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] dm log userspace: base: fix compile warning
Date: Sun, 15 Mar 2015 13:09:38 -0400
Message-ID: <1426439378-26353-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
List-Id: dm-devel.ids

This fixes up a compile warning [-Wunused-but-set-variable] - given the
comments in userspace_set_region_sync() the non-reporting of errors seems
intentional so the return value can be dropped to make gcc happy.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

  CC [M]  drivers/md/dm-log-userspace-base.o
drivers/md/dm-log-userspace-base.c: In function 'userspace_set_region_sync':
drivers/md/dm-log-userspace-base.c:744:6: warning: variable 'r' set but not used [-Wunused-but-set-variable]

The comment here states:
/*
 * It would be nice to be able to report failures.
 * However, it is easy emough to detect and resolve.
 */
note though that userspace_do_request() calls dm_consult_userspace()
which can also return -EINVAL (which is though reported in
dm_consult_userspace via DMINFO if I got it right)

Patch was only compile tested with x86_64_defconfig + CONFIG_DM_LOG_USERSPACE

Patch is against 4.0-rc3 (localversion-next is -next-20150313)

 drivers/md/dm-log-userspace-base.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index 39fa007..1e3038e 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -741,7 +741,6 @@ static int userspace_get_resync_work(struct dm_dirty_log *log, region_t *region)
 static void userspace_set_region_sync(struct dm_dirty_log *log,
 				      region_t region, int in_sync)
 {
-	int r;
 	struct log_c *lc = log->context;
 	struct {
 		region_t r;
@@ -751,7 +750,7 @@ static void userspace_set_region_sync(struct dm_dirty_log *log,
 	pkg.r = region;
 	pkg.i = (int64_t)in_sync;
 
-	r = userspace_do_request(lc, lc->uuid, DM_ULOG_SET_REGION_SYNC,
+	userspace_do_request(lc, lc->uuid, DM_ULOG_SET_REGION_SYNC,
 				 (char *)&pkg, sizeof(pkg), NULL, NULL);
 
 	/*
-- 
1.7.10.4

