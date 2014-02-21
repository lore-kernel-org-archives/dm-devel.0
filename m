From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-dm-3.14-fixes 5/8] dm thin: fix the error
	path for the thin device constructor
Date: Thu, 20 Feb 2014 21:56:02 -0500
Message-ID: <1392951365-9829-6-git-send-email-snitzer@redhat.com>
References: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

dm_pool_close_thin_device() must be called if dm_set_target_max_io_len()
fails in thin_ctr().  Otherwise __pool_destroy() will fail because the
pool will still have an open thin device:

 device-mapper: thin metadata: attempt to close pmd when 1 device(s) are still open
 device-mapper: thin: __pool_destroy: dm_pool_metadata_close() failed.

Also, must establish error code if failing thin_ctr() because the pool
is in fail_io mode.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-thin.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index bc52b3b..7db53d7 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2920,6 +2920,7 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	if (get_pool_mode(tc->pool) == PM_FAIL) {
 		ti->error = "Couldn't open thin device, Pool is in fail mode";
+		r = -EINVAL;
 		goto bad_thin_open;
 	}
 
@@ -2931,7 +2932,7 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	r = dm_set_target_max_io_len(ti, tc->pool->sectors_per_block);
 	if (r)
-		goto bad_thin_open;
+		goto bad_target_max_io_len;
 
 	ti->num_flush_bios = 1;
 	ti->flush_supported = true;
@@ -2952,6 +2953,8 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	return 0;
 
+bad_target_max_io_len:
+	dm_pool_close_thin_device(tc->td);
 bad_thin_open:
 	__pool_dec(tc->pool);
 bad_pool_lookup:
-- 
1.8.3.1
