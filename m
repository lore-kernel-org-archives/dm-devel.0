Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888C74C9E02
	for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 13:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602372; cv=none; b=I3mYyW/w76D9OTcKmZux1Pn4N7KwX537VIjy8m0dZU6+Wk6+VBj1GPg2xJiz7fuLSjqyfVyQ5OA6CPJmPnWiPYaj8A1++0pWlRS9rZO5qDbOiFCRLUT05/6g8lJEH/2BhjOGGv1AinthbIiSLKiMuiG8st6vUuMBUJAEMdV+z2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602372; c=relaxed/simple;
	bh=io+mbOBr0Rt7TH/wdx/lZ5oAtsvxfyuCrmFKA9OR3tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4yfRA5GYibsjcFaTmJ/JboPFWv2fNEdbUhoQ2lWKt7KIegyBDE6+jrdCupJA+g5D31NS4UQqaF0KJJlYCkX1qgKFRZz3H47toUO/Kj0H48h1F2Y+Xntvb0TRNvXtsPYsGmi/iR8aNfgFagh1c+/gwYbhGRfyGxAew5Kdbji9wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CL2EYjaW; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CL2EYjaW"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f63546c5so2731292f8f.2
        for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 06:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790602368; x=1791207168; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OcUXv3wgMOdU2Q5PfJeVzuf4KJvyhVvGu/xuChutEvA=;
        b=CL2EYjaWCJ2dg11NG5A2gCQ0GAxTkgiBIw1oizicXnQfH6R+Pratlqo7FhOLg/WTRm
         lFNwZKCs3bmLOwyzfLHebMnJcd3+U2cbXbTtZL+ixP5bdWbsNC3Gf/BufN2M1ECA30B+
         9/1wpw/0yAP5F+p94RCaOx3DSiVeqLOrdeKZgQpRXRCqhlbcfy7zyKP2LqCJrOOQJm86
         Me0oLJ3p1MoXh9x7ih0aqD96Siq+JiyOmdgqCVcYLu6WMMKh3i8C0/T0vkQXhKY4bu/y
         jN+Qp4oV1+IzdqLwtww1EvX4CK+wb/SFtGXz1E2PjybRJJUowAQfj2ys5uyKjK7wcMfW
         EAFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790602368; x=1791207168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OcUXv3wgMOdU2Q5PfJeVzuf4KJvyhVvGu/xuChutEvA=;
        b=JTFHKHK59FB5/xRFbdvjtnQZIZe42TXXyHfTbiKH5Rfm4W4VSTow7kyRmcn06dUu//
         0jgDUcDORXe5cpNDdyaAWHBGdIgLY4aqmIyUJf7aHjUVHntyN3sxmDaLPFHIARo88yKP
         gVKbkKV551Nwhd+y5284dWIfzJSed+c41nrXcSyydEnMbh/WTLjlGwZTqGcJcApUhIoF
         KnPwnahsuqhgiecmrHn+/ekTsXS29gfmWNyty7esuXV8/U3Ltvz3xqz1QvekMJmZaVV2
         FA6M8+ZvEWnqjuFKko8M80pIxY+HHITIDSicMymf/SvlGWWLqpAXMFNbl5TP2xd3sC6X
         d/nQ==
X-Forwarded-Encrypted: i=1; AKwUvByS4GHsQ+LDDGEwo0ZDV6PPQXa4tG67Y+8oG6tBmyYxqUIvIjHm8DMrZYICtMMlry2pbZu1GaFejw==@lists.linux.dev
X-Gm-Message-State: AFq9FYJtXG1Wd7CwjHfhI2X6WX1QV9GrkyyPOGdwFNM+1IZUxN9pAaeF
	OOCVt2htQMp41crZK2Yr8OqZSkhtUsAxYTWpQkZ6uGEwgxUSmyU0APl1
X-Gm-Gg: AYBFou1J/brQ/pSFNAiHnZ/1NS8Yspg942aCM+KuAfAqANKSN6rQg4oq9dkZ1D2G7aY
	oACCK9bPFJ0FbmMXw/nYQ3flK2RuBa8UGLgbbg7tlirZlDQWA+cuJMq3scTdJ7vA72sSiqa9lUf
	qVNy9Tf5eJQwV3MS+zIZ+MKQgsuh8TvvJR45ee333wOUPVQgaOg8XLB8CbgDzZv2yd8eegkWw28
	MMt2Twxdz6puCurVdQT8vwFOxRSVJOMXpp5zPiFYkPG3s+vdlLq9x2ejbP4fp73hgeeKVGd5B+V
	QLT2x8cRH5G4sTSXidx0Xs8vr1Mxt8vcq82qUIUmrVgkYJVVoIAoa84JDJgmwg3lO8GAurSZXRK
	yLAC0xZO/1eakVXBinW0q612jW/UwDMwEnDf57UyyC8Ps0lp1AzbQvpX5VHgbYulrC5JwpaFawZ
	6OhnBYY4HZ+n4DVctSH5z8bsegirnU1d9LcPUqGEpvsAAl3PzqS4iILkoDc2sCx06cXt+zwuoQl
	zuYAdrfnGMMczWvQxDft6nGxyzpySzWqIwshu9qsYK61REOT1nTpjZ6WdkpcQ==
X-Received: by 2002:adf:e19c:0:b0:487:11c3:b004 with SMTP id ffacd0b85a97d-488719760c4mr23422853f8f.52.1790602368298;
        Mon, 28 Sep 2026 06:32:48 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a349731sm28090164f8f.12.2026.09.28.06.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 06:32:47 -0700 (PDT)
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
Subject: [PATCH v7 03/13] block: always adjust bi_offset on bio_advance_iter
Date: Mon, 28 Sep 2026 14:32:19 +0100
Message-ID: <39b4cb178513b33726c8d2ee0824f7324e84828e.1790602223.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1790602223.git.asml.silence@gmail.com>
References: <cover.1790602223.git.asml.silence@gmail.com>
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
index 75f8086351c0..10ece05cbf43 100644
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

