From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] dm crypt: Initialize crypto wait structures
Date: Mon, 31 Aug 2020 14:55:55 +0900
Message-ID: <20200831055555.471935-1-damien.lemoal@wdc.com>
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
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Use the DECLARE_CRYPTO_WAIT() macro to properly initialize the crypto
wait structures declared on stack before their use with
crypto_wait_req().

Fixes: 39d13a1ac41d ("dm crypt: reuse eboiv skcipher for IV generation")
Fixes: bbb1658461ac ("dm crypt: Implement Elephant diffuser for Bitlocker compatibility")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-crypt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 238cd80826a6..380386c36921 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -739,7 +739,7 @@ static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
 	u8 buf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(__le64));
 	struct skcipher_request *req;
 	struct scatterlist src, dst;
-	struct crypto_wait wait;
+	DECLARE_CRYPTO_WAIT(wait);
 	int err;
 
 	req = skcipher_request_alloc(any_tfm(cc), GFP_NOIO);
@@ -936,7 +936,7 @@ static int crypt_iv_elephant(struct crypt_config *cc, struct dm_crypt_request *d
 	u8 *es, *ks, *data, *data2, *data_offset;
 	struct skcipher_request *req;
 	struct scatterlist *sg, *sg2, src, dst;
-	struct crypto_wait wait;
+	DECLARE_CRYPTO_WAIT(wait);
 	int i, r;
 
 	req = skcipher_request_alloc(elephant->tfm, GFP_NOIO);
-- 
2.26.2
