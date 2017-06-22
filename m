From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] dm ioctl: constify ioctl lookup table
Date: Thu, 22 Jun 2017 11:33:47 -0700
Message-ID: <20170622183347.48799-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, Eric Biggers <ebiggers@google.com>
List-Id: dm-devel.ids

From: Eric Biggers <ebiggers@google.com>

Constify the lookup table for device-mapper ioctls so that it is placed
in .rodata.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 41852ae287a5..8e9a1eff25d3 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1604,7 +1604,7 @@ static int target_message(struct dm_ioctl *param, size_t param_size)
  *---------------------------------------------------------------*/
 static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
 {
-	static struct {
+	static const struct {
 		int cmd;
 		int flags;
 		ioctl_fn fn;
-- 
2.13.1.611.g7e3b11ae1-goog
