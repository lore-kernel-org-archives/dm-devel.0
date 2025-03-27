Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDC017E4
	for <dm-devel@lists.linux.dev>; Thu, 27 Mar 2025 19:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743102207; cv=none; b=ZTHEFsiBtLjcJ3jjobEpRltlFSCSEk+qxlo1bJ1Denf2IdtTdLuEcRedhmoI0zWJyP8Rz5anhmsM+A9B8Jf7i0WLUA/ZbVlznfm74tOZP1k43EIitFLlmffWJIN6ClgspHt41cj9He6pRnhsp/JLDsFPJMQvC8eCNneu/eBMfvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743102207; c=relaxed/simple;
	bh=21OZWe2ICTQnU74HQSulR98ImmkXlo3LRJ7rhjcRt/I=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=MmTtaMjvQPw4bD5MDhMUN/VWnw/cxpNykteas/K+78GfWrMZ65ONCQ9wjMY5bnc8wV7ffLnFECxrSztslpuVSgaLmtBOTIr8k936S2G7HP8MeoTlRQP7A1Bx8jGQulUOB1ek05UPckj2XHFB0soga/8yNddFPVPj/edJmt3cQsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FS466vlI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FS466vlI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743102203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=73mwpJjGcW6R3vrU+A4U6Yr3DEHhaocaH6wsNjhzyHY=;
	b=FS466vlIKhVN+epqr6NqYXJUiLh5105d3TbHHyMc3Nqr6Zzokc2Da7asBsJd/zymGDri7P
	oBpX0k6xHk6JL7kuVhvyMcOmd6L8flcSSQuXMXsGekq+LXs543dk4i9eMEYCAE2gcrfUBk
	yMpEcNh1NtLIG4/LceMZapCoUgmGiXU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-307-IFomcrX5PlWUzlrhAbTygw-1; Thu,
 27 Mar 2025 15:03:18 -0400
X-MC-Unique: IFomcrX5PlWUzlrhAbTygw-1
X-Mimecast-MFC-AGG-ID: IFomcrX5PlWUzlrhAbTygw_1743102191
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A04819560BA;
	Thu, 27 Mar 2025 19:03:11 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71286191F241;
	Thu, 27 Mar 2025 19:03:09 +0000 (UTC)
Date: Thu, 27 Mar 2025 20:03:04 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: LongPing Wei <weilongping@oppo.com>, agk@redhat.com, 
    dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org, 
    Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] dm-verity: support block number limits for different
 ioprio classes
In-Reply-To: <20250327173510.GA3371050@google.com>
Message-ID: <a5553d19-d773-b004-e848-6cd2f2839d6f@redhat.com>
References: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com> <20250326013049.1292617-1-weilongping@oppo.com> <93b863a6-24f3-2281-c9a7-c3e59b2a6ec2@redhat.com> <431f8798-e0e5-362c-bf6b-fb6cddadd4b2@oppo.com> <20250326165336.GB1243@sol.localdomain>
 <052d22b6-2d49-7faf-49f3-742c9b79fc8e@redhat.com> <20250326204845.GB6625@sol.localdomain> <dd421003-2d7f-4d35-aa77-12d319454160@oppo.com> <20250327170524.GF1425@sol.localdomain> <6421ae31-5b4a-f35a-724c-1970ec3ab06b@redhat.com>
 <20250327173510.GA3371050@google.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OIFPegOkhk0qQDShupXufkUsKqH5glQefGeTFOoCpSI_1743102191
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 27 Mar 2025, Eric Biggers wrote:

> On Thu, Mar 27, 2025 at 06:12:22PM +0100, Mikulas Patocka wrote:
> > 
> > 
> > On Thu, 27 Mar 2025, Eric Biggers wrote:
> > 
> > > > Hi, Eric
> > > > 
> > > > It seems that verity_prefetch_io doesn't work efficiently.
> > > > dm_bufio_prefetch_with_ioprio
> > > >   __dm_bufio_prefetch
> > > >     blk_start_plug
> > > >     for loop
> > > >       __bufio_new
> > > >       submit_io
> > > >       cond_resched
> > > >     blk_finish_plug
> > > > 
> > > > If more than one hash blocks need to be prefetched, cond_resched will
> > > > be called in each loop and blk_finish_plug will be called at the end.
> > > > 
> > > > The requests for hash blocks may have not been dispatched when the
> > > > requests for data blocks have been completed.
> > > 
> > > Well, it's always possible for the prefetch I/O to be too slow, but the way it
> > > works does seem to be unnecessarily bad.  The prefetch work runs on a kworker,
> > > which is going to slow things down.  The way it should work is that verity_map()
> > > runs the prefetch work and starts, but doesn't wait for, any I/O that is needed.
> > > (And of course, most of the time no I/O will actually be needed.)
> > > 
> > > - Eric
> > 
> > dm-verity used to prefetch from the verity_map function, but it caused a 
> > deadlock - 3b6b7813b198b578aa7e04e4047ddb8225c37b7f - so, it was moved to 
> > a workqueue.
> 
> Interesting.  Unfortunately I think the workqueue makes it way worse.
> 
> In principle there is no need for it to block for anything.  If it would have to
> block, it just should just continue on.
> 
> - Eric

That seems to be right concern. Should I disable prefetch and add a switch 
to enable it on demand? Or delete the prefetch code entirely?

There is also a bug that prefetch may race with suspend, sending I/Os even 
when the dm-verity device is suspended - but that is fixable by adding 
flush_workqueue to the postsuspend hook.

Mikulas


