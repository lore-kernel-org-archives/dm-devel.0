Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907084D0CEB
	for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 13:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602390; cv=none; b=gCSwCrEFXR7uxJeTZaTEJ4nPJHWsNF5p2d2x8qopzSVGFzZndBIwD/YsiQpdDnumZVnGoJZXktTtaeUOIohKBErckeCNE9ow+oGTVYElgP/WxGXB5ROC+JQZGmKzHEh2nKoOgxrkfV+AyUemAWvYxr+aFVeQBoU7E3VAmikD9nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602390; c=relaxed/simple;
	bh=dp8A9m21F4Z6vnwVaB36/IYEFqc7xZs52MFL03Y1vS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQ6fdJirUk8fzIYKcDc9284D3e4Uikp7oSoy0qdlOK/8s59fGHQtLXRAqE+1OyaVmZ99ilFi9eHV7UVGwUzpKhpfnESPol7JRCMUQrRi2Y6nuvyZHC9MWgkFvmv5WuJ1lmcV5vVOFIZUF90YMVn8H6b4BSidveys79U/Y8EldAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QCuqgYGy; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QCuqgYGy"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e6598dd44so18556655e9.1
        for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 06:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790602382; x=1791207182; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=raEDt673oWsC7HjzDuokLb4yrdGb5LOQuk6WNjaexbY=;
        b=QCuqgYGyAWuGXbr9ZV76qcFkxXsRIQYTWbkfcN8Py/Jsp0W1bSs8eSh1tGb0Fl58Wd
         ts5MXiuyZH38g6g4ZslF+BRx5lIa8gExKoUHCJVwJi1nwGWIwlMnYJvf3jqvm4Ba9PkL
         ISgAgUD+MUHWBbMZo73qQC4i7ZemJmWLtxGPBRqxqFj73h2TIqklqj5nuZhDDC73VX10
         hbxCsCDMFfCfwpbs9pMpU5iPSX7ju+1RgTHW89ONrgOUkfDoQWT9X0bC1KzK1QSwtanb
         nakp8P5Vi//YQXHxx6Z1wyKr0bfduN53/slBIU+l1XgxcgWeSexv+VvywRZceCbZ+I7o
         lU1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790602382; x=1791207182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=raEDt673oWsC7HjzDuokLb4yrdGb5LOQuk6WNjaexbY=;
        b=H3wNXY6Np3XZmgc+ritX+o/cIIUyGVJJSw+X8v4JrmJ8UWDvOmqsWbo5zQc/+pw4bW
         4C0XimjhXVo5Ccr5AL5/Su+PIrGhcM/hK6BYcvyamjrLt4IANgmjL4KYpV28mh6P+aCw
         cYHbMWHUsIw5b18XhERF156zAO66WaX9MfEa0G1KKnGVswAMk2pSkyfj3co/snHrph6q
         pI9EV7xuZ967RFHC6wSc931SxhKbQ5tD0emh4Il/i9UMsid4SojwfOOLRC+hEvqQNL2Z
         tGgTxbmA6x3h2E6qpXPOaBZJQT9Wd5ZOQcPeOYXacZsoKiypAPpt5mTyM9t5ep/1GdmI
         qMgA==
X-Forwarded-Encrypted: i=1; AKwUvBzMmhuyXP0tLegg0EREuWk9IvJUgEDnvLLUMi0vyr4KDow/y1WJxfJLK7AIJRPWpA+M21wt77RnOw==@lists.linux.dev
X-Gm-Message-State: AFuF++lp74gCu+lP2UZbtsgMO3d/8PsI1yiP7tZ55sS31VAY/pCtEYOV
	QU15wgXqsObXhlRPDbeA+oUfpZO3B1QJb+eRGKy4CJfDEn4wHbbuHeaT
X-Gm-Gg: AYBFou2c/IsmQt1QGKVm0055I0XHmDs7Lff9S+zlxcjB91Y9JhdzS6zBYP9KZrKJyRP
	soxAo4aYIOgbyl/YbFaRkDTvIyCjquQzgBtvruVgLayyQsP5j9OdvFOIlhZQ729m4w3Mv+eY8v0
	75C31WHyM+DguJcyIwEHQzrNT86RHoErqhMNWIzlC4APnimfnsHvWMrRju7xwGG1O9xo011eTCb
	cVcBZ7uzqP4r2go/zZUTCLy5zexbo2Bl8sy3UX9aJVqrA95UaDlj5b4B+EhPgSezC4fMbha1TA7
	UiAE/bxrprR0wipp9dgr5w1JGUdJocNFUKtw4aCP62uRU8EJXdD4ULR26Wi2X8M1XDs74o4Qc8H
	yFqIlN0NVOCK1kow4DusjzYZHv9TEBzg0C5qhK7lxI+5x5rqFRGrlwpJtMo8EW12NFUCXea7hmN
	HoayFJn1PYBlOckVs/Dgszf95tYwgP4vEpZNQtAWFH1/xq17IMoOqvQ93/Dxbt0VS4XWdSJbRPZ
	Zn+JTdgmOGXZrREtmxtD8XsnsKtZlYifFbuEnGC9PsJEYM01voyegZ+FUuP18IXsGwDYvTr95UZ
X-Received: by 2002:a05:600c:c3cb:20b0:49f:fc13:189d with SMTP id 5b1f17b1804b1-49ffc131a3bmr73381205e9.1.1790602381298;
        Mon, 28 Sep 2026 06:33:01 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a349731sm28090164f8f.12.2026.09.28.06.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 06:33:00 -0700 (PDT)
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
Subject: [PATCH v7 11/13] io_uring/rsrc: add uncloneable regbuf flag
Date: Mon, 28 Sep 2026 14:32:27 +0100
Message-ID: <6bb81fd0941222a30477dc849684d47333d1e4ce.1790602223.git.asml.silence@gmail.com>
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
index 83a7ad9f5bc7..65d6cf7201ce 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1434,6 +1434,11 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
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

