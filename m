From: Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH 12/16] DM: release unneeded buffer as soon as possible.
Date: Mon, 15 Aug 2016 10:36:49 -0700
Message-ID: <1471282613-31006-13-git-send-email-linuxram@us.ibm.com>
References: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-doc@vger.kernel.org
Cc: shli@kernel.org, agk@redhat.com, snitzer@redhat.com, corbet@lwn.net, Ram Pai <linuxram@us.ibm.com>
List-Id: dm-devel.ids

Done to conserve as much free space as possible.  Waiting to release till the
bio is done will unneccesarily hog up memory.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/md/dm-inplace-compress.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-inplace-compress.c b/drivers/md/dm-inplace-compress.c
index bc1cf70..b1c3e5f 100644
--- a/drivers/md/dm-inplace-compress.c
+++ b/drivers/md/dm-inplace-compress.c
@@ -977,7 +977,7 @@ static struct dm_icomp_io_range *dm_icomp_create_io_read_range(
 	io->comp_kmap = (segments == 1);
 	/* note down the requested length for decompress buffer.
 	 * but dont allocate it yet.
-	 /
+	 */
 	io->decomp_req_len = decomp_len;
 	return io;
 }
@@ -1375,8 +1375,13 @@ static int dm_icomp_handle_write_modify(struct dm_icomp_io_range *io,
 	}
 
 	dm_icomp_get_req(req);
-	if (ret == 1)
+
+	if (ret == 1) {
 		io->io_req.mem.ptr.addr = io->decomp_data + (offset << 9);
+		dm_icomp_release_comp_buffer(io);
+	} else
+		dm_icomp_release_decomp_buffer(io);
+
 	io->io_region.count = comp_len >> 9;
 	io->io_region.sector = start + req->info->data_start;
 
@@ -1443,8 +1448,11 @@ static void dm_icomp_handle_write_comp(struct dm_icomp_req *req)
 	io->io_region.sector = req->bio->bi_iter.bi_sector +
 			 req->info->data_start;
 
-	if (ret == 1)
+	if (ret == 1) {
 		io->io_req.mem.ptr.addr = io->decomp_data;
+		dm_icomp_release_comp_buffer(io);
+	} else
+		dm_icomp_release_decomp_buffer(io);
 
 	io->io_region.count = comp_len >> 9;
 	io->io_req.bi_rw = req->bio->bi_rw;
-- 
1.7.1
