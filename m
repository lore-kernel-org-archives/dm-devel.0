Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7840E345EB7
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 01:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791337397; cv=none; b=YFFOFKINy0iYq1cUs4R0LdNfZJa9zbWSNodwf7BLSnGGy0r3uXZ8gw9PoJMvu6woAQTuO3ufbyMdaC+b8gVo6FONlkD7GASq0Q2TX8lmSYwgCi/WYLA96j5SBlJDVk7ux1hMUEIeFSOmRQXrQ8x4OVR/kj6KisgMQNib5c8TKUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791337397; c=relaxed/simple;
	bh=lqtmMOq9NyJHWkCTixF/EfRvdzo9ti4x7BRbdW0dvpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8+/XDqfSDBT7Eidk6WppTxtpQLco60Zhk/za0VLijQBuGrxBhdXaEr4UDxhF2UdIAdukWLhoBabYQsilhXakQ1FQv5Z2h5+CJqmrRBxPDF1SH4ISJB88fpQ/t2BlXn7npDCUoelUL8ECzKGPdz/cieVGgaLwzdobIUNnY112ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y++P7FWQ; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y++P7FWQ"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a1688d7769so21900065e9.0
        for <dm-devel@lists.linux.dev>; Tue, 06 Oct 2026 18:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791337394; x=1791942194; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BooWm7URUcyrH2E2qkRWxlx7KQoz7GWFpr53v56Fl9k=;
        b=Y++P7FWQ6nBzdok+aCqJA37xG/1AYXNynUxwCluHKHEdoydAvPJxI4EAp9ELKii0vK
         WEFVZkPOGFJSjXZdWLySZy+XdwRBSRTCiUw7XcHlIs2TcrL4nmmRqKR7pMENuAD52ypy
         MBwf/OzuR5VdwKvOrfvhFGl5LgKYT6OxIR7BAKGiuGimobw1jpadXiTc5LVPsOjVUYhC
         a3cS2ujeOHSVG3hd0wWPtFhfXyidfA8/8ej648U8ZJjgZAW4hdgGfyB5LsHCuwNeH8ZN
         DGwtPfNCQXe9jePIQhftC05MDJeyhG1MLTVClRQ2wX/60UiVzxvu2MeCo2s6hWGoMOHr
         gqpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791337394; x=1791942194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BooWm7URUcyrH2E2qkRWxlx7KQoz7GWFpr53v56Fl9k=;
        b=lUw+q1DOivTcOetJgTTVvICwAAvEucq3OqvIsAF6kQeJkLRjZ2qBkwPFybeyRxyY9Q
         5h3qtNkLCzJ1fEpQhOCe5CxpXeR8eI2OP8WddEyHA0K1Yr+32+VUPmH4PhdI2EgIlb0X
         6nZl4oswZFdVnZ/knb7YYRrFK8TAmWbP1jxmhNYhHbuXgL6ERS/OlucUYI4xi9yWHowR
         dNNZOlRX6ZceMilkRJhoN//qTsXnDsaD+Bk1WFBXLlvlaBDZ0pvpD6gt7LFcW0U1HdPE
         G52/z/AD1+YQNfxGSJnlvcwjTClAHlUGCjeDDsjAt0i6n6/jlj4UrkdwUnqDf6XohUkP
         XuKA==
X-Forwarded-Encrypted: i=1; AKwUvBzou02dIdbKYwXJ78+cexNp8cWRwjdE3YPo1fwgAauKRLreSXDY1rHhemhBF/0X93NmboPQVNlVWA==@lists.linux.dev
X-Gm-Message-State: AFuF++ldaxa2Kf6hbd4Ku3CUxUHa3OZCZG36Z9+XyzuK99JCQwWnKvP1
	KtSG7ZAsJ/CL/Oo8qfeKh+xS3fz7B1BYRjTH5o6KQonZQqS853cqwyHc
X-Gm-Gg: AYBFou3uJMY5YN3mQhEenJE4guCAijYO4dc+9OlE3GKczUeOzzjki74W8FZMYtfapJ1
	dhWvJVCmuD7eXAsyZMcQ1G9qXcSWL+T9nKvkeLAV9dmbDSq1OcATYIgFpKVoKGVU/n5bNzsDtfW
	XDSAF5VR1R4fJQSQUDBajn6yn2ipFElYnUr+Ejz3RzJk3QOqtjOUQVIK3o2HPH+Axbz43zHjKwO
	I3WOqmnivboiDB3HLJGgPsGxHPrzfZVXYG7sBlZF8o9gx/jxHtFDw8Fu+mBiH1XmVUMmP+trWeq
	gpwgto1AasZ5L0xiyFk4n+xcEih4RdQ/ajjlSrOAez3zJ9tH4nW2guTlm2iXI5gT9Z8Mrwtxni2
	T3VhzXGD69WoMlCJWYxVY8VowWTJSEH2HSzCvFY3HtycMxE/ii48g/jwzQNXMbK4Fp/GRf+rwwh
	7D8bzVzrvWGLajDxH2Q211UvHPERzgdWBp/vZHYOpODzY4KjIPjhY/I4qBWmyWcKPJ+WSsv4FgP
	cxrqQyhNsa5UfJSYUp2/PEZ4O515EjojPM/lP8T28LqzSwzPcKPHTImXNvF+w9RiJK+EbEWG1lg
	Hw/PzQDXh2A=
X-Received: by 2002:a05:600c:6097:b0:4a0:1f90:594b with SMTP id 5b1f17b1804b1-4a18064cf5bmr6446075e9.22.1791337393761;
        Tue, 06 Oct 2026 18:43:13 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f653d7csm26423895e9.14.2026.10.06.18.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:43:13 -0700 (PDT)
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
Subject: [PATCH v9 03/13] block: always adjust bi_offset on bio_advance_iter
Date: Wed,  7 Oct 2026 02:42:46 +0100
Message-ID: <beec7303891dac21cd620d2a47842f843b391192.1791336930.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1791336930.git.asml.silence@gmail.com>
References: <cover.1791336930.git.asml.silence@gmail.com>
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

