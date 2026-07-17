Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3DD3E4C65
	for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 08:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784277606; cv=none; b=Q0b9akc0d0O4pr6odfgvshH7SuAOWlp+o4PlVCVDYyOZYxgZ6jI/WJCAT/PPQL3I/Fwl9vUvzb1G5rTxC5LLirXG8zNGRNJz8qoJXrQfgrpqJqor2aIgmojEJ4Ubhks67CeKJUhKs48RQFisCH8wfVmeKPPXAtgBGGaPl6Lsv5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784277606; c=relaxed/simple;
	bh=GZ5gwgCP2LA26o6pMZlFMuRWHmWxQ6Zx+dcQOna+q7U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fvPBH7cfIKcuBXh+TWXQwQdF7SIGYwIZKUSfS62gYCuo/ngc8VmjxrdMCV3+oqSBOa+VxtTZ2cg56yjhuqXnylXkOZ8983t/FTB9Kjoz92Vk7fhsoZ+CmZsDjzX4RUwus7SE+PEwTaMYEu4VMpqECwylc90VP0g8W/Zqn2itPaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CFdq3nbD; arc=none smtp.client-ip=74.125.227.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CFdq3nbD"
Received: by mail-pj2-f3.google.com with SMTP id d9443c01a7336-2ce7ac92dfcso33173455ad.1
        for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 01:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784277605; x=1784882405; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KezZCHqRxWTLWtHb/Ud8bW+hXzNnb7tgRNgyfGZ/luY=;
        b=CFdq3nbDSSIvjQeI67NOBbVEiVaIwF9kfmTZWSUJRI/Ys5fVY21DJblmb1c6ZLm/E6
         dsLj+jwKLUpXE/5kPsA0JBxiTPtJfIboQ+x8Z3urYA4OCFLdVBs5/HesdVtuFtNnGtsg
         h2I4RRv9jjGsXpzNtqDfqnm3w/1xXppN2IxcwrMpMvxwqY+kZEM5Qd/TsSvuXw38X7Fh
         M/s5AcdzM0QT3MXoUsIwOzhLZ3qKTUhM7PDjHn3/Wv9nwhj0VMpbyzL4gbfFl2jV8LTv
         AVXBbbTLKyQraYmlIdlT2I7GwT5/aNTmQqzzUcWKlJatvN5KZzSYjSFCXZR87pTQ1Y8w
         Pn8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784277605; x=1784882405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KezZCHqRxWTLWtHb/Ud8bW+hXzNnb7tgRNgyfGZ/luY=;
        b=okIC1Y3yQTSmrn6EpmvJIzplc/5QPnN/3904GnPfHCF04BTmNxsFmW8UIDlv5zzi4d
         cBlsff0e6bCIk/Morn5M/0Eij1XA4ES7WRiwAV2NU+vRlRwfo8W+INUQgGjY4g5YhlGh
         ZkXanfxLz+1wDHL6oC0K1zt5G1iW9WC+qEff1TuzGnPbTSv8TQJWEuV2jrugsXIKzDNt
         ulxJwbMQTgMlJk1bKHsGVf2TPEaEf/bfQmAe3ZLF5DI9CCVEktt/ksZXKv9l0J7oaY3F
         2xfaxq1+ndZe/RMEIO+Ihx4iuiWOVO7/DjgvEk2nYGsFb8+rQ5QdAXrjd1Siy/VBzBxm
         Vftg==
X-Forwarded-Encrypted: i=1; AHgh+Ro9N3hXGTZaONTUf+J2xUXqk/i+Z3emm0g+v9mew+wXAq71QRPukzofvD99Yfp3ji/HlBHWBe13hw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyfYTVbYGWM2i+E3j7S14YMAovd6i7IHr3VQN1eAdpyASRBp3vh
	DYnTCYWXc/s+EfFdJo2Ba6u3V1cGJyNUx6gHlBMdIKdgqQChl06ZyG62
X-Gm-Gg: AfdE7clzT7rMhEE5Goi3Wx+kdN42mHlXNUPt8P6Zyaz/ixZ4KIPMZj0CaS/nLvncVar
	5XaC0wtu6D2ucgp3okeTjyemC40dHVRbOSTJiSwpKcqwAAk62NN5lmYICetoTVs/0LqmwxrPDEd
	LZ4TeLd4Efty10LZOalPuQandDdwsb2BPtWCPrJHRpKOOCWsh/JSTRQCUTeqaq2OPcZR4ab0oHp
	g/vODpL50J/Z/NyJABCw1McaZ6Fv9BK2bNa+cS5DIcHjNkZ0PmYUgRkGp1bae36cLH9Ns4HvfB7
	qPDsLZelUVxDNoo+ISsdAkZnTjqWR42i20JyVIuc11RbokNwP9QwTS/Ufm9gLfszuYAIWxrLaWM
	8ye+FAf8CO0GeLpcZ9+HOq+hyzlWeLB3Uy1UlzSRyM80dwQaEJNaDOFgyR1VtKQlKwNe9rSFzER
	7UwspCmdZXWbiJYs7t6OFzGDBgAtk=
X-Received: by 2002:a17:903:24f:b0:2c9:e9c4:82c1 with SMTP id d9443c01a7336-2cf3494af9fmr17587945ad.26.1784277605056;
        Fri, 17 Jul 2026 01:40:05 -0700 (PDT)
Received: from DESKTOP-P5RIK7I.localdomain ([118.112.177.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf344be458sm6842445ad.25.2026.07.17.01.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 01:40:04 -0700 (PDT)
From: jianyungao89@gmail.com
To: dongsheng.yang@linux.dev,
	cengku@gmail.com
Cc: mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jianyun Gao <jianyungao89@gmail.com>
Subject: [PATCH 2/3] dm-pcache: simplify cache_seg_remain()
Date: Fri, 17 Jul 2026 16:38:55 +0800
Message-Id: <20260717083856.12820-3-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260717083856.12820-1-jianyungao89@gmail.com>
References: <20260717083856.12820-1-jianyungao89@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

Remove redundant local variables and return the expression directly.

Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 drivers/md/dm-pcache/cache.h | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
index b1f44f62e336..08a9409deb35 100644
--- a/drivers/md/dm-pcache/cache.h
+++ b/drivers/md/dm-pcache/cache.h
@@ -517,15 +517,7 @@ static inline u32 get_kset_onmedia_size(struct pcache_cache_kset_onmedia *kset_o
  */
 static inline u32 cache_seg_remain(struct pcache_cache_pos *pos)
 {
-	struct pcache_cache_segment *cache_seg;
-	struct pcache_segment *segment;
-	u32 seg_remain;
-
-	cache_seg = pos->cache_seg;
-	segment = &cache_seg->segment;
-	seg_remain = segment->data_size - pos->seg_off;
-
-	return seg_remain;
+	return pos->cache_seg->segment.data_size - pos->seg_off;
 }
 
 /**
-- 
2.34.1

