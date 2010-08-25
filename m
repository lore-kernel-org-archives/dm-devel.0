From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 26/30] ext4: do not send discards as barriers
Date: Wed, 25 Aug 2010 17:47:43 +0200
Message-ID: <1282751267-3530-27-git-send-email-tj__31856.2467852191$1282751827$gmane$org@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@l
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

From: Christoph Hellwig <hch@infradead.org>

ext4 already uses synchronous discards, no need to add I/O barriers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index df44b34..a22bfef 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2567,7 +2567,7 @@ static inline void ext4_issue_discard(struct super_block *sb,
 	trace_ext4_discard_blocks(sb,
 			(unsigned long long) discard_block, count);
 	ret = sb_issue_discard(sb, discard_block, count, GFP_NOFS,
-			       BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+			       BLKDEV_IFL_WAIT);
 	if (ret == EOPNOTSUPP) {
 		ext4_warning(sb, "discard not supported, disabling");
 		clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
-- 
1.7.1
