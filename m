From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: [PATCH 0/4] dm: reduce memory overhead of DM devices
Date: Fri, 3 Oct 2014 11:48:08 +0000
Message-ID: <542E8CF9.6000609@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: ja-JP
Content-ID: <16B48B7638BBAA4AB19DF9850FE480A4@gisp.nec.co.jp>
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

This series of patches reduce the memory overhead of device-mapper
device mainly by removing unused mempool for bio vecs.

DM creates per-device bioset to ensure forward progress under
low memory situation and bioset always includes mempool for bvec.

However, with the introduction of immutable bvec by Kent Overstreet,
dm core now uses bio_clone_fast for creating a clone bio, and no longer
needs bvecs for it.

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

Jun'ichi Nomura (4):
  dm: remove nr_iovecs parameter from alloc_tio()
  block: use bio_clone_fast() in blk_rq_prep_clone()
  block: add bioset_nobvec_create()
  dm: use bioset_nobvec_create()

 block/bio.c         | 61 ++++++++++++++++++++++++++++++++++++++---------------
 block/blk-core.c    |  2 +-
 drivers/md/dm.c     | 15 +++++--------
 include/linux/bio.h |  1 +
 4 files changed, 51 insertions(+), 28 deletions(-)

-- 
1.9.3

--
Jun'ichi Nomura, NEC Corporation
