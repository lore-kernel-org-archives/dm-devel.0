From: Shahzad Hussain Bangash <ext-shahzad.bangash@nokia.com>
Subject: [PATCH] : Fix for memory leak in setup indexes
Date: Thu, 05 Aug 2010 09:57:41 +0300
Message-ID: <1280991461.2281.5.camel@sbangash-desktop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-EuQOx/0TIITU4YSwU1N1"
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
To: neilb <neilb@suse.de>, dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids


--=-EuQOx/0TIITU4YSwU1N1
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



-- 
Shahzad Hussain Bangash <ext-shahzad.bangash@nokia.com>

--=-EuQOx/0TIITU4YSwU1N1
Content-Disposition: attachment;
	filename="0001-Fixes-memory-leak-in-setup_indexes.patch"
Content-Type: text/x-patch;
	name="0001-Fixes-memory-leak-in-setup_indexes.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

From 57da07e6847cedd14d54ba1675264377846a026c Mon Sep 17 00:00:00 2001
From: Shahzad Bangash <ext-shahzad.bangash@nokia.com>
Date: Tue, 3 Aug 2010 13:58:48 +0300
Subject: [PATCH] Fixes memory leak in setup_indexes

Signed-off-by: Shahzad Bangash <ext-shahzad.bangash@nokia.com>
---
 drivers/md/dm-table.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e869128..05691f2 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -876,7 +876,7 @@ static int setup_indexes(struct dm_table *t)
 {
 	int i;
 	unsigned int total = 0;
-	sector_t *indexes;
+	sector_t *indexes, *indexes_head;
 
 	/* allocate the space for *all* the indexes */
 	for (i = t->depth - 2; i >= 0; i--) {
@@ -888,6 +888,8 @@ static int setup_indexes(struct dm_table *t)
 	if (!indexes)
 		return -ENOMEM;
 
+	indexes_head = indexes;
+
 	/* set up internal nodes, bottom-up */
 	for (i = t->depth - 2; i >= 0; i--) {
 		t->index[i] = indexes;
@@ -895,6 +897,7 @@ static int setup_indexes(struct dm_table *t)
 		setup_btree_index(i, t);
 	}
 
+	vfree(indexes_head);
 	return 0;
 }
 
-- 
1.6.3.3


--=-EuQOx/0TIITU4YSwU1N1
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-EuQOx/0TIITU4YSwU1N1--
