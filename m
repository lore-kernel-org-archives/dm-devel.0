Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EE514831C
	for <dm-devel@lists.linux.dev>; Thu, 26 Sep 2024 15:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727365334; cv=none; b=R76GT/np60H4d9MsSAufSBPvvLjZYXiJkTGdd6vcZ0R+oIw1lZ9SFiBc34oPzcB+ZDBtkEgrmzXNr68mXz3mMZpxyS6jTWeykw4DnSaYer7xb5e5xryAORi1YvRZRht5d74bZJSTYskg+O/vXhu8jXavtEhQlbYRfr9xbdOt5Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727365334; c=relaxed/simple;
	bh=3W2fZfGEpX/lFK6wM2IKAUgSsnsQjM1m2n/hzraSYW4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W+p5lN6Xptes7hGQX5Nx7ayefM+Inl0ZslCKDJMIp4UQzQmlHSV9BCHJMcMHRjqbDZIq8NNS0eijaTPvLH4sniWaaJav2rSvx+RIZF2vfd7Lx0sFXhwIgyIckktblYdqyLo2e72cszUOowdLpWR/+DehSuRSgtUFCGhznecBobo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E8kSqbdO; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E8kSqbdO"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-6db9f7969fdso10615937b3.0
        for <dm-devel@lists.linux.dev>; Thu, 26 Sep 2024 08:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727365332; x=1727970132; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mFXuhvPZOqx6BX8p8CigHMhK4QXUREK7gnTBmym06JE=;
        b=E8kSqbdO7xjbv+bW/3awcVgEF7kqoV62xncTBQafbAGfzstG6JHqMzOxVNJpkKonzY
         89DaG+MSLZ8dfCd68yiJwWBkNHJ6Qqss5JQw7SR0Z+nrdD9Be1KUivxuJjaN2EvbamZ+
         pBm/5tV6p6gtq8BHpTG6K5rP5pvTx1gHQ39MLnW2NhmEtMbZO/jo5trKVSzZ7dJ/TUE/
         s5fLoFoDtGCqhA8MTrR5DihdsdlKIwwHdFz15Q3AMB/XKl7R0wq30Y77ZGJcLyaAe6Pn
         L3SL0Niwg0TOA/8t2qbRQfrfPeRB5mjuYYWq3PMG8KipSLRyuqiroXrAjN1FM6ltPWu+
         OflA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727365332; x=1727970132;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mFXuhvPZOqx6BX8p8CigHMhK4QXUREK7gnTBmym06JE=;
        b=mYZoPIYid0nXA1FGO4oAUx/+LkUGL6guECQl1xaC3+X28g0rSl4Z4wTWQeackDRMmO
         Mg/83r6mmYZLGNhr/gG8OadFC0TW9Jc/jVkD4QGo5H1x5UnfXPklam/r5xl8Tfbxowcs
         2uIBb7xJ/0HJG4eHm+eqEhUUxZiKlAxifoiGYb6cTsiKPkQR6OWUZhx/TFLfBcLa4I1y
         GYzndB/nQFO9zJ9tMaWz3ysfxa5nMt4WcXA29M3hkkCX16VBLL7CoxFHaurAyFkyZ3r7
         hE7rGGWdi9fnkywoB9Ua5AV1YDjbFtd2WSzT1Oj7T1/DnjKFt0S410SoeWumUSkJYk0C
         S5yg==
X-Gm-Message-State: AOJu0YxmfOdYYdGSF6Sep/yrDzAql5hOElAp7XxYuF+gcUYhp+QUtFh4
	hpofhBvQDTk/sKV0183UMYK4RVqMz19UavMzT0gNhPbRX4ibQ4mwnGpCJbPHsnLmTqhfAAfYTXy
	3EJX4f+ucv7fnf+mPg3YmGAMUqp4=
X-Google-Smtp-Source: AGHT+IHReuLBdwZJ85ws7DfN/kR55+PgEKvpPhQaa5DlJn0PGXKNFSttNwVZbYQB3bjL3I+IcXUe2Qh110cN3dxX08U=
X-Received: by 2002:a05:690c:3486:b0:66b:c28b:f234 with SMTP id
 00721157ae682-6e2454a43b9mr1581777b3.21.1727365330687; Thu, 26 Sep 2024
 08:42:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240922161753.244476-1-luca.boccassi@gmail.com>
 <8b212fc8-c67a-2973-fc5c-0cb61d165fd5@redhat.com> <CAMw=ZnRO3WTm4Ad=MA99ehiDei4cAYG7zSQFEMUYhUKaUmmb=Q@mail.gmail.com>
 <63220688-ac55-e1fc-300d-c93a948801e3@redhat.com>
In-Reply-To: <63220688-ac55-e1fc-300d-c93a948801e3@redhat.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Thu, 26 Sep 2024 17:41:59 +0200
Message-ID: <CAMw=ZnScWJKPRqwKxaYPbHAjd7-XqLbroHk12X977pVa=Hcs3Q@mail.gmail.com>
Subject: Re: [PATCH] dm verity: fallback to platform keyring also if key in
 trusted keyring is rejected
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, snitzer@kernel.org, serge@hallyn.com, 
	wufan@linux.microsoft.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 26 Sept 2024 at 17:02, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
>
> On Wed, 25 Sep 2024, Luca Boccassi wrote:
>
> > > > diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
> > > > index d351d7d39c60..a9e2c6c0a33c 100644
> > > > --- a/drivers/md/dm-verity-verify-sig.c
> > > > +++ b/drivers/md/dm-verity-verify-sig.c
> > > > @@ -127,7 +127,7 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
> > > >  #endif
> > > >                               VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
> > > >  #ifdef CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
> > > > -     if (ret == -ENOKEY)
> > > > +     if (ret == -ENOKEY || ret == -EKEYREJECTED)
> > > >               ret = verify_pkcs7_signature(root_hash, root_hash_len, sig_data,
> > > >                                       sig_len,
> > > >                                       VERIFY_USE_PLATFORM_KEYRING,
> > > > --
> > > > 2.39.5
> > >
> > > Hi
> > >
> > > Please describe what problem does this patch solve. I.e. why would anyone
> > > put a key into the trusted keyring that could sign the roothash and
> > > restrict its usage so that it can't be used to sign the roothash?
> > >
> > > In the other places of the kernel, only -ENOKEY is tested:
> > > kexec_kernel_verify_pe_sig:
> > > if (ret == -ENOKEY && IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING))
> > > s390_verify_sig:
> > > if (ret == -ENOKEY && IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING))
> > > do they need to be converted to -EKEYREJECTED too?
> >
> > To be perfectly honest, I do not have a use case for the EKEYREJECTED
> > fallback - it was suggested by Serge when I was working on the IPE
> > keyrings usage:
> >
> > https://lore.kernel.org/all/20240920020217.GA528455@mail.hallyn.com/
> >
> > I would like to maintain the usage of keyrings in sync between the two
> > components given they are used together, for consistency, so I
> > counter-proposed to send the change to dmverity first. I am following
> > up on that promise with this patch.
> > If there are reasons not to take this change, or if there are no
> > convincing reasons to take it, I do not have strong opinions either
> > way so I don't mind what the outcome is either way, as I am just
> > following up on that review comment. I'll let Serge explain the
> > reasoning for the request, if he wants to do it.
> >
> > If this change is accepted, I will send the same for IPE. If not, I
> > won't. I do not directly use other subsystems that use these keyrings,
> > so I will not send changes for those even if this goes in.
>
> Hi
>
> I accepted this patch, I'll send it to Linus with other device mapper
> patches.
>
> Mikulas

Thank you!
