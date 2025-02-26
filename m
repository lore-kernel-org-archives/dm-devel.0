Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8720E22154E
	for <dm-devel@lists.linux.dev>; Wed, 26 Feb 2025 14:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740580739; cv=none; b=aULbxwhfn7WSHrp16UpZiQT7Qkid59vRE9JjJcQEoyAb10bz9Emm+Xs0sMqdvqjqR6AfExJIHPdDW4m8l5tmFHtw7VzodKQQ5Qgszv91RyArDajCoQipBseXTSgTBXJzky3PXigBM1D4JdgzMOQsaiQzE6GuLKfQh5u1YWlon+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740580739; c=relaxed/simple;
	bh=4HzSOBJ7v/xi/lFkR0PWK9gzb3mxTpLXn2xOOncdSSk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=S66cnmOmZG4OOb0+pcxAdXb/nWI084yg6+69BsT1lByBeYY1+1lMBFEfmBfNz7v79dfrYV8rfBe3AuayoMggNEXJPuM6B5kc7+vk77PG8qeo39hvczf5cO0+C8BENeClr58+cxa8V7fUQgAb5RMDOf6CjSeYxRb7FxzFqGIDwPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=g5kGKJE2; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="g5kGKJE2"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d19d214f0aso47220685ab.1
        for <dm-devel@lists.linux.dev>; Wed, 26 Feb 2025 06:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740580736; x=1741185536; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KjfGHR3mANWfNEqN0oG3qrm9QtKnyMkYTku5fjSXWXk=;
        b=g5kGKJE2XhnNPDDq4ukLSKRqdsbGA6n5mhxzLPL9C/RKnchgMnNGoDNdTOkywvpNLs
         KK8nRL6XgiA1hxY+BrlJY9mxrAqket7Lq0XVysywjgWp9R39Y9GsrLfNwk5g1DqGscMb
         lqUfNgYPSt2jj/E0QyX3BpyGWzAnMr04eMnlW5VkWPH+U37PVlvY2rZoXfpCi9BWWZVW
         REr5ex8Uly14uonP1w1DKXL7fj1hBmAKXnsbGxFt3v7pmbUsaMraoQ0wfltG88e5YrjW
         GHMXnjxoxKTSV6hMYF9KewIuOBT5byvmVtTOVoH9gET3vBbFx3fHrr6UuivbfrBCZ5eo
         fEFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740580736; x=1741185536;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KjfGHR3mANWfNEqN0oG3qrm9QtKnyMkYTku5fjSXWXk=;
        b=hGXgY8IrLFmByLQL/Txq8f2mybuT32c2DztblgQCdl1s9mAazc7uUsUVILyCcxcydX
         uAXE14baYb6l9NcEi5YMDIyYNgYIWKMN8pAfT5yIiRasRJ30dmF63SDTr7LqzxM0nUeF
         XG1wKixtsU+EXQHuqSX0tchdz49lR5zicL42vwX1dfITFiRWakT4NoNZr4emEQcSBwM4
         Fz1Lv4KFUky2IzQw+fNplyzNTaSKDwHVSevUkGvwz3JAkyjhgpy7Uib4zS5PI6UAjVZp
         W3NWqUWDKPvXAW2hmHoNzAmaAsQSKQLlh/mvhSvDvT907FbMFevswLR6jFA0dVz4rFuD
         PcFA==
X-Forwarded-Encrypted: i=1; AJvYcCWu4f5KsIjKQ3/eeFD8lyTjdmT/zNgzRI/8YbTUhVu5Qo0lNPjn5EsoTdKLh5MXneDAd1X36oPy2w==@lists.linux.dev
X-Gm-Message-State: AOJu0YwdDVRI9p00u6jUyl3y06I9aIBGUlpMvWoSEwJXtIHOoH4VXyI6
	C0Nh/aKgI3eyLyEdDxV+LI25dS/7yaQKzyoZHxk27LJzcMoNP+8Ge68ISGk4L6uYpsiJyC95VFV
	L
X-Gm-Gg: ASbGncv0KJp+q1BY5jcKGU1soWP4KgjxFiLV7gL6UNTi1muymYSWaqqbG833qxv9E1h
	8FBEtTWFMBf/bS2Pl29aPKfl/nal9QY/k8Ik2EFbahAlkUfmnHNVxx4Gh7uSogeSisCZTbA9DT1
	JOlJ42WW1pEWhOF2cFuefe2k4y1Px1H/62Pn2nxQkEf4YZFVqhGRzmUHZQRKzSPR+ndEuZfzDt4
	2HSgM7kI61sg4ubcEZ3wHbL6o8rpEWkLbKJzT4ML7sSpmMtMsD3EuS9fqlEDevQhzSgmfxKyxxW
	8D4Qe8A2T3M6tfZw
X-Google-Smtp-Source: AGHT+IHflMMR06CSDj0x1e+Hr7qg7IFtXxL9jnnQbF/txci+w+Cb8i5OqK2W58Pz8WpyNLiBoDGK+Q==
X-Received: by 2002:a05:6e02:3d83:b0:3d2:b930:ab5b with SMTP id e9e14a558f8ab-3d2cb473053mr193915355ab.10.1740580736635;
        Wed, 26 Feb 2025 06:38:56 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f04744db05sm945841173.1.2025.02.26.06.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 06:38:55 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai3@huawei.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, 
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
 target-devel@vger.kernel.org
In-Reply-To: <20250225154449.422989-1-hch@lst.de>
References: <20250225154449.422989-1-hch@lst.de>
Subject: Re: split out the auto-PI code and data structures v2
Message-Id: <174058073532.2232453.9396018019259516741.b4-ty@kernel.dk>
Date: Wed, 26 Feb 2025 07:38:55 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Tue, 25 Feb 2025 07:44:30 -0800, Christoph Hellwig wrote:
> this is the tip of the iceberg of some of the PI work I've done a while
> ago, and given the current discussions it might be a good time to send it
> out.
> 
> The idea is to:
> 
>  a) make the auto-PI code stand out more clearly as it seems to lead to
>     a lot of confusion
>  b) optimize the size of the integrity payload to prepare for usage in
>     file systems
>  c) make sure the mempool backing actually works for auto-PI.  We'll still
>     need a mempool for the actual metadata buffer, but that is left for the
>     next series.
> 
> [...]

Applied, thanks!

[1/3] block: mark bounce buffering as incompatible with integrity
      commit: e9945facd48d2d5da87fa247f5d6a19c23d935fd
[2/3] block: move the block layer auto-integrity code into a new file
      commit: d2cfe5ceca59b74ef96bfe00632e3927d00c9918
[3/3] block: split struct bio_integrity_payload
      commit: 1972a1faaa026eb34322a2b4fcbb3c28d68cc5e2

Best regards,
-- 
Jens Axboe



