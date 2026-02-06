Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6410E33C50D;
	Fri,  6 Feb 2026 05:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354117; cv=none; b=bX07x47IakNv/z8/IoGS+TK0X3xPztsr/q+XL/rugIYRobqqLXBeSCi2RHcypgVCxsljYB6BB2LDMX9+ILcHHoNyWqd+iCKyDtL6eOAxPOBdXuZ4kbmAOSnb0Y4HGD4isI+ocXGqXa9JwEGyyKl3AM3ipS/wPzpsrau+3JF3+BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354117; c=relaxed/simple;
	bh=rf4dX9huoPWX3DYxIAsVDveY0+x+aP1dl4Xg7gjew8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArsRf+gSXHz48HoeO5kVHY4phE17ZGxFa1iik8Y3eA9BNVXJHMw19/GFXgM/TcDPRXIJOlEri/+jlV5ahP9z9nGkjU92N6x8/svgQAwhz80PmoLL179QROfKeE5zNU+AXsA8q8UV81UkDC9znuJWJKRB9muiewc1UCPAb/wm+6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W8weZUE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8weZUE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089B7C2BCC4;
	Fri,  6 Feb 2026 05:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354117;
	bh=rf4dX9huoPWX3DYxIAsVDveY0+x+aP1dl4Xg7gjew8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8weZUE5otCaZSzYUP31ltH6Q7N7gp0altqbnpxcPM36imFuFo+uXljQ67CWttgLJ
	 DeeKXtcwn9S/KFDBYh1lhbVGc7QtGou8jlgu5qLfFz+fmsUom9+9HVVP77fH3MB7uO
	 lGn9zcGglxa1/Cdv2s2v0uUgkfKjSEnQMRiE6fN1SdU0BCBtEKJJM+f5tgrjIoVNG4
	 svt+v5u7EMKHUHsFttAiSa3LthdR35xmnCrhwyOLDjl5T05PMKiOpo/3thg0Lzx57T
	 DzPtp8+0PAg1dxeR/x0f0otaojNrWLn42uvmhXEPbExqvZRtN33SKX6jX4+EHa2kT2
	 kLUzthtm38xbg==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 08/22] dm-verity-fec: replace {MAX,MIN}_RSN with {MIN,MAX}_ROOTS
Date: Thu,  5 Feb 2026 20:59:27 -0800
Message-ID: <20260206045942.52965-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206045942.52965-1-ebiggers@kernel.org>
References: <20260206045942.52965-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every time DM_VERITY_FEC_{MAX,MIN}_RSN are used, they are subtracted
from DM_VERITY_FEC_RSM to get the bounds on the number of roots.
Therefore, replace these with {MIN,MAX}_ROOTS constants which are more
directly useful.  (Note the inversion, where MAX_RSN maps to MIN_ROOTS
and MIN_RSN maps to MAX_ROOTS.)  No functional change.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 6 +++---
 drivers/md/dm-verity-fec.h | 7 +++----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index c3f2516f9c2a9..c5f97a49e5b79 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -71,11 +71,11 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			   unsigned int block_offset, int neras)
 {
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
 	unsigned int n, i, j, parity_pos, to_copy;
-	uint16_t par_buf[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN];
+	uint16_t par_buf[DM_VERITY_FEC_MAX_ROOTS];
 	u8 *par, *block;
 	u64 parity_block;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	/*
@@ -570,12 +570,12 @@ int verity_fec_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 		}
 		v->fec->start = num_ll;
 
 	} else if (!strcasecmp(arg_name, DM_VERITY_OPT_FEC_ROOTS)) {
 		if (sscanf(arg_value, "%hhu%c", &num_c, &dummy) != 1 || !num_c ||
-		    num_c < (DM_VERITY_FEC_RSM - DM_VERITY_FEC_MAX_RSN) ||
-		    num_c > (DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN)) {
+		    num_c < DM_VERITY_FEC_MIN_ROOTS ||
+		    num_c > DM_VERITY_FEC_MAX_ROOTS) {
 			ti->error = "Invalid " DM_VERITY_OPT_FEC_ROOTS;
 			return -EINVAL;
 		}
 		v->fec->roots = num_c;
 
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 32ca2bfee1db7..d8d0e81da2701 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -11,12 +11,12 @@
 #include "dm-verity.h"
 #include <linux/rslib.h>
 
 /* Reed-Solomon(M, N) parameters */
 #define DM_VERITY_FEC_RSM		255
-#define DM_VERITY_FEC_MAX_RSN		253
-#define DM_VERITY_FEC_MIN_RSN		231	/* ~10% space overhead */
+#define DM_VERITY_FEC_MIN_ROOTS	2	/* RS(255, 253): ~0.8% space overhead */
+#define DM_VERITY_FEC_MAX_ROOTS	24	/* RS(255, 231): ~10% space overhead */
 
 /* buffers for deinterleaving and decoding */
 #define DM_VERITY_FEC_BUF_RS_BITS	4	/* 1 << RS blocks per buffer */
 
 #define DM_VERITY_OPT_FEC_DEV		"use_fec_from_device"
@@ -45,12 +45,11 @@ struct dm_verity_fec {
 };
 
 /* per-bio data */
 struct dm_verity_fec_io {
 	struct rs_control *rs;	/* Reed-Solomon state */
-	/* erasures for decode_rs8 */
-	int erasures[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN + 1];
+	int erasures[DM_VERITY_FEC_MAX_ROOTS + 1]; /* erasures for decode_rs8 */
 	u8 *output;		/* buffer for corrected output */
 	unsigned int level;		/* recursion level */
 	unsigned int nbufs;		/* number of buffers allocated */
 	/*
 	 * Buffers for deinterleaving RS blocks.  Each buffer has space for
-- 
2.52.0

