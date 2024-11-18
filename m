Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE441E7657
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 21:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731964509; cv=none; b=mBfM41BOCtsZpQDLNCza6rV+I5w6tTNBmXOxC+XJcUNc/BPVZvYYvjDaG4OKA1tkKLwms0hoHzSKXfoxnAlD2ZainIVQtBGiNoAuAWjGcX8o//gID84l9ZvOZlj2Y1WuswoeomfcSinqdfff3x9DxptSZ5DJWys/Oi2u+jJooCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731964509; c=relaxed/simple;
	bh=LPHDGADmtNNcmlg7Vvt+3gWX4AeEiKoymc0TeRVaebE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=hhWXSPAmkiNZW0i2TOEHiT6b7gRU4we/MmMA/S44zKwxidjdxAhbxsEASL/A7r5kHS/dlw+K0w0aJ4wq0++5P+rjTMZ46B2pZ+qy3/Xx6IbDWYWd5aaSLxCJ3/nPFhJzm67sbeV0YItuyxYpUDD+4AmXtDcFYJ0E3DMF7zyQlNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C/Vh8fyC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C/Vh8fyC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731964506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RVpcXBD5z/WfY5mqH0etjPKIppH99IZib6hWXi+addw=;
	b=C/Vh8fyCIQcXYQv6KCvVEvdGN+xmnL/wbEHQExVQSJqvi1McvQYzYHuPHjLgSpPogiQt5g
	52Am6Z+B7xkPb6cuY5X8pPu7XRSJyPJDH3e8nFc35Az+TQY7A9GX0SqcByoHzJ8qWZEhAc
	R35Dj9x2v4/Rzwe/rqvATo8ydhc3cA0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-600-e6VuAYRBPFO3hBBlPepw0w-1; Mon,
 18 Nov 2024 16:15:00 -0500
X-MC-Unique: e6VuAYRBPFO3hBBlPepw0w-1
X-Mimecast-MFC-AGG-ID: e6VuAYRBPFO3hBBlPepw0w
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A2C51954230;
	Mon, 18 Nov 2024 21:14:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3ABFB1955F3C;
	Mon, 18 Nov 2024 21:14:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AILEvsA667891
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 18 Nov 2024 16:14:57 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AILEvCK667890;
	Mon, 18 Nov 2024 16:14:57 -0500
Date: Mon, 18 Nov 2024 16:14:57 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 0/6] multipath-tools: Handle tableless DM devices
Message-ID: <ZzuuUTMJgFPWV16s@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
 <fbab2026d6850617f84da01c9c075f468295aa3b.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <fbab2026d6850617f84da01c9c075f468295aa3b.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7fZNY9IEYBdLxekgXvVgGJxh9phdVFzU3-S0l7nKBCQ_1731964499
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Nov 18, 2024 at 12:18:20PM +0100, Martin Wilck wrote:
> On Fri, 2024-11-15 at 18:22 -0500, Benjamin Marzinski wrote:
> > 
> > I'm not completely happy with the MAPINFO_ID_IF_FOUND flag. An
> > alternative would be to run a second libmp_mapinfo() call without
> > MAPINFO_MPATH_ONLY to grab the name, if the first failed with
> > DMP_EMPTY.
> > If people think that's a better way to solve this, I can rework those
> > patches.
> 
> We could simply choose to always fill in this information if the
> the caller has requested it, without an additional input flag. It's not
> an expensive operation. Is there a reason not to do this?

Your comments in the code said that libmp_mapinfo() will not touch any
of the output parameters if it doesn't succeed. I didn't audit the code,
but I can certainly imagine a situation where you passed in pointers to
some varaibles that already had values and you didn't want those values
overwritten unless libmp_mapinfo() returned DMP_OK.

But I can go look and see if any callers would get messed up if name or
uuid got set, even when the found device didn't match.

-Ben

> 
> Thanks
> Martin

