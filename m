Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152AC1684B4
	for <dm-devel@lists.linux.dev>; Tue,  3 Mar 2026 05:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772516423; cv=none; b=e9Wz0gGYLcSko7OkA0HZxBxWN8GtHWFWjbzbMSjwjT7Kr9r8QnXCmTGGb4AzpdYZYy14Qt+sDUT0p/AaMtzPGGvBsCLjdOuXk7CNaJGhwmMy/i2uQvHR5o+YjfELtdo3MIE9N5K9Hv5lSBoBN21ysxi3GpcExZOmP9dFe7xIrH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772516423; c=relaxed/simple;
	bh=Efrv2cy+F/yE2YkjAE1qPqG9zYUCEuW6ZG9zHXhbxxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=seFAPBhArweAiHyfRGZGWWM7NRuMSRwwxLboMjKgYD5tki9k2A8oDkKvOoDit04o3WM1ax9mVHapUapxi2ChwVceVPijyTXXKeKcQQhhClPnEziPTw5xoC8rXbZZcfwBWMItVgRuYJPpISyYcWhxKqEIWt1RHIbJ8vTOlPIAi8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SWS3YZUj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SWS3YZUj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772516419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wGDXpiZUgPV8wjM7a62PXYfnySDj7E1W1FYiXgU7gPk=;
	b=SWS3YZUjoThOjxIpu2S9PRIPpnoPxxMvuRXJEa7K6fFeJv0+sQL2p5UIt9qBjvQhIejAIm
	zI6L4WpB6ApYl+2N/LFkYsZn2Ugrm03jUoldiBQfwxXk2cPaGOjyC2iW6EdT0twLpTKD0V
	ALnlJIoQS83+YqwevUC9Z+E+UOJ7Vkk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-551-hkpAaKNIMXqbxBv1z2Y9jA-1; Tue,
 03 Mar 2026 00:40:08 -0500
X-MC-Unique: hkpAaKNIMXqbxBv1z2Y9jA-1
X-Mimecast-MFC-AGG-ID: hkpAaKNIMXqbxBv1z2Y9jA_1772516396
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A15D919560B2;
	Tue,  3 Mar 2026 05:39:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBF8319560A2;
	Tue,  3 Mar 2026 05:39:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6235dr2b1875431
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 3 Mar 2026 00:39:53 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6235drsg1875430;
	Tue, 3 Mar 2026 00:39:53 -0500
Date: Tue, 3 Mar 2026 00:39:53 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/24] scsi-multipath: introduce basic SCSI device support
Message-ID: <aaZ0Kf9n79QF4gbR@redhat.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-3-john.g.garry@oracle.com>
 <aaT0Taxs6WgX6m-j@redhat.com>
 <784abca8-9dc1-4fca-b72f-62d55b4cc3f1@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <784abca8-9dc1-4fca-b72f-62d55b4cc3f1@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: TFB-nf7Zd3dpn7yM9G_isrHb9TzaR--I02Q1sP88V6M_1772516396
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 02, 2026 at 11:39:28AM +0000, John Garry wrote:
> On 02/03/2026 02:22, Benjamin Marzinski wrote:
> > > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> > > index 19d0884479a24..cfab7ad1e3c2c 100644
> > > --- a/drivers/scsi/Kconfig
> > > +++ b/drivers/scsi/Kconfig
> > > @@ -76,6 +76,16 @@ config SCSI_LIB_KUNIT_TEST
> > >   	  If unsure say N.
> > > +config SCSI_MULTIPATH
> > > +	bool "SCSI multipath support"
> > At least until this supports ALUA, it should probably be marked
> > EXPERIMENTAL, just so people trying it out aren't surprised if it
> > doesn't multipath their device in the way they expect.
> 
> I think that ALUA support will be mainline acceptance criteria, and I am
> looking to add it now.
> 
> BTW, Hannes suggested to not use the DH ALUA support, so that means to
> separate out the core ALUA support from the DH stuff. So you have any
> opinion on that approach?

I would (perhaps naively) have thought that the device handlers would be
a useful abstraction for dealing with ALUA devices. But, Hannes knows
this code much better than me. like I said before, I'm no scsi expert.

-Ben

> 
> Thanks!

