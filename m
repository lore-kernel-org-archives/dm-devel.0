Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFB75AB8F
	for <dm-devel@lists.linux.dev>; Tue, 12 Dec 2023 11:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Am8KI+Er"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6ce94f62806so2966408b3a.1
        for <dm-devel@lists.linux.dev>; Tue, 12 Dec 2023 03:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702379549; x=1702984349; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vN+RlAGZeGH2zMVmYb6ghj5GDWJcjTyD9/i+J4cSzo8=;
        b=Am8KI+ErpqYYc0CL0k0ZIFm6y/xjwrOFbkmGY3Dkgz3cPOBWy+x2pXRBaq2YEHwsug
         4psA6q2n2XYJmlTa/V3qsZrBk87IN7Fgs+aUShry3m97A2s1aYnqiRfT65/xrXPpo0Zm
         ImINsEkbLwlPBB77zuJ+Tsb7tuCE8+xJ3dDsBxXhe6mhLqT5HrKn3lZiS3UEtTNsaHq+
         VzcBEXphmd0Hqi3vDmAE4kQ2HJqrF/764VZcO0dnaTb7NARCLVcagsqw3wG9+O3ksyeG
         bdeurEMB5jDXHimvI1O2dTZ0Ip+R1k08s9cW9EbfDljZWRWAudjtBDSKPosUVSG5FD3Q
         aP7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702379549; x=1702984349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vN+RlAGZeGH2zMVmYb6ghj5GDWJcjTyD9/i+J4cSzo8=;
        b=UDwb0HlFXbx4VC6grQYqeop7PaciT3zfv2qZIPjzEFWHxHWvvTUg8RHs81F7zJB6qO
         YlJiWolH7ImW9AJjfVBPzX1nw9QxOQH5tITjfKRiCLRr3PIpEHzzIMMqIM/5HNpk9Vj6
         HUUupA7N+oLslKws6tUefyqX8tfwhKhWjVbJUOGx39nhAU83Q4keoDBL+mMz+2OEAXVB
         G3E9gBfPbQISUkX82zs4jwI7MbRDWdNw3CLcOY3Law/5Y4H2szj8DTaiY5WuLAQEY4/8
         cVBAw8+Xfjxegpwq/JRKVGnBik7VcHd/bLyhhsLpLcaP+myIEczRuAIurf2Pbhq4cLrt
         cwcw==
X-Gm-Message-State: AOJu0YyaEQXq+WEFZZB45x1slkuTiI2dDw5XcSCerDg7tQ5CF8VaXKCR
	t7I31ozPrHGeDZ2jJ825Ri3SFxAS0Vk=
X-Google-Smtp-Source: AGHT+IH8HknLDzaW0Q9TDSRdg3SQu4DIMs5eNiFa7zAa7YAtIDMAqdyYIiPkKRRbitlR1WMMmVqmNQ==
X-Received: by 2002:a05:6a20:4287:b0:186:e53:b64b with SMTP id o7-20020a056a20428700b001860e53b64bmr3221043pzj.47.1702379549391;
        Tue, 12 Dec 2023 03:12:29 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902ee5500b001d0511c990csm8345453plo.237.2023.12.12.03.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 03:12:29 -0800 (PST)
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
Subject: [PATCH v4 4/5] dm verity: Fix I/O priority lost when read FEC and hash
Date: Tue, 12 Dec 2023 19:11:49 +0800
Message-Id: <20231212111150.18155-5-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231212111150.18155-1-hongyu.jin.cn@gmail.com>
References: <ZXeJ9jAKEQ31OXLP@redhat.com>
 <20231212111150.18155-1-hongyu.jin.cn@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongyu Jin <hongyu.jin@unisoc.com>

To fix this problem, when read FEC and hash from disk, I/O priority are
inconsistent with data block and blocked by other I/O with low I/O
priority.

Make I/O for FEC and hash has same I/O priority with original data I/O.

Co-developed-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
---
 drivers/md/dm-verity-fec.c    | 3 ++-
 drivers/md/dm-verity-target.c | 8 ++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 715173cbf0ee..6a5a679e7e8a 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -209,6 +209,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	u8 *bbuf, *rs_block;
 	u8 want_digest[HASH_MAX_DIGESTSIZE];
 	unsigned int n, k;
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	if (neras)
 		*neras = 0;
@@ -247,7 +248,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			bufio = v->bufio;
 		}
 
-		bbuf = dm_bufio_read(bufio, block, &buf, IOPRIO_DEFAULT);
+		bbuf = dm_bufio_read(bufio, block, &buf, bio_prio(bio));
 		if (IS_ERR(bbuf)) {
 			DMWARN_LIMIT("%s: FEC %llu: read failed (%llu): %ld",
 				     v->data_dev->name,
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 0038e168f3d7..8c911b6722ce 100644
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
@@ -293,6 +294,7 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 	int r;
 	sector_t hash_block;
 	unsigned int offset;
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	verity_hash_at_level(v, block, level, &hash_block, &offset);
 
@@ -307,7 +309,7 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 			return -EAGAIN;
 		}
 	} else
-		data = dm_bufio_read(v->bufio, hash_block, &buf, IOPRIO_DEFAULT);
+		data = dm_bufio_read(v->bufio, hash_block, &buf, bio_prio(bio));
 
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -717,7 +719,7 @@ static void verity_prefetch_io(struct work_struct *work)
 		}
 no_prefetch_cluster:
 		dm_bufio_prefetch(v->bufio, hash_block_start,
-				  hash_block_end - hash_block_start + 1, IOPRIO_DEFAULT);
+				  hash_block_end - hash_block_start + 1, pw->ioprio);
 	}
 
 	kfree(pw);
@@ -728,6 +730,7 @@ static void verity_submit_prefetch(struct dm_verity *v, struct dm_verity_io *io)
 	sector_t block = io->block;
 	unsigned int n_blocks = io->n_blocks;
 	struct dm_verity_prefetch_work *pw;
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	if (v->validated_blocks) {
 		while (n_blocks && test_bit(block, v->validated_blocks)) {
@@ -751,6 +754,7 @@ static void verity_submit_prefetch(struct dm_verity *v, struct dm_verity_io *io)
 	pw->v = v;
 	pw->block = block;
 	pw->n_blocks = n_blocks;
+	pw->ioprio = bio_prio(bio);
 	queue_work(v->verify_wq, &pw->work);
 }
 
-- 
2.34.1

