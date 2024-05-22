Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E291420B0
	for <dm-devel@lists.linux.dev>; Wed, 22 May 2024 16:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716396545; cv=none; b=VKyaxFPFk3bbIODJ4Hv+V9H6hUmBm2clDGjJc9cx1NvUYRGub93lGg5LZthsYM8iX+U6FqDDCWrfa3kaQXUdXd8UYrbr7nVRunLTHzZm4NUUuzwqjYQetjWe46JDDVd1U7gKwThjqrMB7rNvWENx3HPhcZc281VaugJQtxppKyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716396545; c=relaxed/simple;
	bh=7MzehI0Q2fJpHZsH1+KgnNH047c73IwfOfxTS9IjLcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OH+0mzRBQ5Iv/fYkT1qhxUs1h0aJ6PXBEoyqEjUnxCTuP1lCWohQNcmKG6XJ/bZ1krg8JBCrx6w3DWRrGT/XKKacIFveCt2eZOA3YScqm0SnJkxlFzxOthAn9cbEd4TNyXEc7D8KVm3WGqozmxmc4E0XIkU5I801wTKs40aM7nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6f0e4212d5aso2819151a34.3
        for <dm-devel@lists.linux.dev>; Wed, 22 May 2024 09:49:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716396541; x=1717001341;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9sJh3+M7j60eGGfzHmACpJhU1B6ooDDZPfumWrr/YfY=;
        b=CQpENgqqWIXY+XBCFd/eoH/YxH5NEiL+Ic/fscFbhLsTYSlawr88o3A28skL9n6/Tb
         gxYPEbwk/GReV5aLPI3iX5qXu7Z2oLo2Wmo9ZR/ShUswEKNT1r6JVl/ZoJFD8bb6Zj7L
         kLVtvJUqyhTKOPdfm+oYOGTfac3o4jf4gV3ug488vHKYOLkoBHvYlxJMdXjP69CMgXUx
         6xBvM17C2S5qBQShof1cgv/3XqYdcBoIGvY897Ryc2wjwfYFSNawDT5FI0Cw9Havrm7/
         UViDu7QVJOMDMaPCrdB+Y+D3Bkq0lsUwKiCL7L/QgfRi584t6k4tmSchYC13KJmb1dev
         IgjQ==
X-Gm-Message-State: AOJu0YzoKHIQnqwYugaxUkK40LnGBvo15hnK83mFYu+oqqtZj+DTNBF9
	0sYfVPuyrFdgRoMwe4DHGMe3WLOluv+66Bo2ohw2qD9RNcaHSvS+2vmFshuw/1k=
X-Google-Smtp-Source: AGHT+IGeZSQX+E3YkbKQFl9xkKgIoXpFnXcZjjux/ZrFPulBr4tPWIpSG7dOPSN9T7Bd71fh8mpW3w==
X-Received: by 2002:a05:6871:b0f:b0:24c:6335:cf1c with SMTP id 586e51a60fabf-24c68ad9b78mr2867125fac.13.1716396541620;
        Wed, 22 May 2024 09:49:01 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43df54ef4c9sm173199201cf.30.2024.05.22.09.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 09:49:01 -0700 (PDT)
Date: Wed, 22 May 2024 12:48:59 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Marco Patalano <mpatalan@redhat.com>,
	Ewan Milne <emilne@redhat.com>
Subject: Re: dm: retain stacked max_sectors when setting queue_limits
Message-ID: <Zk4h-6f2M0XmraJV@kernel.org>
References: <20240522025117.75568-1-snitzer@kernel.org>
 <20240522142458.GB7502@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240522142458.GB7502@lst.de>

On Wed, May 22, 2024 at 04:24:58PM +0200, Christoph Hellwig wrote:
> On Tue, May 21, 2024 at 10:51:17PM -0400, Mike Snitzer wrote:
> > Otherwise, blk_validate_limits() will throw-away the max_sectors that
> > was stacked from underlying device(s). In doing so it can set a
> > max_sectors limit that violates underlying device limits.
> 
> Hmm, yes it sort of is "throwing the limit away", but it really
> recalculates it from max_hw_sectors, max_dev_sectors and user_max_sectors.

Yes, but it needs to do that recalculation at each level of a stacked
device.  And then we need to combine them via blk_stack_limits() -- as
is done with the various limits stacking loops in
drivers/md/dm-table.c:dm_calculate_queue_limits

> > This caused dm-multipath IO failures like the following because the
> > underlying devices' max_sectors were stacked up to be 1024, yet
> > blk_validate_limits() defaulted max_sectors to BLK_DEF_MAX_SECTORS_CAP
> > (2560):
> 
> I suspect the problem is that SCSI messed directly with max_sectors instead
> and ignores max_user_sectors (and really shouldn't touch either, but that's
> a separate discussion).  Can you try the patch below and maybe also provide
> the sysfs output for max_sectors_kb and max_hw_sectors_kb for all involved
> devices?

FYI, you can easily reproduce with:

git clone https://github.com/snitm/mptest.git
cd mptest
<edit so it uses: export MULTIPATH_BACKEND_MODULE="scsidebug">
./runtest ./tests/test_00_no_failure

Also, best to change this line:
./lib/mpath_generic:        local _feature="4 queue_if_no_path retain_attached_hw_handler queue_mode $MULTIPATH_QUEUE_MODE"
to:
./lib/mpath_generic:        local _feature="3 retain_attached_hw_handler queue_mode $MULTIPATH_QUEUE_MODE"
Otherwise the test will hang due to queue_if_no_path.

all underlying scsi-debug scsi devices:

./max_hw_sectors_kb:2147483647
./max_sectors_kb:512

multipath device:

before my fix:
./max_hw_sectors_kb:2147483647
./max_sectors_kb:1280

after my fix:
./max_hw_sectors_kb:2147483647
./max_sectors_kb:512
 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 332eb9dac22d91..f6c822c9cbd2d3 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3700,8 +3700,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	 */
>  	if (sdkp->first_scan ||
>  	    q->limits.max_sectors > q->limits.max_dev_sectors ||
> -	    q->limits.max_sectors > q->limits.max_hw_sectors)
> +	    q->limits.max_sectors > q->limits.max_hw_sectors) {
>  		q->limits.max_sectors = rw_max;
> +		q->limits.max_user_sectors = rw_max;
> +	}
>  
>  	sdkp->first_scan = 0;
>  
> 

Driver shouldn't be changing max_user_sectors..

But it also didn't fix it (mpath still gets ./max_sectors_kb:1280):

[   74.872485] blk_insert_cloned_request: over max size limit. (2048 > 1024)
[   74.872505] device-mapper: multipath: 254:3: Failing path 8:16.
[   74.872620] blk_insert_cloned_request: over max size limit. (2048 > 1024)
[   74.872641] device-mapper: multipath: 254:3: Failing path 8:32.
[   74.872712] blk_insert_cloned_request: over max size limit. (2048 > 1024)
[   74.872732] device-mapper: multipath: 254:3: Failing path 8:48.
[   74.872788] blk_insert_cloned_request: over max size limit. (2048 > 1024)
[   74.872808] device-mapper: multipath: 254:3: Failing path 8:64.

Simply setting max_user_sectors won't help with stacked devices
because blk_stack_limits() doesn't stack max_user_sectors.  It'll
inform the underlying device's blk_validate_limits() calculation which
will result in max_sectors having the desired value (which it already
did, as I showed above).  But when stacking limits from underlying
devices up to the higher-level dm-mpath queue_limits we still have
information loss.

Mike
