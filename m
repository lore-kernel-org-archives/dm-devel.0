Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A32C137937
	for <dm-devel@lists.linux.dev>; Tue,  9 Apr 2024 15:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712678243; cv=none; b=k1L1BUas6qTQCr/Kgw51aF+lPFaokaeKoeLKeoStLdMRYrMRC3GrPSPwJ0z71HvrOouThoBgTX7LXUOGOShNUckCY84wPfuz5Sf7UOzBBr/bA9nXpEz4HPv7BMRzWuFEYLCjl0YDM6GunftulLhF7CGd/7FTuh0sZtPioaPQEs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712678243; c=relaxed/simple;
	bh=F7wmDJo1CTgLlcMGnB22FbyVjlRMIAGgTDI9EoDph5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iBBysiQ4WIpA/7PDUjokDRCQFvRbjEf/g9POTzHEgqDe47S192lpptfi75U9Li7KZ1R+l3T3TZJCaNzkbd5bgO/c+9BuqDNkwUEnk0/OU4XcyaZ8AfHJaeuFqZTxjtR7HySLGh21L4tz2l2wbrs2gyRirLrs42Cr0mwQc+9QDDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OgNnjI5U; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OgNnjI5U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712678241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WzbRqHGt5XInRshA+Pv85lImG4dL2VBw+03B1sBGY9w=;
	b=OgNnjI5Uc2HMk5A9WOVqLGTMgJoSBP+UCEcRfKQuw7kR3uQ7+goTDSpa/tUKIHFnNYCBZV
	iqlU84SbRxWe8Yi5ddvQPa1Bh0/FySy3wP8AZtVMw88/RyWzbbXWaF5y3kQO7NfzJbI5kF
	eNaqDPxuPA1it7qDnkYe8jKx34K0Lwo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-30-BI5_mNe6hz72sLGltcw-1; Tue,
 09 Apr 2024 11:57:19 -0400
X-MC-Unique: 30-BI5_mNe6hz72sLGltcw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88FBA29AA392;
	Tue,  9 Apr 2024 15:57:18 +0000 (UTC)
Received: from fedora (unknown [10.72.116.148])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DDA347B;
	Tue,  9 Apr 2024 15:57:13 +0000 (UTC)
Date: Tue, 9 Apr 2024 23:56:50 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	janpieter.sollie@edpnet.be, Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev, Song Liu <song@kernel.org>,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH] block: allow device to have both virt_boundary_mask and
 max segment size
Message-ID: <ZhVlQqtHU+8oP6rD@fedora>
References: <20240407131931.4055231-1-ming.lei@redhat.com>
 <20240408055542.GA15653@lst.de>
 <ZhOekuZdwlwNSiZV@fedora>
 <20240408084739.GA26968@lst.de>
 <ZhO9UrfK4EulTkLo@fedora>
 <20240409135758.GA20668@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409135758.GA20668@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On Tue, Apr 09, 2024 at 03:57:58PM +0200, Christoph Hellwig wrote:
> On Mon, Apr 08, 2024 at 05:48:02PM +0800, Ming Lei wrote:
> > The limit is from commit 09324d32d2a0 ("block: force an unlimited segment
> > size on queues with a virt boundary") which claims to fix f6970f83ef79
> > ("block: don't check if adjacent bvecs in one bio can be mergeable").
> > 
> > However commit f6970f83ef79 only covers merge code which isn't used by
> > bio driver at all, so not sure pre-6.9-rc is broken for stacking driver.
> 
> We can stack rq drivers as well.
> 
> > Also commit 09324d32d2a0 mentioned that it did not cause problem,
> > actually 64K default segment size limits always exists even though the
> > device doesn't provide one, so looks there isn't report as 'real bugs',
> > or maybe I miss something?
> 
> The problem is when the segment size does not align to the boundary
> mask as you'll now start feeding malformed segments/entris to the
> device.

In case of single bio, this bio will be split with max segment size
if segment size doesn't align with virt boundary, so the resulted bio
is still valid because virt-boundary allows the last bvec to be
unaligned. 

In case of bio merge, bio_will_gap() is always called to make sure
there isn't gap between the two bios wrt. virt boundary.

Can you explain a bit how one malformed bio is made?



Thanks, 
Ming

