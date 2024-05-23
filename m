Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E506011C92
	for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 15:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716479049; cv=none; b=YPhbsgPY2wuXpP0L+fKJ+CfYla8ZaDBypS6Mf5zvoZz2w/cWNkIjUYoGOTsSgeoOLly2y0MESSeugJIFzHeLJhihs1J4spz9zMzdZfXRtKP8joUJg2UHZlKjeomho8aYLZ0A4Tqa2xNr7h6OyBtAWh2BVjYwsCSTKoU6E/ZVXkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716479049; c=relaxed/simple;
	bh=4LtWob32ApnyIrD+FaH4hfwXtzM201Hrt3v3539JzEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUSVmW9PpSd/kfhnFYbc8MyPeONop9rtd8v1aqMklyvQTqGjZI3XmuqDOEePNeAc5uIF9O+kyefn88FqP4rQb5c6qBBgQk0D9z0ybfKJutA/7sjAAHdq+y+EzlQ6NWktNa3GMd96ve1+n9uoetz51HmuChCGUnB09vUUiO071dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-23fb9c871c8so3158154fac.1
        for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 08:44:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716479047; x=1717083847;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VDtPboZQrdlM7tLf8sMngY5uN4PsBPqcCfAsHLauzDY=;
        b=pH9SS1xI8VM4t9s4OszowIwO3Ri/QnCEUVQ+yN4QQpSk4DWBVRgUI3h6PkeQbLeZmq
         cARYxj7e7M3O2XBR9VibNOC5jcyXnYN13dYELbALo1vREFjm33S3UH3ZCpidFPG1eQWI
         /UYLP+TyrJBNJ0Wso9UdY71ABH1ZetNiJrfYAwGvoVy0Vnx4IT8HnttSOhhWjLJGEV06
         gmDIxtEVUhjW9liFSa5F345VVn4qr+SyXxxqDZCJvwWPeEVWkZ5wzI38woJ6R/hiu9Hw
         TEAdKJ0Rc3gp8q2zPfQIDp0gqEjqtgPBRdA410dpzYDyBl1Ce2n9CliPLzSSF7fsE5Ls
         Si1g==
X-Gm-Message-State: AOJu0Yye48UGpu0OnJW7NeForlPyStUxlutLl70nPP8ZeDNt/G9Rtmr2
	hNnex+nMYO/tZGCcTGWKwN8+uSgpdpWl0TB5tXnxgv7pns+LN+Xi5pd1Md45Xy4=
X-Google-Smtp-Source: AGHT+IF89a4FCVi+vzxPLNIcYSlNqsZYXkww3riTOzVp68ENvWzScmBcSrnNCqznAR19rFiVx8LUog==
X-Received: by 2002:a05:6870:171d:b0:23c:471:a5d2 with SMTP id 586e51a60fabf-24c68bc6df0mr5838197fac.30.1716479047071;
        Thu, 23 May 2024 08:44:07 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43e12f41a0asm148653281cf.48.2024.05.23.08.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 08:44:06 -0700 (PDT)
Date: Thu, 23 May 2024 11:44:05 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Marco Patalano <mpatalan@redhat.com>,
	Ewan Milne <emilne@redhat.com>
Subject: Re: dm: retain stacked max_sectors when setting queue_limits
Message-ID: <Zk9kRYgwhu49c8YY@kernel.org>
References: <20240522025117.75568-1-snitzer@kernel.org>
 <20240522142458.GB7502@lst.de>
 <Zk4h-6f2M0XmraJV@kernel.org>
 <20240523082731.GA3010@lst.de>
 <Zk9OyGTESlHXu6Wa@kernel.org>
 <20240523144938.GA30227@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523144938.GA30227@lst.de>

On Thu, May 23, 2024 at 04:49:38PM +0200, Christoph Hellwig wrote:
> On Thu, May 23, 2024 at 10:12:24AM -0400, Mike Snitzer wrote:
> > Not sure what is sketchy about the max_sectors == 0 check, the large
> > comment block explains that check quite well.  We want to avoid EIO
> > for unsupported operations (otherwise we'll get spurious path failures
> > in the context of dm-multipath).  Could be we can remove this check
> > after an audit of how LLD handle servicing IO for unsupported
> > operations -- so best to work through it during a devel cycle.
> 
> Think of what happens if you create a dm device, and then reduce
> max_sectors using sysfs on the lower device after the dm device
> was created: you'll trivially trigger this check.
> 
> > Not sure why scsi_debug based testing with mptest isn't triggering it
> > for you. Are you seeing these limits for the underlying scsi_debug
> > devices?
> > 
> > ./max_hw_sectors_kb:2147483647
> > ./max_sectors_kb:512
> 
> root@testvm:~/mptest# cat /sys/block/sdc/queue/max_hw_sectors_kb 
> 2147483647
> 
> root@testvm:~/mptest# cat /sys/block/sdd/queue/max_sectors_kb 
> 512
> 
> root@testvm:~/mptest# cat /sys/block/dm-0/queue/max_hw_sectors_kb 
> 2147483647
> 
> root@testvm:~/mptest# cat /sys/block/dm-0/queue/max_sectors_kb 
> 1280
> 
> so they don't match, but for some reason bigger bios never get built.

Weird... I'm running in a VMware guest but I don't see why that'd make
a difference on larger IOs being formed (given it is virtual
scsi_debug devices).

In any case, we know I can reproduce with this scsi_debug-based mptest
test and Marco has verified my fix resolves the issue on his FC
multipath testbed.

But I've just floated a patch to elevate the fix to block core (based
on Ming's suggestion):
https://patchwork.kernel.org/project/dm-devel/patch/Zk9i7V2GRoHxBPRu@kernel.org/

Let me know, thanks.
