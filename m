From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 1/5] dm raid: validate current raid sets
	redundancy
Date: Wed, 13 Dec 2017 03:02:34 +0100
Message-ID: <23b69f60931a9dae4bb97661e96ce6ccb648733f.1513125666.git.heinzm@redhat.com>
References: <cover.1513125666.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1513125666.git.heinzm@redhat.com>
In-Reply-To: <cover.1513125666.git.heinzm@redhat.com>
References: <cover.1513125666.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

Verifying the current raid sets redundancy based on retrieved
superblock content has to use the raid level as of superblock
content (e.g. raid0), not the constructor requested one (e.g. raid10).

Using the requested raid level of raid10 lead to a "divide error"
on raid0 which defines data copies divided by to be zero.

Also check for bogus data copies.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index dfbc2bd787c1..c9287666ee5a 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1007,7 +1007,7 @@ static int validate_raid_redundancy(struct raid_set *rs)
 		    !rs->dev[i].rdev.sb_page)
 			rebuild_cnt++;
 
-	switch (rs->raid_type->level) {
+	switch (rs->md.level) {
 	case 0:
 		break;
 	case 1:
@@ -1022,6 +1022,11 @@ static int validate_raid_redundancy(struct raid_set *rs)
 		break;
 	case 10:
 		copies = raid10_md_layout_to_copies(rs->md.new_layout);
+		if (copies < 2) {
+			DMERR("Bogus raid10 data copies < 2!");
+			return -EINVAL;
+		}
+
 		if (rebuild_cnt < copies)
 			break;
 
-- 
2.13.6
