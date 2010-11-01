From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/5] btrfs: close_bdev_exclusive() should use the
	same @flags as the matching open_bdev_exclusive()
Date: Mon,  1 Nov 2010 17:15:26 +0100
Message-ID: <1288628129-12811-3-git-send-email-tj__45370.5863714733$1288628314$gmane$org@kernel.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1288628129-12811-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org, petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jack@suse.cz, akpm@linux-foundatio
Cc: Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

In the failure path of __btrfs_open_devices(), close_bdev_exclusive()
is called with @flags which doesn't match the one used during
open_bdev_exclusive().  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Chris Mason <chris.mason@oracle.com>
---
 fs/btrfs/volumes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cc04dc1..d395962 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -638,7 +638,7 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 error_brelse:
 		brelse(bh);
 error_close:
-		close_bdev_exclusive(bdev, FMODE_READ);
+		close_bdev_exclusive(bdev, flags);
 error:
 		continue;
 	}
-- 
1.7.1
