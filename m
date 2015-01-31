From: Nicholas Krause <xerofoify@gmail.com>
Subject: [PATCH] md:Remove unneeded fixme comment for the
	function, pool_ctr
Date: Sat, 31 Jan 2015 00:36:42 -0500
Message-ID: <1422682602-5856-1-git-send-email-xerofoify@gmail.com>
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
To: agk@redhat.com
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

Removes the no longer needed fix me comment for removing the validation check
for the number of agruments passed by the caller to outside the mutex_lock in
the function,pool_ctr.  This comment is no longer needed as we will clearly jump
to the out_lock block of this function if the validation fails and therefore this
is no real concern for holding the mutex lock longer then required if the validation
check for number of agruments from the caller of fails.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/md/dm-thin.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 07705ee..7d22334 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2849,9 +2849,6 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	struct dm_dev *metadata_dev;
 	fmode_t metadata_mode;
 
-	/*
-	 * FIXME Remove validation from scope of lock.
-	 */
 	mutex_lock(&dm_thin_pool_table.mutex);
 
 	if (argc < 4) {
-- 
2.1.0
