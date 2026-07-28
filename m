Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D974B47DF85
	for <dm-devel@lists.linux.dev>; Tue, 28 Jul 2026 21:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274213; cv=none; b=repyb8tdibIczY5/OfCDXKvdgU1uGb96IVIjHrH3YMdbogTbNMkPk+fUmT9ZtLPacyWaSthC1cBuLV4DzS2/lO3yYT8oTqOpiyPY8Ku9b8uwvtta2CiART63xT96ggitjpe332zO/aKMUDkSzWQUC/gesdizeO/o26Lmd6U29+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274213; c=relaxed/simple;
	bh=GOpsniia9YGwJC5+Tf9jZp7skqJgnlIpNpZfRP/ds68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hS0qzDuyhC/N0iNcGTLIuznQH81F95ljmKeIwFSfwVkHGEtrN0nAyEZC5NUBX3wg0c8aC3MEH5OyAS28crEmVeDQRTyThYDfeybPw2hPUi56PXDHou8fY8FU4qQtST+fWLvswEBQoZTKCiCijVwRdo3+/p95s+gQhn/zJnfYLGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r64hTbKF; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r64hTbKF"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47f9ab7ee38so232733f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 28 Jul 2026 14:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274208; x=1785879008; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jomHTWh5pLJKgL2wIyki6K11K3ENYcuFeD6DEOIqSFg=;
        b=r64hTbKFMO4kWXnjWwEen6jO3Ho5YAqY4VKRsotVQXWoPcaDVp04hg3r675Tzkvmt1
         6SnNcRGMzcO667Qyz3hdSHK16EQV6LstKfZl923TFO97P7aVbbj0Bikw856lE/9BlbcG
         vc37gF8vitFfhQ9Pd2kp7x+RjmecIGHUtIfai/Zf9tWfhi8wzp5oc59OrHiBw4AyJ5tf
         xHMtS36Ui2PVppzxBu9F0ji9DHA0gX9kx85x44lHTarkgmythzRifTjG1mJXCk0JFuiX
         WtnBpKrGddhUuJ9QzaysXermMXzVE4ZZS5bJzSUSo38xgZt30oB0kU39I3mFtlhsEdmE
         z/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274208; x=1785879008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jomHTWh5pLJKgL2wIyki6K11K3ENYcuFeD6DEOIqSFg=;
        b=JYu55pWM28Afu7bkRe++s+FD1EFL+nve2KI0evy8Svkmty9QVFsCrWQN5TTrMEZQ6L
         cL3yCAybYQRY3TXyjW85s3uUSPJqxCoSra1KR8hqT/5nwFCX91W+4vIgRqI2d+9ZiPEb
         MVA5VvZfAg12YFvnb5A87rUo5gqR8cZVl+r0yLsXmLgH1yqFxPqfID1FQ5R0VjB8xM4A
         v+3KnQeUY7rKhM7QhAUYiGYR4JcKDRCP7Z2/mf8nZ3TWje81tSoW+5KOjXBNyjYdXX5R
         FEzssOBuAgoiPy+1Mv89TFgWS49ZtzQaSnvezknmoYmbTtFiTFMcjkwvlByIZARB1vMC
         PvJg==
X-Forwarded-Encrypted: i=1; AHgh+RqhDXlmk20iHxnhgqqqMok9f8c39q8/0oJsXsuWnyWL06DmC+kE7FNLD759i8o5jMODokNuFzhlTQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwL5ewjTYKaVgIIYg5ye9Y1SVAyH4f6kMbvMGj3mIgh/cD60Gx3
	9m1Sik+3S1RVyeozA08/dRXdIDDtFSg0Oe79lCye5M51w2Urp8LeNtUz
X-Gm-Gg: AR+sD11wTiE9FpcDH5+ZI9sR9ME3hhqnKXO5rWVgxgQEDMxRXCgKrTypOAImoqtuBjn
	sqkeXaA88Jhd8gBgiUh8hxwtGl8VsrfasEqEndaSM23oX82LqZLpNdPv5DG0fzmbSWlMDc+BSJl
	9JRNn5wMUsgqZ6C/8Km1myqchtO3PAeKHy8S4mjJJpcC+PTwIx2kuZagl7eA4MEwD+KILtOYDpZ
	TeY4hpsaTDNpKdAYHc/tTv1nIwlqTNEF/P5TKGR1cgiYUjZ9iA0KrAdPNbHLJfp1vozLPAt6+sY
	OZE5cPCXUSNsQzCW9DHuZ7Ak7MXGJRT4B+DIHq1Q6r+FzXY1F7ziy8uJL/ZcPRI+uCrBYkQK7tt
	CTqpYhslK1tNGCan2sJRp5BUZ8YhVWEW/tV98+qgXNmF+08dt7/xEqseFKFzAonHRqCZcpUJHXW
	70uwoFLNQEdSZOyPf1HK7BZvdA3zsbgwRkwdEIvHtmFzziOG8GHxuU/7K582Oy+OmrYeFK63tHK
	aHgUuKAZkYIsgHEp2E=
X-Received: by 2002:a05:6000:2f81:b0:47f:97a4:f121 with SMTP id ffacd0b85a97d-47fb1f108a5mr5045703f8f.30.1785274208062;
        Tue, 28 Jul 2026 14:30:08 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:30:05 -0700 (PDT)
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
Subject: [PATCH v4 12/14] io_uring/rsrc: add uncloneable regbuf flag
Date: Tue, 28 Jul 2026 22:29:24 +0100
Message-ID: <a138961611aadf950ce6ab9215f00ae888b8ce72.1785274111.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785274111.git.asml.silence@gmail.com>
References: <cover.1785274111.git.asml.silence@gmail.com>
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
index 24fc3232a66a..d57e8a0380b5 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1381,6 +1381,11 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		if (!src_node) {
 			dst_node = NULL;
 		} else {
+			if (src_node->buf->flags & IO_REGBUF_F_UNCLONEABLE) {
+				io_rsrc_data_free(ctx, &data);
+				return -ENOMEM;
+			}
+
 			dst_node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 			if (!dst_node) {
 				io_rsrc_data_free(ctx, &data);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 98ae8ef51009..83aa86e6f320 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -29,7 +29,8 @@ enum {
 };
 
 enum {
-	IO_REGBUF_F_KBUF		= 1,
+	IO_REGBUF_F_KBUF		= 1 << 0,
+	IO_REGBUF_F_UNCLONEABLE		= 1 << 1,
 };
 
 struct io_mapped_ubuf {
-- 
2.54.0

