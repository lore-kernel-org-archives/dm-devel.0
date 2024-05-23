Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A03914A627
	for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 14:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716473549; cv=none; b=Ej8x1MhHLhZhzSj6aFzK/uPCfegXAkKShILRAiVughuQ9tA2cchOQWNCXeE1ZERhVTQNlUNHJm0TJX1GAyvL39/sT+0TdGyT81iW/o2oL3D9PhRLc/sHzKREmujsd8qzCuEOQiTZ5onDWIdekskmEIPdFOLsahw7lrqLRPYl12Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716473549; c=relaxed/simple;
	bh=A6b249eIVjdS7vnVC+kgOF6GTuzhWCTIk2nVY/5aPLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oBnU/l90TlYxIdunU9tkLPmoq3KFScXwdm2QaBmtz/LoBzJ/HYEas2oaz0DAIO8fAuhGhwq09LQHD/GdVbdmwI8mIo/DKtnpTkx89NMU3NNybHrd0UYe9yhcmbDnuL+HHv0GAHocDrBk5L3VXAceutHS8dl6hgJ+v8pihYRpiZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-43f984101e4so11375281cf.0
        for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 07:12:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716473546; x=1717078346;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JBPRnkMS0zUivAASHtUxfgXxZpuuzb1J9ltdC7xhBY=;
        b=LcPZIqiHYe45XOtymFr2OkC6XdLbyoyPZv51EsQZyU8o1j7l7hrsBN/1Iaw6YJOg+m
         flP42aqJCjMZG+rrh408mPJkI+4pDqB/PgvmWLT1kdRYtjWizXCIMJsi/3LOQiQr33D3
         c6HivlCqS2Q1Sj6DRT4MxJjUktHBIvcMqBq15wtIZecQEXuM/cSux9CUFQzDzozyrIiX
         +6QFmlwNnnxyKul6AWBwI3MeQTCglw3BAv4kZ17oxCfWXknNOaqJb2BRrajxNUHShimg
         IwCfgTs4DxzRYaGukf799stXrhXnL6ZlbDV6oJP1IdzOQep1aMGKweG2K0yaBhZ0XbI7
         hZ4Q==
X-Gm-Message-State: AOJu0YyxvgUD1PrRDvKFTBwtJwRyYh9H5Kj48bqcNz9arUNlCqHrITho
	w+KaxYAwcZk4D5rHWiLLWpT0AKkGEwM04ZJQC3FgSZq7QohRGbmJkrtBJMaMz2g=
X-Google-Smtp-Source: AGHT+IHPKEMelY5Shpu+fWI3/RY4s2pDGIMViv+ef6vKPVlb1bP6X65trSmZ5dprazwZYRJ3koeaAA==
X-Received: by 2002:ac8:5f96:0:b0:43d:fd2b:3098 with SMTP id d75a77b69052e-43f9e152cb3mr54327551cf.52.1716473546108;
        Thu, 23 May 2024 07:12:26 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43e3c475eb3sm98205551cf.82.2024.05.23.07.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 07:12:25 -0700 (PDT)
Date: Thu, 23 May 2024 10:12:24 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Marco Patalano <mpatalan@redhat.com>,
	Ewan Milne <emilne@redhat.com>
Subject: Re: dm: retain stacked max_sectors when setting queue_limits
Message-ID: <Zk9OyGTESlHXu6Wa@kernel.org>
References: <20240522025117.75568-1-snitzer@kernel.org>
 <20240522142458.GB7502@lst.de>
 <Zk4h-6f2M0XmraJV@kernel.org>
 <20240523082731.GA3010@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523082731.GA3010@lst.de>

On Thu, May 23, 2024 at 10:27:31AM +0200, Christoph Hellwig wrote:
> On Wed, May 22, 2024 at 12:48:59PM -0400, Mike Snitzer wrote:
> > [   74.872485] blk_insert_cloned_request: over max size limit. (2048 > 1024)
> > [   74.872505] device-mapper: multipath: 254:3: Failing path 8:16.
> > [   74.872620] blk_insert_cloned_request: over max size limit. (2048 > 1024)
> > [   74.872641] device-mapper: multipath: 254:3: Failing path 8:32.
> > [   74.872712] blk_insert_cloned_request: over max size limit. (2048 > 1024)
> > [   74.872732] device-mapper: multipath: 254:3: Failing path 8:48.
> > [   74.872788] blk_insert_cloned_request: over max size limit. (2048 > 1024)
> > [   74.872808] device-mapper: multipath: 254:3: Failing path 8:64.
> > 
> > Simply setting max_user_sectors won't help with stacked devices
> > because blk_stack_limits() doesn't stack max_user_sectors.  It'll
> > inform the underlying device's blk_validate_limits() calculation which
> > will result in max_sectors having the desired value (which it already
> > did, as I showed above).  But when stacking limits from underlying
> > devices up to the higher-level dm-mpath queue_limits we still have
> > information loss.
> 
> So while I can't reproduce it, I think the main issue is that
> max_sectors really just is a voluntary limit, and enforcing that at
> the lower device doesn't really make any sense.  So we could just
> check blk_insert_cloned_request to check max_hw_sectors instead.

I haven't tried your patch but we still want properly stacked
max_sectors configured for the device.

> Or my below preferre variant to just drop the check, as the
> max_sectors == 0 check indicates it's pretty sketchy to start with.

At this point in the 6.10 release I don't want further whack-a-mole
fixes due to fallout from removing longstanding negative checks.

Not sure what is sketchy about the max_sectors == 0 check, the large
comment block explains that check quite well.  We want to avoid EIO
for unsupported operations (otherwise we'll get spurious path failures
in the context of dm-multipath).  Could be we can remove this check
after an audit of how LLD handle servicing IO for unsupported
operations -- so best to work through it during a devel cycle.

Not sure why scsi_debug based testing with mptest isn't triggering it
for you. Are you seeing these limits for the underlying scsi_debug
devices?

./max_hw_sectors_kb:2147483647
./max_sectors_kb:512

What are those limits for the mptest created 'mp' dm-multipath device?

Mike
