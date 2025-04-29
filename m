Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7215F259C9B
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 23:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745968948; cv=none; b=QmIQxgfFy8gqTQN9hQ9IEeCpvoQltEkehVQXcSrNr/pakoKW/AsJ5pk2J5cl3TaBD/wyCJ5bkbl+G7JdO7+f3vWZpAQaDUEqB3YMSaopU7rpUqG7WusogMCvuJXGkdu9cz/IxcDlYHirqw3uprU1cIQrkiqGV0h48s+d42HM4cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745968948; c=relaxed/simple;
	bh=WzfneLUF71nwMb39f90k2M2wMSzoqz+AoCAN88mC2xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RsTMaReACsnbYKRCCUWLOMTIE88QBWJ/mA6hH2B9r/Yf+EITgKOfC1KuwdoNj334ij6L2wccKNbZ4j5DQu1JfgxtKoz5mhifkEQaff2RrjAoJyH1er4NpPXsKIXygnCoVFKvKolBTUExVwaWugkT3UUBAvbOTtu1q2DFWYArhrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vh2zjE79; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vh2zjE79"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745968945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bTAWF2C0eWaVPLl3EljTYXnqPDcpVmEElm6gYW/I8BY=;
	b=Vh2zjE797yb1jIOlJxCnk4ayeb9Aej4wGfUqm5JX3g3ID1nU3l4eFMxJnnvDgnBnbABk8M
	GT1g/Fq2gV4bfPhwXMnxPMOT6mU3NjI2COUwUlVbMNIP7xMieZM5kGeTHhQC0JHEd1rvL/
	uFEh91bvF1IxbLSWzm4fBtYM8FyqM4A=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-394-KZqTePyIP_6fHKJ7iaDzvg-1; Tue,
 29 Apr 2025 19:22:22 -0400
X-MC-Unique: KZqTePyIP_6fHKJ7iaDzvg-1
X-Mimecast-MFC-AGG-ID: KZqTePyIP_6fHKJ7iaDzvg_1745968941
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A7101955DC5;
	Tue, 29 Apr 2025 23:22:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C56A419560A3;
	Tue, 29 Apr 2025 23:22:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53TNMJ431956522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 29 Apr 2025 19:22:19 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53TNMJVg1956521;
	Tue, 29 Apr 2025 19:22:19 -0400
Date: Tue, 29 Apr 2025 19:22:19 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Kevin Wolf <kwolf@redhat.com>
Cc: dm-devel@lists.linux.dev, hreitz@redhat.com, mpatocka@redhat.com,
        snitzer@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dm: Allow .prepare_ioctl to handle ioctls directly
Message-ID: <aBFfK8mdxZ5dCW-0@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <20250429165018.112999-2-kwolf@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250429165018.112999-2-kwolf@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Apr 29, 2025 at 06:50:17PM +0200, Kevin Wolf wrote:
> This adds a 'bool *forward' parameter to .prepare_ioctl, which allows
> device mapper targets to accept ioctls to themselves instead of the
> underlying device. If the target already fully handled the ioctl, it
> sets *forward to false and device mapper won't forward it to the
> underlying device any more.
> 
> In order for targets to actually know what the ioctl is about and how to
> handle it, pass also cmd and arg.
> 
> As long as targets restrict themselves to interpreting ioctls of type
> DM_IOCTL, this is a backwards compatible change because previously, any
> such ioctl would have been passed down through all device mapper layers
> until it reached a device that can't understand the ioctl and would
> return an error.
> 
> Signed-off-by: Kevin Wolf <kwolf@redhat.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

