From: Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH 03/16] DM: Error if enough space is not available.
Date: Mon, 15 Aug 2016 10:36:40 -0700
Message-ID: <1471282613-31006-4-git-send-email-linuxram@us.ibm.com>
References: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-doc@vger.kernel.org
Cc: shli@kernel.org, agk@redhat.com, snitzer@redhat.com, corbet@lwn.net, Ram Pai <linuxram@us.ibm.com>
List-Id: dm-devel.ids

if enough space is not available to create a block of the specified size error
out.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/md/dm-inplace-compress.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-inplace-compress.c b/drivers/md/dm-inplace-compress.c
index 70d6c0e..17221a1 100644
--- a/drivers/md/dm-inplace-compress.c
+++ b/drivers/md/dm-inplace-compress.c
@@ -453,6 +453,12 @@ static int dm_icomp_read_or_create_super(struct dm_icomp_info *info)
 	info->data_blocks = data_blocks;
 	info->data_start = (1 + meta_blocks) << DMCP_BLOCK_SECTOR_SHIFT;
 
+	if ((data_blocks << DMCP_BLOCK_SECTOR_SHIFT) < info->ti->len) {
+		info->ti->error =
+			"Insufficient sectors to satisfy requested size";
+		return -ENOMEM;
+	}
+
 	addr = kzalloc(DMCP_BLOCK_SIZE, GFP_KERNEL);
 	if (!addr) {
 		info->ti->error = "Cannot allocate super";
-- 
1.7.1
