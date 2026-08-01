Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C433191D3
	for <dm-devel@lists.linux.dev>; Sat,  1 Aug 2026 15:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599320; cv=none; b=EArKTA0Uu47oMywb7tyw7fxXiCL3RGz3rrJrUkj45PGqUNy4eTmQXmdxP+HLxrbJqlvlO8el3C/Y9L+2HTOjWOtDzof7Inzr7g0gMM5z6okRa0/xm95+2+OHZF8eXte2CafoecT1o0quJB3MnkoE4dvj1xvzB2D2GIGwt/yxHX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599320; c=relaxed/simple;
	bh=1jBAtnFGRJ/F8gXs/co1VF+epb8VpkeomtOw2fyD9ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdoNMvHQcmNqu+3LqMrHwr1WpdbyB9+lpqXob033Mcj12zuQz7i4/gFm1gJujyKpaw0I8FiSIilWqL3aHp6cGaoDkdoGF0+uWC9GZwiayG54/ijxISuZ4YYhkfv0HkNu2LxIiLrbsmD5a1pikYKr1QTUWX9gA2t1KucAHK33na4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vdcr+oBJ; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vdcr+oBJ"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ce98cb8165so20866865ad.1
        for <dm-devel@lists.linux.dev>; Sat, 01 Aug 2026 08:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599318; x=1786204118; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fyuZF+rseQvIVevAALiITcY143h/8lAr4kofVhDXVW8=;
        b=Vdcr+oBJ2GQxBeBdGqhxA/M3VwdNr3yXmNDOxDBNdmwJppwpTYSk/JfHfkMeoUytj8
         5XhcmGd3oirL/ywU53GwhIpwmwomC9+K6FixvhMCwvynP3j+oSMRepy5VbNNtqeyCr7u
         2ZtaGceP628Wm2cZIVpJ27SOHjydlLFebSn8tDKUHaE1J+7bk2OWQaFdUBpdUI65V2cf
         3r+nyIeNbp/92HyzlJHRczIrVaEkGaNGs5xq9TYqFpW3Ar6qV3JS9UKO2jD5q2L+EJH6
         DcB3j7xkNNzDxZ0b2xFD0iMrQRV3PwxnHjx/U5r2FIRr24lSUYsIoYkuQ+ZWUIDN8+hR
         6nrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599318; x=1786204118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fyuZF+rseQvIVevAALiITcY143h/8lAr4kofVhDXVW8=;
        b=svtEfFRtBwgn0/mwTXbUPh9qWGsmuWbL0x7SCrxyTmC2NKc2ZxcnSrV2EJy4eSvKyO
         1MsAPQd4jDDDKdi+H5tIr09vfc9p4s1LBjjgAUsXpeqWrPqncZL0EpwiSg6HsyBb0uyQ
         6V4Si6jd+Y0S0FQI/Lmy6W4k16F84X9PaUhqyU2RB7Y73jiKNBx1qHluxlv7CNsNeDNf
         i2V72V1bn1gTUDb1efwu2UYp8bkudsTU8hO/DCVYRIkU6xFNMqWSV5kPP4gKoEFAd9FV
         P3jDDAcc+kPPl5bv0TIxN/WrKToPO9NmDvAXLzzEryjU7BliRP/XeHSff+sKPkoekUb7
         xjgw==
X-Forwarded-Encrypted: i=1; AHgh+RrFA5yUMDL1z4e0p2wD+E2dDfO1Msk/KC9jU/MMAmZ6VJUDsE5bHzUVSTprwnNSta1uCu7fGrJWOw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzKQkACqqdwiUurArH5RR9kChmSOjwNlX/kn9eQ46ZWmnedvJ18
	o2VXwqkuodpyl8IaUkhQO4d4hHjbmCWoOEelOK8isHCRtjLraJV8OS4K
X-Gm-Gg: AR+sD10gUPA1jxEKnVpVM50oDuokGKLX/9myiYmZzru7ETO5MJkyiyNPzQn8V2Lf8Wy
	y/SCUuL3uD/uDvd5JbKviTMy+1ErxblOT9PZnG3ksdxdBVCwGrr9OsdnUx4wAK7Nz79zb4UFbGz
	NX+7LaDJ2wKO260zJyWg2zsqwCOuQyIy+3+exjJ/W0ExPD0K5+h7W2zuNL24OKn+kxOmeREBRS7
	Sb+vTs+VdhX4KpVCqEgdnVmn61cKSHFYBIG+mv+ckEdSTIHAMlPmtL3AWOKryQPn0T+a7gts1YA
	U7wD8mJwN7HQniKDqOD2Tb1LDdtiUXArxkbl32o3FlE4DAKb07B4Eun7tVCZaClDJN+k5VxMfGj
	MB77we1vrtOYAovLI7jMxCK9SEWHVspe3bmF8+A0WBPh/cbYQhrPEso9JF9ZGjOvAy0mh1rvUR8
	6RllkE3SZLO5ffGYPhjk8Md2jo8+usnnNANjwkw+iBd7ZLl8gCV2xXuE1tMdygQyMmb6jGUl/dh
	oj31gg3Wcv0PHIHGmo83sd7uFgaQOydObk0ey2MLdFa8Bw=
X-Received: by 2002:a17:903:2c0d:b0:2c7:f5c6:c4a6 with SMTP id d9443c01a7336-2d0535b3b1amr33657505ad.7.1785599318082;
        Sat, 01 Aug 2026 08:48:38 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:48:37 -0700 (PDT)
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
Subject: [PATCH v5 05/16] block: move bvec init into __bio_clone
Date: Sat,  1 Aug 2026 16:46:17 +0100
Message-ID: <6ecfe8f9b1c6bfb8665fba7daf55d9ad7a8a3243.1785596451.git.asml.silence@gmail.com>
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

Consolidate bi_io_vec assignment for cloning in __bio_clone to keep any
further changes in one place.

Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 4074a0496b93..00f99d03ac91 100644
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

