Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8730955D886
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 20:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791924948; cv=none; b=N/noMKs8V1vk/lcrG41pPaDRQtjgSfiVctxHx26O//v8WJdg3br5+Mrltzkufh1+j4y5NtYBbuGuOc0tPzbW4Fc104Hr1lH+CvRL0T53/z2rhyvdj9EC8FsWyvPTpJxlD5abIiB0qlDW+bKVjkT04pgEO2FuOOPHIU8YxHK/CbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791924948; c=relaxed/simple;
	bh=Yz9mg10bqVdj7cVQ9CUCuhVSPCWk27GUE+7ZZMs5kDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUEyrM6afRFIWdtVmaQYjArKMmzqZssYP5zJ+7QCmqMNMsvVJCOxibeX18xKpjD4loEE0I2xpRyyXFA7z8mZc8yzPCrExgrQ0eiVcXk7Kz9zCd7v/AsMkqTNrvtVSC8yB2pI9BYwoAZFHRRdCqV4J1m7gniCx2b7WrrkabDbPok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FTCu7GnO; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FTCu7GnO"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48afe75f055so3111074f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 13:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791924941; x=1792529741; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9CL2BRiyUp3CaHGocQHkhsGpx+V6MY3r8MUNMnInA+U=;
        b=FTCu7GnOqvUIAc4xBWTKfm0hue5ddr0eCj5LvRX/ynJLnLNYn+106dHkuqKHii34dW
         ldHrUnshEs9peybK1D8JeNNWPu/DOZGr+5Lpk7q8nwUcQhg+B3j4W5jRAAKxrzsr5tEn
         U08BoHG9c/qCB0CWa+SWVnaCOjgxrE2io35Jg0oPrqrajMtBcQpn0t9lUpZL7+ZnQKzg
         b2DLZ4oXaY+c8PbH5p55C65VDjgx6DJhUI2J8Sl2pLbFHhkxE9OCb3UOA3ZsquVkVokM
         kajXcqAYkR2L7RIxhgBx6kV/Ap3tl1L+jreTObwdmi5hipJY/dk+F1vFf3Q0KKGUau/5
         CU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791924941; x=1792529741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9CL2BRiyUp3CaHGocQHkhsGpx+V6MY3r8MUNMnInA+U=;
        b=hM/y29lglrGtT0mpLDSDsluzEXUncS9wdK9QVqyIuKgJ2N3m75YYVFAkxCjmFPXfdo
         TPxakXh5vkaGebUtBlpu2bgvvAtUpdbJJnwplhjYA3sPD2STgnf1WU/AAjn72GOcu/0Z
         6ISH7yO040EsQymqqfEtsMQ1TR578rY6cXMVXzUgEQ/iabP2oAFHXBvimHx2gO1RDOcu
         XN+jVwMtcOAjXhVU9l/IO/03+SiKdXPI76J5gUV+kA/NRQOkTkptVSWJExL3xVqjBBQ5
         h/gcZQD2qICUmiS2G1ZytR92K7WFBxraI28X7UNbyS9X/LHGfOR5VL0ojVLIhkQBxkih
         2QNg==
X-Forwarded-Encrypted: i=1; AKwUvBwkhZdWXC4XZkUuDJtJ4HY+hjzXRdAAf4WZwUMeyhXEXpUeZ3hjuM9pN6mwBxipJwv25p/TST43/Q==@lists.linux.dev
X-Gm-Message-State: AFq9FYI2b7MqURcWq3MPLA9DoUywaqXxPJD79doFb00pFbMKtn5tZiyH
	aBd+mXv45R/1IMHicSW4n41IFTpGxHdvNYZlSttKWaLQjO56heDKeqHa
X-Gm-Gg: AYBFou0Fub7jP7IIO+zwzICZmbuopR8497OBZNtpp5AFs9xZvWd4nbkTaz4wZOKSa7M
	UIOZAobjYH4HbN70f+LWKlX/KmhPkH3PkGRdcCj+VATentu+eYKqnlJjOtkZfPZMydEKnrtmOyg
	Lh5T9kH5n/cGW1gbkDiGxHiyVXwytnWu81AWJHzCxgKvAgeJD8TJIdCtmnIcoGDVG8H268/TADl
	Wnmd9mmrAlX0gZEVtirv4EPd538ywdgLb655bNM0/EDL2UHuBEyGptRce9wN0Cy9c46iKJcjKS8
	p+hKl2ihvQaS1dWQ7hwTNmonO7CD/DIrTihLxTsF13gCIt/tZW6E20WFzpyNZHtIevBAR2puoKB
	//Sq0jaZjOeN/tTPiKDEvxu5KQV9Yc4iV5AyeLSHJmTT0q3S/3cL8G/BMSeD8pwqso6v7NWUG7u
	0FLsWho0Q0t23SAknROD2+2BozwzGSZazdkXrKGfNcSqlwT98Ck//EyWLSOx7028ZjUzzwYrlkH
	2NIw2XEaBSX6amTsWdtAOWYGou8LfMg8F4VB9D39AuMUa/Q5RP1NDeVrXCAXLHUFn41GxQg0XGu
	1j7EdqNOsf0=
X-Received: by 2002:a05:6000:2407:b0:487:1ddc:aaff with SMTP id ffacd0b85a97d-48dbace40cfmr24537298f8f.44.1791924941527;
        Tue, 13 Oct 2026 13:55:41 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de7273a0esm2380730f8f.29.2026.10.13.13.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 13:55:39 -0700 (PDT)
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
Subject: [PATCH v10 11/13] io_uring/rsrc: add uncloneable regbuf flag
Date: Tue, 13 Oct 2026 21:54:55 +0100
Message-ID: <b013774568929cbc3e6fb9ed29079088a1006431.1791924581.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1791924581.git.asml.silence@gmail.com>
References: <cover.1791924581.git.asml.silence@gmail.com>
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

