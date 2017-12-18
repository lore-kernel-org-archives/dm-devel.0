From: monty <monty_pavel@sina.com>
Subject: [PATCH] persistent-data: fix bug about btree of updating
 internal node's minima key in btree_split_beneath.
Date: Mon, 18 Dec 2017 16:27:58 -0500
Message-ID: <32476.914212066$1513606092@news.gmane.org>
Reply-To: fixbugaboutbtree_split_beneathfunc@redhat.com,
	thisbugmaycauseakeyhadbeeninsertedtobtree@redhat.com,
	butdm_btree_lookupcannotfindthekeyinbtreelater.@redhat.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: monty_pavel@sina.com
List-Id: dm-devel.ids



--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Signed-off-by: monty <monty_pavel@sina.com>
---
 drivers/md/persistent-data/dm-btree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index f21ce6a..25ce5ec 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -694,6 +694,8 @@ static int btree_split_beneath(struct shadow_spine *s, uint64_t key)
 	if (key < le64_to_cpu(rn->keys[0])) {
 		unlock_block(s->info, right);
 		s->nodes[1] = left;
+		if (key < le64_to_cpu(ln->keys[0]))
+			ln->keys[0] = cpu_to_le64(key);
 	} else {
 		unlock_block(s->info, left);
 		s->nodes[1] = right;
-- 
1.7.1


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="persistent-data-fix-bug-about-btree-of-updating-inte.patch"

From 5c926190bdeb71a9b1918cca1ccb5e62251f533c Mon Sep 17 00:00:00 2001
From: monty <monty_pavel@sina.com>
Date: Mon, 18 Dec 2017 15:52:31 -0500
Subject: [PATCH] persistent-data: fix bug about btree of updating internal node's minima
 key in btree_split_beneath.

 fix bug about btree_split_beneath func, this bug may cause a key had
 been inserted to btree, but dm_btree_lookup can not find the key in
 btree later.

Signed-off-by: monty <monty_pavel@sina.com>
---
 drivers/md/persistent-data/dm-btree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index f21ce6a..25ce5ec 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -694,6 +694,8 @@ static int btree_split_beneath(struct shadow_spine *s, uint64_t key)
 	if (key < le64_to_cpu(rn->keys[0])) {
 		unlock_block(s->info, right);
 		s->nodes[1] = left;
+		if (key < le64_to_cpu(ln->keys[0]))
+			ln->keys[0] = cpu_to_le64(key);
 	} else {
 		unlock_block(s->info, left);
 		s->nodes[1] = right;
-- 
1.7.1


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--tKW2IUtsqtDRztdT--
