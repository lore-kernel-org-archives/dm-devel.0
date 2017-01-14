From: heinzm@redhat.com
Subject: [PATCH v2 3/5] dm raid: fix typos and a comment
Date: Sat, 14 Jan 2017 03:53:09 +0100
Message-ID: <20170114025311.22762-4-heinzm@redhat.com>
References: <20170114025311.22762-1-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170114025311.22762-1-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index f3452b1..87c1458 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2983,7 +2983,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			goto bad;
 		}
 
-		/* We can't takeover a journaled radi4/5/6 */
+		/* We can't takeover a journaled raid4/5/6 */
 		if (test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags)) {
 			ti->error = "Can't takeover a journaled raid4/5/6 set";
 			r = -EPERM;
@@ -3016,7 +3016,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		 * is an instant operation as oposed to an ongoing reshape.
 		 */
 
-		/* We can't reshape a jorunaled radi4/5/6 */
+		/* We can't reshape a journaled raid4/5/6 */
 		if (test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags)) {
 			ti->error = "Can't reshape a journaled raid4/5/6 set";
 			r = -EPERM;
@@ -3168,7 +3168,7 @@ static const char *decipher_sync_action(struct mddev *mddev)
 }
 
 /*
- * Return status string @rdev
+ * Return status string for @rdev
  *
  * Status characters:
  *
-- 
2.9.3
