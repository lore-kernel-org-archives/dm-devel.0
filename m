From: Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH 04/16] DM: Ensure that the read request is
	within the device range.
Date: Mon, 15 Aug 2016 10:36:41 -0700
Message-ID: <1471282613-31006-5-git-send-email-linuxram@us.ibm.com>
References: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-doc@vger.kernel.org
Cc: shli@kernel.org, snitzer@redhat.com, agk@redhat.com, corbet@lwn.net
List-Id: dm-devel.ids

If a read request is not within the device range return error.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/md/dm-inplace-compress.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-inplace-compress.c b/drivers/md/dm-inplace-compress.c
index 17221a1..bf18028 100644
--- a/drivers/md/dm-inplace-compress.c
+++ b/drivers/md/dm-inplace-compress.c
@@ -1025,6 +1025,12 @@ static void dm_icomp_read_one_extent(struct dm_icomp_req *req, u64 block,
 {
 	struct dm_icomp_io_range *io;
 
+	if (block+(data_sectors>>DMCP_BLOCK_SECTOR_SHIFT) >=
+			req->info->data_blocks) {
+		req->result = -EIO;
+		return;
+	}
+
 	io = dm_icomp_create_io_range(req, data_sectors << 9,
 		logical_sectors << 9);
 	if (!io) {
@@ -1063,7 +1069,9 @@ again:
 
 	block_index = first_block_index + (logical_sectors >>
 				DMCP_BLOCK_SECTOR_SHIFT);
-	if ((block_index << DMCP_BLOCK_SECTOR_SHIFT) < bio_end_sector(req->bio))
+	if (((block_index << DMCP_BLOCK_SECTOR_SHIFT) <
+			 bio_end_sector(req->bio)) &&
+			((block_index) < req->info->data_blocks))
 		goto again;
 
 	/* A shortcut if all data is in already */
-- 
1.7.1
