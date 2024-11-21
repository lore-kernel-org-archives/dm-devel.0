Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147441AAE1B
	for <dm-devel@lists.linux.dev>; Thu, 21 Nov 2024 18:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215112; cv=none; b=ZWDejhcQVoLInqopMW6aDjYtUeOU6o8/lrBfvUEYCsgE4b16dPDTMRK0i71ccBWALBm2wXT8rFWcX0lmTKhXfbd3zoyC15gWOqzDYpTeKwvo21FSV33VIlWU6hcPIxZm+qxWccpszrEN0Xen/aMNNbThJ/t/vtrNnVQOz9mj0Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215112; c=relaxed/simple;
	bh=MT2dAJwQByCl0JEix3lW0Rg/ua9/5CR34awMKKTsEZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=dJh8q1HH72KUG/NCU70NvmjXbcZKsQk3lFtaKSaV30rB/IPVG3vOkwt9FMFzMbO+a31b5EmnIBWf5GIhrxe/CWau5crfkaldL+mstjX+So9d9YPvd960ZgkY07gxoRhzEB9IwqMnlzOKH6H2Zh1mlXDEr0+R/s9MwCob9uatnJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WZVmQzJT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WZVmQzJT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732215110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T5zChLocM2dVUjG5mHnsfETA7yCIVmCSHZaytjAmhfQ=;
	b=WZVmQzJTy2vzlnUzQuC55YsuzRYbz2oh2DgYSrcmElsGicMTiOsJMVNRE7hvn//Fr7gnFw
	M5ov/G8qJcWTl74Ays9ZOdRtt06n81CT7bYx4kHSxli9hJPR2ltYeVhOj/BYsDIz5KIbZo
	0vL4IeF5AEBqUtXQvz7s33FFgjD+eI4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-208-znfqguAvPNGKeXAlLm7_GQ-1; Thu,
 21 Nov 2024 13:51:46 -0500
X-MC-Unique: znfqguAvPNGKeXAlLm7_GQ-1
X-Mimecast-MFC-AGG-ID: znfqguAvPNGKeXAlLm7_GQ
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 971ED1954B1E;
	Thu, 21 Nov 2024 18:51:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C1C41956056;
	Thu, 21 Nov 2024 18:51:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4ALIphYO707369
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 21 Nov 2024 13:51:43 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4ALIphZW707368;
	Thu, 21 Nov 2024 13:51:43 -0500
Date: Thu, 21 Nov 2024 13:51:43 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] libmultipath: Fix MAPINFO_CHECK_UUID with partitions
Message-ID: <Zz-BP7jAWjBfZeOX@redhat.com>
References: <20241121001744.699362-1-bmarzins@redhat.com>
 <6f53bcf8b37d466e92609ab0a21672ff50914461.camel@suse.com>
 <Zz9_-QcFat49thMA@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Zz9_-QcFat49thMA@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IJPS6PFTD1jMAm80kFtOBpbezT-J0DUwRwFRjjcLc00_1732215105
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Nov 21, 2024 at 01:46:17PM -0500, Benjamin Marzinski wrote:
> On Thu, Nov 21, 2024 at 06:05:48PM +0100, Martin Wilck wrote:
> > On Wed, 2024-11-20 at 19:17 -0500, Benjamin Marzinski wrote:
> > > In libmp_mapinfo__(), if is_mpath_part_uuid() succeeded, instead of
> > > ending the 'if' statement, is_mpath_uuid() would be called because of
> > > the OR operator.  This would always fail if is_mpath_part_uuid()
> > > passed.
> > > This meant that libmp_mapinfo__() could never match partitions with
> > > MAPINFO_CHECK_UUID.
> > > 
> > > Fix that by not calling is_mpath_uuid() if MAPINFO_PART_ONLY is set.
> > > 
> > > Fixes: c1aa0285 ("libmultipath: make MAPINFO_CHECK_UUID work with
> > > partitions")
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > 
> > Ouch. Thanks!!
> > Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> So, in theory the next step would be to open a PR for the upstream
> stable branch, if that existed, right?

But I suppose the better actual plan here is just to update the 0.11.0
PR.

> 
> -Ben

