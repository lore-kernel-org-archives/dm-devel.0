From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Subject: [PATCH] dm-crypt: use struct_size() in kzalloc()
Date: Wed, 12 Jun 2019 14:14:45 +0800
Message-ID: <1560320086-14243-1-git-send-email-liuzhengyuan@kylinos.cn>
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
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, Zhengyuan Liu <liuzhengyuan@kylinos.cn>
List-Id: dm-devel.ids

As Gustavo said in other patches doing the same replace, we can now
use the new struct_size() helper to avoid leaving these open-coded and
prone to type mistake.

Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
---
 drivers/md/dm-crypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 1b16d34..2587e94 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2699,7 +2699,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -EINVAL;
 	}
 
-	cc = kzalloc(sizeof(*cc) + key_size * sizeof(u8), GFP_KERNEL);
+	cc = kzalloc(struct_size(cc, key, key_size), GFP_KERNEL);
 	if (!cc) {
 		ti->error = "Cannot allocate encryption context";
 		return -ENOMEM;
-- 
2.7.4
