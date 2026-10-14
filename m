Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4386A4FECD2
	for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 11:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791975771; cv=none; b=ZbAQEIOtezjRlETAgFkwhXL+v7Tnz0z8gnFWqL5+pPWmrTfU9JHzA5eLfUM0WV/hXywtj4XwoHefUkY6ZDoqzZJK63M0yw6RHJqrIRh5LFldHauJ/vKrHo/q3aWyCl9NhUv9J1hm5E7vIGxjPKgoUqBP7luxnFTlufhMF7KwYzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791975771; c=relaxed/simple;
	bh=Yz9mg10bqVdj7cVQ9CUCuhVSPCWk27GUE+7ZZMs5kDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0MBpXvF9LpbgFe13u03aokB5FDc2cf2JsmpVWMgFsu/dIpkil6gyuNDanPPDAAaN6he+BdxdGOF20ZA/ohf/d2My+cKPd+q1m0CkYt9HJy3C6TDCEotVJd8V85Tbk94STRYmPb2Y2ujOTLmIdzlu54C/gURP0GbPmBfsg6oSAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FvFIw+o1; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FvFIw+o1"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a1682bff3cso3675805e9.1
        for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 04:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791975759; x=1792580559; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9CL2BRiyUp3CaHGocQHkhsGpx+V6MY3r8MUNMnInA+U=;
        b=FvFIw+o1No15mBEmTffSsjurQy3J9eL9/uZilHrLuguT8CfxBEM7N4qtEIkNxme/LJ
         PJd14OvuBFGrXC52acgZl+bU2XgxJwbYHV9N+GV5jFl/imCwIOuQ+mtk/bpax+e06N/3
         ysp+Xs7CN1bOWcAQ2IJGJYJF3CsJ3hWIxk1/2oAmuC0JJoxmpbaRFILbl1iSDK4QBxL1
         +TOzo3knL3AU0NKozn5lwgQ2eb55VR382tow+sEsrVZNTzrmIiYjaVPnNLsm7lgZg/yt
         WMKZZ5BvAdBYf6NLizzEWfZtgpiKyTCcLLfnXM1wBbgcaz/nK5DWfkQBklSATQLWDTKL
         oYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791975759; x=1792580559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9CL2BRiyUp3CaHGocQHkhsGpx+V6MY3r8MUNMnInA+U=;
        b=vz1ADoZtl85l+Pf0uyWXxp5R1Qn3zDD7KgEI5oNA3NzBmCGnxTAXLr6JrQMTzTFcJg
         9dCHUgNnqx0w+5/RYApnfaxBNGXrs+mPP2DvyjiWv9ViILPrrS75FiV1j5oTwZop6Vze
         2/1yUzkdizLqPLbTTpsMVi616b7cHyLpNfTYPT4cMByQuEjnIfXiaLjUDM+CzxunuRgr
         7u85NQl7O/netEc+NNoEx8/cx4b90x3gOJkFz+iBIraMUVnYG5WAsvObq+SezaqR4VP2
         J6KbY38QPbSP6iSmoGPhEbcWNhnZSoYMe0KCv70DY36KtMDr3V0bFZweBxjNBAI3d9yC
         39uQ==
X-Forwarded-Encrypted: i=1; AKwUvBwVeAYTobVUJ2srK/mZdNiNdyi++yWi8bPrMABVJAkuPTTNSd6ArkP8DdJ8ZGc4DqzQOvgWrxNPOw==@lists.linux.dev
X-Gm-Message-State: AFq9FYIo1TECCnIBRAIjTwZizY53FnhQXhUws+IpprSk8hsWaBRr7qOw
	HSxY7OxTVg4NAMI/rbEKoBEsVRJeCQ5gpTPnZ46Cth3EWn2x7t5XM2WL
X-Gm-Gg: AYBFou2Svi1vqyUdtsfbyHYbIZowIo9ro7HmXoHcI/1gus66JVuLRej7xxQHXmupn8K
	havRxuo7i5qzH0/5j/35dB9uW5Ff3CIR1rTvDgA0kN6YfASXJcK/Wu0JxsCCc31T1Y4WXr/cRjD
	BNZ35EjRviNW8swKHHHBWvSkLaetH6ZKPfSd85JhOJYTds9PrsT54emJK39hWLPNrUr9weFNL2G
	LpqRHsfUA1gMXzy+QGzXVAEkGUAqdz5MePyfQE1WXZIQYYbKiyz2wS1VF+3HiOTwxEBMSNXx+8j
	k8hd7Ch1tRr40F0ebym7gUHf3W9v9mH6sjFXDYlAcJv+R7dBsuHDoOSuJ7XLiMZgbEGzLRLQ0bG
	3eTjYYS2v4lKYPmIlkKX/dTDrVtUUzWnylUIYZCD6csS3RoKoXav3+a0S8rCDluniLEhVCSAJTG
	evw+pJZzq1gYdx9RWKxBKN2t0jJiB0I9Uuvnr0CCNnpP0h93thRd4d2FIhyIZrz3UwrCaMORdC5
	4jxnXCz3aT5NRWi/7Q02RKxh82AZBJCBNGkHExPNkvm0FPEC+D6QBCPqFtYUJnRKJX8d0bkSct9
X-Received: by 2002:a05:600c:4747:b0:4a1:77db:45d9 with SMTP id 5b1f17b1804b1-4a18e47aa9amr321452385e9.6.1791975758979;
        Wed, 14 Oct 2026 04:02:38 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1b45eb78csm38078845e9.2.2026.10.14.04.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:02:38 -0700 (PDT)
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
Subject: [PATCH v11 11/13] io_uring/rsrc: add uncloneable regbuf flag
Date: Wed, 14 Oct 2026 12:02:09 +0100
Message-ID: <c73c459578981e64a352e46c0db39ad46621c63a.1791975048.git.asml.silence@gmail.com>
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
index 54774729ee67..532866a1e9b9 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1458,6 +1458,11 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
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

