From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 1/2] md/dm-crypt - restrict EBOIV to cbc(aes)
Date: Tue,  6 Aug 2019 11:02:33 +0300
Message-ID: <20190806080234.27998-2-ard.biesheuvel@linaro.org>
References: <20190806080234.27998-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190806080234.27998-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, snitzer@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, ebiggers@kernel.org, dm-devel@redhat.com, gmazyland@gmail.com, agk@redhat.com
List-Id: dm-devel.ids

Support for the EBOIV IV mode was introduced this cycle, and is
explicitly intended for interoperability with BitLocker, which
only uses it combined with AES in CBC mode.

Using EBOIV in combination with any other skcipher or aead mode
is not recommended, and so there is no need to support this.
However, the way the EBOIV support is currently integrated permits
it to be combined with other skcipher or aead modes, and once the
cat is out of the bag, we will need to support it indefinitely.

So let's restrict EBOIV to cbc(aes), and reject attempts to
instantiate it with other modes.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/md/dm-crypt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d5216bcc4649..a5e8d5bc1581 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -861,6 +861,13 @@ static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
 	struct crypto_cipher *tfm;
 
+	if (test_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags) ||
+	    strcmp("cbc(aes)",
+	           crypto_tfm_alg_name(crypto_skcipher_tfm(any_tfm(cc))))) {
+		ti->error = "Unsupported encryption mode for EBOIV";
+		return -EINVAL;
+	}
+
 	tfm = crypto_alloc_cipher(cc->cipher, 0, 0);
 	if (IS_ERR(tfm)) {
 		ti->error = "Error allocating crypto tfm for EBOIV";
-- 
2.17.1
