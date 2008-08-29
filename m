From: Tejun Heo <tj@kernel.org>
Subject: [PATCH] block: don't test for partition size in bdget_disk() and
 blk_lookup_devt()
Date: Fri, 29 Aug 2008 11:35:17 +0200
Message-ID: <48B7C2D5.2060209@kernel.org>
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <58cb370e0808270757k583c0fc2oc659bc8e2dd6c21e@mail.gmail.com> <200808272145.20627.bzolnier@gmail.com> <200808290210.37211.bzolnier@gmail.com> <20080829070515.GL20055@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20080829070515.GL20055@kernel.dk>
Sender: linux-next-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, dm-devel@redhat.com
List-Id: dm-devel.ids

bdget_disk() and blk_lookup_devt() never cared whether the specified
partition (or disk) is zero sized or not.  I got confused while
converting those not to depend on consecutive minor numbers in commit
5a6411b1178baf534aa9138052864dfa89d3eada and later when dev0 was added
it broke callers which expected to get valid return for zero sized
disk devices.

So, they never needed nr_sects checks in the first place.  Kill them.

This problem was spotted and debugged by Bartlmoiej Zolnierkiewicz.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Thanks for the good spotting.  I got confused between the meaning of
!part and !part->nr_sects and added the wrong check during conversion.
I audited the rest and it seems those two are the only ones.

Thanks.

 block/genhd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: work/block/genhd.c
===================================================================
--- work.orig/block/genhd.c
+++ work/block/genhd.c
@@ -586,7 +586,7 @@ extern struct block_device *bdget_disk(s
 	struct block_device *bdev = NULL;
 
 	part = disk_get_part(disk, partno);
-	if (part && (part->nr_sects || partno == 0))
+	if (part)
 		bdev = bdget(part_devt(part));
 	disk_put_part(part);
 
@@ -1032,7 +1032,7 @@ dev_t blk_lookup_devt(const char *name,
 			continue;
 
 		part = disk_get_part(disk, partno);
-		if (part && (part->nr_sects || partno == 0)) {
+		if (part) {
 			devt = part_devt(part);
 			disk_put_part(part);
 			break;
