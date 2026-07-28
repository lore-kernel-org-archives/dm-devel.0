Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0952A4772BD
	for <dm-devel@lists.linux.dev>; Tue, 28 Jul 2026 21:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274197; cv=none; b=hRViy2gDwOgpuqyhRMUQv0HFD417tTTTaGag8FH1eH2FkhpYFK85hUjEi2NBNQwHnj3PC+y40IEhh6r457SeA6+mtjBZdali1pREsWPNM5t6cJnVa6AG73zKTjr80YrFrrGU6g6mIZ5EDkvWaawvmKkoBYYA2pN8CYIWHEES4Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274197; c=relaxed/simple;
	bh=ouxAbpVq3eLeqOZuflcAiBfEtTkTCcnamxD+XK6c374=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwxkeoP3R/om6E/clEWITVxAEJy5MDtVSduaZ3tR1KKBgKZPteGqOzRa5vxpE+zGrtiozpy3z8Za4sXzDO+fvbvyJi3UORw/ZvYAUcyHhm1FTZ9lo6CRM9tLuGlslMPcLAEIQH/1FrpzU491MI/LpzBHMVCBEEjOOa8z9hp8QYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZptgMb/c; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZptgMb/c"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47f703a9d05so213543f8f.0
        for <dm-devel@lists.linux.dev>; Tue, 28 Jul 2026 14:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274192; x=1785878992; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3L2paztWhQuVkOkPSkB4LVS1c8WWkooOhtLcip+4H4Q=;
        b=ZptgMb/cooJgciTPJ68X6/nfQ/LQGoAQyR0Y3jMYs0hDBaFD1Tn4I0E0JSYJVvpHaW
         t9wS9P0CFaCNz06+JJXhtq0h+ERXUoYgiz10zdEe61RnnbARXyA3C1zpMdPQkZmrljdR
         aXsyyZwrGsKr2g1Wyck8ZfwF4H5xAt8pI+DGXoFakLXpVX8FK3wV5o917U3GYXpHXHZA
         OTcsqK8YxUSauTtk2tcpCi7LXvomoo6ml9Xm1p6vhjs8Uc/m4+FeQfUPrHuvSXnTBZ/t
         VKMPOZxcPSZMMVJynW4wNIB3G8KqjO81Ygyr+eb94oG135VmS38PmG04Fo8wz1qgKQF+
         TC7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274192; x=1785878992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3L2paztWhQuVkOkPSkB4LVS1c8WWkooOhtLcip+4H4Q=;
        b=FRqfuqtBm7zegAmxDkjEuGU4qsOjCYlx077l5heHWtH9hEtFCTvKNrQe3aHfMoHcUc
         y62/m74vZTHSemtTXEWWVtIeJ5w78sSWZ5/Y4OX3ntvefVxvAiQJZAg2OV9eC/sZxuPg
         zxZbZNVBDGL2dc527HqUk2vGx8OejzYtHzNNPKnsTc3Er9dssF+W939yhYdN1hGEOjDv
         B6EKiy08xzcxGbJwuRB/0VB+4RWf2CoE/qj3Qb2Le4uBUM02Q95P4/CjDnbBiLV2N1o5
         PbT5pwU2c1+14RlzgjSMBQDvKppt5kKANmX60MWPXc3ilZoP0I+MpFTufhWxatM8GgwC
         cHVg==
X-Forwarded-Encrypted: i=1; AHgh+RosE+808f9tlnFrCXWtnEWhZznealTiInUPR6Mcs23MCpxBn/KW51N5qoYlcZeTP74yWjZcFND9EQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxKmx21KyGQF9Ato/LZpm7HlL4DunkEclECJZ8duv0snkua0kw5
	tPqfgOid8baA3/e0PeyJbdl/jlhJ3NSXz8uSuuiiyR2v6cxei3dIgTBZ
X-Gm-Gg: AR+sD12/r0G5CknkcD0ZAPqsJV7A7K5300P93B+lwf4F6kGG8PVqOl08MBlKfKkDWrD
	vPAUJ5JBQe3LG6YwSTfPvLSM8X1y1q3GN6AHdXZAOfOQILjflES+JHiNWqU4ttCA6C0ZCMs4umQ
	sorPrHx8a1bIn7LwQTt5enASEuLAGuyvx7gdZOIWDH7ADaHds7HGrJjLnpvZiBzqYtPeXwr51iC
	tT3ovYFMcRtCQdAe4taazRa6Bff5xfq134x/NzZH3at7vf0/eI0ByRlp6OXzJiMPJ0H/4aQtPJC
	w+QSbVv9hzyKFgnYp7CjbLn8FK+9/sos2Z6dvlPFPQXjshD/KchbTMfjpMyDp1eeXV++p4F/3NG
	4IZt05lmcsjqOm2mLe3K8ZiuT1TYniYnzcfcYb2+Qp8cOz1vwt4TewpAwqfyZ98AKmdlHK9NST2
	PUc0HoocJQxvCOQrG52th/DIlWMwfNtnLDpzeU/PlSenQWH+eCDElXy+EBi/ZpUyLUWe8Cdvpht
	sthzefR
X-Received: by 2002:a5d:5d06:0:b0:47f:947a:9dba with SMTP id ffacd0b85a97d-47fb1e5ce09mr5390953f8f.6.1785274191852;
        Tue, 28 Jul 2026 14:29:51 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:29:50 -0700 (PDT)
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
Subject: [PATCH v4 05/14] block: move bvec init into __bio_clone
Date: Tue, 28 Jul 2026 22:29:17 +0100
Message-ID: <7423d294c6184c683d7b2ccddf060b4a308e0316.1785274111.git.asml.silence@gmail.com>
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

Consolidate bi_io_vec assignment for cloning in __bio_clone to keep any
further changes in one place.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index bfaede30a54f..57c127aee116 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -860,6 +860,7 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 	bio->bi_write_hint = bio_src->bi_write_hint;
 	bio->bi_write_stream = bio_src->bi_write_stream;
 	bio->bi_iter = bio_src->bi_iter;
+	bio->bi_io_vec = bio_src->bi_io_vec;
 
 	if (bio->bi_bdev) {
 		if (bio->bi_bdev == bio_src->bi_bdev &&
@@ -902,8 +903,6 @@ struct bio *bio_alloc_clone(struct block_device *bdev, struct bio *bio_src,
 		bio_put(bio);
 		return NULL;
 	}
-	bio->bi_io_vec = bio_src->bi_io_vec;
-
 	return bio;
 }
 EXPORT_SYMBOL(bio_alloc_clone);
@@ -923,7 +922,7 @@ int bio_init_clone(struct block_device *bdev, struct bio *bio,
 {
 	int ret;
 
-	bio_init(bio, bdev, bio_src->bi_io_vec, 0, bio_src->bi_opf);
+	bio_init(bio, bdev, NULL, 0, bio_src->bi_opf);
 	ret = __bio_clone(bio, bio_src, gfp);
 	if (ret)
 		bio_uninit(bio);
-- 
2.54.0

