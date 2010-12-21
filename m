From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 3/7] dm crypt: set key size early
Date: Tue, 21 Dec 2010 16:28:15 +0100
Message-ID: <35a68fc8c918e6b99f06dc9fbe6a17c21e778389.1292944625.git.mbroz@redhat.com>
References: <cover.1292944625.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1292944625.git.mbroz@redhat.com>
In-Reply-To: <cover.1292944625.git.mbroz@redhat.com>
References: <cover.1292944625.git.mbroz@redhat.com>
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
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Simplify key size verification (hexa string) and
set key size early in constructor.

(The "-" string means no key - this is just
for compatibility reasons. Because of shift it properly
decodes to zero key size.)

(Patch required by later changes.)

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-crypt.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index dbed83d..5c04196 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1090,15 +1090,13 @@ static int crypt_setkey_allcpus(struct crypt_config *cc)
 
 static int crypt_set_key(struct crypt_config *cc, char *key)
 {
-	unsigned key_size = strlen(key) >> 1;
-
-	if (cc->key_size && cc->key_size != key_size)
+	if (cc->key_size != (strlen(key) >> 1))
 		return -EINVAL;
 
-	cc->key_size = key_size; /* initial settings */
+	if (!cc->key_size && strcmp(key, "-"))
+		return -EINVAL;
 
-	if ((!key_size && strcmp(key, "-")) ||
-	   (key_size && crypt_decode_key(cc->key, key, key_size) < 0))
+	if (cc->key_size && crypt_decode_key(cc->key, key, cc->key_size) < 0)
 		return -EINVAL;
 
 	set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
@@ -1333,6 +1331,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		ti->error = "Cannot allocate encryption context";
 		return -ENOMEM;
 	}
+	cc->key_size = key_size;
 
 	ti->private = cc;
 	ret = crypt_ctr_cipher(ti, argv[0], argv[1]);
-- 
1.7.2.3
