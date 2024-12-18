Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656A71AA1D1
	for <dm-devel@lists.linux.dev>; Wed, 18 Dec 2024 12:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734526652; cv=none; b=lOdtzrow1wPJAMA/AAn3KGKiW6u+aQAstY3Ao5XdWo0/jhWtM5HBwXio4PckMN8olHWe/rEMhczv/6WXPo0crSOdSyh7COG+VXWrVWwAXH8IoVPX6mEkIGcdIeoh81P2625Batf813+NIXyEq0H6KJwDLpxUJuMljEWabQHhMmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734526652; c=relaxed/simple;
	bh=dpwVm52km41SHecITSys5pQpDL52BRnmNBIKWoKvEVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/i1H2j71HZFyghVU5BCdfiQX0/POt9PGGysliVyywAiljCxgvg06/wWe0wkCYafUb3f2E4Hr5WGq49VTB/shXlqnAbcvwhQ5SsgNKoWt9u0SCKC/Zxfm6pF1Oe4bNU/7dhpAgp95HAAMkjqDnqhA+BfwDUYJmlhn23Ty6ZP/e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F/Mtl9jI; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F/Mtl9jI"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aa6c0d1833eso1151648666b.1
        for <dm-devel@lists.linux.dev>; Wed, 18 Dec 2024 04:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734526649; x=1735131449; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FOxK+btZDYuB+m3Y/BcsT4E8aBM3APrwUNkgX6eOIzM=;
        b=F/Mtl9jIXznoUtr4hhQKiWosD8t8Sq068Vcib/E2R6IqAEnX1cOVOg998QwcOgRFb8
         BnV355yKxERa0zazJBJDqV8JYGAs4djTqi34wEC/RCM428J2YMmlsA1PPkJICwyh0KML
         TDMg+EDwzaC3P4ramyNcv49ZPK0SsGUAKjHUoTQyJermkFLEldjr7dav0dkmxZ7SMkU+
         tLbO/zHAQycrlsN5cXMRsEcA7XBJEkqtc7nMGTaxFmq9c21tyAKX5iysuiN6ZM718CCS
         Dq4z12V76SKMfz902tupTZ7tlYseFZtSP9FiuMJibP/tAK3I9Pe5ZgJM8pMm/pNITsA3
         B2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734526649; x=1735131449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FOxK+btZDYuB+m3Y/BcsT4E8aBM3APrwUNkgX6eOIzM=;
        b=JrvEF3FSCrXgIfOjvRHMeLgpyBszXuFWj7Pc9WmHgX8T0kMPu0/9tBsuhqR6pYr46T
         MwauZu0lSUlDAeehlz/y2gdZ22yxoL5tqcEhyEbXG96uaj+IG967czVaD/Ui8KQrsOXY
         zRCdq+rrobsbvoqXzIxbwznWNaeuZlG3UjQti+wWnJZ2ldSz/PVR7tz8w0laBXKGgX3q
         z0uQW6/23yfuxvPDPtPa/ngn+4jHCLaVp0new04OrmL++rdsYkQeLQKqiTbeuCZJAB29
         AOupHLrQ754jJ5A6UvG5NawqG0P0vH+zZWsxbFiSM47IOHZCAJ4/+KilbyMsZFEbBIFh
         xN8Q==
X-Gm-Message-State: AOJu0YwR2WncVlBvuy2biZ1EP/GAZL692IkW1CQJmUOMp5A1kBrp90yQ
	yRgdPabyewPy21zCfhrnvUSpJPqBcP2cO20JQi4wrJBxPLvLaLWbeKvp0A==
X-Gm-Gg: ASbGncv6HCaNOTCbj9bQ7YNG6MRhHw6qxGqbFZjyJButYIRAX1d4Ex5zsuHdrYfSSYK
	RZtXZMuIe7uUJmwuSGQIA5WL4AlRhOqjzFCi3SxG9RcwZWlwH/+4T1YQok9J/QlYELGci7g5bxh
	lq+VU5RBykE6D8ICzAjUWAFu1cQQyFslww5Q2R1jFXTlQ27CpNxkGI1tBpjT+6KCeJEUORxJXNs
	20+WqfCv0gg5Afmc5sKpne9qPLHv0c6YLx2lbP2/rvkEFwYtiPE+/Mg0366dUI=
