Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F616AB8D
	for <dm-devel@lists.linux.dev>; Thu, 21 Dec 2023 10:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ixn2nnyJ"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6d099d316a8so625765b3a.0
        for <dm-devel@lists.linux.dev>; Thu, 21 Dec 2023 02:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703154729; x=1703759529; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rQTsvHi1Xi8RfgpJ+r1gUAH45t6Iv3m0mcpAy4KCiow=;
        b=Ixn2nnyJ/rjinf9uMbQC+MoRwio/i7u+SGS6ce92uHgz0LHZJ8KVvxusDzeBhU1REs
         XybfLN73fKDAdzIAJb0LWEv2hTH1O2IqgJGLn69T6FuaqQzdrRMjGb8GR0MztDCZjvVI
         4zczyGu1FwU4LoRHdtIlNRuxjFsfNMPAdRu5RJ+ODxhh/Mt//ppC2JXYIdpThXF1lSss
         AYAc01Tq9o9vS1Qi69wurenS59aXzdt4mw1r6/yUrAIaIsqk/N0uzn8qXDwqKZeXA+rH
         s6gAzAk5a/bmHs77Jx/RHWCxWWUOXaC1TgIoEdk8YZTRvKYAoB5A/iiQcMEemD087Zw0
         c5gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703154729; x=1703759529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rQTsvHi1Xi8RfgpJ+r1gUAH45t6Iv3m0mcpAy4KCiow=;
        b=CohESTVBIKyFWQkrwrD7cYXk5UvR4jwsMhDbltfGXfWzW0LAl99t284do5KF3jm4qj
         MqrF7Zq7dMWX1VtbnHFTUVU59jy/YI9xwq3rG2avTGu9KzYxTNk+yJJN+Mbj9iRPW0te
         S4v8jx7PXiBGveLiUaNjvi/2ArGYswmDSLKPpOZ8xtlEfzah8EI5Kbl2s9iBR36qVH6l
         WJAB25e1qL7MHUFQOcAHCDX0WxFAB42VXgARgIEclQIfq48OTzgI/fa7ZRcN9K4/WoCM
         7R6m7hphbtuiRdQ1E7uyRKuT78XBPKaJ6hBG0RJMuTvjqRbVN4m8I+CiOZkRIlLNs8sj
         13IA==
X-Gm-Message-State: AOJu0Yx8qHKhr/X1fjU0uPJWz1C+JUoVxHm9Ulf7TH2AsGbvQHg8kMn7
	i3EneciYgWyyv03NkW6n7/l9AAdKzlk=
X-Google-Smtp-Source: AGHT+IEn+hV7MHImT2jOrxcsLRKzSXZkqyqpsJCSArr7UaoWwnZ+8kjtWqL6t3VUimwMGkQSVlk1Bw==
X-Received: by 2002:a05:6a00:4601:b0:6cd:f91e:dfe4 with SMTP id ko1-20020a056a00460100b006cdf91edfe4mr23617971pfb.2.1703154728002;
        Thu, 21 Dec 2023 02:32:08 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id a25-20020a634d19000000b005c6617b52e6sm1274539pgb.5.2023.12.21.02.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:32:07 -0800 (PST)
From: Hongyu Jin <hongyu.jin.cn@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	axboe@kernel.dk,
	ebiggers@kernel.org
Cc: zhiguo.niu@unisoc.com,
	ke.wang@unisoc.com,
	yibin.ding@unisoc.com,
	hongyu.jin@unisoc.com,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: [PATCH v7 4/5] dm verity: Fix I/O priority lost when read FEC and hash
Date: Thu, 21 Dec 2023 18:31:38 +0800
Message-Id: <20231221103139.15699-5-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231221103139.15699-1-hongyu.jin.cn@gmail.com>
References: <20231220100333.107049-6-hongyu.jin.cn@gmail.com>
 <20231221103139.15699-1-hongyu.jin.cn@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongyu Jin <hongyu.jin@unisoc.com>

After obtaining the data, verification or error correction process may
trigger a new I/O that loses the priority of the original I/O, that is,
the verification of the higher priority IO may be blocked by the lower
priority IO.

Make the I/O of verification and error correction follow the
priority of original I/O.

