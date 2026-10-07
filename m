Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC0A365A1D
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 01:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791337415; cv=none; b=PCOdEIaPkjyxvmLTT8lPHxFgH97mEHtlnzwU/2LJees9X1jyA4iP5yjh9Vo58vYQq2QeVjM2aNOK42VOqJHnsOA5GWeGrorIPpze0isAlteegLsZVKQ9SBcXkcUqIRu5IVksRB6Uc5veiOwXo9bFkV5/CaG3Uis8z7cqJhFao6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791337415; c=relaxed/simple;
	bh=sZSKKXCePxitJxwkXP2zXOFTkw2i/N+YLyO84coSzgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsU4fsX+YwjkHzXSMqgT0hhzVk/B3mxrvmMey4M/KXy/9kXH+mB0xJt02tjQaQetDtzlQaCZ4Qc3tSFKAl3bBw2VGz3fqr+6/8ph+R8dAHHRQifvWU9no9lC5gAwp6yQFOg1jJjmRi7CUqZ6+9GBRQgXmAMXtKF5taxAf3JDk28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d5NpBvXm; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d5NpBvXm"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48c45111bebso879225f8f.0
        for <dm-devel@lists.linux.dev>; Tue, 06 Oct 2026 18:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791337408; x=1791942208; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PKjZvbLAs20rdhF/f8LJ7mlj5bzqJB3zMFv/Fdm/dPM=;
        b=d5NpBvXmnU4g8EL4RezsMVGa2ahLzSZb47W7f2CJE2Q5v3YczlMXN8ubBN1gBAmKWr
         kW8nLUOF06W+SFwTYse6WtYkTGJTHfisjRiumtivP9DIUSTaiOcoNIFHkLeFAoBemO/j
         SKpc2W0Y5y8fqUKGmTwk3zJHjummRVsrExCb6zQEzoeHYuyv+QEmC36SHe3iyO/XTKKU
         DQCP9wBs/MUNlSNyREbrEAeKAJLqEsgkZN4N3zZTi9pXxFHelAJXAi7RLripbCLzwcHy
         lufDPDas/u4aTdFa7isJncxp5oeDhSy7GXFTvjkvY4l+ZYqJOV3ETWimgUGhfiomwUP3
         gG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791337408; x=1791942208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PKjZvbLAs20rdhF/f8LJ7mlj5bzqJB3zMFv/Fdm/dPM=;
        b=nWQY0+invtGqtUnTRWXrLZ0X+q7aOZWLd6pYO0/KjKESNi2NU6/CdK3Ksqovxr+6DG
         KImPCGBfHdP4la4OmgpiE/tN2WDCqthmsKI2yIAeGJ+A2CD5Yj8/ZN/l4aJmvxQ8xQKj
         3S7h3E3eI1z9F5LmMpjR0nvSxO+vpeBPTiW+MDU8RLmTm7/P7uwLoMvgC8LneX6H9G0/
         Q1RwEbxJIyFBXqA16LPjjFeA1ciHr65I9e4zpC1A14AbWSmlswhTSvZrXfcxWabNaeL8
         eHxtHwVEpyUPwIQH3tNcVJ+1QuedIgd9oqZNc2aoJACbFKekc7dKjgSChUi9ReqeqB2W
         EnGw==
X-Forwarded-Encrypted: i=1; AKwUvBxwSVLkHgHUKAqArO//vrUfqPP6DxE1+WADSgkU/hvMbtrPmeGOWkCATJEmqfXwfu+7A7s/gnEIWQ==@lists.linux.dev
X-Gm-Message-State: AFuF++lD+Qxn7tLixCyFN/6lMBhRCgqI5Iehhja9JWj9+IpG0VpgqWM7
	qrsmZ+M7HDolxM4iw494cbIMKZY2r7c9yTn6hKHyWw4dbH/Q749VsJBK
X-Gm-Gg: AYBFou1jNXDcbohN09TeWNXOvfljfo7KJ4JBzWCuCMW3QiPMxMoZdJAVLZu/VWn6zSt
	Q72qvIesXoY0gqzML7fY6xMc4thqc9NQ5sUylhoaJEE9yDjgQ7zND7sMlSfadk/80NwgMxQPY10
	ytzbcS8J6RL8m5ClCayoE5qOlpzXjtcwNhmygnS23CC45XG33+BP+8bf81cMuDbAbP0QeQrjs5o
	LB5hdOkOxh+AJnGNX4F4U+N/GTCUYRx7EYjeU6OX7LNkhqhyITxkzhoLanNVU5CY/Ua1Kk0u6Ll
	3hpBI1/EIijiPTQbv66F7EIXXdrtjFT20s7jXJgRpFK9hdahc9MwAbTfgnSU6X+rhmQUUjw/F49
	fS9RiJoAkmYmGKGkNhwpEW2WBFiwmO7F3ngO8QmBw+A3PHJjPbhDOCWvoQmN7Chr7dB67Ay4iFS
	haxiRtuetw0zI6gHZLGIQDlqMlF/QCNfJ2ACF3h4McHYKY2pqIAVBDGQXtTrsSp9ikp6EGZOATq
	2FMlxoxijx06Iwhx/K6EpNmbP74OTL7akYt2GEVwkSFKnIRQY0swSLkK4pUYu6t8J1PRq7lyNYL
X-Received: by 2002:a05:600c:1911:b0:4a1:78c5:79f5 with SMTP id 5b1f17b1804b1-4a180455696mr7216955e9.33.1791337408104;
        Tue, 06 Oct 2026 18:43:28 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f653d7csm26423895e9.14.2026.10.06.18.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:43:27 -0700 (PDT)
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
Subject: [PATCH v9 11/13] io_uring/rsrc: add uncloneable regbuf flag
Date: Wed,  7 Oct 2026 02:42:54 +0100
Message-ID: <e46bb4ba345595eb920f2e14077f7f3d3b044d0f.1791336930.git.asml.silence@gmail.com>
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

