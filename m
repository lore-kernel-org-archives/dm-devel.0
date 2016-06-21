From: Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH] dm verity fec: fix block calculation
Date: Tue, 21 Jun 2016 11:02:42 -0700
Message-ID: <1466532162-54016-1-git-send-email-samitolvanen@google.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Sami Tolvanen <samitolvanen@google.com>
List-Id: dm-devel.ids

do_div was replaced with div64_u64 at some point, causing a bug
with block calculation due to incompatible semantics of the two
functions.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
---
 drivers/md/dm-verity-fec.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 459a9f8..0f0eb8a 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -453,9 +453,7 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 	 */
 
 	offset = block << v->data_dev_block_bits;
-
-	res = offset;
-	div64_u64(res, v->fec->rounds << v->data_dev_block_bits);
+	res = div64_u64(offset, v->fec->rounds << v->data_dev_block_bits);
 
 	/*
 	 * The base RS block we can feed to the interleaver to find out all
-- 
2.8.0.rc3.226.g39d4020
