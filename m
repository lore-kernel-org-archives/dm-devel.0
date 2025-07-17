Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECA329CB32
	for <dm-devel@lists.linux.dev>; Thu, 17 Jul 2025 12:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753716; cv=none; b=FeBwrK8gwPCP7Pi7ZqliLSXkuuxbjLVCGpIeJ7WIi/+BXodxpcO3HmvKzYo31wS0EeoZ6OTFyEW8IY+H2rPbXpGNVlG6SaWM0HmzK4RVyae9pqcD/C/PJscncgSLU8UI+ace5w8spvOQ5MmW3UGgn8P0+2P5edVQcj5oD+rGX2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753716; c=relaxed/simple;
	bh=kjEyn7nEjF8oiVB6GgmGedSuLAr7HCIjBycrDFOZBKY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fP6e7N/rGjxt4Noq9A5gqdRJWO55NkqXeO8tNiAwp7uQEBWRC5mDHflpVXWiY3R5BEKL7gUNIfh3mG5DoDsnZw3YCWu+MAc/D56NwIIRkMSm2DInwTslSwEA5kwRVrr7Sbwu9ewbtEllVWPqF6QbGbR1gi8kpqeRZgo9+xS28v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=llTqYxwM; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="llTqYxwM"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3df210930f7so4230195ab.1
        for <dm-devel@lists.linux.dev>; Thu, 17 Jul 2025 05:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752753712; x=1753358512; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61ZOPEc1Npv0N7lkKyvYLgeXrgu1p1u4u8vtKljsiog=;
        b=llTqYxwMOos20RYOzVN1lfP1Sp4RMz9uf2UEOnyc6J56FfUWMti+GiZlKmnuLdTjqs
         gXwxt/Siymh6qXTu9GuoH1rAQikV7zuzZDVJxgOAxxtobzEWpD06gepFi3+F3zaXJHDS
         Iv0RQv5aPXcynEoyeZj1fnD7kUACEtthIuuwfByjoLF6uz3XqS3o3ibflq/QkONqrIhf
         pB5AQw6mg8G3/USnKKWFmZGVYhPEIjWbdukhus7QlDZ2QdHyONHOz7/wXH2eCOZ+7TU5
         bTsz/UZcjalGvv7CsYT6Vx4bfgrgdYh+sURLby9r8skTx8lun4FjuYl25UfK50UZD5mt
         x8zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752753712; x=1753358512;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61ZOPEc1Npv0N7lkKyvYLgeXrgu1p1u4u8vtKljsiog=;
        b=gU2a0DP6BIqPHJdG+g22KfGjQ+fLxW6PpL5s+WvaTYDtq/QXfSL820e6oUgIy6pD7n
         TZWx+8ny7dR0wThIJBxvCO6XSYQkgA9C+Cc6FcUnDD97CatYPAlCdC7MGaTRXt1gMqHO
         mqxLrJttuR64I8gRLNc5X4aM3O+9aPfVNF8K5d8IgL8wiLr/j1ZfQ7jBFkNtHRSpfdDv
         h+B4nX1HoU4mQkZWKUbDbsVlnChpBMRitmCnJ4T+FQONYsRr0xniqIe02X+cSijyO7Tz
         AXWBFmeZnWL2UW92S+xqEuP3GR0TkgJy5INKo7EdDZri/3UYl1J1Nvgd+WuaE/LSobza
         nGWQ==
X-Gm-Message-State: AOJu0YyH7lM/8ocqEQBaELN4NiBsPIXtfH58ncEqUJxuo9kHQYkn2y5c
	k82P8xwf3gFBM3xrJr6POp++ULlnZT4Hxw71/gvvnd+israv95AFi0ZLrPEGN32YbCo=
X-Gm-Gg: ASbGncupM8YdYqID2fIvRGJsqc24AVWNV8VO2HILbEUP/YQvvUPuz+gEP2ELfrPUftm
	vvpwqMHkHXcMGqVrxajjJXo+nnk637xybXDLWME2j9+cUliEpKz/k9rtiIusS7DJ+fZ6XX02+Pm
	ZaEWz3ngpr3ld1HeER9M8Re6anLNgs+eFzZAsnA8nv/D7O2Mlm+wFdOZFF+cHxjAiX9DYETPGUF
	IEp2JrGOinVMBPHr1JzWxi1GnsL0qX3AJOK2ORkQQNQpdQqjWTIiAiB95VWphZHBYZs1dbXifNg
	FxsMj/kLys89J/6SG0Yy9ogpEZ6kdGC0BMXFvKNeM+pZedyWO91pDZQPzyBbBqLiRe5uODrYBcF
	ZvEcLNZ240N899g==
X-Google-Smtp-Source: AGHT+IGuqUVz1MlM22DWouaSIEqVc7JUz/swP0ZPOQK4pvQiO3B+o4V938h5qOKiQPbhSq72i+cb3A==
X-Received: by 2002:a05:6e02:4618:b0:3df:e7d:fda8 with SMTP id e9e14a558f8ab-3e28b718bcamr29664265ab.1.1752753712400;
        Thu, 17 Jul 2025 05:01:52 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e24611ce92sm49563745ab.6.2025.07.17.05.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 05:01:51 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
 song@kernel.org, yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, 
 cem@kernel.org, John Garry <john.g.garry@oracle.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-raid@vger.kernel.org, linux-block@vger.kernel.org, 
 ojaswin@linux.ibm.com, martin.petersen@oracle.com, 
 akpm@linux-foundation.org, linux-xfs@vger.kernel.org, djwong@kernel.org, 
 dlemoal@kernel.org
In-Reply-To: <20250711105258.3135198-1-john.g.garry@oracle.com>
References: <20250711105258.3135198-1-john.g.garry@oracle.com>
Subject: Re: [PATCH v7 0/6] block/md/dm: set chunk_sectors from stacked dev
 stripe size
Message-Id: <175275371113.371765.7347642796595215334.b4-ty@kernel.dk>
Date: Thu, 17 Jul 2025 06:01:51 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Fri, 11 Jul 2025 10:52:52 +0000, John Garry wrote:
> This value in io_min is used to configure any atomic write limit for the
> stacked device. The idea is that the atomic write unit max is a
> power-of-2 factor of the stripe size, and the stripe size is available
> in io_min.
> 
> Using io_min causes issues, as:
> a. it may be mutated
> b. the check for io_min being set for determining if we are dealing with
> a striped device is hard to get right, as reported in [0].
> 
> [...]

Applied, thanks!

[1/6] ilog2: add max_pow_of_two_factor()
      commit: 6381061d82141909c382811978ccdd7566698bca
[2/6] block: sanitize chunk_sectors for atomic write limits
      commit: 1de67e8e28fc47d71ee06ffa0185da549b378ffb
[3/6] md/raid0: set chunk_sectors limit
      commit: 4b8beba60d324d259f5a1d1923aea2c205d17ebc
[4/6] md/raid10: set chunk_sectors limit
      commit: 7ef50c4c6a9c36fa3ea6f1681a80c0bf9a797345
[5/6] dm-stripe: limit chunk_sectors to the stripe size
      commit: 5fb9d4341b782a80eefa0dc1664d131ac3c8885d
[6/6] block: use chunk_sectors when evaluating stacked atomic write limits
      commit: 63d092d1c1b1f773232c67c87debe557aab5aca0

Best regards,
-- 
Jens Axboe



