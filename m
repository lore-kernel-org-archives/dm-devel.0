From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V14 10/18] btrfs: use mp_bvec_last_segment to get
	bio's last page
Date: Mon, 21 Jan 2019 16:17:57 +0800
Message-ID: <20190121081805.32727-11-ming.lei@redhat.com>
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

Preparing for supporting multi-page bvec.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/btrfs/extent_io.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index dc8ba3ee515d..986ef49b0269 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2697,11 +2697,12 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 {
 	blk_status_t ret = 0;
 	struct bio_vec *bvec = bio_last_bvec_all(bio);
-	struct page *page = bvec->bv_page;
+	struct bio_vec bv;
 	struct extent_io_tree *tree = bio->bi_private;
 	u64 start;
 
-	start = page_offset(page) + bvec->bv_offset;
+	mp_bvec_last_segment(bvec, &bv);
+	start = page_offset(bv.bv_page) + bv.bv_offset;
 
 	bio->bi_private = NULL;
 
-- 
2.9.5
