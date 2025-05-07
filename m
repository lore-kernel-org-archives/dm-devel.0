Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA9028934F
	for <dm-devel@lists.linux.dev>; Wed,  7 May 2025 14:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746626556; cv=none; b=QB7HPmAvLgo1eoi02nofk0aWg2w9A20T6kVwjb5rXCpzBa0mqyLcZilZGlopYuUeh9fbj8jXcyW4x1KYz/Y6gCN/4SOY213/Tadyphw/maenOuIaFzkoGmgzD1hB1Qlv4Kt1Aw7vp1A3XNh9vC+KsiF8NWVjcE+EFNG2s2aharM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746626556; c=relaxed/simple;
	bh=u1WvrSapMzjyS9qZrw1hKIGsBWOqDhnGPCP10gYW6Cg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=f9fTqDJlH0WNQ8rLUttBjOXjR/FG+1usXwWCkGb3ooZldeKpWVWXahTgRt6PpwNCRwIGlsEmtHOALQOBn5K9faeEsUhmIuxbYM+A4Q9l7hwUG8jNW2wOcH7Cdf9hwRRVyVsg+x78qlVH+bm/Mh/Ot6GJ3iNHlbI527tQBN+wvnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2LnBJlK4; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2LnBJlK4"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-867355d9c4eso48223739f.0
        for <dm-devel@lists.linux.dev>; Wed, 07 May 2025 07:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746626553; x=1747231353; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/e69eX7rTdQU3DebRyniOro00nTR+2O7+QHGV+7EO0=;
        b=2LnBJlK4bT8aIlSWgDTiSq2/M8OPZ55H+UH31h6vtjQhRJO1H+75L8CN+ldDexeTvf
         vGIgwYlWcDestvqtuuK+F/KMzMgD7AV4bA9FlK9p5gjX27jrlzx8PEhWEE/kAwVEEmue
         GkldGjRtBSMMd3DHIWsnGKcoo9R4bXUGmwqgtyVpXG4ATLCWx35M1/b9dvuztR9idtl1
         gEzjVInUwmA+pqOnWtwq3ghA8MMprd73UJ+YdO2ialwgUs4SBRmN1tnB28/TNLB63QBq
         BK2JUoWj5yOgdYOFJSLcgmfYjeSp5xGS087shs/CrJYy7uaB1Z9e8mh3M8NsP5Ypkn/n
         2X4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746626553; x=1747231353;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n/e69eX7rTdQU3DebRyniOro00nTR+2O7+QHGV+7EO0=;
        b=C/u2PgilWAGfdudTcqp1ADB+SSDo+9OBwoWvk0veEnrgh4QJ4rr7LkdZtx1a3veamG
         IIgRPL08FjWUlTzp8jQ1Jf5JHGyRR3kaw0ngDwHqNjR6JrdvRRG/k41eKi7BUduaXNMO
         H7+V0TFtYsJjzrfbznKxcR6l6n2crBFgrS2sXt5S0cUXqPrMNxe76cilvYNQabtZVDAr
         Qiq1ADaL0CHS3gZARHqftTFx0q8Xv15RkU2psMdb5eidWr6kZM7alzlxdDDIAVrgzF2t
         67C+tKiGxF5Jjj7lBA+2lXvPeRc317FtejhJ8cwuofWLX090WgEmuJyMmlAt+dy962IQ
         pRAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVBXZqYJNs4xEkq6zk3NNh+ZxVhB6uhFsQpsp1MNhrA6Rxo4nEC5YVq5OnDF2vEYiCHGAVXUBPaA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyocTAluaxcWyuABlbAMVZUKB6M0gS3d4h092GtEdHs0h57rVct
	+3nxCJqi3K1xjXqrQS6JM13/7ufT/YtAnp3GJslA8LQILVyRa6BjJVxaoxK++oo=
X-Gm-Gg: ASbGnctkeMB2jDTu8knLFA+Vw+nLddEBPPqfznjDpXKFx/lCwCtcbS2sm3aElX7lDmr
	w34Dt1hw19NGtB4pvOasjfnBYJabUA6MRx0XPwNToBph3ekB4TveKbBAiALfgBSwntVxJNRkP6E
	2PiZwZicuiSczEO4j5QQw1sjrnA9L7AgHbI2vzvy6XB8tvQFX8iM06WMyYlTPVoxEqXa1x5QjgM
	6GVA43H0ENT6hKJn1RYDNSNyLIUr+5c2JfiyEfWSJRRrEwgELHh9UpGr7+dV1jlKBWaUsvBo+mb
	ghAdRDYadOaG3Yj0CtRAfKC2hB1mhf8=
