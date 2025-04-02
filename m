Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF21D2E3374
	for <dm-devel@lists.linux.dev>; Wed,  2 Apr 2025 18:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743619496; cv=none; b=NFri49QFBUaFo8xiRltnXAbqikLFnIxIHQdAVP8HryCSZDKUFDYG4Vt1ahlM9jR6D7DxmRxiVUjY1APWAUB9j0KP96mOd+xPQW8fVRF31gjogoORpGd0BH/Rt9mmIc16YflrA0hSgFfiU2f3en+6F+sJnI++5JZaonGED7M356U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743619496; c=relaxed/simple;
	bh=ZXzQYGM0IfSN/VXmW6ygLF1UHWSiMta3Z24QzOrbTQU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=J1Seoni2zcbmdP67ox7gSvy2WaVqkzTfi0T5odyy26jLcBfpE7HjqNJV0m70CRkJVWJ5CNoJ4rmWd9ZW4GkS9AxQUhuRtRAkATgZkLR9evclcWIoZGoseKt8ZZMDfgX02y8IbnIQQSbfXPuQZB0sjerwEmiT/sHWrlCMMsG7Lbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aKSnXfvr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aKSnXfvr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743619492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K8ZS4ySQVIEpledRddq2ZWwDdKNzinha3IqvjZ3uXaA=;
	b=aKSnXfvrOLL7Mz5Eb7R0dTKEIMbxgAW9fL5K6oWzEAXEW4pehPB0w6hOXUoJC1pJLYbxWV
	THEmGWWcPJvhgg0Oly2c9/Qybvhl5ZbRJd64KitUM6f0ty0btcGqIstzyg5iFJ9WAjWMyz
	xn9jNiJYEOo96mpv2PdGVTn8NtzuakI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-462-mYhaWRIKNMuYnLd3H6ZRkg-1; Wed,
 02 Apr 2025 14:44:47 -0400
X-MC-Unique: mYhaWRIKNMuYnLd3H6ZRkg-1
X-Mimecast-MFC-AGG-ID: mYhaWRIKNMuYnLd3H6ZRkg_1743619486
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 24B7C180AF4C;
	Wed,  2 Apr 2025 18:44:46 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F27119560AD;
	Wed,  2 Apr 2025 18:44:43 +0000 (UTC)
Date: Wed, 2 Apr 2025 20:44:39 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: LongPing Wei <weilongping@oppo.com>
cc: snitzer@kernel.org, dm-devel@lists.linux.dev, guoweichao@oppo.com, 
    ebiggers@kernel.org, bvanassche@acm.org
Subject: Re: [PATCH 2/2] dm-verity: prefetch all hash blocks in verity_ctr
In-Reply-To: <d25b56ad-fa6f-49db-9a78-d4849742b22e@oppo.com>
Message-ID: <7228249e-db9d-be26-8459-9141ec3b3ceb@redhat.com>
References: <20250402070934.2387587-1-weilongping@oppo.com> <20250402070934.2387587-2-weilongping@oppo.com> <8ec81db3-fff0-71be-e643-b74cb5bb88de@redhat.com> <d25b56ad-fa6f-49db-9a78-d4849742b22e@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rqgRqWv5FtB4ZzedFRnoX3uoZzDU7fI8O5LJkY2cmww_1743619486
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 2 Apr 2025, LongPing Wei wrote:

> On 2025/4/2 17:56, Mikulas Patocka wrote:
> > 
> > 
> > On Wed, 2 Apr 2025, LongPing Wei wrote:
> > 
> > > At this time, all bios for hash blocks should eventually
> > > be merged into a single large bio.
> > > 
> > > Signed-off-by: LongPing Wei <weilongping@oppo.com>
> > > ---
> > >   drivers/md/dm-verity-target.c | 4 ++++
> > >   1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> > > index 3c427f18a04b..813d5cfc7ffa 100644
> > > --- a/drivers/md/dm-verity-target.c
> > > +++ b/drivers/md/dm-verity-target.c
> > > @@ -1683,6 +1683,10 @@ static int verity_ctr(struct dm_target *ti,
> > > unsigned int argc, char **argv)
> > >     	verity_verify_sig_opts_cleanup(&verify_args);
> > >   +	dm_bufio_prefetch_with_ioprio(v->bufio, v->hash_start,
> > > +		v->hash_blocks - v->hash_start,
> > > +		IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, 0));
> > > +
> > >   	dm_audit_log_ctr(DM_MSG_PREFIX, ti, 1);
> > >     	return 0;
> > > -- 
> > > 2.34.1
> > 
> > Hi
> > 
> > I would move it into the "resume" callback, so that if the user
> > reconfigures the device stack between "ctr" and "resume", it won't read
> > the data too early.
> > 
> > Don't use IOPRIO_CLASS_RT, this is not real-time requirement,
> > IOPRIO_CLASS_RT would slow down concurrent I/O.
> > 
> If the prefetch io is submitted with non-rt at first, the later dm io
> need the same hash block will wait the non-rt bio.

Submitting large I/O with IOPRIO_CLASS_RT will block every other task that 
does some I/O, so I can't do that. It needs to be changed to 
IOPRIO_CLASS_NONE or IOPRIO_CLASS_IDLE.

> > Another problem with this approach is that when the verity device is big
> > and system memory is small, it just causes I/O churn - new bufio blocks
> > will be displacing old blocks - and it will degrade performance, not
> > improve it.
> > 
> Do we need a solution to check if the memory is enough to the prefetch?

Yes.

> For Android devices, the verity device should be created on the boot
> procedure.

> > Please, describe some scenario, where this prefetch actually helps. What
> > is the size of the metadata that you are prefetching? What is the total
> > memory size? Is there any benchmark that shows the advantage of this
> > patch?
> 
> The size of hash blocks for the ROM of our low-end devices is about
> 71MiB. I want to enhance probability of cache hit when
> try_verify_in_tasklet is enabled. How about only doing the prefetch when
> try_verify_in_tasklet is enabled?
> For example:
> 	if (v->use_bh_wq)
> 		dm_bufio_prefetch_with_ioprio(v->bufio, v->hash_start,
> 			v->hash_blocks - v->hash_start,
> 			IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, 0));

I wouldn't overload the "use_bh_wq" option for that. Perhaps we could add 
a new option (that would be off by default), so that the patch won't cause 
problems to existing users.

How much does this patch improve Android boot time? So that we can decide 
whether the improvement is worth the complexity.

Mikulas

