Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D23A2E338E
	for <dm-devel@lists.linux.dev>; Tue, 25 Mar 2025 01:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742867988; cv=none; b=T06h0wU5m7FnSWfMSmjGRU6Qi3wBE5sbAMBL9KexrxfZ2gZduxbd1nmFv/TWeBHRB7wVStwI2gk1n1ouwSVzlaMYRLUPE5XzUp/2uPKVD+muji2xEKSfWAZU94CFUn3pPNfIIttIpi2kTZAe3669AA6WO7/wWkDIPSWrnwX/UbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742867988; c=relaxed/simple;
	bh=a3SfM2E5itAxigNlTNED5nn2jtUfVzltN7dHP5+Trqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LrnOLH5otNR1drZPLO7tmga/P5QB3ll5yEcclfS7ymzcdrGk6xawGUspo2N9qSVbmBxXS3jdWssNGcUMSUSH3oAQfyU1jo6V81PqUqIbK3MUEv2EZq4SJJqd3yF5itYABW4lmh/MqEhlPGGH6OHikAD2WBWrdHKKXGUrmZSJSW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P8kmmruG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P8kmmruG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742867985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=clpnkbJfvqv7SZHVgPNYOHrHbGjyXELYMANBu3LzwQ0=;
	b=P8kmmruGY3WkIIOV9SMCXFzaCCR/JgHQkPCiVuyWM8PaZWwvHVTZVTyi6OyGoXKMc+VVXF
	OrU/EX7NE7qn7uyfs7j+1/Rd/WPPtRF14Rhiz2+U9bGIg6eXVENW1aqcLZS+fMnSoRPnQH
	0tbtXbjuZtL8IFXK3U0yFAgJZtTLtkk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-UUi8lV3ROiaQ-l5fU0UsJA-1; Mon,
 24 Mar 2025 21:59:42 -0400
X-MC-Unique: UUi8lV3ROiaQ-l5fU0UsJA-1
X-Mimecast-MFC-AGG-ID: UUi8lV3ROiaQ-l5fU0UsJA_1742867981
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8AC8E1801A1A;
	Tue, 25 Mar 2025 01:59:40 +0000 (UTC)
Received: from fedora (unknown [10.72.120.10])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A9A919560AD;
	Tue, 25 Mar 2025 01:59:32 +0000 (UTC)
Date: Tue, 25 Mar 2025 09:59:26 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Jooyung Han <jooyung@google.com>, Mike Snitzer <snitzer@kernel.org>,
	zkabelac@redhat.com, dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH V3 0/5] loop: improve loop aio perf by IOCB_NOWAIT
Message-ID: <Z-IN_qS0Z3Tw_fHX@fedora>
References: <20250322012617.354222-1-ming.lei@redhat.com>
 <174266520675.800027.959344570613955585.b4-ty@kernel.dk>
 <aed4f9cd-863b-44b8-bc24-68ac67eb75f2@kernel.dk>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aed4f9cd-863b-44b8-bc24-68ac67eb75f2@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Mon, Mar 24, 2025 at 08:50:14AM -0600, Jens Axboe wrote:
> On 3/22/25 11:40 AM, Jens Axboe wrote:
> > 
> > On Sat, 22 Mar 2025 09:26:09 +0800, Ming Lei wrote:
> >> This patchset improves loop aio perf by using IOCB_NOWAIT for avoiding to queue aio
> >> command to workqueue context, meantime refactor lo_rw_aio() a bit.
> >>
> >> In my test VM, loop disk perf becomes very close to perf of the backing block
> >> device(nvme/mq virtio-scsi).
> >>
> >> And Mikulas verified that this way can improve 12jobs sequential rw io by
> >> ~5X, and basically solve the reported problem together with loop MQ change.
> >>
> >> [...]
> > 
> > Applied, thanks!
> > 
> > [1/5] loop: simplify do_req_filebacked()
> >       commit: 04dcb8a909b5b68464ec5ccb123e9614f3ac333d
> > [2/5] loop: cleanup lo_rw_aio()
> >       commit: 832c9fec8e2314170c5451023565b94f05477aa7
> > [3/5] loop: move command blkcg/memcg initialization into loop_queue_work
> >       commit: a23d34a31758000b2b158288226bf24f96d8864d
> > [4/5] loop: try to handle loop aio command via NOWAIT IO first
> >       commit: dfc77a934a3acdb13dadf237b7417c6a31b19da8
> > [5/5] loop: add hint for handling aio via IOCB_NOWAIT
> >       commit: 4c3f4bad7a6e9022489a9f8392f7147ed3ce74b1
> 
> Just a heads-up that I had applied this for testing, not necessarily to
> get included. To clear up that confusion, I have retained patches 1-3
> for now, and then we can queue up 4-5/5 later when everybody is happy
> with them.

Fine.

I'd see the reason if there is, looks not see it anywhere, :-)

And it should have been posted on mail list.

Christoph suggested per-cmd struct, which does cause regression for
the usual sequential IO workload from both throughput and cpu utilization viewpoints,
and this thing has been observed 10 years ago when enabling loop dio/aio.

https://lore.kernel.org/lkml/1439778711-9621-4-git-send-email-ming.lei@canonical.com/

And my recent test shows same result too:

https://lore.kernel.org/linux-block/Z9I2lm31KOQ784nb@fedora/

Mikulas's test shows per-cmd struct works much worse than this patchset:

https://lore.kernel.org/linux-block/7b8b8a24-f36b-d213-cca1-d8857b6aca02@redhat.com/

And anything else?


Thanks,
Ming

