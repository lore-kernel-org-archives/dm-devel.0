Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315963AD50F;
	Wed, 29 Jul 2026 05:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785302504; cv=none; b=KTeZUEO9FfCnLrEFgniVRWGFGdXix4ypqb8BmhlP2ru0+oirVMNc0AodPh7ZMwh/wwSkUnuklRhhdb93qgMb5l4/03iThOUXVZSoPmazL+TkGPz6zrAHZWV/uKKRj9Ewrbt+Sd9GlYsAoookN7+fTudL3PqOuG/M3l/ofA1EMRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785302504; c=relaxed/simple;
	bh=KHltdLZzca2MS+qzleUldbAet8U0oie++G8O+z+ddvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2+YaSn4CEQ2fzUCNcB84eVTJ1m2sC+PLKK4msPV5dcFO4lQXruVVzHzcumpN0kTUSxJ02JJlAufvBYhYjuYyi5VjNVJwJ5iJQfyko0EEOf5BwCqmbXckRCNbAbQyyZujzXia8L5NhZpO/DEks4PSv1D8MZnVbmOoLS0XfLc1jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUY66haz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUY66haz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C391F00A3F;
	Wed, 29 Jul 2026 05:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785302502;
	bh=Ugzl1Kpp6sTmEbzkf9pYZyQBabChQKwh3yAmOiKxtF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUY66hazsrzMBbjvoOzBWyONxl4aqDEV/dwFlJz9Ux93Mb8wFXnxpUvvJcoZWN+gP
	 OWDULYxCmiiAvk55agYMrH8rmClFKK9pNF1AzJl2+62RiCAc94AzLQjrFwOaFhyhHL
	 BsF9ILKJczSOjuetu+FuWWtLMRHZICUghuEtLdcf7TYYaW7aYoMiHqYAOrnLfR8pwY
	 RyY/ViFmbFWLLVq5JRX9i4pYhxHnoo82f+cUkNyca5u2XOrpLI3oocrhOSllym/db5
	 pfUUl04UOm3Wkj5k7ZE+W75CwlhKWgxa1J1kyDJ3YNSJ0U5CKOF5KcS4XJjJvS3wYY
	 lLg6WVQFzkIBQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: dm-devel@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 3/4] dm-verity-fec: replace {MAX,MIN}_RSN with {MIN,MAX}_ROOTS
Date: Tue, 28 Jul 2026 22:19:08 -0700
Message-ID: <20260729051909.62106-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729051909.62106-1-ebiggers@kernel.org>
References: <20260729051909.62106-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 82fbd6a3e29a329d439690cd7ccc4162c9cd8db6 upstream.

Every time DM_VERITY_FEC_{MAX,MIN}_RSN are used, they are subtracted
from DM_VERITY_FEC_RSM to get the bounds on the number of roots.
Therefore, replace these with {MIN,MAX}_ROOTS constants which are more
directly useful.  (Note the inversion, where MAX_RSN maps to MIN_ROOTS
and MIN_RSN maps to MAX_ROOTS.)  No functional change.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-verity-fec.c | 6 +++---
 drivers/md/dm-verity-fec.h | 7 +++----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index a8fbf97b97517..cebcc8fd25d70 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -87,7 +87,7 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
 	unsigned int n, i, j, parity_pos, to_copy;
-	uint16_t par_buf[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN];
+	uint16_t par_buf[DM_VERITY_FEC_MAX_ROOTS];
 	u8 *par, *block;
 	u64 parity_block;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
@@ -605,8 +605,8 @@ int verity_fec_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 
 	} else if (!strcasecmp(arg_name, DM_VERITY_OPT_FEC_ROOTS)) {
 		if (sscanf(arg_value, "%hhu%c", &num_c, &dummy) != 1 || !num_c ||
-		    num_c < (DM_VERITY_FEC_RSM - DM_VERITY_FEC_MAX_RSN) ||
-		    num_c > (DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN)) {
+		    num_c < DM_VERITY_FEC_MIN_ROOTS ||
+		    num_c > DM_VERITY_FEC_MAX_ROOTS) {
 			ti->error = "Invalid " DM_VERITY_OPT_FEC_ROOTS;
 			return -EINVAL;
 		}
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 90a0af3f35d31..b3460103e0e10 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -13,8 +13,8 @@
 
 /* Reed-Solomon(M, N) parameters */
 #define DM_VERITY_FEC_RSM		255
-#define DM_VERITY_FEC_MAX_RSN		253
-#define DM_VERITY_FEC_MIN_RSN		231	/* ~10% space overhead */
+#define DM_VERITY_FEC_MIN_ROOTS	2	/* RS(255, 253): ~0.8% space overhead */
+#define DM_VERITY_FEC_MAX_ROOTS	24	/* RS(255, 231): ~10% space overhead */
 
 /* buffers for deinterleaving and decoding */
 #define DM_VERITY_FEC_BUF_PREALLOC	1	/* buffers to preallocate */
@@ -50,8 +50,7 @@ struct dm_verity_fec {
 /* per-bio data */
 struct dm_verity_fec_io {
 	struct rs_control *rs;	/* Reed-Solomon state */
-	/* erasures for decode_rs8 */
-	int erasures[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN + 1];
+	int erasures[DM_VERITY_FEC_MAX_ROOTS + 1]; /* erasures for decode_rs8 */
 	u8 *bufs[DM_VERITY_FEC_BUF_MAX];	/* bufs for deinterleaving */
 	unsigned int nbufs;		/* number of buffers allocated */
 	u8 *output;		/* buffer for corrected output */
-- 
2.55.0

