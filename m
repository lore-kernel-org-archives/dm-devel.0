Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31163009D6
	for <dm-devel@lists.linux.dev>; Sat,  1 Aug 2026 15:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599299; cv=none; b=dJ/RSIhkt6ImTGlxeKeX0JYBnZfv9PTnVoyA77ohm3z0D1p0NYYyh+oCdZJ9GhExazxhMkyQjuA94/5LtijKwhtDQhZcAmrdfMOOGRSXlQoPRR5qcasX0Ef3Q2R60IG04mvRviNcL8U4OQs2yQOB/d2OHwk6JFFU2SVRPEYug84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599299; c=relaxed/simple;
	bh=X3zRjuSdVBD5i7gQmFjvEEAtiBuCzXBqrfu9vE0MnhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2fr4lma21IsvK4ZXnvIsmPpZwyxLNLxb0Py17Y4w6wV4ZGOyDMp6MoYTa52dJS5FgpQkUqMrZLpNQZtwmCms1H9o1LvLyw4yjFc48QuJYbI6jqADz5RF/GiFLhPuoiRR8jdBhjV8/uYWeEh9VapqZ+KGsMsl6iEQ8Ygm+th4Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZTPBcDQV; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZTPBcDQV"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cace91f112so21799375ad.0
        for <dm-devel@lists.linux.dev>; Sat, 01 Aug 2026 08:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599297; x=1786204097; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R0GcIDTsY2CDASlyPqk465WOkbyFB/dgtSdtycnJJZM=;
        b=ZTPBcDQV0MFv+BjR8YaRqZG7Fl1TGcSUNlanykMm24+gPYGtZKakw9JVvt3WQv5Z4p
         yqB8YxhfRYFVcVWdJtbkqRO6N5hwpNQhDSfM4BVOxqOolR1cS0XjWPPhrYxbnE8JwqbQ
         W1WLYMu0A1GejqCMkUWQmxa9ASP7nOSK5xELU92Roqzk4rSBucxAUxKJSvePhEVylRF6
         zi+rsdXg/L00Su/WcKS6L3lvJ6Z8OesLHKvam243ToyzVD155+2Gr7NH0F2gnFl7ZgBK
         kfGABhnSyzPSfHqVj9CluKpBzi23Sw6PcRQpi0M3LS1K1+NFkFUb4QkvmmTMiSZa61tC
         6ztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599297; x=1786204097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R0GcIDTsY2CDASlyPqk465WOkbyFB/dgtSdtycnJJZM=;
        b=AwafvrMzqjCpjU7gQU4mc+Y+JrG+heJFP0AaTl0ddxZr30cxITC6KgTzGvQ1SXgC9H
         9G6KLVcw+MrtpXRyQPdm8Yt926CZpiWV3kSRuNhYYp95K05NPm+KWMKdx1mk/C3Zqp0y
         di+7wgcu8v1mDxYzNQDM4zpCqmZXEsjgEoMA6KkvgOGlZ/V1urL5ktd39G8SRGoVVeL0
         ilYkAggNu4DNqPQxj2oJ1RexIq+IwTh3EYAmDQsDyexM2vrYzuT3RLA9AG2jKMOg9a0R
         p7JRiyXgGqwChl6hgh/3IXmqDr4iDSHMzbIe6ASBH6NJGfigLl/kLq4bvjP+RPoU6pgV
         t7Vw==
X-Forwarded-Encrypted: i=1; AHgh+RoVGq5dIXVeeSHo0ItWn4AHo17140WjpAM7WM6Ri0C3B82BO2JApNbQRVAXUna6uRm4J0Sftizi6A==@lists.linux.dev
X-Gm-Message-State: AOJu0YxfEwuvjMV2woiP5HrxGGIZti8qyqBpUh9pgt2gVice/UYTIGXO
	8Wi9fnVtW5HsozsP7wc4ffFSlaiit1Gm3nbJSHExiFnB7rEVpmmanQhS
