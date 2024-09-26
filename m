Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205AAE56A
	for <dm-devel@lists.linux.dev>; Thu, 26 Sep 2024 15:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727362974; cv=none; b=JihfuTFaCvR/bpSdk5eFfZAAL5qaUkU16WhXDuIKLmm4L+vlNlwjInThEEQNECbm235riiarJFeOnJOEleL4W5ITUGg/NnK8rsrAY3SHnmhBSKxQi19jpK3de9zp6SjROE78Zv9r5kiYDmu5UyKWyeFczJjYP2nLF1XTKSxXKtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727362974; c=relaxed/simple;
	bh=CSRmlhnp9AvsmmYQf1H8J/iswNXs/+Ho7IxL9lhjlT8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lVbQBFDaiBHg8K7g13WCbB2Gu4X6IiDIylaRZ5XkMHIhjwQeIZd1ETTG1AGavXlVXARbkoEP6TPBpzc/9g9pjx2G0wBjSqexM5reOX/jRb+nYqu2D4tTtjl9D+lrfynucrb0f2nuAQPug9uj/MG5eiNoityrHruCQgy2lS+mnM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KmmQL1VE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KmmQL1VE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727362972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sIgxS+1AS6f3U9IGl0zvT6F/IdVtdZ/1kvAwAseJQeY=;
	b=KmmQL1VEIQCzplR1NmCS4vl8n+NGc/6Zc/+inLUGe+czmQFuEhPrYtbw9ffLd/yRxICF+S
	YTGorHlGdiebEyL+vr/3xB/rk+bOMjzub2EuERYEQlVKNB7vSFK+HPmRiMWT9OXFh9SmX6
	NePy5y2UgD8QjSR96PyhXYSgfYFYBJU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-315-M13QeHOyODGDxqfxrUFQxg-1; Thu,
 26 Sep 2024 11:02:44 -0400
X-MC-Unique: M13QeHOyODGDxqfxrUFQxg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EEB7E1944A88;
	Thu, 26 Sep 2024 15:02:42 +0000 (UTC)
Received: from [10.45.225.58] (unknown [10.45.225.58])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A5F619373D7;
	Thu, 26 Sep 2024 15:02:41 +0000 (UTC)
Date: Thu, 26 Sep 2024 17:02:38 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Luca Boccassi <luca.boccassi@gmail.com>
cc: dm-devel@lists.linux.dev, snitzer@kernel.org, serge@hallyn.com, 
    wufan@linux.microsoft.com
Subject: Re: [PATCH] dm verity: fallback to platform keyring also if key in
 trusted keyring is rejected
In-Reply-To: <CAMw=ZnRO3WTm4Ad=MA99ehiDei4cAYG7zSQFEMUYhUKaUmmb=Q@mail.gmail.com>
Message-ID: <63220688-ac55-e1fc-300d-c93a948801e3@redhat.com>
References: <20240922161753.244476-1-luca.boccassi@gmail.com> <8b212fc8-c67a-2973-fc5c-0cb61d165fd5@redhat.com> <CAMw=ZnRO3WTm4Ad=MA99ehiDei4cAYG7zSQFEMUYhUKaUmmb=Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 25 Sep 2024, Luca Boccassi wrote:

> > > diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
> > > index d351d7d39c60..a9e2c6c0a33c 100644
> > > --- a/drivers/md/dm-verity-verify-sig.c
> > > +++ b/drivers/md/dm-verity-verify-sig.c
> > > @@ -127,7 +127,7 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
> > >  #endif
> > >                               VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
> > >  #ifdef CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
> > > -     if (ret == -ENOKEY)
> > > +     if (ret == -ENOKEY || ret == -EKEYREJECTED)
> > >               ret = verify_pkcs7_signature(root_hash, root_hash_len, sig_data,
> > >                                       sig_len,
> > >                                       VERIFY_USE_PLATFORM_KEYRING,
> > > --
> > > 2.39.5
> >
> > Hi
> >
> > Please describe what problem does this patch solve. I.e. why would anyone
> > put a key into the trusted keyring that could sign the roothash and
> > restrict its usage so that it can't be used to sign the roothash?
> >
> > In the other places of the kernel, only -ENOKEY is tested:
> > kexec_kernel_verify_pe_sig:
> > if (ret == -ENOKEY && IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING))
> > s390_verify_sig:
> > if (ret == -ENOKEY && IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING))
> > do they need to be converted to -EKEYREJECTED too?
> 
> To be perfectly honest, I do not have a use case for the EKEYREJECTED
> fallback - it was suggested by Serge when I was working on the IPE
> keyrings usage:
> 
> https://lore.kernel.org/all/20240920020217.GA528455@mail.hallyn.com/
> 
> I would like to maintain the usage of keyrings in sync between the two
> components given they are used together, for consistency, so I
> counter-proposed to send the change to dmverity first. I am following
> up on that promise with this patch.
> If there are reasons not to take this change, or if there are no
> convincing reasons to take it, I do not have strong opinions either
> way so I don't mind what the outcome is either way, as I am just
> following up on that review comment. I'll let Serge explain the
> reasoning for the request, if he wants to do it.
> 
> If this change is accepted, I will send the same for IPE. If not, I
> won't. I do not directly use other subsystems that use these keyrings,
> so I will not send changes for those even if this goes in.

Hi

I accepted this patch, I'll send it to Linus with other device mapper 
patches.

Mikulas

