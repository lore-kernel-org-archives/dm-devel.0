From: Mike Snitzer <msnitzer@redhat.com>
Subject: Re: dm transaction manager: handle space map checker
	failure
Date: Thu, 21 Jun 2012 02:10:09 -0400
Message-ID: <20120621061009.GA21318@redhat.com>
References: <1340220299-17771-1-git-send-email-snitzer@redhat.com>
	<20120620212010.GK22599@redhat.com>
	<20120620213756.GL22599@redhat.com>
	<20120620221542.GA18880@redhat.com>
	<20120621051032.GA20978@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120621051032.GA20978@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Thu, Jun 21 2012 at  1:10am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Hey Vivek,
> 
> Here is a more comprehensive patch (seems vmalloc doesn't support
> passing a @size of 0, whereas kmalloc does).
> 
> But I know that this patch causes sm_checker_destroy() to crash in the
> kfree() from ca_destroy(&smc->old_counts);
> 
> If I simply switch back from vzalloc to using kzalloc all works fine!?
> 
> Seems very odd, will dig deeper when I get a chance.

Not odd, just a stupid oversight on my part.  Needed to switch to using
vfree too ;)

Here is an updated patch.

(Joe and Alasdair, I'll post 2 new cleaned up patches for 3.5; the
dm-space-map-disk.c change in this patch needs to be folded into v2 of
the "dm transaction manager: handle space map checker failure" patch I
posted yesterday)

 drivers/md/persistent-data/dm-space-map-checker.c |   28 ++++++++++++--------
 drivers/md/persistent-data/dm-space-map-disk.c    |    8 +++++-
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-checker.c b/drivers/md/persistent-data/dm-space-map-checker.c
index 6d7c832..f0eded3 100644
--- a/drivers/md/persistent-data/dm-space-map-checker.c
+++ b/drivers/md/persistent-data/dm-space-map-checker.c
@@ -89,13 +89,22 @@ static int ca_create(struct count_array *ca, struct dm_space_map *sm)
 
 	ca->nr = nr_blocks;
 	ca->nr_free = nr_blocks;
-	ca->counts = kzalloc(sizeof(*ca->counts) * nr_blocks, GFP_KERNEL);
-	if (!ca->counts)
-		return -ENOMEM;
+
+	if (nr_blocks) {
+		ca->counts = vzalloc(sizeof(*ca->counts) * nr_blocks);
+		if (!ca->counts)
+			return -ENOMEM;
+	} else
+		ca->counts = NULL;
 
 	return 0;
 }
 
+static void ca_destroy(struct count_array *ca)
+{
+	vfree(ca->counts);
+}
+
 static int ca_load(struct count_array *ca, struct dm_space_map *sm)
 {
 	int r;
@@ -126,12 +135,14 @@ static int ca_load(struct count_array *ca, struct dm_space_map *sm)
 static int ca_extend(struct count_array *ca, dm_block_t extra_blocks)
 {
 	dm_block_t nr_blocks = ca->nr + extra_blocks;
-	uint32_t *counts = kzalloc(sizeof(*counts) * nr_blocks, GFP_KERNEL);
+	uint32_t *counts = vzalloc(sizeof(*counts) * nr_blocks);
 	if (!counts)
 		return -ENOMEM;
 
-	memcpy(counts, ca->counts, sizeof(*counts) * ca->nr);
-	kfree(ca->counts);
+	if (ca->counts) {
+		memcpy(counts, ca->counts, sizeof(*counts) * ca->nr);
+		ca_destroy(ca);
+	}
 	ca->nr = nr_blocks;
 	ca->nr_free += extra_blocks;
 	ca->counts = counts;
@@ -151,11 +162,6 @@ static int ca_commit(struct count_array *old, struct count_array *new)
 	return 0;
 }
 
-static void ca_destroy(struct count_array *ca)
-{
-	kfree(ca->counts);
-}
-
 /*----------------------------------------------------------------*/
 
 struct sm_checker {
diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/persistent-data/dm-space-map-disk.c
index 9535234..124828b 100644
--- a/drivers/md/persistent-data/dm-space-map-disk.c
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@ -315,7 +315,13 @@ struct dm_space_map *dm_sm_disk_create(struct dm_transaction_manager *tm,
 				       dm_block_t nr_blocks)
 {
 	struct dm_space_map *sm = dm_sm_disk_create_real(tm, nr_blocks);
-	return dm_sm_checker_create_fresh(sm);
+	struct dm_space_map *smc = dm_sm_checker_create_fresh(sm);
+
+	if (IS_ERR(smc) && !IS_ERR_OR_NULL(sm))
+		dm_sm_destroy(sm);
+	sm = smc;
+
+	return sm;
 }
 EXPORT_SYMBOL_GPL(dm_sm_disk_create);
 