Co-developed-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
---
 drivers/md/dm-verity-fec.c    | 21 ++++++++++++---------
 drivers/md/dm-verity-target.c | 12 ++++++++----
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 49db19e537f9..066521de08da 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -60,7 +60,8 @@ static int fec_decode_rs8(struct dm_verity *v, struct dm_verity_fec_io *fio,
  * to the data block. Caller is responsible for releasing buf.
  */
 static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
-			   unsigned int *offset, struct dm_buffer **buf)
+			   unsigned int *offset, struct dm_buffer **buf,
+			   unsigned short ioprio)
 {
 	u64 position, block, rem;
 	u8 *res;
@@ -69,7 +70,7 @@ static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
 	block = div64_u64_rem(position, v->fec->io_size, &rem);
 	*offset = (unsigned int)rem;
 
-	res = dm_bufio_read(v->fec->bufio, block, buf, IOPRIO_DEFAULT);
+	res = dm_bufio_read(v->fec->bufio, block, buf, ioprio);
 	if (IS_ERR(res)) {
 		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
 		      v->data_dev->name, (unsigned long long)rsb,
@@ -121,16 +122,17 @@ static inline unsigned int fec_buffer_rs_index(unsigned int i, unsigned int j)
  * Decode all RS blocks from buffers and copy corrected bytes into fio->output
  * starting from block_offset.
  */
-static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
-			   u64 rsb, int byte_index, unsigned int block_offset,
-			   int neras)
+static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
+			   struct dm_verity_fec_io *fio, u64 rsb, int byte_index,
+			   unsigned int block_offset, int neras)
 {
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
 	unsigned int n, i, offset;
 	u8 *par, *block;
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
-	par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
+	par = fec_read_parity(v, rsb, block_offset, &offset, &buf, bio_prio(bio));
 	if (IS_ERR(par))
 		return PTR_ERR(par);
 
@@ -158,7 +160,7 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 		if (offset >= v->fec->io_size) {
 			dm_bufio_release(buf);
 
-			par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
+			par = fec_read_parity(v, rsb, block_offset, &offset, &buf, bio_prio(bio));
 			if (IS_ERR(par))
 				return PTR_ERR(par);
 		}
@@ -210,6 +212,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	u8 *bbuf, *rs_block;
 	u8 want_digest[HASH_MAX_DIGESTSIZE];
 	unsigned int n, k;
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	if (neras)
 		*neras = 0;
@@ -248,7 +251,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			bufio = v->bufio;
 		}
 
-		bbuf = dm_bufio_read(bufio, block, &buf, IOPRIO_DEFAULT);
+		bbuf = dm_bufio_read(bufio, block, &buf, bio_prio(bio));
 		if (IS_ERR(bbuf)) {
 			DMWARN_LIMIT("%s: FEC %llu: read failed (%llu): %ld",
 				     v->data_dev->name,
@@ -377,7 +380,7 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 		if (unlikely(r < 0))
 			return r;
 
-		r = fec_decode_bufs(v, fio, rsb, r, pos, neras);
+		r = fec_decode_bufs(v, io, fio, rsb, r, pos, neras);
 		if (r < 0)
 			return r;
 
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 4758bfe2c156..8cbf81fc0031 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -51,6 +51,7 @@ static DEFINE_STATIC_KEY_FALSE(use_tasklet_enabled);
 struct dm_verity_prefetch_work {
 	struct work_struct work;
 	struct dm_verity *v;
+	unsigned short ioprio;
 	sector_t block;
 	unsigned int n_blocks;
 };
@@ -294,6 +295,7 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 	int r;
 	sector_t hash_block;
 	unsigned int offset;
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	verity_hash_at_level(v, block, level, &hash_block, &offset);
 
@@ -308,7 +310,7 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 			return -EAGAIN;
 		}
 	} else
-		data = dm_bufio_read(v->bufio, hash_block, &buf, IOPRIO_DEFAULT);
+		data = dm_bufio_read(v->bufio, hash_block, &buf, bio_prio(bio));
 
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -720,13 +722,14 @@ static void verity_prefetch_io(struct work_struct *work)
 no_prefetch_cluster:
 		dm_bufio_prefetch(v->bufio, hash_block_start,
 				  hash_block_end - hash_block_start + 1,
-				  IOPRIO_DEFAULT);
+				  pw->ioprio);
 	}
 
 	kfree(pw);
 }
 
-static void verity_submit_prefetch(struct dm_verity *v, struct dm_verity_io *io)
+static void verity_submit_prefetch(struct dm_verity *v, struct dm_verity_io *io,
+				   unsigned short ioprio)
 {
 	sector_t block = io->block;
 	unsigned int n_blocks = io->n_blocks;
@@ -754,6 +757,7 @@ static void verity_submit_prefetch(struct dm_verity *v, struct dm_verity_io *io)
 	pw->v = v;
 	pw->block = block;
 	pw->n_blocks = n_blocks;
+	pw->ioprio = ioprio;
 	queue_work(v->verify_wq, &pw->work);
 }
 
@@ -796,7 +800,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
 
 	verity_fec_init_io(io);
 
-	verity_submit_prefetch(v, io);
+	verity_submit_prefetch(v, io, bio_prio(bio));
 
 	submit_bio_noacct(bio);
 
-- 
2.34.1

