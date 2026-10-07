Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C00E377AB3
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 01:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791336755; cv=none; b=SLBwuZ8M4vCtuvqJHhyC1j5xdj2N4tIW8x3kTGNE9DKsyPDfCNDzvDwUHJHe31IOOZTEThIknVCFtiX8n2qaGCIvvOLljcaLFm6wcTH5o3XfMAXWBA4tmxAW6HmJCThzpfKU39i6QKiko7b8tQOWvBtB/2HAbC/NrD8UV4Zkj4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791336755; c=relaxed/simple;
	bh=sZSKKXCePxitJxwkXP2zXOFTkw2i/N+YLyO84coSzgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpkUpSAu+IdWRCdcf8F2MP8zDlMztSVHbBJXuWGbH2TKh1dYr+0UECNN8Dr4vFJyCl92tPRpbBOISqEkJgIIi+cLUxkPHCyo4mvdtjT8CxfUlivFngWUFA+6UvI4/lY3bccDIH5C3ZjFURInVSKuKYhpTczZNWPC9/jLMVztZHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MV9DCILV; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MV9DCILV"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a0286c981dso31547295e9.2
        for <dm-devel@lists.linux.dev>; Tue, 06 Oct 2026 18:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791336751; x=1791941551; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PKjZvbLAs20rdhF/f8LJ7mlj5bzqJB3zMFv/Fdm/dPM=;
        b=MV9DCILVRcvX6VdciF7p/uCtFgvylgL+t0Nzx41rLn0ugacxGpU+sQO/bLncGvv6Df
         jAXgyj7jf6VUvijn+C/RIQli/H5DM9juCWWJBMGyThOQz+4KTqNV5yMf4g1D7Oganbds
         zil36aA8DWD8EQ2SAEWiPfAeQ4ZUyxIsj73MFL9m7TN/LmBeuDTHxjmCKRnq/DpMVQz3
         cx4Q08O+TTW37bnkZL1IpoTj0HKuFvA1mAd2QuLr6/lfpETKxxltTyObxo5eBoCLAprv
         Z7cdjRYTINP1USmVsFBCV2IbRRwmuIbrx2kR1aGN4pPAlQtDygtvZ9MnAIJe78wx4AA/
         JvAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791336751; x=1791941551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PKjZvbLAs20rdhF/f8LJ7mlj5bzqJB3zMFv/Fdm/dPM=;
        b=VhMk8/T04niOm3BL/O7v3fczRGq+cWq7S4zapVPeGt3QjPGj4lPvk5qiOJitCsq37j
         5adNxrZqAOGs1UYPtPsa1MyPgUHc3/nQ5TXquYA3wWsdBgajZCKjw67tAD9Z6t7kFxAF
         TZvAfT8X8UvjLZjaJj24Z8vTeBKRo36VamQX/6W28W31Dn7mWMkxOGZpPxcg208yMCqH
         W3o5KYp2CkROlz/srxUcgI5dWWvUKWtsm4u8pQd+CEX2OqTlXaCxeatb91rXt0awni1/
         7t60CALyb6LxXq5Mrk42zcsOvfFAOs8+mHg8Oq/P6Ll7UZKVs8CrQUY8kJBWVQ+noSrT
         nuEw==
X-Forwarded-Encrypted: i=1; AKwUvBwmLBGNeHtjdGpEf+gT+EWhOGjIDYn6Yzg44vJpMLDEDJ3gazNIaewfIoslnoEIrL5EIk96xchyVQ==@lists.linux.dev
X-Gm-Message-State: AFuF++k2tj0xdKe0fdelfjT1mNtjBTtyucoposkyI8Xx6siwdBeIIfW3
	gt8F9iyUH0NIxA4KnF54l5V9pAleUbAFb04lZuwzbgiPnaqXBctxJHAo
X-Gm-Gg: AYBFou32AuGn4O/a46OWQPYmfc+w162D2RdwU2k5YB+G99A3gYFO66j43cYgxXfn4Nm
	dLuBtEjwj4rhQ9Lo3H5XYgZ5B24vQz2FGnp2/W2f+WmPAGJ1bL3giFerj02UrDN9Wqzhc09Dfbp
	m69vIfyYlQ1zbE5rSukPH63MoesGN4a7TBkfo/cVijeyHme4VmrrS3VDVC98Hftk0uXfvnPaKhb
	Nlb6zWUq29ua9gqtcYJIzFH4imhHI+ZyAtuqE34FQoiEOHx8t/cFYNQ2i8OgZqCHVU+b1QkjByv
	hfu5Pq+e2H6lST/hOf35HjmrjeR+K/0PLWHDGydjQWoysmbE2dOxIdVPdjaPEpd5pUuS53kGoju
	lIhSCki1qHLEYGKXtWt4/zbfTkEKseH3HA/0X2lOKD7NVHUQFuYft7NhANS1vQrxLBG8toOxamz
	vF5LMqxqwDQfg0ZQJzbOOtWQVchCh/jd8B8kWZvwfWV4urp32MiR1eFe3boUAfDscMBABAvFr3Q
	eg6udGgLMZV2JRnMFGrmdwx3VE+PI1asAwvdgro/HNK9p0KyGq1sHwzHcScG7cOgzkC74VYaC4h
X-Received: by 2002:a05:600c:3155:b0:4a1:7ecc:b23c with SMTP id 5b1f17b1804b1-4a18041ad89mr5983065e9.6.1791336751486;
        Tue, 06 Oct 2026 18:32:31 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f6538b7sm21183615e9.13.2026.10.06.18.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:32:30 -0700 (PDT)
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
Subject: [PATCH v8 11/13] io_uring/rsrc: add uncloneable regbuf flag
Date: Wed,  7 Oct 2026 02:31:54 +0100
Message-ID: <5ccde8461121af903a18cd6085ccac98656aba4b.1791336002.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1791336002.git.asml.silence@gmail.com>
References: <cover.1791336002.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's hard to implement cloning if the internal structure needs to be
mutable and/or relies on other ring resources. In preparation to such
buffer types, add a flag indicating that the buffer can't be cloned. It
might be possible to add cloning in the future for them, but that would
likely need reallocating the structure and reacquiring resources in case
by case manner.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 5 +++++
 io_uring/rsrc.h | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 77e6929f665d..6930a6897b41 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1456,6 +1456,11 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		if (!src_node) {
 			dst_node = NULL;
 		} else {
+			if (src_node->buf->flags & IO_REGBUF_F_UNCLONEABLE) {
+				io_rsrc_data_free(ctx, &data);
+				return -EOPNOTSUPP;
+			}
+
 			dst_node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 			if (!dst_node) {
 				io_rsrc_data_free(ctx, &data);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 9ef88383b363..73d7b1ebf0b6 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -26,7 +26,8 @@ struct io_rsrc_node {
 };
 
 enum {
-	IO_REGBUF_F_KBUF		= 1,
+	IO_REGBUF_F_KBUF		= 1 << 0,
+	IO_REGBUF_F_UNCLONEABLE		= 1 << 1,
 };
 
 struct io_mapped_ubuf {
-- 
2.54.0

