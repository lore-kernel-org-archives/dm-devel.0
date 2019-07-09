From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v2 2/3] dm-crypt: Remove obsolete comment about
	plumb IV.
Date: Tue,  9 Jul 2019 15:22:13 +0200
Message-ID: <20190709132214.3905-2-gmazyland@gmail.com>
References: <20190709132214.3905-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190709132214.3905-1-gmazyland@gmail.com>
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

The URL is no longer valid and the comment is obsolete anyway
(the plumb IV was never used).

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-crypt.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 0e24079e97da..c567e13a0e5f 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -290,9 +290,6 @@ static struct crypto_aead *any_tfm_aead(struct crypt_config *cc)
  *       is calculated from initial key, sector number and mixed using CRC32.
  *       Note that this encryption scheme is vulnerable to watermarking attacks
  *       and should be used for old compatible containers access only.
- *
- * plumb: unimplemented, see:
- * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
  */
 
 static int crypt_iv_plain_gen(struct crypt_config *cc, u8 *iv,
-- 
2.20.1
