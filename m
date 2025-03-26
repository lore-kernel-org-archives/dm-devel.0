Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DAF17F7
	for <dm-devel@lists.linux.dev>; Wed, 26 Mar 2025 18:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743015047; cv=none; b=JIyAuUoNCufxXADuz+ezonAXs1Z/nf2S1J6559l8SyuxiMyettGyRmpb3wMEwkujO5WTCUO3T5ahWGXiI+qRvFMQ9KY1ZAYv9UBrlDl7UjthUYqpBqM1OlvCLj1LPKaqUSfz6DX/tG5jSA7BqEWWkg+mGXxe85Ptn8YMXBarMEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743015047; c=relaxed/simple;
	bh=HaO1eXsWwYFBIqQKH3BzfVbD8ISblX+/cW2FwwvJw0I=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=UOax12c3VxbemILUybeaHPgW+AdYhStNuTRe6QjLTPAEvnvQj4X1pgkAuLhFjFm7bbOcNCawKQHDFJ8mffVY2BVzu64Ojelc6wUC2ZmY5dQ2NMTErpDau9sktr8BSjj8EiyLPVvyNC/iE+vqlSShh0+iA0FYO7jxeMVsCPAsm6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WiB7k407; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WiB7k407"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743015045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qPLgXml+4SPrinvre/q2huBQ3R0je/gc0dlfRu7e+cI=;
	b=WiB7k407h7yZxLetEoLomw3G4952TT2X4YfX/selCjg3qmNoG3KiT5RbdCEbl1KkHwvRHh
	cyaLo23rA0bm+65MsPWjnNSLfF+2Joj8TeEQI1+KmgZ35JR686v8kEZGHk3HpeeCaORk0T
	jYCB8mAhalEnd8QAwzFEc1YwHghSX8M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-153-ijh-iZKQNoikc8qK2wvTmw-1; Wed,
 26 Mar 2025 14:50:42 -0400
X-MC-Unique: ijh-iZKQNoikc8qK2wvTmw-1
X-Mimecast-MFC-AGG-ID: ijh-iZKQNoikc8qK2wvTmw_1743015040
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B12C01944F0A;
	Wed, 26 Mar 2025 18:50:40 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A732D180175A;
	Wed, 26 Mar 2025 18:50:38 +0000 (UTC)
Date: Wed, 26 Mar 2025 19:50:34 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: LongPing Wei <weilongping@oppo.com>, agk@redhat.com, 
    dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org, 
    Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] dm-verity: support block number limits for different
 ioprio classes
In-Reply-To: <20250326165336.GB1243@sol.localdomain>
Message-ID: <052d22b6-2d49-7faf-49f3-742c9b79fc8e@redhat.com>
References: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com> <20250326013049.1292617-1-weilongping@oppo.com> <93b863a6-24f3-2281-c9a7-c3e59b2a6ec2@redhat.com> <431f8798-e0e5-362c-bf6b-fb6cddadd4b2@oppo.com> <20250326165336.GB1243@sol.localdomain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V4fGwBcHXms2vh1czuvPAVNIP375ff8PsqprJV_mDaM_1743015040
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 26 Mar 2025, Eric Biggers wrote:

> On Wed, Mar 26, 2025 at 09:32:27PM +0800, LongPing Wei wrote:
> > On 2025/3/26 19:04, Mikulas Patocka wrote:
> > > 
> > > 
> > > On Wed, 26 Mar 2025, LongPing Wei wrote:
> > > 
> > > > Calling verity_verify_io in bh for IO of all sizes is not suitable for
> > > > embedded devices. From our tests, it can improve the performance of 4K
> > > > synchronise random reads.
> > > > For example:
> > > > ./fio --name=rand_read --ioengine=psync --rw=randread --bs=4K \
> > > >   --direct=1 --numjobs=8 --runtime=60 --time_based --group_reporting \
> > > >   --filename=/dev/block/mapper/xx-verity
> > > > 
> > > > But it will degrade the performance of 512K synchronise sequential reads
> > > > on our devices.
> > > > For example:
> > > > ./fio --name=read --ioengine=psync --rw=read --bs=512K --direct=1 \
> > > >   --numjobs=8 --runtime=60 --time_based --group_reporting \
> > > >   --filename=/dev/block/mapper/xx-verity
> > > > 
> > > > A parameter array is introduced by this change. And users can modify the
> > > > default config by /sys/module/dm_verity/parameters/use_bh_bytes.
> > > > 
> > > > The default limits for NONE/RT/BE/IDLE is set to 4096.
> > > > 
> > > > Call verity_verify_io directly when verity_end_io is in softirq.
> > > > 
> > > > Signed-off-by: LongPing Wei <weilongping@oppo.com>
> > > 
> > > Are you sure that 4096 bytes is the correct threshold?
> > > 
> > > I suggest that you run the benchmarks for 4k, 8k, 16k, 32k, 64k, 128k,
> > > 256k, 512k and set the default threshold to the largest value where bh
> > > code performs better than non-bh code.
> > > 
> > > Mikulas
> > > 
> 
> 4096 bytes sounds good to me.  As I mentioned elsewhere in the thread
> (https://lore.kernel.org/dm-devel/20250326164057.GA1243@sol.localdomain/),
> objections keep getting raised to doing more work in softirq context due to
> potential impact on real-time tasks.  So while more I/O benchmarks would be
> interesting, they are also not the whole story and we should probably prefer a
> more conservative threshold.  Also, dm-verity I/O requests have a bimodal
> distribution with peaks at 4 KiB (for synchronous reads) and 128 KiB or
> read_ahead_kb (for readahead) anyway, so most of the impact should come from 4
> KiB anyway.
> 
> 8 KiB could also be reasonable when taking into account multibuffer hashing
> though, since multibuffer hashing makes hashing two 4 KiB blocks almost as fast
> as hashing a single 4 KiB block.  (Though multibuffer hashing is currently
> Android-only, as the crypto maintainer keeps rejecting it upstream.)
> 
> - Eric

OK, so I'll set it to 8KiB.

Do you think that I should increase this limit to "unlimited" for 
IOPRIO_CLASS_RT and disable this feature at all for IOPRIO_CLASS_NONE?

Mikulas

