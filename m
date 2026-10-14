Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEA04F68DD
	for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 11:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791975753; cv=none; b=UJDSYlY3XYKBK3Nf9XhHBvKgX5he3U4X7heWgYcBU6QZ4j/BIcPlGQ9hhRzMVFEh7ctGFpNv+SvNKeD/Oix8FTJSGtEyv7MAOS3ov5pVP4uktqiD0XGWYn0XnXadwumKwU9dlq053uldR4q7vewyed7lKF3lRaQ28Toef3fDvfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791975753; c=relaxed/simple;
	bh=lqtmMOq9NyJHWkCTixF/EfRvdzo9ti4x7BRbdW0dvpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQNujQ4DjrK30uqOCtA9CLSroC329AqEZtAjOgOalDqqPfslfYdCxTtw6ULKgaESw5dezHbOXi7CM6YOz678AIm6LekusM5bm6hJdsrRsgotLmcnnu9GFaAi92GpCF74KX80p8XwqFw9ul/6nA+JBBjzylsw3QMjyB13s2HPlGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QvXMHOYf; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QvXMHOYf"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a061a13884so34064135e9.3
        for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 04:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791975744; x=1792580544; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BooWm7URUcyrH2E2qkRWxlx7KQoz7GWFpr53v56Fl9k=;
        b=QvXMHOYfLVPiDsxfQKz+fvKM5t37zFVvP54egKuGWMIgqG3ikNrw463DodNg2+uKxj
         YwQNJNFtosVErg5/Q7m/5NUgnPhoiGGLtY2IlHW/+mQKSaz0P7jHVS5DHaTB76jdQrYx
         hkVod0JN7qv+K+Pgm/aMc5IVslp1/OvUMA6i6Dvr+YmuJNDFV+Ybj1PIZ4FDUzDMxo3i
         h0HHoAjom9d1ecXYbqeh0SglYeuEvyFIpT+qQuGtWzoid48jgETeyPTGRV8OxLQPvFtR
         saZNRklyjJGzIS1b1gJ4r/blUhbdN+SE1gMj6Zjkl3Qisv355msj1UGQ9vG4W2XW4pWm
         o0Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791975744; x=1792580544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BooWm7URUcyrH2E2qkRWxlx7KQoz7GWFpr53v56Fl9k=;
        b=aWbPYe6DLwi6nu+0gl9itLHNsIJ3q1hhh11acOeA94FUEgugbgzxGBVwLHu7RK7eVT
         1CyVmqRfb73JMq5IEMMypBsB7LTKZD0f2Kc7foznWQdiuhkhVvAAMSLh33Le6IW865aZ
         0ccArJp/PklpMsY1nodjkFy59sFgfeRaRFuj5x0JgPkwKohKdhwbxfWkF9XOxftkcar8
         jWLsvKH1dJuO1S+MYPkgYmFe7bWdO1+h3hk7zT3GYnXEkBm/SukXQrKZrL5FYQe94h0a
         i+EV0AH7tzVqfFq2VVEoKjzv31AmKJIklhCy9Qbx+nUe5x6jB6mfYh4z92gIcTUQQsCs
         oPSQ==
X-Forwarded-Encrypted: i=1; AKwUvBzDZkwNE5son/0t3QbkTwAJPU5XERKeBiQ1UpDN5MjGSjTKodjMDCD4bjpEUGjJf+v1uRpW8m1Vxg==@lists.linux.dev
X-Gm-Message-State: AFq9FYISflZK5pfJRnVGmJSgMveR0kSj6NxfwKo0nWpzYFRxaYLJ+Eli
	6EGH1lCua49QKJQsuD7vik9HkTQ5beSjbuPHLDJcbR9KUUNhBEXZBKOf
X-Gm-Gg: AYBFou2gKYrS9V8NI9/8gWf261F780UfIjIfGlfpv/iogp2q5JCshqyBI/AZfp8fGy7
	HJ/0NxdRqFdwGoF7b++z18YOy7SwmDgXOdXYEUuZJKQKYZ3tfPIF7pM93gniFXaxgwRVjnA4BIt
	6LoXyXBmJ84o6crlVGSUSPIEDSJDGeD2cp9u1fAEiacFTK2RpQ6AuMyN14Nm/hVl2+Ld63KDMt6
	0K3x9xTJUaIsBdiTGE9hK/nNG/4JZQ8K9tVwo238omQAsw9nJuQMCOsgWkOXEsrH/mNkWDLr6wL
	o+3DwKzmjbDf6JocWuvyf+kACV2BEMHu7S6g9Y6VZq4zTN0Qy/K1alQjWkRRdKSrgjIxK/pVPgI
	XKK484ikyQ5KfLbWW4dcRdoDv7P2Ufq368LNO2JwFqVVebh9Nrc8VTgUJ3+jAsH88JLjmjNvTbi
	jFWmB+y9B1FKfC9kem2222QZdxdIMsMq0ENzTaA2WDNyOLb6EBo5YdZmv/+zxbvnMi0LCoXKOVS
	s0OwY4PLm4CQV0mbRMEcBmFH0+HGgTKVG6fhUS1hQlfv05p94wOhSEfT1K9VuDidXUi1wjtgUnw
	Vw==
X-Received: by 2002:a05:600c:a088:b0:4a0:333:253a with SMTP id 5b1f17b1804b1-4a18e49c331mr307406695e9.14.1791975744203;
        Wed, 14 Oct 2026 04:02:24 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1b45eb78csm38078845e9.2.2026.10.14.04.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:02:23 -0700 (PDT)
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
	Matthew Brost <matthew.brost@intel.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v11 03/13] block: always adjust bi_offset on bio_advance_iter
Date: Wed, 14 Oct 2026 12:02:01 +0100
Message-ID: <8e5a67c2f84b6df99ff57a7b3bf7b289999e0468.1791975048.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1791975048.git.asml.silence@gmail.com>
References: <cover.1791975048.git.asml.silence@gmail.com>
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

