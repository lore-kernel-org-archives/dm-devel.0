From: Aiden Leong <aiden.leong@aibsd.com>
Subject: [RFC] Reed-Solomon Code: Update no_eras to the actual number of errors
Date: Wed, 24 Jun 2020 21:10:53 -0700
Message-ID: <20200625041141.8053-1-aiden.leong@aibsd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Thomas Gleixner <tglx@linutronix.de>, Ferdinand Blomqvist <ferdinand.blomqvist@gmail.com>, YueHaibing <yuehaibing@huawei.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Kees Cook <keescook@chromium.org>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-Id: dm-devel.ids

Corr and eras_pos are updated to actual correction pattern and erasure
positions, but no_eras is not.

When this library is used to recover lost bytes, we normally memset the
lost trunk of bytes to zero as a placeholder. Unfortunately, if the lost
byte is zero, b[i] is zero too. Without correct no_eras, users won't be
able to determine the valid length of corr and eras_pos.

Signed-off-by: Aiden Leong <aiden.leong@aibsd.com>
---
 drivers/md/dm-verity-fec.c      |  2 +-
 fs/pstore/ram_core.c            |  2 +-
 include/linux/rslib.h           |  4 ++--
 lib/reed_solomon/decode_rs.c    | 20 ++++++++++++++------
 lib/reed_solomon/reed_solomon.c |  4 ++--
 lib/reed_solomon/test_rslib.c   | 18 ++++++++++++------
 6 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index fb41b4f23c48..ae8366a50244 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -50,7 +50,7 @@ static int fec_decode_rs8(struct dm_verity *v, struct dm_verity_fec_io *fio,
 	for (i = 0; i < v->fec->roots; i++)
 		par[i] = fec[i];
 
-	return decode_rs8(fio->rs, data, par, v->fec->rsn, NULL, neras,
+	return decode_rs8(fio->rs, data, par, v->fec->rsn, NULL, &neras,
 			  fio->erasures, 0, NULL);
 }
 
diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index aa8e0b65ff1a..fcc661a60640 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -115,7 +115,7 @@ static int persistent_ram_decode_rs8(struct persistent_ram_zone *prz,
 
 	for (i = 0; i < prz->ecc_info.ecc_size; i++)
 		prz->ecc_info.par[i] = ecc[i];
-	return decode_rs8(prz->rs_decoder, data, prz->ecc_info.par, len,
+	return decode_rs8(prz->rs_decoder, data, prz->ecc_info.par, &len,
 				NULL, 0, NULL, 0, NULL);
 }
 
diff --git a/include/linux/rslib.h b/include/linux/rslib.h
index 238bb85243d3..80662abc9af7 100644
--- a/include/linux/rslib.h
+++ b/include/linux/rslib.h
@@ -64,7 +64,7 @@ int encode_rs8(struct rs_control *rs, uint8_t *data, int len, uint16_t *par,
 #endif
 #ifdef CONFIG_REED_SOLOMON_DEC8
 int decode_rs8(struct rs_control *rs, uint8_t *data, uint16_t *par, int len,
-		uint16_t *s, int no_eras, int *eras_pos, uint16_t invmsk,
+		uint16_t *s, int *no_eras, int *eras_pos, uint16_t invmsk,
 	       uint16_t *corr);
 #endif
 
@@ -75,7 +75,7 @@ int encode_rs16(struct rs_control *rs, uint16_t *data, int len, uint16_t *par,
 #endif
 #ifdef CONFIG_REED_SOLOMON_DEC16
 int decode_rs16(struct rs_control *rs, uint16_t *data, uint16_t *par, int len,
-		uint16_t *s, int no_eras, int *eras_pos, uint16_t invmsk,
+		uint16_t *s, int *no_eras, int *eras_pos, uint16_t invmsk,
 		uint16_t *corr);
 #endif
 
diff --git a/lib/reed_solomon/decode_rs.c b/lib/reed_solomon/decode_rs.c
index 805de84ae83d..122bc08eb75f 100644
--- a/lib/reed_solomon/decode_rs.c
+++ b/lib/reed_solomon/decode_rs.c
@@ -24,6 +24,7 @@
 	int count = 0;
 	int num_corrected;
 	uint16_t msk = (uint16_t) rs->nn;
+	int no_eras_orig = no_eras ? *no_eras : 0;
 
 	/*
 	 * The decoder buffers are in the rs control struct. They are
@@ -106,11 +107,11 @@
 	memset(&lambda[1], 0, nroots * sizeof(lambda[0]));
 	lambda[0] = 1;
 
-	if (no_eras > 0) {
+	if (no_eras_orig > 0) {
 		/* Init lambda to be the erasure locator polynomial */
 		lambda[1] = alpha_to[rs_modnn(rs,
 					prim * (nn - 1 - (eras_pos[0] + pad)))];
-		for (i = 1; i < no_eras; i++) {
+		for (i = 1; i < no_eras_orig; i++) {
 			u = rs_modnn(rs, prim * (nn - 1 - (eras_pos[i] + pad)));
 			for (j = i + 1; j > 0; j--) {
 				tmp = index_of[lambda[j - 1]];
@@ -129,8 +130,8 @@
 	 * Begin Berlekamp-Massey algorithm to determine error+erasure
 	 * locator polynomial
 	 */
-	r = no_eras;
-	el = no_eras;
+	r = no_eras_orig;
+	el = no_eras_orig;
 	while (++r <= nroots) {	/* r is the step number */
 		/* Compute discrepancy at the r-th step in poly-form */
 		discr_r = 0;
@@ -158,8 +159,8 @@
 				} else
 					t[i + 1] = lambda[i + 1];
 			}
-			if (2 * el <= r + no_eras - 1) {
-				el = r + no_eras - el;
+			if (2 * el <= r + no_eras_orig - 1) {
+				el = r + no_eras_orig - el;
 				/*
 				 * 2 lines below: B(x) <-- inv(discr_r) *
 				 * lambda(x)
@@ -312,14 +313,21 @@
 				eras_pos[j++] = loc[i] - pad;
 			}
 		}
+		if (no_eras > 0)
+			*no_eras = j;
 	} else if (data && par) {
 		/* Apply error to data and parity */
+		j = 0;
 		for (i = 0; i < count; i++) {
 			if (loc[i] < (nn - nroots))
 				data[loc[i] - pad] ^= b[i];
 			else
 				par[loc[i] - pad - len] ^= b[i];
+			if (b[i])
+				j++;
 		}
+		if (no_eras > 0)
+			*no_eras = j;
 	}
 
 	return  num_corrected;
diff --git a/lib/reed_solomon/reed_solomon.c b/lib/reed_solomon/reed_solomon.c
index bbc01bad3053..b2c811674c98 100644
--- a/lib/reed_solomon/reed_solomon.c
+++ b/lib/reed_solomon/reed_solomon.c
@@ -359,7 +359,7 @@ EXPORT_SYMBOL_GPL(encode_rs8);
  *  errors. The count includes errors in the parity.
  */
 int decode_rs8(struct rs_control *rsc, uint8_t *data, uint16_t *par, int len,
-	       uint16_t *s, int no_eras, int *eras_pos, uint16_t invmsk,
+	       uint16_t *s, int *no_eras, int *eras_pos, uint16_t invmsk,
 	       uint16_t *corr)
 {
 #include "decode_rs.c"
@@ -410,7 +410,7 @@ EXPORT_SYMBOL_GPL(encode_rs16);
  *  errors. The count includes errors in the parity.
  */
 int decode_rs16(struct rs_control *rsc, uint16_t *data, uint16_t *par, int len,
-		uint16_t *s, int no_eras, int *eras_pos, uint16_t invmsk,
+		uint16_t *s, int *no_eras, int *eras_pos, uint16_t invmsk,
 		uint16_t *corr)
 {
 #include "decode_rs.c"
diff --git a/lib/reed_solomon/test_rslib.c b/lib/reed_solomon/test_rslib.c
index 4eb29f365ece..b30a4aea8796 100644
--- a/lib/reed_solomon/test_rslib.c
+++ b/lib/reed_solomon/test_rslib.c
@@ -258,7 +258,7 @@ static void compute_syndrome(struct rs_control *rsc, uint16_t *data,
 
 /* Test up to error correction capacity */
 static void test_uc(struct rs_control *rs, int len, int errs,
-		int eras, int trials, struct estat *stat,
+		int *eras, int trials, struct estat *stat,
 		struct wspace *ws, int method)
 {
 	int dlen = len - rs->codec->nroots;
@@ -327,8 +327,11 @@ static int ex_rs_helper(struct rs_control *rs, struct wspace *ws,
 		pr_info("  %s\n", desc[method]);
 
 	for (errs = 0; errs <= nroots / 2; errs++)
-		for (eras = 0; eras <= nroots - 2 * errs; eras++)
-			test_uc(rs, len, errs, eras, trials, &stat, ws, method);
+		for (eras = 0; eras <= nroots - 2 * errs; eras++) {
+			int no_eras = ers;
+
+			test_uc(rs, len, errs, &no_eras, trials, &stat, ws, method);
+		}
 
 	if (v >= V_CSUMMARY) {
 		pr_info("    Decodes wrong:        %d / %d\n",
@@ -364,7 +367,7 @@ static int exercise_rs(struct rs_control *rs, struct wspace *ws,
 
 /* Tests for correct behaviour beyond error correction capacity */
 static void test_bc(struct rs_control *rs, int len, int errs,
-		int eras, int trials, struct bcstat *stat,
+		int *eras, int trials, struct bcstat *stat,
 		struct wspace *ws)
 {
 	int nroots = rs->codec->nroots;
@@ -420,8 +423,11 @@ static int exercise_rs_bc(struct rs_control *rs, struct wspace *ws,
 			eras = 0;
 
 		cutoff = nroots <= len - errs ? nroots : len - errs;
-		for (; eras <= cutoff; eras++)
-			test_bc(rs, len, errs, eras, trials, &stat, ws);
+		for (; eras <= cutoff; eras++) {
+			int no_eras = eras;
+
+			test_bc(rs, len, errs, &no_eras, trials, &stat, ws);
+		}
 	}
 
 	if (v >= V_CSUMMARY) {
-- 
2.25.1