X-Google-Smtp-Source: AGHT+IGjwB+KGaz9IxPiPoUO4BRYEVgKODcuoLUHzuVxFxj6tbHcXYJgE0gFmUExylPTg29ml9dQmg==
X-Received: by 2002:a17:907:9507:b0:aa6:707a:af59 with SMTP id a640c23a62f3a-aabf4911484mr200259766b.50.1734526648438;
        Wed, 18 Dec 2024 04:57:28 -0800 (PST)
Received: from syrah.fi.muni.cz ([2001:718:801:22c:1369:c402:50e6:7236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aab963598c2sm555116966b.96.2024.12.18.04.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2024 04:57:28 -0800 (PST)
From: Milan Broz <gmazyland@gmail.com>
To: dm-devel@lists.linux.dev
Cc: snitzer@kernel.org,
	mpatocka@redhat.com,
	samitolvanen@google.com,
	jaegeuk@google.com,
	Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 2/2] dm-verity FEC: Avoid copying RS parity bytes twice.
Date: Wed, 18 Dec 2024 13:56:59 +0100
Message-ID: <20241218125659.743433-2-gmazyland@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241218125659.743433-1-gmazyland@gmail.com>
References: <20241218125659.743433-1-gmazyland@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Caching RS parity bytes is already done in fec_decode_bufs() now,
no need to use yet another buffer for conversion to uint16_t.

This patch removes that double copy of RS parity bytes.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-verity-fec.c | 31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 6bd9848518d4..e61855da6461 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -39,22 +39,6 @@ static inline u64 fec_interleave(struct dm_verity *v, u64 offset)
 	return offset + mod * (v->fec->rounds << v->data_dev_block_bits);
 }
 
-/*
- * Decode an RS block using Reed-Solomon.
- */
-static int fec_decode_rs8(struct dm_verity *v, struct dm_verity_fec_io *fio,
-			  u8 *data, u8 *fec, int neras)
-{
-	int i;
-	uint16_t par[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN];
-
-	for (i = 0; i < v->fec->roots; i++)
-		par[i] = fec[i];
-
-	return decode_rs8(fio->rs, data, par, v->fec->rsn, NULL, neras,
-			  fio->erasures, 0, NULL);
-}
-
 /*
  * Read error-correcting codes for the requested RS block. Returns a pointer
  * to the data block. Caller is responsible for releasing buf.
@@ -132,8 +116,9 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 {
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
-	unsigned int n, i, offset, par_buf_offset = 0;
-	u8 *par, *block, par_buf[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN];
+	unsigned int n, i, j, offset, par_buf_offset = 0;
+	uint16_t par_buf[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN];
+	u8 *par, *block;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	par = fec_read_parity(v, rsb, block_offset, &offset,
@@ -147,8 +132,11 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	 */
 	fec_for_each_buffer_rs_block(fio, n, i) {
 		block = fec_buffer_rs_block(v, fio, n, i);
-		memcpy(&par_buf[par_buf_offset], &par[offset], v->fec->roots - par_buf_offset);
-		res = fec_decode_rs8(v, fio, block, par_buf, neras);
+		for (j = 0; j < v->fec->roots - par_buf_offset; j++)
+			par_buf[par_buf_offset + j] = par[offset + j];
+		/* Decode an RS block using Reed-Solomon */
+		res = decode_rs8(fio->rs, block, par_buf, v->fec->rsn,
+				 NULL, neras, fio->erasures, 0, NULL);
 		if (res < 0) {
 			r = res;
 			goto error;
@@ -166,7 +154,8 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 		/* Check if parity bytes are split between blocks */
 		if (offset < v->fec->io_size && (offset + v->fec->roots) > v->fec->io_size) {
 			par_buf_offset = v->fec->io_size - offset;
-			memcpy(par_buf, &par[offset], par_buf_offset);
+			for (j = 0; j < par_buf_offset; j++)
+				par_buf[j] = par[offset + j];
 			offset += par_buf_offset;
 		} else
 			par_buf_offset = 0;
-- 
2.45.2

