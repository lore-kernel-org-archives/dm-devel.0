Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1415A1DFF8
	for <dm-devel@lists.linux.dev>; Thu, 27 Mar 2025 17:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743095555; cv=none; b=Gt6PsO8Lu1wS+s2uD2dAo9AEyzfYgMnnmPl7p2D1ZMTrgAdeJJJTE18gMZfWDOjEOi6y7R3hvCJhiySBEoxR6eq8JUnvwQyB+6D5QCjwwWqBqsP76qgvdwpbhmtUNGFpAyxxYCB7YygvtC2pX4wTqQ1Ce6yBhMvz6GNNOOwkli8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743095555; c=relaxed/simple;
	bh=ggTv7fKrarHgNmEmYhPg/drHjrKAOorRd5RikBYREFM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=r5hZQZGI1waSL9pLzBkIXmNQSlBW3/apic6dxN/ygiqudW6LBCYumkA26u0k6XWI4aSQ0tUTROAuk4cxMlR/nCqj96JEaIUaMgtCAc5fsLQ+Kffuy65RfjxszJXBa8/xpPf+fqHyjTgjm5/wDkbpzgrJHlzyfdc3KGmCiN8ZCR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MLG48yOW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MLG48yOW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743095552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xv+u19ACMQrcMgTmswOIm+sQfnvd5qphJgxtYSjJvKc=;
	b=MLG48yOWn7I/YxfqUCjjpMDlMMs0q8SYq4uGzVTcm8l+R1nUB8SNc/2knAOIUsOz/Tiic+
	/HmHtkJTUXGqtF2dV2nGMLPkKy806uNdC+cEEK5Qa+PLNlMuzAbSd2R+oVAWakiDvLlwRz
	T5kTWemwoY4MlQ5dBbXY8MMEXFuehcU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-207-3jj1PjrCNB28LMjxSCkp5g-1; Thu,
 27 Mar 2025 13:12:29 -0400
X-MC-Unique: 3jj1PjrCNB28LMjxSCkp5g-1
X-Mimecast-MFC-AGG-ID: 3jj1PjrCNB28LMjxSCkp5g_1743095548
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A4E61801A07;
	Thu, 27 Mar 2025 17:12:28 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 623B91956095;
	Thu, 27 Mar 2025 17:12:25 +0000 (UTC)
Date: Thu, 27 Mar 2025 18:12:22 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: LongPing Wei <weilongping@oppo.com>, agk@redhat.com, 
    dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org, 
    Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] dm-verity: support block number limits for different
 ioprio classes
In-Reply-To: <20250327170524.GF1425@sol.localdomain>
Message-ID: <6421ae31-5b4a-f35a-724c-1970ec3ab06b@redhat.com>
References: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com> <20250326013049.1292617-1-weilongping@oppo.com> <93b863a6-24f3-2281-c9a7-c3e59b2a6ec2@redhat.com> <431f8798-e0e5-362c-bf6b-fb6cddadd4b2@oppo.com> <20250326165336.GB1243@sol.localdomain>
 <052d22b6-2d49-7faf-49f3-742c9b79fc8e@redhat.com> <20250326204845.GB6625@sol.localdomain> <dd421003-2d7f-4d35-aa77-12d319454160@oppo.com> <20250327170524.GF1425@sol.localdomain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 11qjnqBbspmnmdRe_Vnjqs6Mki-vkmPHjAu2VWPhMqw_1743095548
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 27 Mar 2025, Eric Biggers wrote:

> > Hi, Eric
> > 
> > It seems that verity_prefetch_io doesn't work efficiently.
> > dm_bufio_prefetch_with_ioprio
> >   __dm_bufio_prefetch
> >     blk_start_plug
> >     for loop
> >       __bufio_new
> >       submit_io
> >       cond_resched
> >     blk_finish_plug
> > 
> > If more than one hash blocks need to be prefetched, cond_resched will
> > be called in each loop and blk_finish_plug will be called at the end.
> > 
> > The requests for hash blocks may have not been dispatched when the
> > requests for data blocks have been completed.
> 
> Well, it's always possible for the prefetch I/O to be too slow, but the way it
> works does seem to be unnecessarily bad.  The prefetch work runs on a kworker,
> which is going to slow things down.  The way it should work is that verity_map()
> runs the prefetch work and starts, but doesn't wait for, any I/O that is needed.
> (And of course, most of the time no I/O will actually be needed.)
> 
> - Eric

dm-verity used to prefetch from the verity_map function, but it caused a 
deadlock - 3b6b7813b198b578aa7e04e4047ddb8225c37b7f - so, it was moved to 
a workqueue.

Mikulas

