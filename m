Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4073869E19
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 20:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647721; cv=none; b=SOJtMlwdDM/pSYrE5hHNy3QVSikVlyYoP26wTElfvAmxgdJFl15s8qWlxDtKUD6ahKtTL6XdFGSyT/04pKisb7DRZ+0v88PXuX1htHW52penmiaJK5oRM0cYq8tpZFqyiU+QPlFpIkmz9SIMKMomwbb6BCxp/9FefGz4MIAb594=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647721; c=relaxed/simple;
	bh=lML9QmyIv+LUMOg/iT47sri/G1/loRasVQk342qZgN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJUnXpcW1P6ItUoRCC1PU0tUMbZ6b5JRaQPKXt47b+h5Y3+wBEPvGIzFkfALkz99jF6YvvLpT1sbqmja+14p3MqaQALHDtQxiQn8pIvkjBaihLktA8NrTE8AweE4WUiXnTs/g3YM52LE0qL1H0iEghIjNlosAV0ndG6FBjDp7VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-42ab4f6daf2so6379461cf.3
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 12:48:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706647719; x=1707252519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5wxvZziXbUhtUP1Y9zXw54fZ6cDdnya/SKk+UDHGEFo=;
        b=d8775/G+2yOc0pdR6/t6Kv5iO9wbIXmMqvUqm95/DZ7aCtqVAyz0uxVjZ9ft4vfAmW
         Ato7r+fYm+pEu8mcFJLal8jyxlNiSf7yqzZ7xS5QCz5alv4kAUR3AjjwNm8l0pLNYWZ1
         WONhdN3ZCDe6GsthcC2n0MEUiqsminGN4GdBrUAmm+wg9Ig8xytyZPTXIJVTJ4/Z9YOi
         /Mt30JXNMRk5I8kL/+HcvZmeB4jL0bxT57O+rirnswsem1z2pNc24SX/dc5OIGfLp0MN
         ZUtGJmsW82P8AHwVsRUEmTTHaUcU5hcx0SXeuZsDTpUkvp4k4mB1RHjGhMKM1udUpF4h
         rXog==
X-Gm-Message-State: AOJu0YxL9I8YM9UP+4ZxWG9JVsN0scPgonGBAanmiSHpdEjd0hQSB3Mq
	7D3z0c7dwo6BiRpqvetVK6lZUw7UCrE75+7EbO/sUHcDZMxZznwsd7p7S5AqWw==
X-Google-Smtp-Source: AGHT+IH5S9pyQeSM2K6WGjuq7LBNmUE3HoawjAO33JauM5M9qFYAUZROQj6Nk22MOXOq+8oUsCH3ng==
X-Received: by 2002:ac8:7f8a:0:b0:42a:b37f:4a75 with SMTP id z10-20020ac87f8a000000b0042ab37f4a75mr3021041qtj.16.1706647719211;
        Tue, 30 Jan 2024 12:48:39 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id x4-20020ac81204000000b00429bd898838sm4160126qti.47.2024.01.30.12.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 12:48:38 -0800 (PST)
Date: Tue, 30 Jan 2024 15:48:37 -0500
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
Subject: Re: [PATCH v3 2/5] dm: dm-zoned: guard blkdev_zone_mgmt with noio
 scope
Message-ID: <ZblgpVdHZqPaq7xD@redhat.com>
References: <20240128-zonefs_nofs-v3-0-ae3b7c8def61@wdc.com>
 <20240128-zonefs_nofs-v3-2-ae3b7c8def61@wdc.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240128-zonefs_nofs-v3-2-ae3b7c8def61@wdc.com>

On Mon, Jan 29 2024 at  2:52P -0500,
Johannes Thumshirn <johannes.thumshirn@wdc.com> wrote:

> Guard the calls to blkdev_zone_mgmt() with a memalloc_noio scope.
> This helps us getting rid of the GFP_NOIO argument to blkdev_zone_mgmt();
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>
