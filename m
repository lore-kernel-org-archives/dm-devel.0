Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA7BF4FD
	for <dm-devel@lists.linux.dev>; Mon, 18 Dec 2023 01:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SpR4OjPx"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-53fbf2c42bfso2133896a12.3
        for <dm-devel@lists.linux.dev>; Sun, 17 Dec 2023 17:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702862940; x=1703467740; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vN+RlAGZeGH2zMVmYb6ghj5GDWJcjTyD9/i+J4cSzo8=;
        b=SpR4OjPxurOx1iFUdvRQ4gP0svIdzN/gTo7rUdF5RgG7l01TbnHCq9SUiuyndkQsZP
         NT7M0j0stTfG07KW32u83zUiWmTGIpTjReOEHRTnomilKykp7bGpYdcWrpBJonjnX2Bm
         LHcHJlNrE5XK60OwGq9paAbGhznuHW2GyoFMaru3FohPhq1tPXsSzpTuCUxDb3iI+LId
         I6Gipy+x/cXZHG2R3zd/O7zZR7rDC8VzgavNhD1+mh/vFMs8/6DUNNseUPbRHGVcJbXz
         CEtBFflKT2xbMhBqa3VptPysQ7V00DksFx55wNIJyifW+UFQhKX2Vhc4a0yg+4t4Uo1D
         gfYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702862940; x=1703467740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vN+RlAGZeGH2zMVmYb6ghj5GDWJcjTyD9/i+J4cSzo8=;
        b=IwfeZCSF1D5f91Ent8NhU6voOGYRvD8/fWTpGrqh4R9QltvtlroN1voedMHHRE483o
         dfH7ZQFLI5+a/YucXyrhKHuy88AYpYgEvB6zhng/GSuSL91uMf2kY7HZvNEDnv9RbOPq
         5P3B/+m+eMVIqswNZXff/wqRGLel9KQo3gKvZsWNginBJsQ9gUuCDlZ+K8Ms03f3JrYk
         kPgkFAK/XaruU/YYvlO+ZlXmT+fuXdgrAcKkPC5AAgWyhYg39tJ5c+GC7Rtop1ftkqY1
         WN/O3JemkpCT33k7t2njTbV21Si9dN/gWCD5wIxyEEIqdMEPhjBXwjqHFEpr2jWLnS2d
         Mnsw==
X-Gm-Message-State: AOJu0Yxf8a6VBDbpcB/umgZYQk90WTjrhVwm51jMxsUYQUq8TWo6BGvu
	/d20106tiyXYZL9W9zhkrpU=
X-Google-Smtp-Source: AGHT+IHNZOIZZK8St++v3NOH3K1OldeUEfUBj9J/bhUS13A0V8/odDR7LtT+dNzvkyYsPcVzipihwg==
X-Received: by 2002:a05:6a20:2593:b0:190:8c90:c317 with SMTP id k19-20020a056a20259300b001908c90c317mr18839984pzd.79.1702862940240;
        Sun, 17 Dec 2023 17:29:00 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id s6-20020a625e06000000b006d64c4cb661sm1414014pfb.200.2023.12.17.17.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Dec 2023 17:29:00 -0800 (PST)
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
Subject: [PATCH v5 RESEND 4/5] dm verity: Fix I/O priority lost when read FEC and hash
Date: Mon, 18 Dec 2023 09:27:45 +0800
Message-Id: <20231218012746.24442-5-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231218012746.24442-1-hongyu.jin.cn@gmail.com>
References: <CAMQnb4O15c=JC-zkCJD0U9GWwWko+Hez1iU7+cc3vhNSG86p9w@mail.gmail.com>
 <20231218012746.24442-1-hongyu.jin.cn@gmail.com>
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

