From: Ondrej Kozina <okozina@redhat.com>
Subject: [PATCH] dm-crypt: rewrite (wipe) key in crypto layer by
	random data
Date: Mon, 24 Apr 2017 14:21:53 +0200
Message-ID: <1493036513-5906-1-git-send-email-okozina@redhat.com>
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
Cc: Ondrej Kozina <okozina@redhat.com>, mpatocka@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

message "key wipe" used to wipe real key stored in crypto layer by rewriting it
with zeroes. This no longer works in FIPS mode for xts. With commit 28856a9
while running in FIPS mode the crypto key part has to differ from tweak one.

Signed-off-by: Ondrej Kozina <okozina@redhat.com>
---
 drivers/md/dm-crypt.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 389a363..b8f3d77 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1649,12 +1649,16 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 
 static int crypt_wipe_key(struct crypt_config *cc)
 {
+	int r;
+
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
-	memset(&cc->key, 0, cc->key_size * sizeof(u8));
+	get_random_bytes(&cc->key, cc->key_size);
 	kzfree(cc->key_string);
 	cc->key_string = NULL;
+	r = crypt_setkey(cc);
+	memset(&cc->key, 0, cc->key_size * sizeof(u8));
 
-	return crypt_setkey(cc);
+	return r;
 }
 
 static void crypt_dtr(struct dm_target *ti)
-- 
2.7.4
