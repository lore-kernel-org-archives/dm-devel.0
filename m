Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C484519CD01
	for <dm-devel@lists.linux.dev>; Wed, 18 Dec 2024 12:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734526651; cv=none; b=YoOMaU5UCymhH5bZFQpgG0Vb/u6pg7Ny7BYDLNJ2WV3VtWRg55uvfNv7M/bziTQ2M0Lh7CS4KmtX9tpzXw1X1IrHtY/fSfackwX400imWfAiYAe13XwMx7ezHyUrZx+APmG71EB6lYZZNOZukO9mVwxVwRVc/GuDGpGJP1yCSzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734526651; c=relaxed/simple;
	bh=z8wms88ORT9j6FOpNaVYrgGG7JWgrQzacqQ5JCsYVho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p217eC1gm8BwZXnWai/rHe9pemnJyiCD+RyAXGAGuMDs7ahWKm70/O6/CACuW3m9K/ShFOnRpctdcDsJ36KfhhAGqZRcyTC6wnmaHApPVYwc+lx+J/N2w0wogMK7ZmtFRuhCOuGFYPSxoVxRfOwL4xmPCgsbYSXFjkACna/5pmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XAYDV01Q; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XAYDV01Q"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aa6c0d1833eso1151646966b.1
        for <dm-devel@lists.linux.dev>; Wed, 18 Dec 2024 04:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734526648; x=1735131448; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rCPMR6EORe91bOxjKN4OfMPqLEjWnpVbBSIjTYcJc1w=;
        b=XAYDV01Qh29OEwGXIskbjHYsrPDP6phIzd6jwO9BTWMMzrdrnVLEockVllAAe1GR/P
         RQsqC9Y04jJf3yxyqc4WD5Rl3tuSLMxQZodw4a8hTD6aDMtIQD1YJjIlj3FEKH4+4pA0
         dkbPF6abeUCFSZPbDRP4E9S6O6BV2SwBwIXaie0hXkdlGvW3S2ioFMMwqOIwSjJ79BSn
         b6jqjBcmXB/pcq4Sx19ewP8/BrSE2rbVhgoXEpZXqetfUUsPL0Yr4s4dEQg6Ggehe1bU
         ymBFrZt2gMRNJ1L1mW3s4JVpRH3ZDMbZb2sQoylL8yq8ZxQI1MTswlCoZOC3VIYAVcxW
         6CjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734526648; x=1735131448;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rCPMR6EORe91bOxjKN4OfMPqLEjWnpVbBSIjTYcJc1w=;
        b=B0Aswt30Ft1SyLZ1E18DHlhFWYeWRvClKGDav2y2Et1mEQR4AZdtWKdgRJLiUxhPFA
         9I0y93gmIjgiFXXqqWiSy6Yz8sNNLxoi5SdgNGwRVqZs9c+WhirKm14kAiKgLhxgMTXB
         0MTojuMvUIcZDFwI5Nkb9fWcx+lZwcuEmu/6Ax9RF7xdSWoHNkRJL/rrb6aDg83lq12f
         t9kmCYmT6+iVRUpRkkX4mxt6C273ULjWXqippNvXB4aGIGKKA9ZihAHJ2LmjUYTMpUnL
         LYTgXBcbpP+Ix5zhdpClQCKvA5ZphdjaxwxIqin5lcMuLZhXo+q1JK3FaZm9OwEKKEQp
         c4DA==
X-Gm-Message-State: AOJu0YzHkWqC4ese/hgiloEiadJtpOkUqfu/jU/ZX8s5ay5U7n9KwsR+
	tfoUi0gawusnUWegNcXxCR7dfb/4c55LOEBqCKcTblabPi2tEHctQyAPbvHq
