From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] dm-ioctl: Don't leak memory in target_message() if 'argc'
 is NULL
Date: Sun, 6 Nov 2011 23:20:14 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1111062318090.5763@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: dm-devel.ids

If 'argc' is NULL we'll jump to the 'out:' label, but this will leak
the memory that 'dm_split_args()' allocated for 'argv', so we should
be jumping to the 'out_argv:' label instead to free up that
memory. This patch does so.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

 note: compile tested only.

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 31c2dc2..1ce84ed 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1437,7 +1437,7 @@ static int target_message(struct dm_ioctl *param, size_t param_size)
 
 	if (!argc) {
 		DMWARN("Empty message received.");
-		goto out;
+		goto out_argv;
 	}
 
 	table = dm_get_live_table(md);
-- 
1.7.7.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
