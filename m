Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487A4331A4D
	for <dm-devel@lists.linux.dev>; Wed,  5 Nov 2025 15:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762357510; cv=none; b=Z9U9ipEbrdqy540tC/ZoIYrxzOZZJLubgQVZO5/BoJHZyrC0qH6wvTVXdsg2HvgP/6JAoTtOf09yeCfQg9Whnv/9hVUH4zryPYii8fGicpfUet18WKYlcuhNX0fX71hZ+uduLeQoA+qC70kQOoR9N+PMLcywt2SihAbQWb7fFIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762357510; c=relaxed/simple;
	bh=vBpIbHl5BJYu3GvhFAscHMjHAct8CImIgNJ4c1z/oeA=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=a7xdwuaaEDdHjcx2qOLpMz4oU1tLm+MOJyYUywuA4wnXeiBbxjpx0fsmSd7aBv2HWNvxd0xPCoMgkbK98I21nblnW6maMrAQWYyaZLVHm1H+ztbpstOVnyjY/4BY1neSgzQo2KZ45tzEBUO42b7LO7KvqvUaYsb1CAvc2jkqjIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ofKd/Dz1; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ofKd/Dz1"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-43321629a25so43848125ab.3
        for <dm-devel@lists.linux.dev>; Wed, 05 Nov 2025 07:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762357507; x=1762962307; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pmEA5UIRtFUkoJTebXPiJtfqEeDxZBhUOtjCk6lwm1Q=;
        b=ofKd/Dz1mF7agtzpb1GibZBqu3TuaCz/HKski5PVo3wnO/eG/9h9JHJxF5kRyVAp5m
         nTCWyOR7qeC41k+9JRFs1PejqfbZVeqZt7TMTm3xz8jTzezPK/UzhYRgkNCXG3pkamh3
         fWYWW+SCiNDFqt38Y/0YT+th7WQkL1W/LJcRMX4VeGnj2uPxleVX+4d5U+LVtPDFncCK
         ACjWZ7RTXTU+/rrDNZABqRJFR9C/q4Tx5RmKqhz8ycmiZFl/6JznrjCPPcbrCSCz0dkD
         Nnrsitymmc2iG/XB544xLpLQE6QaWxmeuMmtCb4cjFnn11dOWZixSbXBpjwSwTLKfAUj
         1aFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762357507; x=1762962307;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pmEA5UIRtFUkoJTebXPiJtfqEeDxZBhUOtjCk6lwm1Q=;
        b=hdnbCuz5lzU/wlFiVdGNSFviQ0twF/Xkw75FMG6C56K6y31rOlEnRgxrTjcnIpWd0o
         izbTxjRphN3HyRfk2IQrbPUCWFMxjKiHZabwhE/0VlF+p8h7qLXqpvHlbVEaXUCzpAt0
         6CTBO7tW3zxQ1n3NHf6uuzRv8YEYT9sJBu1wMP7BS5pQ7Eza6oDCF+sm2yiHNRe87GIM
         pSNUcvnxFupK+jCz5Xg4u6GO6lVY2xkvdR5KPeX+rUYVuXY910RdrnH8oYhIoUFlP1yj
         zdqetDQiE9c1VV+0kg0nbfMq/ABE4trTg4W2l83XNyyeR/XA+aps1ezxhbPd/U4I9UO3
         aHyg==
X-Forwarded-Encrypted: i=1; AJvYcCUzmuF10nt/reC2VxUIdwWrghPur/4iwy30d8myfTHXxLlDngI98iXf5tEC2lVP9lA6WO3BX/KQcQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwZqSqWhBsF92ItD/RQMwtm22ksHjZT1tew0OY1xurI3Tvz9Dkw
	NsLEXX1Y/Ji9ArnSmxBSbBengAG1GGOPbiiuRAA3vEtBos0+tqatuxZwT89/h8hzG68=
