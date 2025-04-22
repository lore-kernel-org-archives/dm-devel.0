Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC2B20B80D
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 11:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745321241; cv=none; b=gnIAGmw6YSUiAiOqZQBg6IH7H98Lml8LwBm68+erRzl7ZJyMEIbfACJvxXJtKhW7zPPQGqVAuuNBqbSxI7VBYQlGAZO3nksqZWoNFvsUF5WcJjMbdpd7vIzdXhl8zAbOI36MO3O+xx9vXGtHRiuXMzbWLjYUPRdQbwtmfulnsSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745321241; c=relaxed/simple;
	bh=83zpv/jr4mUUwQBgyzKRgMnNFx7fQrsVcMYw/C4vDDU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=uY+Ru7+6dnygNryAtd4hYiyQ5QIM752Mt/6BGCSE6DbtVbGzAk0FKH6Qz1RZoCgioh8vDSLQ8oOWeQwakStB4FfhO5YtEjMMCp+ZGxpxIdZH73AWW47DM1Q2YqjvuwXSGD2J5Ao6MzOmRpdvcopEcc7FsenVr7bYsIFhtYE74oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PM71jA3q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PM71jA3q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745321238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fp9npfNSCzI3A1Vzwn+mamTiLC/gV+N/q3HK69kvMnc=;
	b=PM71jA3qKymnqZSjrKM2dO4qKcscnzlzJqyVpz+Sf3APc5nEGd8fGWpVM/gFOaDUWYM/Ti
	gHPcPtGlk3+CRItCdWhO7JwXaUsu3nWCXXdlrLHrgLNknz03M4tzs0Wv/1+pux0e3S0T/b
	4G8oEydUYCJr6N0n6CLt0fI4TEHwbpc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-436-Oub2peEeNr2FZutuYERw2w-1; Tue,
 22 Apr 2025 07:27:14 -0400
X-MC-Unique: Oub2peEeNr2FZutuYERw2w-1
X-Mimecast-MFC-AGG-ID: Oub2peEeNr2FZutuYERw2w_1745321233
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C31CD1800873;
	Tue, 22 Apr 2025 11:27:13 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A084195608F;
	Tue, 22 Apr 2025 11:27:11 +0000 (UTC)
Date: Tue, 22 Apr 2025 13:27:07 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
    Christoph Hellwig <hch@lst.de>, Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2] dm-delay: Prevent zoned write reordering on suspend
In-Reply-To: <222c2fac-ae6d-4b6a-8a83-a40eaf044d44@kernel.org>
Message-ID: <d9c47917-0ff9-5d6a-01a3-cbb357ca6812@redhat.com>
References: <20250411000435.1007720-1-dlemoal@kernel.org> <81bd6eca-6d62-6934-9007-28eaef465bb7@redhat.com> <79733459-5674-4bd3-9a33-dd5fbd7ed651@kernel.org> <cadd3b0f-2eca-c8af-62e9-27dd528007bd@redhat.com>
 <222c2fac-ae6d-4b6a-8a83-a40eaf044d44@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nNVhjuh51YwhdYjcHHVW8nhK-ewhhJUUSKM_Qql_oyg_1745321233
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 18 Apr 2025, Damien Le Moal wrote:

> > It seems that you want to send many small overlapping write bios - the 
> > question is why? Why can't the application accumulate the content and send 
> > it as one big bio?
> 
> That is the application problem. On HDDs at least, small IOs will hurt
> performance. SMR or not, same problem. Intellignet applications will try to
> shape their workload to optimize performance. But that point is irrelevant here.
> The kernel porvides a service: process write requests, regardless of how big
> these requests are, if they are correct (i.e. for zoned devices, they must be
> issued in order by the user), we must correctly execute the writes.
> 
> > I'm a bit worried that supporting this ordering will just bloat the kernel 
> > with marginal benefit.
> 
> Bloat ?

We would need three states instead of two: normal, suspended, resuming (so 
it would bloat all the device mapper logic with another state). There's 
dm_wq_work using submit_bio_noacct, which wouldn't work, as it would 
immediatelly enqueue the bio for suspend again, so we would need some 
other path to submit the bio.

dm_wq_work would have to transition the device from the "resuming" state 
to the "normal" state when it processes all the bios, but it is called for 
various other reasons too.

> everything is already in place to preserve the order of write operations
> to zoned devices, since a long time ago.

What if the controller doesn't preserve the order of writes? I think that 
there was some bit for that, but I forgot its name. So we can simply not 
set the bit for device mapper - and the applications will have to deal 
with it by using write plugging.

> What has not been covered are cases
> like suspend/resume which may, depending on what they do, break the ordering
> guarantees that we have for write requests. The only reason this has not been
> fixed is because I completely overlooked these cases as zoned block devices were
> in the past mostly used in enterprise systems where suspend/resume is not really
> used at all. But we have zoned UFS devices these days (smart phones), so
> properly supporting DM suspend/resume is important I think.

Do you mean zoned flash devices? I've never heard of them.

Mikulas

