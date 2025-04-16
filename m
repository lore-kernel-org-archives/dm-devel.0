Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F4E2DFA49
	for <dm-devel@lists.linux.dev>; Wed, 16 Apr 2025 12:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744807557; cv=none; b=LDUAGQYtjjo33iF9njtyp6uRlqw8xCJVY/Tn0bucG+e9iZ1eASoigFuH5TbzkkIzuX0xVXh148e/ji/luHw6mkl1BWWNxhqqEs2x4QsYnNFvYR+f3ILNPaw/5pfmFUdtTQtuZrWqjPZkMb8GF6nbaZnGI+mUpQAbHbSWAcWUI20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744807557; c=relaxed/simple;
	bh=fQtUiDGoyLjGJt7V22gRqUyNo5fWr936Y/pKCwHh8aY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ps1tc2OJoDQWRteBmnbpB00IlAw5IcZapbVSjCbXfOuC0Dh9nWFR/pSA/wralWXmMkx2NmgUmYbSrWvlU8wBfcqk/qRGZVnsqu4ps0O+s73ggh/9ysXNSpILprH9scNnIlet1gNKBlTdfXMiEeZnroagu7+JFOXWVq6UMwdfX6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=btnglncW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="btnglncW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744807554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2s85+0fw6j9g2sq+YLtYlofEgkeXmcMUSHjYEvYmFc4=;
	b=btnglncWjLKgTLw67MT3on82yC9lvBVtrghEY8DQvQYEeoEtXpfOCUXmLshCko8f0tFiDk
	6piaxXh9U8NNzWLd3mdI18KoodvQM9vudbXonQj3dY9wBhC+tGcP9WFm7mm4GCKA6TQDm6
	KfBe3FjzkTmBshrAYkj6ganIW7TzA0M=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-Abz_BaK5PE-9_4_YYnpDxg-1; Wed,
 16 Apr 2025 08:45:53 -0400
X-MC-Unique: Abz_BaK5PE-9_4_YYnpDxg-1
X-Mimecast-MFC-AGG-ID: Abz_BaK5PE-9_4_YYnpDxg_1744807552
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 11D25180036E;
	Wed, 16 Apr 2025 12:45:52 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 05DB4180045B;
	Wed, 16 Apr 2025 12:45:49 +0000 (UTC)
Date: Wed, 16 Apr 2025 14:45:47 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
    Christoph Hellwig <hch@lst.de>, Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2] dm-delay: Prevent zoned write reordering on suspend
In-Reply-To: <79733459-5674-4bd3-9a33-dd5fbd7ed651@kernel.org>
Message-ID: <cadd3b0f-2eca-c8af-62e9-27dd528007bd@redhat.com>
References: <20250411000435.1007720-1-dlemoal@kernel.org> <81bd6eca-6d62-6934-9007-28eaef465bb7@redhat.com> <79733459-5674-4bd3-9a33-dd5fbd7ed651@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CLzm2bxjTwCNG_vgaiESSwvAMY_bTFJxYdIscuS2Wcc_1744807552
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 15 Apr 2025, Damien Le Moal wrote:

> > Hi
> > 
> > I looked at the generic device mapper code and it seems that ordering of 
> > write bios is not guaranteed with any target in case of suspend/resume.
> > 
> > * we suspend the device:
> > * received bios are added to md->deferred in queue_io
> > 
> > * we resume the device:
> > * __dm_resume calls dm_queue_flush
> > * dm_queue_flush clears DMF_BLOCK_IO_FOR_SUSPEND and submits work item 
> >   &md->work (dm_wq_work)
> > * dm_resume clears DMF_SUSPENDED
> > * the device starts accepting new bios in dm_submit_bio
> > * dm_wq_work runs concurrently with new bios that are received, so 
> >   ordering of bios is not preserved
> > 
> > So it doesn't make much sense to try to fix it in dm-delay, if it isn't 
> > supposed to work at all.
> 
> Just need to fix the generic DM resume code then. This patch fixing dm-delay is
> still relevant even with DM generic resume fixes.
> 
> I can resend the dm-delay fix together with DM core resume fixes. And Benjamin
> can re-send the dm-delay kthread timer cleanup independently (I will rebase) or
> on top of that fix series. Does that work for you ?

I would like to know why is this needed. If you have a zoned device, you 
can send one big write bio, wait for the big bio to finish, send another 
big write bio, wait for it to finish and so on. Then, there will be at 
most one write bio oustanding and you don't have to care about kernel 
reordering in-flight bios.

It seems that you want to send many small overlapping write bios - the 
question is why? Why can't the application accumulate the content and send 
it as one big bio?

I'm a bit worried that supporting this ordering will just bloat the kernel 
with marginal benefit.

Mikulas

