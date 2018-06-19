From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] md: remove a bogus comment
Date: Tue, 19 Jun 2018 06:52:15 +0200
Message-ID: <20180619045216.21130-6-hch@lst.de>
References: <20180619045216.21130-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180619045216.21130-1-hch@lst.de>
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
Cc: linux-block@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

The function name mentioned doesn't exist, and the code next to it
doesn't match the description either.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 29b0cd9ec951..81f458514ac0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -204,10 +204,6 @@ static int start_readonly;
  */
 static bool create_on_open = true;
 
-/* bio_clone_mddev
- * like bio_clone_bioset, but with a local bio set
- */
-
 struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 			    struct mddev *mddev)
 {
-- 
2.17.1
