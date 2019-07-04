From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 1/3] dm-crypt: Wipe private IV struct after key
	invalid flag is set.
Date: Thu,  4 Jul 2019 15:10:31 +0200
Message-ID: <20190704131033.9919-1-gmazyland@gmail.com>
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
Cc: Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

If a private IV wipe function fails, the code does not set the key
invalid flag. This patch moves code after the flag is set and
prevents the device resume in an inconsistent state.

Also, it allows using of a randomized key in private wipe function
(to be used later patches).

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-crypt.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 1b16d34bb785..c6d41a7e89c9 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2158,6 +2158,14 @@ static int crypt_wipe_key(struct crypt_config *cc)
 
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 	get_random_bytes(&cc->key, cc->key_size);
+
+	/* Wipe IV private keys */
+	if (cc->iv_gen_ops && cc->iv_gen_ops->wipe) {
+		r = cc->iv_gen_ops->wipe(cc);
+		if (r)
+			return r;
+	}
+
 	kzfree(cc->key_string);
 	cc->key_string = NULL;
 	r = crypt_setkey(cc);
@@ -3050,14 +3058,8 @@ static int crypt_message(struct dm_target *ti, unsigned argc, char **argv,
 				memset(cc->key, 0, cc->key_size * sizeof(u8));
 			return ret;
 		}
-		if (argc == 2 && !strcasecmp(argv[1], "wipe")) {
-			if (cc->iv_gen_ops && cc->iv_gen_ops->wipe) {
-				ret = cc->iv_gen_ops->wipe(cc);
-				if (ret)
-					return ret;
-			}
+		if (argc == 2 && !strcasecmp(argv[1], "wipe"))
 			return crypt_wipe_key(cc);
-		}
 	}
 
 error:
-- 
2.20.1
