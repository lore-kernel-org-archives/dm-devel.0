Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3625192D80
	for <dm-devel@lists.linux.dev>; Thu,  5 Sep 2024 07:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725522838; cv=none; b=ELyqw6zY1IpgNCp/N7ad4O4OlR9YWsxQArjWfU5aTRvspzz60SpHIwdhB773aIZBUbm4nFaP8kwLmsvJTZtWh8FpTbgRZb6caOX+J89G+NPNeqdq8ofcgv4n3b7ETBCa6Tzag2zB/vsWwAQs7oLxTYSsLA1qanJccwBO0hCM3z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725522838; c=relaxed/simple;
	bh=yS+07PXc5/xgvY/sIIJryK5hY4xV8bAj7jy8IxBcF9c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WFdS6uAa8vof/iwEdGMMh/s6ROlXXtOuTZVwoCGxVLqtd427sja7Q5L5WNn6xIOE8dCdV0ahXGnLi4SxS9YStpwYZt4wFB0RgrpPXeMXOLnqfZMYOCnn4zlAsLH89Nf93FH72wytWf3p3MP/5JzIKfqLB+Ckz9Sa9CoZZLbMz+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EKnU6+ux; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EKnU6+ux"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a86859e2fc0so69060366b.3
        for <dm-devel@lists.linux.dev>; Thu, 05 Sep 2024 00:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725522834; x=1726127634; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yS+07PXc5/xgvY/sIIJryK5hY4xV8bAj7jy8IxBcF9c=;
        b=EKnU6+uxaDafCuLEbHDsrrImvk51nsfUEzuQu/PTpRR5oeCo/4UnLT85iZGEqvSEtZ
         KXcgASpTHzqSAJGjofGFzlL/2eTSiLR/O4HhgXQYhroXIncHo998CZ6Rdscyt2++H4wx
         0rxQSzfHan86d6+xjJaU5ckxViaHTD0j10z1+pNm8vVJoO7DFQMgu94VELm+Cv9ctNZh
         NhakdRNCOJpGmmpGM5Li96slJO2BS2wPNEaH/qdPJMoT9PKLXSAtWT0AxP1ZzFH4wMwC
         EIMVvGscc4GiBftLMJZuj6Kr+w854ISroBEwVlyWtuoR+PgGYOSvBtB2wwIm7XMqmKjf
         JHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725522834; x=1726127634;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yS+07PXc5/xgvY/sIIJryK5hY4xV8bAj7jy8IxBcF9c=;
        b=WaHt/WpSn/WfJ1bQv2QtQ4OF2n6/gr6Tavy3Z9ICUS9nUOXvIU3p50Pg86zn86fjXG
         cWwjxR+OBcgDTsucXaHsosHe4bVr48KUk5DphJgZNCp9DdVaq9XSvkdVXa7d2hQW2WU6
         pkaLXSEPsiqapv8YJOuUBze2E+8CcP/MPdPvza2hX4VMKMJJCZjcZvZPJzKDFj8VMuIJ
         C4NQz/EQyo1xdzKU1saG4HlDY5ooQU1im6vCxtTop/1EDYzY9S4h6B0EAa6ymP8qW3bi
         fgnHu6IdlX1dFt9VG6ATxrqW3UJiDk28vRDsquIq9yfSSvFTOTvqlS4+x5vnAIugyWRB
         /n3g==
X-Forwarded-Encrypted: i=1; AJvYcCUxLMflE9xJWKTPs4oG0bcwGdEX8OmX6/UiVHYfBlE29qrXPCojjMiknIIQlQZjGaZJeL3fUXQF6w==@lists.linux.dev
X-Gm-Message-State: AOJu0YwqITmFsi/SJo6NB+PW5jBR02Dto+QJbi8UjrkFS0n/Crk5snBK
	e0eG6dCtTqnAq/3xFUNTvGOpi4CZj9mk5MJtf8szpwvyryYEMFLcLSAk8hqVhXJ95imCwP49AAe
	M
X-Google-Smtp-Source: AGHT+IHIQEp08cCxmN9JPKGYbe5dxErLstaXunqQNpMwTArBRx5/9Ev2ogAdPBvvKQRwvrN9QerK8g==
X-Received: by 2002:a17:906:df46:b0:a8a:7062:23ef with SMTP id a640c23a62f3a-a8a70623650mr52371266b.32.1725522833622;
        Thu, 05 Sep 2024 00:53:53 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a623c1ee0sm96306966b.160.2024.09.05.00.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 00:53:53 -0700 (PDT)
