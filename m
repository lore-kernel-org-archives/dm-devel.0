Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD3C4A1E1F
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 13:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789997975; cv=none; b=gforxkRdrApzj4ibhNaKDTDEJO0QywUeq+EnSW48tBL8/tvEQOAvfae/waD6Zryk1nYX2S4a7HiJu88XOKxPc8NjeRn0G9oYX4Q8gCfcW4yILam76zaSN+y3zdSqgfyxXwf2y/nHnKN0bnLgymemN0URBDBPhIzmB9e+QjQzrX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789997975; c=relaxed/simple;
	bh=lqtmMOq9NyJHWkCTixF/EfRvdzo9ti4x7BRbdW0dvpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1L0nYpksj9HfFYQ9m+51ezg+HjrI/bIyyuTqO4qGGnTB/gSyq6dydD4CeWwj4pQn5w0fotegiWy/rOK0sTo9FMY9mj2371EkIZ9tfkAHm/q77xhH+2/L/hsCcs46ir++KM4ky13OfgENEpkvspBaPB8/fBBGHvSrqVOfSyAHrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RyUZ0eVb; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RyUZ0eVb"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d37b6so14023445e9.0
        for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 06:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789997970; x=1790602770; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BooWm7URUcyrH2E2qkRWxlx7KQoz7GWFpr53v56Fl9k=;
        b=RyUZ0eVbuWXchz3MmPcmUFlUEVBTGQEOsmc3pr3ybaWxTh3LbXRvXRvY+7UAgTzFSL
         vvuzC/o0jAqJarppTIUptx0jeP88KMQkGnUnBbHk1bhI8JUYJe7ba68ljs19xT+RfofH
         L+xwmHGiUWcKOvTEmJq7ROcFAta/hBYaG3AYf6Su/Ig/u+hB+yUmd8EZesctGa+qUE9m
         XI9oQU1BpVc1Ic6rU7feM09hoBDwl2+qTSh5xqnHGBShBYzwBMkYgPC6ID/z52/c6B3X
         6qNqQsBnGVj6i6+vDNqHQZEyRhtbYOQxl0o3vAamN+veSy/VPm+C1C7QcnQ0ZqNffJ90
         1hMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789997970; x=1790602770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BooWm7URUcyrH2E2qkRWxlx7KQoz7GWFpr53v56Fl9k=;
        b=F/hHCvo3HVzQ3mnVF/1mWRDVUrHPjqD8gG91y6tu4KbckMjgq4SkX2l1l0U1iUgASp
         wI7MGEnuP2HVulVF2tIekpldC9rjn3XhkETREh5j1/y9rb9Zzsl5selbwMeurGd1/QRq
         l7PzDli1s4gPjrUk2e+QHn+fbVhVeWEqfrZujx9UrzmjUxaEShePPribCykTEIs3Fg9J
         sZxmAVBZBAtEd2fA3xKhGqLqNRKpsVY68RukqG2khgWXl2ldkCE9Lku4H3Z3pHh51cFG
         KVBjDp5mvXMrX7W5ZkHjlTDVQ6D4Y7ocCrTaXcaNf1Jiwbf1BrNoel13apD2tkbPVQUj
         OyJQ==
X-Forwarded-Encrypted: i=1; AKwUvBzhP+E/grrG0zLrXdvz4G941qDHuOv7SXFKcr1rz0UyqsiRQP6PxFBWDpN/l1EtBqHG/xPDWml+IA==@lists.linux.dev
X-Gm-Message-State: AFuF++nhtNUl8pMV9zoxWppiXWV1qppm/7EmMPOWEzpYYAI/9fe7J/j0
	M42fg1zJkWH+Q2v/thEryP5VGcfQ/hvKwQ6YoJ2XmNbNW96SV8VZo93T
X-Gm-Gg: AYBFou2bkDjHrsyZ9kC3ADag4xSdo8TTrClJV455CY6AupLXxWYCGxDPUnDp5vdc9K8
	T5UmvK8k+VeP8a/i/rcm8spyCzx3sAvaSryETNJKj1rugRVi+LvnSybL3B6ENWdXRcR8k4hhM8v
	3Mh9m2sXxlLxLjUwYAhfDwnO9LjktYU9I3C79qZZKfE9/xTwjrZ5cVnkZaB28hauPXKX8HnYhuG
	OUJCYbM6P6LQ/XCTlc56IxQXy4bvbUt8gvvM0ldRqemaGZm51LLWo6FP48BjT9JauFYGCSB1UYd
	xH8a6z7paVIgAfsFbuGClyMMIhIG33ceNdE+75a6oz5OiMzHF5bhM13FRRfg4mY4X3X/Iyxc2MS
	cVDiZvsVOpy2y2Osx/7AF/e+SdEbig/zff2cJOq+sK5Bb72ebqIGQkqJTmdXnmn/CE33jkN6sFt
	2G+fXRMvE8e0ZRarliS5kZTlkgupBqro03Q2Ts6ekpKRWs9QfC4FpkLo8Q0/h4xDqaLL3QNaX66
	dQcf7mOG9+Zh15DjJ01GZ72nLLpeHtq9rB6kwJT9tK5c8m5bGhEoLmlStLeS8EFvbh+7TjxXFsG
	xc/mHX79A9xLOpLJH887EIN2pny3ZA==
X-Received: by 2002:a05:600c:c0c3:10b0:49e:823a:9dec with SMTP id 5b1f17b1804b1-49fc5a10b5fmr145292005e9.3.1789997970323;
        Mon, 21 Sep 2026 06:39:30 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-213-26.dab.02.net. [82.132.213.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc585920fsm617171605e9.4.2026.09.21.06.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:39:29 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: linux-block@vger.kernel.org
Cc: asml.silence@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v6 03/13] block: always adjust bi_offset on bio_advance_iter
Date: Mon, 21 Sep 2026 14:38:47 +0100
Message-ID: <f3c6132b313e7bc6e237e1a16ae8750be5988a40.1789997898.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1789997898.git.asml.silence@gmail.com>
References: <cover.1789997898.git.asml.silence@gmail.com>
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
index 17944e44b584..892ca469c570 100644
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