X-Gm-Gg: ASbGnctY7wNg24p0CwaM3f7MjHGX/wsQQifw7WLZQtONBHftCXNG4gSB9vPXXIfGRUo
	XEiOlZLfvIKpJ+D6xPrWBG5ozY25nuNurqclAeD6R0qwNvjdYxYn210hCpw3KJZpGtLrshQpLHi
	HyvXMQVhmkO/aXx8jQCPTaWo3edAZNOoJY2Afhq7h8slOAkjMcGHJ79KvHC20eOXyVjw9aDntIk
	mIRhPFHWiCEyvpz4xUiVbABU6XH1T+oZlZ3dvQs6F9kN3SQy4G+PVcnOHobRik=
X-Google-Smtp-Source: AGHT+IH6xphJbzBB0clZE8WO90m1ArQbyWne+sZk3kJAASTuFfHPXnqqCDdwobQVEXgXsMJb4BK/tg==
X-Received: by 2002:a17:906:3297:b0:aa6:66bc:8788 with SMTP id a640c23a62f3a-aabf48cf088mr209274066b.45.1734526647725;
        Wed, 18 Dec 2024 04:57:27 -0800 (PST)
Received: from syrah.fi.muni.cz ([2001:718:801:22c:1369:c402:50e6:7236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aab963598c2sm555116966b.96.2024.12.18.04.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2024 04:57:27 -0800 (PST)
From: Milan Broz <gmazyland@gmail.com>
To: dm-devel@lists.linux.dev
Cc: snitzer@kernel.org,
	mpatocka@redhat.com,
	samitolvanen@google.com,
	jaegeuk@google.com,
	Milan Broz <gmazyland@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] dm-verity FEC: Fix RS FEC repair for roots unaligned to block size (take 2)
Date: Wed, 18 Dec 2024 13:56:58 +0100
Message-ID: <20241218125659.743433-1-gmazyland@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch fixes an issue that was fixed in the commit
  df7b59ba9245 ("dm verity: fix FEC for RS roots unaligned to block size")
but later broken again in the commit
  8ca7cab82bda ("dm verity fec: fix misaligned RS roots IO")

If the Reed-Solomon roots setting spans multiple blocks, the code does not
use proper parity bytes and randomly fails to repair even trivial errors.

This bug cannot happen if the sector size is multiple of RS roots
setting (Android case with roots 2).

The previous solution was to find a dm-bufio block size that is multiple
of the device sector size and roots size. Unfortunately, the optimization
in commit 8ca7cab82bda ("dm verity fec: fix misaligned RS roots IO")
is incorrect and uses data block size for some roots (for example, it uses
4096 block size for roots = 20).

This patch uses a different approach:

 - It always uses a configured data block size for dm-bufio to avoid
 possible misaligned IOs.

 - and it caches the processed parity bytes, so it can join it
 if it spans two blocks.

As the RS calculation is called only if an error is detected and
the process is computationally intensive, copying a few more bytes
should not introduce performance issues.

The issue was reported to cryptsetup with trivial reproducer
  https://gitlab.com/cryptsetup/cryptsetup/-/issues/923

Reproducer (with roots=20):

 # create verity device with RS FEC
 dd if=/dev/urandom of=data.img bs=4096 count=8 status=none
 veritysetup format data.img hash.img --fec-device=fec.img --fec-roots=20 | \
 awk '/^Root hash/{ print $3 }' >roothash

 # create an erasure that should always be repairable with this roots setting
 dd if=/dev/zero of=data.img conv=notrunc bs=1 count=4 seek=4 status=none

 # try to read it through dm-verity
 veritysetup open data.img test hash.img --fec-device=fec.img --fec-roots=20 $(cat roothash)
 dd if=/dev/mapper/test of=/dev/null bs=4096 status=noxfer

 Even now the log says it cannot repair it:
   : verity-fec: 7:1: FEC 0: failed to correct: -74
   : device-mapper: verity: 7:1: data block 0 is corrupted
   ...

With this fix, errors are properly repaired.
   : verity-fec: 7:1: FEC 0: corrected 4 errors

Signed-off-by: Milan Broz <gmazyland@gmail.com>
Fixes: 8ca7cab82bda ("dm verity fec: fix misaligned RS roots IO")
Cc: stable@vger.kernel.org
---
 drivers/md/dm-verity-fec.c | 40 +++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 62b1a44b8dd2..6bd9848518d4 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -60,15 +60,19 @@ static int fec_decode_rs8(struct dm_verity *v, struct dm_verity_fec_io *fio,
  * to the data block. Caller is responsible for releasing buf.
  */
 static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
-			   unsigned int *offset, struct dm_buffer **buf,
-			   unsigned short ioprio)
+			   unsigned int *offset, unsigned int par_buf_offset,
+			   struct dm_buffer **buf, unsigned short ioprio)
 {
 	u64 position, block, rem;
 	u8 *res;
 
+	/* We have already part of parity bytes read, skip to the next block */
+	if (par_buf_offset)
+		index++;
+
 	position = (index + rsb) * v->fec->roots;
 	block = div64_u64_rem(position, v->fec->io_size, &rem);
-	*offset = (unsigned int)rem;
+	*offset = par_buf_offset ? 0 : (unsigned int)rem;
 
 	res = dm_bufio_read_with_ioprio(v->fec->bufio, block, buf, ioprio);
 	if (IS_ERR(res)) {
@@ -128,11 +132,12 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 {
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
-	unsigned int n, i, offset;
-	u8 *par, *block;
+	unsigned int n, i, offset, par_buf_offset = 0;
+	u8 *par, *block, par_buf[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN];
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
-	par = fec_read_parity(v, rsb, block_offset, &offset, &buf, bio_prio(bio));
+	par = fec_read_parity(v, rsb, block_offset, &offset,
+			      par_buf_offset, &buf, bio_prio(bio));
 	if (IS_ERR(par))
 		return PTR_ERR(par);
 
@@ -142,7 +147,8 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	 */
 	fec_for_each_buffer_rs_block(fio, n, i) {
 		block = fec_buffer_rs_block(v, fio, n, i);
-		res = fec_decode_rs8(v, fio, block, &par[offset], neras);
+		memcpy(&par_buf[par_buf_offset], &par[offset], v->fec->roots - par_buf_offset);
+		res = fec_decode_rs8(v, fio, block, par_buf, neras);
 		if (res < 0) {
 			r = res;
 			goto error;
@@ -155,12 +161,21 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 		if (block_offset >= 1 << v->data_dev_block_bits)
 			goto done;
 
-		/* read the next block when we run out of parity bytes */
-		offset += v->fec->roots;
+		/* Read the next block when we run out of parity bytes */
+		offset += (v->fec->roots - par_buf_offset);
+		/* Check if parity bytes are split between blocks */
+		if (offset < v->fec->io_size && (offset + v->fec->roots) > v->fec->io_size) {
+			par_buf_offset = v->fec->io_size - offset;
+			memcpy(par_buf, &par[offset], par_buf_offset);
+			offset += par_buf_offset;
+		} else
+			par_buf_offset = 0;
+
 		if (offset >= v->fec->io_size) {
 			dm_bufio_release(buf);
 
-			par = fec_read_parity(v, rsb, block_offset, &offset, &buf, bio_prio(bio));
+			par = fec_read_parity(v, rsb, block_offset, &offset,
+					      par_buf_offset, &buf, bio_prio(bio));
 			if (IS_ERR(par))
 				return PTR_ERR(par);
 		}
@@ -724,10 +739,7 @@ int verity_fec_ctr(struct dm_verity *v)
 		return -E2BIG;
 	}
 
-	if ((f->roots << SECTOR_SHIFT) & ((1 << v->data_dev_block_bits) - 1))
-		f->io_size = 1 << v->data_dev_block_bits;
-	else
-		f->io_size = v->fec->roots << SECTOR_SHIFT;
+	f->io_size = 1 << v->data_dev_block_bits;
 
 	f->bufio = dm_bufio_client_create(f->dev->bdev,
 					  f->io_size,
-- 
2.45.2