X-Gm-Gg: AR+sD11ulJ9Hk/pBZELDg5oC9VUC0znonx9Bi0YAiae/p+NGax7SKIK2OALgvdCNYuO
	TllemLw9vHafZ8eXHUr/Z36MiZj+oukeFUEu6TpiNfVw9Gur+cxHy0NMl2bJIp+wAt77M18+U+P
	uVuXE7OS4oYNetes/2To2HuqQ9dnvZjeoOpww3zjS5cTo2qouLK6pKYLcgu1d6++ngm/M5ig0R+
	xZGvBLkJrUURoapZnsnBy05Z5Ugjw2Czg/vDuFC+XcLD96/FT6ic8TnFaOSpE6hjowp+yWm+Tla
	LYfpdvJ50QM2b8pOBVj3oW1UsxsJrVg0NUuELm5aa2wpo80pKXMFbTo9tfXIGtWvASNCgabWnjw
	kgdCOkhE3DdS2EEynqaEYDflye/HYHigOgnMhBZkBgovoYOofemVZjY8brhaBUMiCIyl/VAbXRr
	foUuwNGB8TzglryUiuRH6T4BCo8gQEzS8mc6+l17Xjp9iX8X7o7DTt6yoFJfyZNTeJZJxCZxJ2v
	u9XMIsq8QKm6vBB97XbfqgCXpn3dYnb4TXXtGsZ6+X7GBA=
X-Received: by 2002:a17:903:22c3:b0:2c0:a555:80d6 with SMTP id d9443c01a7336-2d0521bcb54mr36749555ad.2.1785599297067;
        Sat, 01 Aug 2026 08:48:17 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:48:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
Subject: [PATCH v5 04/16] block: always adjust bi_offset on bio_advance_iter
Date: Sat,  1 Aug 2026 16:46:16 +0100
Message-ID: <64f559a1d1ac43880149de5950187beee6bc2aaf.1785596451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785596451.git.asml.silence@gmail.com>
References: <cover.1785596451.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend bio_no_advance_iter() iteration to also increment the offset.
It's not currently needed because the currently listed request types
don't have a buffer, but will be useful once we add bios backed by
dma-buf, which don't have a bvec but work with a single range.

Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/md/dm-io-rewind.c |  6 ++++--
 include/linux/bio.h       | 12 ++++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-io-rewind.c b/drivers/md/dm-io-rewind.c
index 04f3fc8aeb6f..b22719c6411c 100644
--- a/drivers/md/dm-io-rewind.c
+++ b/drivers/md/dm-io-rewind.c
@@ -113,10 +113,12 @@ static inline void dm_bio_rewind_iter(const struct bio *bio,
 	iter->bi_sector -= bytes >> 9;
 
 	/* No advance means no rewind */
-	if (bio_no_advance_iter(bio))
+	if (bio_no_advance_iter(bio)) {
 		iter->bi_size += bytes;
-	else
+		iter->bi_offset -= bytes;
+	} else {
 		dm_bvec_iter_rewind(bio->bi_io_vec, iter, bytes);
+	}
 }
 
 /**
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 0445ecba3b24..f9b8903c6a87 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -113,11 +113,13 @@ static inline void bio_advance_iter(const struct bio *bio,
 {
 	iter->bi_sector += bytes >> 9;
 
-	if (bio_no_advance_iter(bio))
+	if (bio_no_advance_iter(bio)) {
 		iter->bi_size -= bytes;
-	else
+		iter->bi_offset += bytes;
+	} else {
 		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
 		/* TODO: It is reasonable to complete bio with error here. */
+	}
 }
 
 /* @bytes should be less or equal to bvec[i->bi_idx].bv_len */
@@ -127,10 +129,12 @@ static inline void bio_advance_iter_single(const struct bio *bio,
 {
 	iter->bi_sector += bytes >> 9;
 
-	if (bio_no_advance_iter(bio))
+	if (bio_no_advance_iter(bio)) {
 		iter->bi_size -= bytes;
-	else
+		iter->bi_offset += bytes;
+	} else {
 		bvec_iter_advance_single(bio->bi_io_vec, iter, bytes);
+	}
 }
 
 void __bio_advance(struct bio *, unsigned bytes);
-- 
2.54.0