X-Google-Smtp-Source: AGHT+IFKzirCN+Eb4LryiVuePRi35iU9q8ScKrI1anbroM0TMHPbhux4iOi4irCSUABdP/WxjlqB7w==
X-Received: by 2002:a05:6602:6d0e:b0:85b:505a:7e01 with SMTP id ca18e2360f4ac-8674727e70dmr348656939f.5.1746626544084;
        Wed, 07 May 2025 07:02:24 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f9fc6bb606sm642485173.18.2025.05.07.07.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 07:02:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
 Jack Wang <jinpu.wang@ionos.com>, Coly Li <colyli@kernel.org>, 
 Kent Overstreet <kent.overstreet@linux.dev>, 
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
 Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
 David Sterba <dsterba@suse.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
 Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 slava@dubeyko.com, glaubitz@physik.fu-berlin.de, frank.li@vivo.com, 
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 linux-pm@vger.kernel.org
In-Reply-To: <20250507120451.4000627-1-hch@lst.de>
References: <20250507120451.4000627-1-hch@lst.de>
Subject: Re: add more bio helpers v3
Message-Id: <174662654265.1844963.5765833717643625363.b4-ty@kernel.dk>
Date: Wed, 07 May 2025 08:02:22 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Wed, 07 May 2025 14:04:24 +0200, Christoph Hellwig wrote:
> this series adds more block layer helpers to remove boilerplate code when
> adding memory to a bio or to even do the entire synchronous I/O.
> 
> The main aim is to avoid having to convert to a struct page in the caller
> when adding kernel direct mapping or vmalloc memory.
> 
> Changes since v2:
>  - rebase on top of the latest block for-next branch to resolve
>    conflicts with the bonuce buffering removal
> 
> [...]

Applied, thanks!

[01/19] block: add a bio_add_virt_nofail helper
        commit: 850e210d5ad21b94b55b97d4d82b4cdeb0bb05df
[02/19] block: add a bdev_rw_virt helper
        commit: 10b1e59cdadabff16fc78eb2ca4c341b1502293c
[03/19] block: add a bio_add_max_vecs helper
        commit: 75f88659e47dc570bdebddf77d7a3cd5f0845612
[04/19] block: add a bio_add_vmalloc helpers
        commit: 8dd16f5e34693aa0aa6a4ed48427045008097e64
[05/19] block: remove the q argument from blk_rq_map_kern
        commit: af78428ed3f3eebad7be9d0463251046e9582cf6
[06/19] block: pass the operation to bio_{map,copy}_kern
        commit: fddbc51dc290f834f520ce89c00a0fce38260c16
[07/19] block: simplify bio_map_kern
        commit: 6ff54f456671415e101e671a7dfa1fe13a31bdb5
[08/19] bcache: use bio_add_virt_nofail
        commit: 23f5d69dfa993cb6d17e619fff5e623e76b9b17f
[09/19] rnbd-srv: use bio_add_virt_nofail
        commit: a216081323a1391991c9073fed2459265bfc7f5c
[10/19] gfs2: use bdev_rw_virt in gfs2_read_super
        commit: 65f8e62593e64f6991ece4f08ab9e147e62df488
[11/19] zonefs: use bdev_rw_virt in zonefs_read_super
        commit: b2f676efe601586360e5f7461f6d36981ac1e6c9
[12/19] PM: hibernate: split and simplify hib_submit_io
        commit: 0cb8c299f81591699e908d1a6ad2dba6df642e25
[13/19] dm-bufio: use bio_add_virt_nofail
        commit: 9134124ce1bac3d5228ee1b1fc7a879422ff74f6
[14/19] dm-integrity: use bio_add_virt_nofail
        commit: bd4e709b32ac932aee3b337969cbb1b57faf84bd
[15/19] xfs: simplify xfs_buf_submit_bio
        commit: 9dccf2aa6ed5fa6ee92c8d71868bf3762ae85bda
[16/19] xfs: simplify xfs_rw_bdev
        commit: d486bbecc90d86e0292071bd06322543f8f5f658
[17/19] xfs: simplify building the bio in xlog_write_iclog
        commit: 5ced480d4886b12e6a2058ac3ebd749b0ff14573
[18/19] btrfs: use bdev_rw_virt in scrub_one_super
        commit: 760aa1818b040c8ec6a1ee9cea1ea8cac0735ce3
[19/19] hfsplus: use bdev_rw_virt in hfsplus_submit_bio
        commit: 15c9d5f6235d66ebc130da9602b1cd7692bcf85d

Best regards,
-- 
Jens Axboe