Message-ID: <95f3cdf6556991bf981e1d74e4cd6ce6ebb6f9cd.camel@suse.com>
Subject: Re: [PATCH 04/15] libmultipath: remove pending wait code from
 libcheck_check calls
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Thu, 05 Sep 2024 09:53:52 +0200
In-Reply-To: <ZtjOWgPfSNcHrOj1@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-5-bmarzins@redhat.com>
	 <de20ab3264728d3ce0d56b7f6debe79315ae72fd.camel@suse.com>
	 <ZtjOWgPfSNcHrOj1@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-09-04 at 17:17 -0400, Benjamin Marzinski wrote:
> On Wed, Sep 04, 2024 at 10:05:30PM +0200, Martin Wilck wrote:
> > On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> > > When the tur and directio checkers start an asynchronous checker,
> > > they
> > > now immediately return with the path in PATH_PENDING, instead of
> > > waiting in checker_check(). Instead the wait now happens in
> > > checker_get_state().
> > >=20
> > > Additionally, the directio checker now waits for 1 ms, like the
> > > tur
> > > checker does. Also like the tur checker it now only waits once.
> > > If it
> > > is still pending after the first call to checker_get_state(). It
> > > will
> > > not wait at all on future calls, and will just process the
> > > already
> > > completed IOs.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > Now I understand what you're doing, but I find it somewhat
> > confusing. I
> > believe this can be simplified after the split between starting the
> > checkers and looking at their result.
> >=20
> > Why not just fire off the checkers, wait 1ms for _all_ the just
> > started
> > checkers in checkerloop() [*], and then do the pending test like it
> > is
> > now (but just in polling mode, with no c->timeout)?
>=20
> That's probably possible. You would also need to put that wait in
> pathinfo().

pathinfo() is tricky because it's written with the assumption that the
result is obtained synchronously. Maybe in pathinfo we should just fire
up the checker and set the status to PENDING. But we might as well not
run the checker at all, just set the checker interval to minimum, and
let the checkers do their work. (I like that idea, actually).=C2=A0

Another idea would be to define an exception for pathinfo(), and
actually wait for completion there, not until c->timeout expires, but
somewhat longer than we currently do.

> The big reason I did it this way was so nothing outside of the
> checker
> itself needed to care about things like if the checker was set to
> async
> and whether or not the checker was actually async capable and if this
> was a newly started async check or if the checker had already been
> pending for a cycle, where waiting another 1ms was pointless.

Right, the sync property should be hidden. If sync checkers are in use,
none of the recent changes will have much of a positive effect. I'd
like to convert all checkers to async mode. Just need some time to do
it :-/ AFAICS, the only sync checker that still matters is rdac.

Below is some brainstorming from my side.=C2=A0
Ignore it if it makes no sense.

We currently use the path state, in particular PATH_PENDING, to infer
the state of the checker (thread, aio request), but that doesn't give
us the full picture.

We should be able to distinguish the path state and the state of the
checker itself, which can be IDLE, RUNNING, or DONE. The checker
provides an API checker_state() (I can't think of a better name) to
retrieve its state. The path state can (only) be retrieved in DONE
checker state. When the path state is retrieved, the checker state
switches to IDLE. checker_start() switches from IDLE to RUNNING.
checker_wait(timeout) waits until the RUNNING checker reaches DONE, or
the passed timeout is reached. A timed-out checker
(wrt c->timeout) has state DONE with path state PATH_TIMEOUT.

Sync checkers would have a degenerated API where checker_start() and
checker_state() would be noops.

> This way, you just call checker_get_state() on all the paths were you
> ran the path checker, and if at least one of them needs to wait, then
> the first one that does will wait, and the rest won't. If none of
> them
> need to wait, then none of them will.

This makes sense.=C2=A0But the "wait" you're talking about is the 1ms delay=
,
after which the paths may well still be in PATH_PENDING. It's actually
not much different from not waiting at all, we've just decreased the
likelihood of PATH_PENDIN. 1ms is just an estimate, and, in my
experience, too short in many environments.

The real benefit of your patch set is that we now start all (async)
checkers in parallel. Which means that we can wait longer, increasing
the likelihood that the checkers have actually finished, while spending
less total time waiting. "Waiting longer" is a bit hand-waving; IMO it
should be handled further up in the stack rather than down in the
checker code.

We could achieve the behavior you describe in checkerloop, like this:

 - record start_timestamp
 - fire off all handlers
 - calculate end_time as start_timestamp + some_delay=20
 - use that end_time for waiting for results of all fired-off checkers

Like in your example, we'd really wait for no more than 1 path.
We could do this for the entire set of paths, or for each multipath map
separately.

Regards
Martin

