From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] dm-crypt: Fix benbi IV constructor if used in authenticated mode
Date: Mon,  6 Jan 2020 10:11:47 +0100
Message-ID: <20200106091147.1485292-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Milan Broz <gmazyland@gmail.com>, stable@vger.kernel.org
List-Id: dm-devel.ids

If benbi IV is used in AEAD constructionm for example
  cryptsetup luksFormat <device> --cipher twofish-xts-benbi --key-size 512 --integrity=hmac-sha256
the constructor ues wrong skcipher function and crashes.

 BUG: kernel NULL pointer dereference, address: 00000014
 ...
 EIP: crypt_iv_benbi_ctr+0x15/0x70 [dm_crypt]
 Call Trace:
  ? crypt_subkey_size+0x20/0x20 [dm_crypt]
  crypt_ctr+0x567/0xfc0 [dm_crypt]
  dm_table_add_target+0x15f/0x340 [dm_mod]

This patch fixes the problem with properly using crypt_aead_blocksize() in this case.

Reported in https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=941051

Signed-off-by: Milan Broz <gmazyland@gmail.com>
Cc: <stable@vger.kernel.org> # v4.12+
---
 drivers/md/dm-crypt.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index f9370a1a574b..fd30143dca91 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -343,8 +343,14 @@ static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *iv,
 static int crypt_iv_benbi_ctr(struct crypt_config *cc, struct dm_target *ti,
 			      const char *opts)
 {
-	unsigned bs = crypto_skcipher_blocksize(any_tfm(cc));
-	int log = ilog2(bs);
+	unsigned bs;
+	int log;
+
+	if (test_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags))
+		bs = crypto_aead_blocksize(any_tfm_aead(cc));
+	else
+		bs = crypto_skcipher_blocksize(any_tfm(cc));
+	log = ilog2(bs);
 
 	/* we need to calculate how far we must shift the sector count
 	 * to get the cipher block count, we use this shift in _gen */
-- 
2.25.0.rc1
