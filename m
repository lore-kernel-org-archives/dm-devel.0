From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V14 03/18] block: remove bvec_iter_rewind()
Date: Mon, 21 Jan 2019 16:17:50 +0800
Message-ID: <20190121081805.32727-4-ming.lei@redhat.com>
References: <20190121081805.32727-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190121081805.32727-1-ming.lei@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Darrick J . Wong" <darrick.wong@oracle.com>, Omar Sandoval <osandov@fb.com>, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Boaz Harrosh <ooo@electrozaur.com>, Gao Xiang <gaoxiang25@huawei.com>, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dave Chinner <dchinner@redhat.com>, David Sterba <dsterba@suse.com>, Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

Commit 7759eb23fd980 ("block: remove bio_rewind_iter()") removes
bio_rewind_iter(), then no one uses bvec_iter_rewind() any more,
so remove it.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/bvec.h | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 02c73c6aa805..ba0ae40e77c9 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -92,30 +92,6 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
 	return true;
 }
 
-static inline bool bvec_iter_rewind(const struct bio_vec *bv,
-				     struct bvec_iter *iter,
-				     unsigned int bytes)
-{
-	while (bytes) {
-		unsigned len = min(bytes, iter->bi_bvec_done);
-
-		if (iter->bi_bvec_done == 0) {
-			if (WARN_ONCE(iter->bi_idx == 0,
-				      "Attempted to rewind iter beyond "
-				      "bvec's boundaries\n")) {
-				return false;
-			}
-			iter->bi_idx--;
-			iter->bi_bvec_done = __bvec_iter_bvec(bv, *iter)->bv_len;
-			continue;
-		}
-		bytes -= len;
-		iter->bi_size += len;
-		iter->bi_bvec_done -= len;
-	}
-	return true;
-}
-
 #define for_each_bvec(bvl, bio_vec, iter, start)			\
 	for (iter = (start);						\
 	     (iter).bi_size &&						\
-- 
2.9.5
