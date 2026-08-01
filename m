Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1164230CD95
	for <dm-devel@lists.linux.dev>; Sat,  1 Aug 2026 15:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599510; cv=none; b=QzNAOXbmzr5lHMJZ+pH/Bja/PlHHPtXMB2rYILcf4qpfj540HZTJepx+ppyIVyH5VgpYR0XGPjZ9BEoNfR8CGp6ZNtlMExArxl7G+v6pY1ouIQlzHAJIM87JQ6ISt2OrjdNyqCWo8caVfiTON/Ck17FxhJCvdkRP09kYeC6fj5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599510; c=relaxed/simple;
	bh=PHUqDIjZ/fDz2a0/0v9uQuWQT4kuiEnCn87yNoeA1yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceyifdA5bUClvJbDPSQaKkrcy4C3enoNl+neSOXUnCzBv/X2TqduG7VJ1UHPj5Gr1L9NGmie0qWAAbux0UxlM/mU2N0x1HFP0dt9s0AgTExi2DiuXa6R697wu3R9Oq2lZZpK3OCkDaOnTg62CXynyf7ZTNcQk9x92yvvSzo8XTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E7dhYcwA; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E7dhYcwA"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d02b4c3601so23014455ad.3
        for <dm-devel@lists.linux.dev>; Sat, 01 Aug 2026 08:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599508; x=1786204308; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ijUzk6DmoV2KfP6NttCifTbOeJnZ78uDbymc6z2HdV8=;
        b=E7dhYcwAKKVHlFekDjuljZLqcQsnNDCo7VcCOdtVAD+K5sf6TgU4pFRtsx/2aAfBv8
         p85Fw2+NWdALohnxdYd5nAvTk5bAaOA4dYpjzs8s8Lc0l+6KGNWUTO24KmP4rbZLvL0g
         2/wsqulCbml4v2KJaFrOZ5HCHrunx1otW/PbkZWwv2VCa+AEv91YN6GjjKFUPhoxkAxL
         BldfKDc0UKQNTeItFWCmQrRPScWe3qeZAK3leV0LQcUiAZzFmTQSE5fWuKYzH3wRzFBm
         KmhUNjPD2XzGFgblJoIdyAenuzEsLHlpilmHDQlzvwAdJs0JG3pD38kg1GcMcELJH6fY
         Is3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599508; x=1786204308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ijUzk6DmoV2KfP6NttCifTbOeJnZ78uDbymc6z2HdV8=;
        b=GqxuAZWh/AC8qLhwN9aiGLmSaodx6R6m7YoUS/bkSWBqqMqYxt+Hyoxv99SsvL6z3D
         jv10mfBaIzjGyVKI4xn5UKytUdP8kxjMF9McjkwA84sbK9DnGHohap6qiJQH3lte+cpY
         W8SEOP7Xrsk8FL6z+UTlLaZhuBQe3ScYOSjNumzKIARstayCi8xhQ56cTyuVPHkYLlKS
         bhV7oqySYpoJ5ZEsl1njwd63oW0X3F3/UsYiDI+u7bbr4Z+vRLyspa5DrhM5E8Mrl7hX
         WnVX5wjE3RZ6TneLl24ZJ/YPlYLk+oGTU1EywdeDeF9Y5VaQicmptcJYaMpRUWOY54xz
         WJBQ==
X-Forwarded-Encrypted: i=1; AHgh+RoNEfPhpCm9XRArmQfQDNrr20y96anYOjtZE0//4uevwUh01I/6I0XfuEjIf/OcAgZPAnwgGjSk8w==@lists.linux.dev
X-Gm-Message-State: AOJu0YzaWyLfyvAw+2kHSXU1x6pHvGPoo/kFO1neEHYdSbI3V3L/abhZ
	y1e6t7bmzQ/E692D2mDBnzqaXeAcJDMhfq4aYbe0arTwkGd63gWjXnbY
X-Gm-Gg: AR+sD11pOfKIPO0ZqrG+If+ayUIuCXBaFw+NDdnaqKzIiEPPWA/Yse84pMl+nWLgt0H
	J5NOZX5H2kbZJ/LWXPM4KO3fVK8HiZeUCOriXfwNtAVL6YuLZ0DqaEkksNVRb/Hf/fvKjLMjgOI
	A8x00E6iGM0m7qM/TTY4vyBi4QCvWZYa7Vw8dq9jw9eC3fQ5wD7tlgaAE9F5j0370SLHl2sLS0m
	eiTb6WiZmBFTDwe5OKrq0cCHdXAtVSkABF20sEDOZW0prkVgUSUdjXOfqgMrSqY8f76cJ986MHP
	2eFJM2QRG0+eNvIiUTFniq+I3U7t9goirfOqFR9fLFXrQenTCv2d+YbqtVw3uQv6j7NhidQiR55
	TxQ0c005WDie7SxUhq87jmUFkx4+dCa8C/ABHjbdetvpy5VpV2/jpTDEeVNYx0fd/IncNpXD5iW
	ydUXbTFQ+4ja8cDYZeMcAhFrNK2LTEP8wFem+iwwVMu9OagNwHDbTNS2Mzl5rYibGxRREry9j1P
	ozU4vcTotcnHll0mbiaY3a8dKyVuIz0rOZwHtsmF5wQQ8EHnbBa2H5h7iQ=
X-Received: by 2002:a17:902:e945:b0:2cc:9179:335 with SMTP id d9443c01a7336-2d0521e87a4mr39523185ad.8.1785599508438;
        Sat, 01 Aug 2026 08:51:48 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:51:47 -0700 (PDT)
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
Subject: [PATCH v5 14/16] io_uring/rsrc: add uncloneable regbuf flag
Date: Sat,  1 Aug 2026 16:46:26 +0100
Message-ID: <65be6058af60c33328f9ccd8133d24e2bbbd0f84.1785596451.git.asml.silence@gmail.com>
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
index 406619158fbb..f041b0db77af 100644
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

