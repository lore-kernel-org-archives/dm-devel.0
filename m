From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH] dm verity: fix no salt used use case
Date: Thu, 18 May 2017 13:47:25 +0300
Message-ID: <1495104445-29753-1-git-send-email-gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
Cc: Marian Csontos <mcsontos@redhat.com>, Milan Broz <gmazyland@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

DM-Verity has an (undocumented) mode where no salt is used.
This was never handled directly by the DM-Verity code, instead working due
to the fact that calling crypto_shash_update() with a zero length data is
an implicit noop.

This is no longer the case now that we have switched to
crypto_ahash_update(). Fix the issue by introducing an explicit handling
of the no salt use case to DM-Verity.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reported-by: Marian Csontos <mcsontos@redhat.com>
Fixes: d1ac3ff ("dm verity: switch to using asynchronous hash crypto API")
CC: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-verity-target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 97de961..1ec9b2c 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -166,7 +166,7 @@ static int verity_hash_init(struct dm_verity *v, struct ahash_request *req,
 		return r;
 	}
 
-	if (likely(v->version >= 1))
+	if (likely(v->salt_size && (v->version >= 1)))
 		r = verity_hash_update(v, req, v->salt, v->salt_size, res);
 
 	return r;
@@ -177,7 +177,7 @@ static int verity_hash_final(struct dm_verity *v, struct ahash_request *req,
 {
 	int r;
 
-	if (unlikely(!v->version)) {
+	if (unlikely(v->salt_size && (!v->version))) {
 		r = verity_hash_update(v, req, v->salt, v->salt_size, res);
 
 		if (r < 0) {
-- 
2.1.4
