From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3] dm verity: don't prefetch hash blocks for
	already-verified data
Date: Mon,  6 Jan 2020 20:34:24 -0800
Message-ID: <20200107043424.18668-1-ebiggers@kernel.org>
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
To: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "yuanjiong . gao" <yuanjiong.gao@transsion.com>, "ruxian . feng" <ruxian.feng@transsion.com>, "xianrong.zhou" <xianrong.zhou@transsion.com>, Patrik Torstensson <totte@google.com>, Eric Biggers <ebiggers@google.com>
List-Id: dm-devel.ids

From: "xianrong.zhou" <xianrong.zhou@transsion.com>

Try to skip prefetching hash blocks that won't be needed due to the
"check_at_most_once" option being enabled and the corresponding data
blocks already having been verified.

Since prefetching operates on a range of data blocks, do this by just
trimming the two ends of the range.  This doesn't skip every unneeded
hash block, since data blocks in the middle of the range could also be
unneeded, and hash blocks are still prefetched in large clusters as
controlled by dm_verity_prefetch_cluster.  But it can still help a lot.

In a test on Android Q launching 91 apps every 15s repeated 21 times,
prefetching was only done for 447177/4776629 = 9.36% of data blocks.

Tested-by: ruxian.feng <ruxian.feng@transsion.com>
Co-developed-by: yuanjiong.gao <yuanjiong.gao@transsion.com>
Signed-off-by: yuanjiong.gao <yuanjiong.gao@transsion.com>
Signed-off-by: xianrong.zhou <xianrong.zhou@transsion.com>
[EB: simplified the 'while' loops and improved the commit message]
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-target.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 4fb33e7562c5..0d61e9c67986 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -611,8 +611,22 @@ static void verity_prefetch_io(struct work_struct *work)
 
 static void verity_submit_prefetch(struct dm_verity *v, struct dm_verity_io *io)
 {
+	sector_t block = io->block;
+	unsigned int n_blocks = io->n_blocks;
 	struct dm_verity_prefetch_work *pw;
 
+	if (v->validated_blocks) {
+		while (n_blocks && test_bit(block, v->validated_blocks)) {
+			block++;
+			n_blocks--;
+		}
+		while (n_blocks && test_bit(block + n_blocks - 1,
+					    v->validated_blocks))
+			n_blocks--;
+		if (!n_blocks)
+			return;
+	}
+
 	pw = kmalloc(sizeof(struct dm_verity_prefetch_work),
 		GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
 
@@ -621,8 +635,8 @@ static void verity_submit_prefetch(struct dm_verity *v, struct dm_verity_io *io)
 
 	INIT_WORK(&pw->work, verity_prefetch_io);
 	pw->v = v;
-	pw->block = io->block;
-	pw->n_blocks = io->n_blocks;
+	pw->block = block;
+	pw->n_blocks = n_blocks;
 	queue_work(v->verify_wq, &pw->work);
 }
 
-- 
2.24.1
