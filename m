From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH 08/12] RAID 4/5/6: Indicate parity blocks as 'META'
Date: Mon,  4 Apr 2016 12:06:12 +0700
Message-ID: <1459746376-27983-9-git-send-email-shaun@tancheff.com>
References: <1459746376-27983-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1459746376-27983-1-git-send-email-shaun@tancheff.com>
Sender: linux-scsi-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@fb.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: dm-devel.ids

From: Shaun Tancheff <shaun.tancheff@seagate.com>

    It is useful for ZDM to know that a block is part of a parity stripe
    as parity stripes are deemed to be hotter and more prone to becoming
    stale. ZDM will co-locate META bios to alternate streams.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
 drivers/md/raid5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b4f02c9..c96655e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -937,6 +937,8 @@ again:
 			rrdev = NULL;
 		}
 		if (rw & WRITE) {
+			if (i == sh->pd_idx || i == sh->qd_idx)
+				rw |= REQ_META;
 			if (replace_only)
 				rdev = NULL;
 			if (rdev == rrdev)
-- 
1.9.1

