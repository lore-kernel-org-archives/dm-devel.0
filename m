From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] dm verity: log the hash algorithm implementation
Date: Wed,  5 Dec 2018 20:54:13 -0800
Message-ID: <20181206045413.32531-1-ebiggers@kernel.org>
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
To: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-crypto@vger.kernel.org
List-Id: dm-devel.ids

From: Eric Biggers <ebiggers@google.com>

Log the hash algorithm's driver name when a dm-verity target is created.
This will help people determine whether the expected implementation is
being used.  It can make an enormous difference; e.g., SHA-256 on ARM
can be 8x faster with the crypto extensions than without.  It can also
be useful to know if an implementation using an external crypto
accelerator is being used instead of a software implementation.

Example message:

[   35.281945] device-mapper: verity: sha256 using implementation "sha256-ce"

We've already found the similar message in fs/crypto/keyinfo.c to be
very useful.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-target.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index fc65f0dedf7f..f4c31ffaa88e 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1040,6 +1040,15 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		v->tfm = NULL;
 		goto bad;
 	}
+
+	/*
+	 * dm-verity performance can vary greatly depending on which hash
+	 * algorithm implementation is used.  Help people debug performance
+	 * problems by logging the ->cra_driver_name.
+	 */
+	DMINFO("%s using implementation \"%s\"", v->alg_name,
+	       crypto_hash_alg_common(v->tfm)->base.cra_driver_name);
+
 	v->digest_size = crypto_ahash_digestsize(v->tfm);
 	if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
 		ti->error = "Digest size too big";
-- 
2.19.2