X-Gm-Gg: ASbGncsvz883s+v2kZwxJ5jM3LEH5bZO+5LR7k+lJuw3/eiY4mPja/HGjihozzoR8d+
	gcItKjYu1AOgQ4SHMUFHMC4J58GJ9t1my4U+jKM/r4CUTh0LyqrmWc3r7Y1rZNcxgCCThSsC+Gg
	LISeqUCAlPX5zImSvFa8jglnuqHzXDVej5zErpky6rdRujvrc6IDWumfv+/TDCS35BBc5M1tVYI
	LV4vO+qSS8KzcB5seJM6u2GJm1Z1e+OOuK03pgw87tboYAsrK09FM5ocoiK8g9I9aNtRO9KiSVz
	eTHrfFH26OmIfuLSX/md8tBhG2H0m96PRgQxm3JMEcXFSPqDC8FqtO78UBmv/kJp8JvuRO9lBZP
	+L3V5fllE+MjquHIeteEoFH+0Fh6qnTzGGSzZtKpbOIuVu1lRah+C92dWJPv5bjQB9J9Hjz1Htv
	rvuQ==
X-Google-Smtp-Source: AGHT+IGRprlY0B/j7MFC0euD5DLU4VAIhfixS9xB+G6Pb3CIfQJOwUgjuW1G2xa98UfKd2ncVWvKMA==
X-Received: by 2002:a05:6e02:1a85:b0:433:2957:2e87 with SMTP id e9e14a558f8ab-433407d98e4mr47454155ab.28.1762357507117;
        Wed, 05 Nov 2025 07:45:07 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b72258d4e8sm2521439173.3.2025.11.05.07.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 07:45:06 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 Keith Busch <keith.busch@wdc.com>, Christoph Hellwig <hch@lst.de>, 
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, 
 linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-btrfs@vger.kernel.org, 
 David Sterba <dsterba@suse.com>, Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20251104212249.1075412-1-dlemoal@kernel.org>
References: <20251104212249.1075412-1-dlemoal@kernel.org>
Subject: Re: [PATCH v4 00/15] Introduce cached report zones
Message-Id: <176235750606.190479.10317258805246349798.b4-ty@kernel.dk>
Date: Wed, 05 Nov 2025 08:45:06 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 05 Nov 2025 06:22:34 +0900, Damien Le Moal wrote:
> This patch series implements a cached report zones using information
> from the block layer zone write plugs and a new zone condition tracking.
> This avoids having to execute slow report zones commands on the device
> when for instance mounting file systems, which can significantly speed
> things up, especially in setups with multiple SMR HDDs (e.g. a BTRFS
> RAID volume).
> 
> [...]

Applied, thanks!

[01/15] block: handle zone management operations completions
        commit: efae226c2ef19528ffd81d29ba0eecf1b0896ca2
[02/15] block: freeze queue when updating zone resources
        commit: bba4322e3f303b2d656e748be758320b567f046f
[03/15] block: cleanup blkdev_report_zones()
        commit: e8ecb21f081fe0cab33dc20cbe65ccbbfe615c15
[04/15] block: introduce disk_report_zone()
        commit: fdb9aed869f34d776298b3a8197909eb820e4d0d
[05/15] block: reorganize struct blk_zone_wplug
        commit: ca1a897fb266c4b23b5ecb99fe787ed18559057d
[06/15] block: use zone condition to determine conventional zones
        commit: 6e945ffb6555705cf20b1fcdc21a139911562995
[07/15] block: track zone conditions
        commit: 0bf0e2e4666822b62d7ad6473dc37fd6b377b5f1
[08/15] block: refactor blkdev_report_zones() code
        commit: 1af3f4e0c42b377f3405df498440566e3468c314
[09/15] block: introduce blkdev_get_zone_info()
        commit: f2284eec5053df271c78e687672247922bcee881
[10/15] block: introduce blkdev_report_zones_cached()
        commit: 31f0656a4ab712edf2888eabcc0664197a4a938e
[11/15] block: introduce BLKREPORTZONESV2 ioctl
        commit: b30ffcdc0c15a88f8866529d3532454e02571221
[12/15] block: improve zone_wplugs debugfs attribute output
        commit: 2b39d4a6c67d11ead8f39ec6376645d8e9d34554
[13/15] block: add zone write plug condition to debugfs zone_wplugs
        commit: 1efbbc641ef7d673059cded789b9c8a743c17c9a
[14/15] btrfs: use blkdev_report_zones_cached()
        commit: ad3c1188b401cbc0533515ba2d45396b4fa320e1
[15/15] xfs: use blkdev_report_zones_cached()
        commit: e04ccfc28252f181ea8d469d834b48e7dece65b2

Best regards,
-- 
Jens Axboe



