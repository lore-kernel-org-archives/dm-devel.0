From: Jeffy Chen <jeffy.chen@rock-chips.com>
Subject: [PATCH] dm-crypt: Fix memory leak in crypt_ctr_cipher_old()
Date: Wed, 27 Sep 2017 20:28:57 +0800
Message-ID: <20170927122857.19227-1-jeffy.chen@rock-chips.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Jeffy Chen <jeffy.chen@rock-chips.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
List-Id: dm-devel.ids

Fix memory leak of cipher_api.

Fixes: 33d2f09fcb35 (dm crypt: introduce new format of cipher with "capi:" prefix)
Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
---

 drivers/md/dm-crypt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a55ffd4f5933..04be8ce1742e 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2467,6 +2467,7 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
 		return ret;
 	}
 
+	kfree(cipher_api);
 	return 0;
 bad_mem:
 	ti->error = "Cannot allocate cipher strings";
-- 
2.11.0


