From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] dm-integrity: Fail early if required HMAC key is
	not available.
Date: Tue, 13 Feb 2018 14:50:50 +0100
Message-ID: <20180213135050.21039-1-gmazyland@gmail.com>
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

With crypto API
  commit 9fa68f620041be04720d0cbfb1bd3ddfc6310b24
  crypto: hash - prevent using keyed hashes without setting key

dm-integrity cannot use keyed algorithms without setting key.

The dm-integrity recognizes this too late (during use of HMAC),
so it allows creation and formatting of superblock, but the device
is in fact unusable.

Fix it by detecting key requirement in integrity table constructor.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-integrity.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 46d7c8749222..6c81b11d0521 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2548,6 +2548,9 @@ static int get_mac(struct crypto_shash **hash, struct alg_spec *a, char **error,
 				*error = error_key;
 				return r;
 			}
+		} else if (crypto_shash_get_flags(*hash) & CRYPTO_TFM_NEED_KEY) {
+			*error = error_key;
+			return -ENOKEY;
 		}
 	}
 
-- 
2.16.1
