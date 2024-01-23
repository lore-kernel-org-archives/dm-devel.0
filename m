Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848B853E33
	for <dm-devel@lists.linux.dev>; Tue, 23 Jan 2024 23:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706052113; cv=none; b=Gi2eTgRBcD1DKDfHeNEKeBr5mojeMddiLUlclj45uTlkPI8FiNGS2rg3PaN534C+xQWOK8abELyjaVCwAxY2dzWqqvhfhuq1eZrkOdfOF6f5FoDZ5uAGDSNaB26/roZsRqwq2N9PDa+FqRXNm269NXjYqwsdyfFBea5aeut/N1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706052113; c=relaxed/simple;
	bh=ZR7sfWUwnT5BjG/tPD79vE4fth31migQSpuAcSwowUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+9pVnhHCyzFGPavGYi0d6GVcjrbhWCiCkYoXr6/XbbhTxt0+GWyuiX4dHJ6ZHYHntGPUwbOlYyb9toOGsTgyqmjy3aZ16M3DfhkTAlBAEgwwTu/M2P+dS0ynUHgie65lS3Pate3XJiW1fmK0SBnBnfJKaQnOdi86fJjS4ilWjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rzjrRnQ2; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rzjrRnQ2"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d71e184695so19441285ad.3
        for <dm-devel@lists.linux.dev>; Tue, 23 Jan 2024 15:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1706052111; x=1706656911; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pyNE0YBQ61XvxQg0qzcUw/mj3pyKM5V+H7U9PFr3Dnc=;
        b=rzjrRnQ2a2W6EAPdyyhnYREoy4jm1WXNu/N9VPZ4lVLCi/zJF/B9yHB2Bo0hZOswo8
         45Z+Ye9DCZBfMQGa0y1LwLingKzxAKMch5IWsZbJjxgNEO7OqqIlUSVjenqPjFInVrHH
         ughlBiLzz/zJqvcvIUpJPGQGyafTEItj24VAskSwzFZk9t4Cb08eznjgUwu2yC7naBXC
         nO0ywZwae1veCLxzdT1rLWf3KYxZt2L4NdbAqsWssDRrjKpXb2oePa1stEejLbcOOIwU
         GxPLHrpJ4Sb+fVQ4Gy9KfUz/YYCP3PCVqOgoWW2bYgf9CyMogABWXkvjqMN05GOpZAMX
         kB7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706052111; x=1706656911;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pyNE0YBQ61XvxQg0qzcUw/mj3pyKM5V+H7U9PFr3Dnc=;
        b=uf/vD5t2V0RPUvp30gg8lFBAYgycUdlX7gxM2LWuEZ1VM+rGMmK8pMvfOQECvXKssQ
         LakPkArWD+bU3aRUvkdPS22mkVgAYgyikAMf3LHAf/mdTcoj6fCpENVHYIisVD8AW3dj
         Hw9tj0t7ss9VcusZU9BqnkKOBgL8yLa5mBk/UTBubSryQf+pSnuk4ayqU7ilmEQge08C
         nA6Put/LILzNOxsTCTxSxz4FpYw1m5PGbwOMV8lzkBVQUXzsSLdgfwD5MXHHv4qLufjw
         V+7Yv2KEOf0XbhsT/Lmv4vq+xEDiXYMewDBEPAHY/Hcr8SujuUhj5quR9X9PeE5DTTaF
         qbXg==
X-Gm-Message-State: AOJu0YwjnkBL7JZXYwnjRXxaGcWx5OSc3RrK1EsXrWByvUrxo6ZPU5ZH
	xpbpMuDoFZlx052OhzG6fvSrgQVeIchMTO4Zd0io1t+8OhyJlmnpKBhA+A+SPtg=
X-Google-Smtp-Source: AGHT+IGeQm//kQ1jNNCFdA/q04f/cj+3wXvZbTLBGBCW2U08K7o/GP2/AW3XgLOokmhWoQbjbV2FZg==
X-Received: by 2002:a17:902:d202:b0:1d7:1e5d:ab39 with SMTP id t2-20020a170902d20200b001d71e5dab39mr3908243ply.80.1706052110812;
        Tue, 23 Jan 2024 15:21:50 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id t10-20020a170902bc4a00b001d714a1530bsm8165932plz.176.2024.01.23.15.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 15:21:50 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rSQ5T-00EPce-2c;
	Wed, 24 Jan 2024 10:21:47 +1100
Date: Wed, 24 Jan 2024 10:21:47 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: Re: [PATCH 1/5] zonefs: pass GFP_KERNEL to blkdev_zone_mgmt() call
Message-ID: <ZbBKC3U3/1yPvWDR@dread.disaster.area>
References: <20240123-zonefs_nofs-v1-0-cc0b0308ef25@wdc.com>
 <20240123-zonefs_nofs-v1-1-cc0b0308ef25@wdc.com>
 <31e0f796-1c5-b7f8-2f4b-d937770e8d5@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31e0f796-1c5-b7f8-2f4b-d937770e8d5@redhat.com>

On Tue, Jan 23, 2024 at 09:39:02PM +0100, Mikulas Patocka wrote:
> 
> 
> On Tue, 23 Jan 2024, Johannes Thumshirn wrote:
> 
> > Pass GFP_KERNEL instead of GFP_NOFS to the blkdev_zone_mgmt() call in
> > zonefs_zone_mgmt().
> > 
> > As as zonefs_zone_mgmt() and zonefs_inode_zone_mgmt() are never called
> > from a place that can recurse back into the filesystem on memory reclaim,
> > it is save to call blkdev_zone_mgmt() with GFP_KERNEL.
> > 
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> > ---
> >  fs/zonefs/super.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> > index 93971742613a..63fbac018c04 100644
> > --- a/fs/zonefs/super.c
> > +++ b/fs/zonefs/super.c
> > @@ -113,7 +113,7 @@ static int zonefs_zone_mgmt(struct super_block *sb,
> >  
> >  	trace_zonefs_zone_mgmt(sb, z, op);
> >  	ret = blkdev_zone_mgmt(sb->s_bdev, op, z->z_sector,
> > -			       z->z_size >> SECTOR_SHIFT, GFP_NOFS);
> > +			       z->z_size >> SECTOR_SHIFT, GFP_KERNEL);
> >  	if (ret) {
> >  		zonefs_err(sb,
> >  			   "Zone management operation %s at %llu failed %d\n",
> > 
> > -- 
> > 2.43.0
> 
> zonefs_inode_zone_mgmt calls 
> lockdep_assert_held(&ZONEFS_I(inode)->i_truncate_mutex); - so, this 
> function is called with the mutex held - could it happen that the 
> GFP_KERNEL allocation recurses into the filesystem and attempts to take 
> i_truncate_mutex as well?
> 
> i.e. GFP_KERNEL -> iomap_do_writepage -> zonefs_write_map_blocks -> 
> zonefs_write_iomap_begin -> mutex_lock(&zi->i_truncate_mutex)

zonefs doesn't have a ->writepage method, so writeback can't be
called from memory reclaim like this.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
