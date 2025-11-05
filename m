Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C2E18C332
	for <dm-devel@lists.linux.dev>; Wed,  5 Nov 2025 17:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762364385; cv=none; b=cBJiTM7uvGisrhBZ2fvNc2GVrb6bfuwH0RYyqrrsnItbh6Gxcmt/DTO9/mZ5aYoAXPys8HYk3ys/Num9Jnzq3C+utjEfS9ttnWyHF2RnkqGa+jjtRsWETsH/8MHpRO26t18aN+6ksaxxluqfg0WYHu8P9OMcGAHM3YsATpJvqJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762364385; c=relaxed/simple;
	bh=UNBiK/sqsww4AWR5Xfu73m3bS043DijKbuHUWJeYuXI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WnwPB+fvHwQtbZesDzAymenMQbMeRULGA2sR/lGMAmx20VyEWKCgOKukGxgIy6h1Bn2t7pnYrFFQVBwvDHvtlcmO9qo8Ckh21s0oJc/lU7/+RSJY+XAftXt89q/b2wM6OhbQd4XBDjhNnd6fNbKwBsPAd2YE/dEVXL2TGo5D1pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AQtXtjRS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AQtXtjRS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762364382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g8ueqZiLKk2+O/CDtdhkETNFgbrC7R0xw5TSFBEjmF4=;
	b=AQtXtjRSogDem3N4wCcCR0jp0hQbeIylIw70iBpjP+K7SsDNIUnKxtDbWNu5xK7I5JgWIJ
	v8P1x66oDlnbY5pBNtetSowImyvCEqc0NrRtXHZr3NrQ8M2KvKCA1nekAw/oF2xUn81yK0
	0BAcAuQMa9JSzERGCFIyhszvIGc96Go=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-IMM7xUlVMzCzn1WxoEkZcw-1; Wed,
 05 Nov 2025 12:39:37 -0500
X-MC-Unique: IMM7xUlVMzCzn1WxoEkZcw-1
X-Mimecast-MFC-AGG-ID: IMM7xUlVMzCzn1WxoEkZcw_1762364376
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFADE1956088;
	Wed,  5 Nov 2025 17:39:35 +0000 (UTC)
Received: from [10.45.225.163] (unknown [10.45.225.163])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D79921800451;
	Wed,  5 Nov 2025 17:39:33 +0000 (UTC)
Date: Wed, 5 Nov 2025 18:39:26 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Garry <john.g.garry@oracle.com>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    michael.christie@oracle.com, martin.petersen@oracle.com
Subject: Re: [PATCH 0/2] dm-crypt atomic writes support
In-Reply-To: <90b9aaa5-0572-4a3c-afd3-33864daeb814@oracle.com>
Message-ID: <a78c06d6-27ea-55c1-fcba-98ebc0bb7a43@redhat.com>
References: <20251105120244.99752-1-john.g.garry@oracle.com> <7942b0d8-9f5f-d8b5-194a-3dd5b604898a@redhat.com> <90b9aaa5-0572-4a3c-afd3-33864daeb814@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kZdUCSImylPWL7nu0md2CavMJSpYT7V_abTniI5Qw5s_1762364376
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 5 Nov 2025, John Garry wrote:

> On 05/11/2025 15:00, Mikulas Patocka wrote:
> > 
> > 
> > On Wed, 5 Nov 2025, John Garry wrote:
> > 
> > > This small series enables atomic writes support for dm-crypt.
> > > 
> > > Apart from setting DM_TARGET_ATOMIC_WRITES flag, we need to make the
> > > following changes:
> > > - limit atomic write size to dm-crypt max write size
> > > - BUG_ON() any partial completions for when REQ_ATOMIC is set
> > > 
> > > John Garry (2):
> > >    dm: BUG on REQ_ATOMIC in dm_accept_partial_bio()
> > >    dm-crypt: enable DM_TARGET_ATOMIC_WRITES
> > > 
> > >   drivers/md/dm-crypt.c | 21 +++++++++++++++++++--
> > >   drivers/md/dm.c       |  5 +++--
> > >   2 files changed, 22 insertions(+), 4 deletions(-)
> > > 
> > > -- 
> > > 2.43.5
> > 
> 
> Hi Mikulas,
> 
> > 
> > Thanks for the patches, I reworked them a bit.
> > 
> > Regarding the first patch - note that the device mapper stack may be
> > arbitrarily reconfigured, so it is possible that REQ_ATOMIC bio may be
> > sent to a target that doesn't support atomic writes - and this could
> > trigger the "BUG_ON(bio->bi_opf & REQ_ATOMIC);".
> 
> When reconfigured, the dm device request queue limits are re-evaluated, right?

It may or may not be re-evaluated. If you stack LVM volume group on the 
top of another LVM volume group, and if you change something in the lower 
volume group, the upper group has no way of finding out that the 
underlying physical volumes (which are logical volumes on the lower group) 
were reconfigured.

Similarly, if you stack dm-crypt on the top of a logical volume and change 
the limits of the logical volume, dm-crypt has no way to find you that the 
underlying logical volume was reconfigured.

There is also time-to-check - vs - time-to-use race condition. Someone may 
see that a device has non-zero atomic_write_hw_max, construct an atomic 
write bio, the device could be reconfigured after the bio was contructed 
and before the bio was dispatched - and the atomic bio would be sent to a 
dm target that is not expecting it.

Mikulas

