Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F77071B3A
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 20:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647766; cv=none; b=nXmg59QiwzWjutRJxJ4+ZCQ2GVZ2fTRhujGieV0Kv/k/NW72dMqQ4pBVlIFFqWArxJ8o+GqRTTapiWPc2J0GVxXzbTy5FQIIF5YCPZ3/Sy/54e4BZ6LkWaDUxXqBBT95TjqKMP5mcvd6SYrlkdOnVFHQEBmQ9CS8sxVbshL1TNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647766; c=relaxed/simple;
	bh=bS3zY4RD+CMpw9nf3G/9PKea3i0PDScm6HPQf3AhHgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gaLRoSW+v/CV+hyOpPvGvgSGJti39iol518xze75YoxhKoOQPUh0Nwv815ZgBmE2J4jkKYUb8Yl81JpN87d1/Cxz8io33DdWswnuw8v4vF678kvs/nbuNWCBntzcba7YwPf/v+pw8FMLjQVZOub2+ziX6GdCgy12b/SQP2RCV8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-68873473ce6so34068156d6.0
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 12:49:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706647763; x=1707252563;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AtZBEe426KIf/mBUMlvvoaF7jyFEZ9/COBSE2/txMLU=;
        b=vhA4i28dVJiopdbA5lQY8Su2x0GeeWCN775+yBsFHEhlzF69+pIVCJEnbuNWnP3q/J
         l+l41r9K67w/Rb8LSejia8XbpW1KCX8GCkT4i9nfxo7/Mzznphhr9Mu/afl+z1pUPqaP
         xVqyriAA2uzjdkDov74Je8OMSRQv8bl6XRjxyBkQXYKc0A3oYh9U+ekIuMG/S3bC6kHe
         BA96B0IBSGehLAwYStV+YWzh/BlwRG3jHq/RanxAwI8FAMQMRFd3y46qczLuHugxu13K
         XNi9nqPCgORLeciHBaIL/XCb+jcIxxeKiPrzJb+tEWySrtZysy5eO3BP5kWDI7mvQAFj
         anMg==
X-Gm-Message-State: AOJu0YyFamqZECWYIj7rnqNiH9dsdhr34VX+VulGD6rlToZh7JYly8CW
	rXDy3aBbosJLQeEXzXlqUryXANjknmZoX5v4unJ/A606EdK2YtnIS1CbnGKPaQ==
X-Google-Smtp-Source: AGHT+IExCJjqhy5J/HQbLwc6HEIv1PKoKFV6opMfTc/hdwP/PWAAPv9RfvTcXLRcTuNHUUdlDE2mNw==
X-Received: by 2002:a05:6214:f2c:b0:681:7d81:705b with SMTP id iw12-20020a0562140f2c00b006817d81705bmr615439qvb.4.1706647763522;
        Tue, 30 Jan 2024 12:49:23 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id of10-20020a056214434a00b0068c560eaf8fsm1688182qvb.134.2024.01.30.12.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 12:49:23 -0800 (PST)
Date: Tue, 30 Jan 2024 15:49:22 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org
Subject: Re: [PATCH v3 5/5] block: remove gfp_flags from blkdev_zone_mgmt
Message-ID: <Zblg0qE25wPt-SRv@redhat.com>
References: <20240128-zonefs_nofs-v3-0-ae3b7c8def61@wdc.com>
 <20240128-zonefs_nofs-v3-5-ae3b7c8def61@wdc.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240128-zonefs_nofs-v3-5-ae3b7c8def61@wdc.com>

On Mon, Jan 29 2024 at  2:52P -0500,
Johannes Thumshirn <johannes.thumshirn@wdc.com> wrote:

> Now that all callers pass in GFP_KERNEL to blkdev_zone_mgmt() and use
> memalloc_no{io,fs}_{save,restore}() to define the allocation scope, we can
> drop the gfp_mask parameter from blkdev_zone_mgmt() as well as
> blkdev_zone_reset_all() and blkdev_zone_reset_all_emulated().
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>
