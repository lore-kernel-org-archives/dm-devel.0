Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FDE22AE5D
	for <dm-devel@lists.linux.dev>; Mon, 10 Mar 2025 13:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741614645; cv=none; b=S3up25n+UHyrcxdHEtdj8udypW0rdAJBecvF5tWSzHEYBhZYbZ7ZJ6eE8D5uckzff1kuEN0mlW0E+CICmuzDxBy6XRjjsx60pjxviQcbyc5S2MrhGcRpYBkqx4TTfiuma69WgasCifINcUFT0ZmU/FVL8Xa41CoyyxL3zv9pKow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741614645; c=relaxed/simple;
	bh=kRowGLaCnFK9DFM6f7uMT7JNCKLCEf2PT5kJGF3yYYc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UmZ3U5zzrMQjAOfAQgnEmI4DbDPss8+yEbIbG60jUshQZxAUrlk79+2TWpdnXA01YYtLvhZiXDvxJ1agvmFUqDFGjpn58HS0Z6fKfA833A0/cJkzA6Id7ZeGmEUe3abPubWlZxXJy+omqm9SX3sSNWYJnv7rUxS/PkD6/QA125o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vjE6J3Zs; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vjE6J3Zs"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3d45875d440so5353975ab.0
        for <dm-devel@lists.linux.dev>; Mon, 10 Mar 2025 06:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741614642; x=1742219442; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tUspsaKaBehtCKwT16rXODc0xHUdVxEjdsqpOZ3zIYo=;
        b=vjE6J3ZszjtMOAuvGYtC8xjdYIs/STY4CwbXj7pCdnJGtEzazArPx71W2rCsbe4+P0
         06FkS9GmoYcRlhx+zw/bc55Z4FYPpcPD/uRoO/BeLA6HUQ1UCJVkw02SJ28LS0vx0Eh1
         LI4tk24BYsRuOjZKx6W5lmIQ27Ar4iocmL+Ho6Rt3TmdyQIn+lkNFMJNGLqAYd75cJnH
         bDGCVwMQYEIqSxGSAvoajBd11plnyXtw7X+Uhs1mEblZZajx7ZdYGulBjq1pWeapze05
         meAf9xxxJwjEhicuPt7jHdukHUzjx033Qdi/jDvl05573ajYC5uvSMJgBWIccpXT4QS3
         0eZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741614642; x=1742219442;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tUspsaKaBehtCKwT16rXODc0xHUdVxEjdsqpOZ3zIYo=;
        b=u2D/yGeviABm02rye+8TRoVm3L7Z89bAyGpIKd5zPLbUTA2v6cNUYXAFh97CafSjLP
         T5AB8SwP2ZvIAYzBGdma9SMyH0U0drKQlvp51zlUso1bjuZW9bUiWTkVzD4hdsmCKbEc
         hE9lZ4iAC5ZBic/KlnLuALbnc+ZVMg+V6faJ3wHr5dIxM7MiX45zyxML2mOQ3jhmoCmI
         gVepVJUeCP5/C+DgP8vGVnYgkC1yOb5gNq+qUJpIFeLyvTlyJACG9UloLAj49IZPqmnG
         loAwb8xi8eH6xjiTybW+vvFc9VjpbJ7hLxOCaHcE8S8seaKawifFGQxSDMpb5s8VlCl6
         0ymw==
X-Gm-Message-State: AOJu0YyaF26K/yND2cac5oYCp7UVsw7pcKbngYMTNRhz7gCnNeRUJWtE
	IoteLRTPG4FgnieCgT4ej5m0BXQfygGBLUBm3q5nhn6vVlJs7j+/155DQ7wWScfQxVVnD0Q51Kt
	z
X-Gm-Gg: ASbGncv+t8OuylsX4mYeXpIra7sPzTrb8NLDdC4fjYScv0qX6eY80YSEXr1zr2kjLO6
	TYW5cJmabMzF7Pkmf/U/z8LOO2INSavuS7JF8uOsxgDZ4bvr4qsTL69jShxVOqVCVyhzlFYEn+6
	5I1ehTJZLcDlGkmoZB/P3QZjEkjFMkEL0LkYPH2MvdrEjHoWtYbR7xSGwHbLZ4bD3hBNHUDKpxK
	GO797lP0SJ3Ku/9orW2vZ3ZF/Shk+6EyTebRpg5sbsriwzB2/VLktl6ML0XhEtfdd8VZH1qduRN
	cYZct6GUa00Oo5lUFLbdZ0ccOYMqmCdf7p8=
X-Google-Smtp-Source: AGHT+IFNw1d4zMmcDFKbVYZybB1yEIUzV0WvPzCrDNX6b2PPX+F5muZn2JfFNZcEZIvopidgYOn7fw==
X-Received: by 2002:a05:6e02:144f:b0:3d4:36c3:7fe3 with SMTP id e9e14a558f8ab-3d441960b65mr144960085ab.9.1741614641970;
        Mon, 10 Mar 2025 06:50:41 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d43b511091sm21350915ab.42.2025.03.10.06.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 06:50:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc: dm-devel@lists.linux.dev, stable@vger.kernel.org, 
 Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20250310115453.2271109-1-ming.lei@redhat.com>
References: <20250310115453.2271109-1-ming.lei@redhat.com>
Subject: Re: [PATCH V2] block: make sure ->nr_integrity_segments is cloned
 in blk_rq_prep_clone
Message-Id: <174161464074.178937.3099509536865247557.b4-ty@kernel.dk>
Date: Mon, 10 Mar 2025 07:50:40 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Mon, 10 Mar 2025 19:54:53 +0800, Ming Lei wrote:
> Make sure ->nr_integrity_segments is cloned in blk_rq_prep_clone(),
> otherwise requests cloned by device-mapper multipath will not have the
> proper nr_integrity_segments values set, then BUG() is hit from
> sg_alloc_table_chained().
> 
> 

Applied, thanks!

[1/1] block: make sure ->nr_integrity_segments is cloned in blk_rq_prep_clone
      commit: fc0e982b8a3a169b1c654d9a1aa45bf292943ef2

Best regards,
-- 
Jens Axboe



