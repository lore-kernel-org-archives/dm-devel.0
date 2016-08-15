From: Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH 14/16] DM: Wasted bio copy.
Date: Mon, 15 Aug 2016 10:36:51 -0700
Message-ID: <1471282613-31006-15-git-send-email-linuxram@us.ibm.com>
References: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-doc-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-doc@vger.kernel.org
Cc: shli@kernel.org, agk@redhat.com, snitzer@redhat.com, corbet@lwn.net, Ram Pai <linuxram@us.ibm.com>
List-Id: dm-devel.ids

No point doing it.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/md/dm-inplace-compress.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-inplace-compress.c b/drivers/md/dm-inplace-compress.c
index 55a515b..31b144b 100644
--- a/drivers/md/dm-inplace-compress.c
+++ b/drivers/md/dm-inplace-compress.c
@@ -1434,7 +1434,6 @@ static void dm_icomp_handle_write_comp(struct dm_icomp_req *req)
 		req->result = -EIO;
 		return;
 	}
-	dm_icomp_bio_copy(req->bio, 0, io->decomp_data, count << 9, true);
 
 	/* compress data */
 	comp_len = io->comp_len;
-- 
1.7.1

