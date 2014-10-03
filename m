From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 4/4] dm: use bioset_create_nobvec()
Date: Fri,  3 Oct 2014 17:27:13 -0400
Message-ID: <1412371633-30356-4-git-send-email-snitzer@redhat.com>
References: <1412371633-30356-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1412371633-30356-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <20141003204852.GA14135@redhat.com>
References: <20141003204852.GA14135@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, Junichi Nomura <j-nomura@ce.jp.nec.com>, Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, Kent Overstreet <kmo@daterainc.com>
List-Id: dm-devel.ids

From: Junichi Nomura <j-nomura@ce.jp.nec.com>

Since DM core uses bio_clone_fast() for both bio-based and request-based
DM devices there is no need for DM's bioset to have a bvec mempool.

With this patch, on arch with 4KB page for example, memory usage will be
reduced by 64KB for each bio-based DM device and 1MB for each
request-based DM device.

For example, when you create 10,000 bio-based DM devices and 1,000
request-based DM devices, memory usage of biovec under no load is:
  # grep biovec /proc/slabinfo

  biovec-256        418068 418068   4096  ...
  biovec-128             0      0   2048  ...
  biovec-64              0      0   1024  ...
  biovec-16              0      0    256  ...

With this patch series applied, the usage becomes:
  # grep biovec /proc/slabinfo

  biovec-256           116    116   4096  ...
  biovec-128             0      0   2048  ...
  biovec-64              0      0   1024  ...
  biovec-16              0      0    256  ...

So 4096 * (418068 - 116) = 1.6GB of memory is saved in this example.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index aaeed99..f78ac7f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3021,7 +3021,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
 	if (!pools->io_pool)
 		goto out;
 
-	pools->bs = bioset_create(pool_size, front_pad);
+	pools->bs = bioset_nobvec_create(pool_size, front_pad);
 	if (!pools->bs)
 		goto out;
 
-- 
1.9.3
