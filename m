From: Behan Webster <behanw@converseincode.com>
Subject: [PATCH] Remove VLAIS usage from dm-crypt
Date: Tue, 30 Oct 2012 14:15:56 -0400
Message-ID: <1351620956-17583-2-git-send-email-behanw@converseincode.com>
References: <1351620956-17583-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1351620956-17583-1-git-send-email-behanw@converseincode.com>
Sender: linux-raid-owner@vger.kernel.org
To: agk@redhat.com, dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>, pageexec@freemail.hu, Behan Webster <behanw@converseincode.com>
List-Id: dm-devel.ids

=46rom: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>

The use of variable length arrays in structs (VLAIS) in the Linux Kerne=
l code
precludes the use of compilers which don't implement VLAIS (for instanc=
e the
Clang compiler). This patch instead allocates the appropriate amount of=
 memory
using an char array.

Patch from series at
http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/14=
2707.html
by PaX Team.

Signed-off-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
Cc: pageexec@freemail.hu
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 drivers/md/dm-crypt.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index bbf459b..8b724ea 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -525,29 +525,29 @@ static int crypt_iv_lmk_one(struct crypt_config *=
cc, u8 *iv,
 			    u8 *data)
 {
 	struct iv_lmk_private *lmk =3D &cc->iv_gen_private.lmk;
-	struct {
-		struct shash_desc desc;
-		char ctx[crypto_shash_descsize(lmk->hash_tfm)];
-	} sdesc;
+	char sdesc[sizeof(struct shash_desc)
+		+ crypto_shash_descsize(lmk->hash_tfm)
+		+ CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *desc =3D (struct shash_desc *)sdesc;
 	struct md5_state md5state;
 	u32 buf[4];
 	int i, r;
=20
-	sdesc.desc.tfm =3D lmk->hash_tfm;
-	sdesc.desc.flags =3D CRYPTO_TFM_REQ_MAY_SLEEP;
+	desc->tfm =3D lmk->hash_tfm;
+	desc->flags =3D CRYPTO_TFM_REQ_MAY_SLEEP;
=20
-	r =3D crypto_shash_init(&sdesc.desc);
+	r =3D crypto_shash_init(desc);
 	if (r)
 		return r;
=20
 	if (lmk->seed) {
-		r =3D crypto_shash_update(&sdesc.desc, lmk->seed, LMK_SEED_SIZE);
+		r =3D crypto_shash_update(desc, lmk->seed, LMK_SEED_SIZE);
 		if (r)
 			return r;
 	}
=20
 	/* Sector is always 512B, block size 16, add data of blocks 1-31 */
-	r =3D crypto_shash_update(&sdesc.desc, data + 16, 16 * 31);
+	r =3D crypto_shash_update(desc, data + 16, 16 * 31);
 	if (r)
 		return r;
=20
@@ -556,12 +556,12 @@ static int crypt_iv_lmk_one(struct crypt_config *=
cc, u8 *iv,
 	buf[1] =3D cpu_to_le32((((u64)dmreq->iv_sector >> 32) & 0x00FFFFFF) |=
 0x80000000);
 	buf[2] =3D cpu_to_le32(4024);
 	buf[3] =3D 0;
-	r =3D crypto_shash_update(&sdesc.desc, (u8 *)buf, sizeof(buf));
+	r =3D crypto_shash_update(desc, (u8 *)buf, sizeof(buf));
 	if (r)
 		return r;
=20
 	/* No MD5 padding here */
-	r =3D crypto_shash_export(&sdesc.desc, &md5state);
+	r =3D crypto_shash_export(desc, &md5state);
 	if (r)
 		return r;
=20
--=20
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
