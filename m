From: Vinothkumar Raja <vinraja@cs.stonybrook.edu>
Subject: [dm-devel] [PATCH] Fix for find_lowest_key in dm-btree.c
Date: Thu,  6 Apr 2017 22:09:38 -0400
Message-ID: <1491530978-6215-1-git-send-email-vinraja@cs.stonybrook.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, shli@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, ezk@cs.stonybrook.edu, npanpalia@cs.stonybrook.edu, tarasov@vasily.name, Vinothkumar Raja <vinraja@cs.stonybrook.edu>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

We are working on dm-dedup which is a device-mapper's dedup target that 
provides transparent data deduplication of block devices. Every write 
coming to a dm-dedup instance is deduplicated against previously written 
data.  We’ve been working on this project for several years now. The 
Github link for the same is https://github.com/dmdedup. Detailed design 
and performance evaluation can be found in the following paper: 
http://www.fsl.cs.stonybrook.edu/docs/ols-dmdedup/dmdedup-ols14.pdf.

We are currently working on garbage collection for which we traverse our 
btrees from lowest key to highest key. While using find_lowest_key and 
find_highest_key, we noticed that find_lowest_key is giving incorrect 
results. While the function find_key traverses the btree correctly for 
finding the highest key, we found that there is an error in the way it 
traverses the btree for retrieving the lowest key. The find_lowest_key 
function fetches the first key of the rightmost block of the btree 
instead of fetching the first key from the leftmost block. This patch 
fixes the bug and gives us the correct result.  

Signed-off-by: Erez Zadok <ezk@fsl.cs.sunysb.edu>
Signed-off-by: Vinothkumar Raja <vinraja@cs.stonybrook.edu>
Signed-off-by: Nidhi Panpalia <npanpalia@cs.stonybrook.edu>

---
 drivers/md/persistent-data/dm-btree.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 02e2ee0..83121d1 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -902,9 +902,12 @@ static int find_key(struct ro_spine *s, dm_block_t block, bool find_highest,
 		else
 			*result_key = le64_to_cpu(ro_node(s)->keys[0]);
 
-		if (next_block || flags & INTERNAL_NODE)
-			block = value64(ro_node(s), i);
-
+		if (next_block || flags & INTERNAL_NODE) {
+			if (find_highest)
+				block = value64(ro_node(s), i);
+			else
+				block = value64(ro_node(s), 0);
+		}
 	} while (flags & INTERNAL_NODE);
 
 	if (next_block)
-- 
1.8.3.1

