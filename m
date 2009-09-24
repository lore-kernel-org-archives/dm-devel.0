From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] dm: Add a remapping trace to request-based dm
Date: Thu, 24 Sep 2009 16:24:22 +0900
Message-ID: <4ABB1EA6.2070805@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: lizf@cn.fujitsu.com, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

# Re-sending just the dm part.

Hi Alasdair,

This patch adds a remapping trace to request-based dm.
BIO-based dm already has the equivalent tracepoint.

For example, under this dm stack (linear LV on multipath):
  # dmsetup ls --tree -o ascii
  vg-lv0 (253:1)
   `-mpath0 (253:0)
      |- (8:160)
      |- (66:80)
      |- (65:176)
      `- (65:160)

Trace of 'dd of=/dev/vg/lv0 bs=128k count=1 oflag=direct' looks like this:

without the patch:
  dd-6674  [000]   539.727384: block_bio_queue: 253,1 WS 0 + 256 [dd]
  dd-6674  [000]   539.727392: block_remap: 253,0 WS 384 + 256 <- (253,1) 0
  dd-6674  [000]   539.727394: block_bio_queue: 253,0 WS 384 + 256 [dd]
  dd-6674  [000]   539.727405: block_getrq: 253,0 WS 384 + 256 [dd]
  dd-6674  [000]   539.727409: block_plug: [dd]
  dd-6674  [000]   539.727410: block_rq_insert: 253,0 W 0 () 384 + 256 [dd]
  dd-6674  [000]   539.727416: block_rq_issue: 253,0 W 0 () 384 + 256 [dd]
  dd-6674  [000]   539.727426: block_rq_insert: 65,176 W 0 () 384 + 256 [dd]
  dd-6674  [000]   539.727427: block_rq_issue: 65,176 W 0 () 384 + 256 [dd]
  ...

and with the patch: (the line with '**' is the trace added by this patch)
  dd-6617  [002]   162.914301: block_bio_queue: 253,1 WS 0 + 256 [dd]
  dd-6617  [002]   162.914314: block_remap: 253,0 WS 384 + 256 <- (253,1) 0
  dd-6617  [002]   162.914316: block_bio_queue: 253,0 WS 384 + 256 [dd]
  dd-6617  [002]   162.914331: block_getrq: 253,0 WS 384 + 256 [dd]
  dd-6617  [002]   162.914335: block_plug: [dd]
  dd-6617  [002]   162.914337: block_rq_insert: 253,0 W 0 () 384 + 256 [dd]
  dd-6617  [002]   162.914347: block_rq_issue: 253,0 W 0 () 384 + 256 [dd]
**dd-6617  [002]   162.914356: block_rq_remap: 65,176 W 384 + 256 <- (253,0) 384
  dd-6617  [002]   162.914358: block_rq_insert: 65,176 W 0 () 384 + 256 [dd]
  dd-6617  [002]   162.914359: block_rq_issue: 65,176 W 0 () 384 + 256 [dd]
  ...


The patch depends on the following commit, which is currently
in Jens' for-linus tree (for 2.6.32).
   commit 0dcaf5b406a5e09ecbb80ad25434694457117e50
   Author: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
   Date:   Mon Sep 21 21:04:03 2009 +0200
      Add a tracepoint for block request remapping

The patch can apply either with or without the patch series
for -next in your editing tree.

If you are ok, please pull this patch to your tree for 2.6.32.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>

---
 drivers/md/dm.c |    2 ++
 1 file changed, 2 insertions(+)

Index: block-for-linus-2.6.32/drivers/md/dm.c
===================================================================
--- block-for-linus-2.6.32.orig/drivers/md/dm.c
+++ block-for-linus-2.6.32/drivers/md/dm.c
@@ -1505,6 +1505,8 @@ static void map_request(struct dm_target
 		break;
 	case DM_MAPIO_REMAPPED:
 		/* The target has remapped the I/O so dispatch it */
+		trace_block_rq_remap(clone->q, clone, disk_devt(dm_disk(md)),
+				     blk_rq_pos(tio->orig));
 		dm_dispatch_request(clone);
 		break;
 	case DM_MAPIO_REQUEUE:
