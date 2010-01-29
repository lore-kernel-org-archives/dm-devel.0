From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [BUGFIX] [PATCH] freeze_bdev: don't deactivate successfully frozen
 MS_RDONLY sb
Date: Fri, 29 Jan 2010 09:56:22 +0900
Message-ID: <4B623236.90003@ce.jp.nec.com>
References: <d2deb3241001160158r4baed1e1t7e8f6642de018b4c@mail.gmail.com> <20100122160740.6c16c22d.akpm@linux-foundation.org> <20100128134205.352044bd@notabene> <4B612F89.7020503@ce.jp.nec.com> <20100128182528.GA29926@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100128182528.GA29926@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, tmb@mandriva.org
Cc: Fran?ois Figarola <francois.figarola@i-consult.fr>, device-mapper development <dm-devel@redhat.com>, Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, stable@kernel.org
List-Id: dm-devel.ids

Thanks Thomas and Christoph for testing and review.
I removed 'smp_wmb()' before up_write from the previous patch,
since up_write() should have necessary ordering constraints.
(I.e. the change of s_frozen is visible to others after up_write)
I'm quite sure the change is harmless but if you are uncomfortable
with Tested-by/Reviewed-by on the modified patch, please remove them.


If MS_RDONLY, freeze_bdev should just up_write(s_umount) instead of
deactivate_locked_super().
Also, keep sb->s_frozen consistent so that remount can check the frozen state.

Otherwise a crash reported here can happen:
http://lkml.org/lkml/2010/1/16/37
http://lkml.org/lkml/2010/1/28/53


This patch should be applied for 2.6.32 stable series, too.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Thomas Backlund <tmb@mandriva.org> 
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com> 
Cc: stable@kernel.org

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 73d6a73..d11d028 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -246,7 +246,8 @@ struct super_block *freeze_bdev(struct block_device *bdev)
 	if (!sb)
 		goto out;
 	if (sb->s_flags & MS_RDONLY) {
-		deactivate_locked_super(sb);
+		sb->s_frozen = SB_FREEZE_TRANS;
+		up_write(&sb->s_umount);
 		mutex_unlock(&bdev->bd_fsfreeze_mutex);
 		return sb;
 	}
@@ -307,7 +308,7 @@ int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 	BUG_ON(sb->s_bdev != bdev);
 	down_write(&sb->s_umount);
 	if (sb->s_flags & MS_RDONLY)
-		goto out_deactivate;
+		goto out_unfrozen;
 
 	if (sb->s_op->unfreeze_fs) {
 		error = sb->s_op->unfreeze_fs(sb);
@@ -321,11 +322,11 @@ int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 		}
 	}
 
+out_unfrozen:
 	sb->s_frozen = SB_UNFROZEN;
 	smp_wmb();
 	wake_up(&sb->s_wait_unfrozen);
 
-out_deactivate:
 	if (sb)
 		deactivate_locked_super(sb);
 out_unlock:
