Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B09E4C61F
	for <dm-devel@lists.linux.dev>; Mon,  8 Apr 2024 09:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712569705; cv=none; b=EPtQw/iVYYayGrtqiH2VJgnOTCqLgGeymEgq3I3rjSoIpVpdpfgNu3q+cKtJBMyU0cUY3r+H2Ih3iZ/18CSY/EfJJ8jV08gRMwyTfisZ7aghVCZvPxvqhwyXdlMqmJi/+6hHrx0ZSpuMCyesWbH2P3ij4Yiik4wF8qRGZEB9eRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712569705; c=relaxed/simple;
	bh=IUp08mqVpzXZ0Ua/UT88n3Tbk8rfXt40q2MuLB1Mj9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pP+FE59Uy+BKrBUog3GP5aI9e3XqdvQGb+6w5WbR0B5bHEnB/cUFXocghQAoK3jeGX0AaLjlP751BUs8fLQL1B49Kf3QTKYhgCara13TGuWawN3I9GPlbi6mU3MofafwRpRsrdyrOtLkPkZPmDxcYTHYnRBrtAYrnVgjGw7Ud4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PnHM0hBV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PnHM0hBV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712569703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bk+qeUpt0NeaYtZeGZHtTJDFgi95opWbJTTRcZV5Uts=;
	b=PnHM0hBVjefFPkfbboZi3Bkgevu7vgi384AzBfQrwGbgCfAAauQtvzmPIBgJqIJBmEIFsJ
	DAcOx7LM71I2UW6siKhYfoY+Y6kW28JtjxNziVKW3+d0F8T+WDtNaRo2VbejjQgl7LvaKC
	fwLJC9tfnHe2K2uSPDTAMO26cn/jmtI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-383-s6smG9LPPne4nc8-Zuj9lA-1; Mon, 08 Apr 2024 05:48:17 -0400
X-MC-Unique: s6smG9LPPne4nc8-Zuj9lA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21A491049B82;
	Mon,  8 Apr 2024 09:48:17 +0000 (UTC)
Received: from fedora (unknown [10.72.116.148])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 80F462026D06;
	Mon,  8 Apr 2024 09:48:12 +0000 (UTC)
Date: Mon, 8 Apr 2024 17:48:02 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	janpieter.sollie@edpnet.be, Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev, Song Liu <song@kernel.org>,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH] block: allow device to have both virt_boundary_mask and
 max segment size
Message-ID: <ZhO9UrfK4EulTkLo@fedora>
References: <20240407131931.4055231-1-ming.lei@redhat.com>
 <20240408055542.GA15653@lst.de>
 <ZhOekuZdwlwNSiZV@fedora>
 <20240408084739.GA26968@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408084739.GA26968@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Mon, Apr 08, 2024 at 10:47:39AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 08, 2024 at 03:36:50PM +0800, Ming Lei wrote:
> > It isn't now we put the limit, and this way has been done for stacking device
> > since beginning, it is actually added by commit d690cb8ae14b in v6.9-rc1.
> > 
> > If max segment size isn't aligned with virt_boundary_mask, bio_split_rw()
> > will split the bio with max segment size, this way still works, just not
> > efficiently. And in reality, the two are often aligned.
> 
> We've had real bugs due to this, which is why we have the check.  We also
> had a warning before the commit, it's just it got skipped for
> stacking.  So even if we want to return to the broken pre-6.9-rc behavior
> it should only be for stacking.  I don't think that is a good outcome,
> though.

The limit is from commit 09324d32d2a0 ("block: force an unlimited segment
size on queues with a virt boundary") which claims to fix f6970f83ef79
("block: don't check if adjacent bvecs in one bio can be mergeable").

However commit f6970f83ef79 only covers merge code which isn't used by
bio driver at all, so not sure pre-6.9-rc is broken for stacking driver.

Also commit 09324d32d2a0 mentioned that it did not cause problem,
actually 64K default segment size limits always exists even though the
device doesn't provide one, so looks there isn't report as 'real bugs',
or maybe I miss something?

commit 09324d32d2a0843e66652a087da6f77924358e62
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue May 21 09:01:41 2019 +0200

    block: force an unlimited segment size on queues with a virt boundary

    We currently fail to update the front/back segment size in the bio when
    deciding to allow an otherwise gappy segement to a device with a
    virt boundary.  The reason why this did not cause problems is that
    devices with a virt boundary fundamentally don't use segments as we
    know it and thus don't care.  Make that assumption formal by forcing
    an unlimited segement size in this case.

    Fixes: f6970f83ef79 ("block: don't check if adjacent bvecs in one bio can be mergeable")
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Ming Lei <ming.lei@redhat.com>
    Reviewed-by: Hannes Reinecke <hare@suse.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>


Thanks,
Ming

