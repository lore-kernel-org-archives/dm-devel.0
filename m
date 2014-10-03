From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: [PATCH 4/4] dm: use bioset_nobvec_create()
Date: Fri, 3 Oct 2014 11:55:26 +0000
Message-ID: <542E8EAE.8060300@ce.jp.nec.com>
References: <542E8CF9.6000609@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <542E8CF9.6000609@ce.jp.nec.com>
Content-Language: ja-JP
Content-ID: <0FDA2F8F0D721C429E70C24152967BAF@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>
List-Id: dm-devel.ids

Since dm core uses bio_clone_fast() for both bio-based and request-based
DM device, there is no need for bvec mempool.

With this patch, on arch with 4KB page for example, memory usage will be
reduced by 64KB for each bio-based DM device and 1MB for each
request-based DM device.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4210b3c..7160853 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2895,7 +2895,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
 	if (!pools->io_pool)
 		goto out;
 
-	pools->bs = bioset_create(pool_size, front_pad);
+	pools->bs = bioset_nobvec_create(pool_size, front_pad);
 	if (!pools->bs)
 		goto out;
 
-- 
1.9.3
