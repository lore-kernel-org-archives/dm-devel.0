From: heinzm@redhat.com
Subject: [PATCH 08/26] dm raid: fix comment typos
Date: Wed,  6 Jul 2016 19:24:39 +0200
Message-ID: <1467825897-26058-9-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index f6120e1..cc6eb7c 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2510,10 +2510,10 @@ static int rs_setup_reshape(struct raid_set *rs)
 	 *   be available at the end of each disk
 	 *
 	 * - data_offset and new_data_offset are
-	 *   adjusted for afreentioned out of place
+	 *   adjusted for aforementioned out of place
 	 *   reshaping based on userspace passing in
 	 *   the "data_offset <sectors>" key/value
-	 *   pair via te constructor
+	 *   pair via the constructor
 	 */
 
 	/* Add disk(s) */
-- 
2.5.5
