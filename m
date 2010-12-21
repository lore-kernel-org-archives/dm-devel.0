From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 4/7] dm crypt: remove unused compatible table
	output
Date: Tue, 21 Dec 2010 16:28:16 +0100
Message-ID: <6d942218774967849021d96a0d4cd4174a4163ac.1292944625.git.mbroz@redhat.com>
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

cc->cipher_mode is always set in constructor

dm-crypt still can use compatible mode without IV
or blockmode set but it is already internaly converted
to "cbc-plain" so we can remove unused table output.

(Also simplify tfm variable which will be removed later.)

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-crypt.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 5c04196..863e412 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1241,7 +1241,6 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 		}
 		per_cpu_ptr(cc->cpu, cpu)->tfm = tfm;
  	}
-	tfm = any_tfm(cc);
 
 	/* Initialize and set key */
 	ret = crypt_set_key(cc, key);
@@ -1251,7 +1250,7 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	}
 
 	/* Initialize IV */
-	cc->iv_size = crypto_ablkcipher_ivsize(tfm);
+	cc->iv_size = crypto_ablkcipher_ivsize(any_tfm(cc));
 	if (cc->iv_size)
 		/* at least a 64 bit sector number should fit in our buffer */
 		cc->iv_size = max(cc->iv_size,
@@ -1451,10 +1450,7 @@ static int crypt_status(struct dm_target *ti, status_type_t type,
 		break;
 
 	case STATUSTYPE_TABLE:
-		if (cc->cipher_mode)
-			DMEMIT("%s-%s ", cc->cipher, cc->cipher_mode);
-		else
-			DMEMIT("%s ", cc->cipher);
+		DMEMIT("%s-%s ", cc->cipher, cc->cipher_mode);
 
 		if (cc->key_size > 0) {
 			if ((maxlen - sz) < ((cc->key_size << 1) + 1))
-- 
1.7.2.3
