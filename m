Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC98548E3
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 18:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714675474; cv=none; b=pJ7zRtdJRf07xej14UyGnBnbHrHG8anFCBMoNKL51g3hiYTAK6pe9ZeKWxxpDV6ff12byhw9TkMQEd1jQaX3f8jua4wwMyXAnC75f9jPPUVuJFIZ74VpxFtKcPGhWP6RLeFNAcB4D8a2I5jvYBftXz3ansPY/TNPRbjxSfYvhpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714675474; c=relaxed/simple;
	bh=PH36IRfJDTLMgUNBZKttF+wtrqilgSHlT+3RcfoKM7Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N1PSHXRwn1g58HW14Nrda3PLN7We1Blty5rRz4TYywGeCtnalZq9nmEk7wBAJSCjQHJLPbOz/GY4aCfPVfecNkWxPicdCWRtfFmOjxDseUNqYQpEJ7VpIm2Ue/TdxHDD0bGS6FLHSIgwxW8AE2VJHOB9QKHRk8TzfNJCsM6qVvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f5C5Poi7; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f5C5Poi7"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a58eb9a42d9so824825366b.0
        for <dm-devel@lists.linux.dev>; Thu, 02 May 2024 11:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714675470; x=1715280270; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PH36IRfJDTLMgUNBZKttF+wtrqilgSHlT+3RcfoKM7Y=;
        b=f5C5Poi7j3iUZd2cQOxSoHtMlpFXkGXLlI9Y/JUIzIpG5Zr5xjmDUf/quCfJx8UH6t
         oIcUmclOFP0erqH7Joh1MIUQeEt9gUa3P1AQm90I07tPAyoUAHYwscGUS0WtG2/ISfpd
         /peNaRdUMvR1Vv6a2REPI6bYFqW+uYv/wH8s0beloqq4lB3iVSV56WqI3c1v2H3UPags
         A2TswL2pZ/btAVyz+IGoGehC2f3vK/zFX1WLhxlBV3u4X4bUCk8ynqnOarA+y03fZo8c
         8iCHOvNCcfOmaX8HmjYvnrNndGGyNiwsnEGZlsCQ3VRSbeexSeAP1O7301i5joOc+M2a
         fISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714675470; x=1715280270;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PH36IRfJDTLMgUNBZKttF+wtrqilgSHlT+3RcfoKM7Y=;
        b=L0qvahbx/GHtIClKvruRA2BmTBAQC0sseQQwPd/QWE3JcDy2/QAOPW3Z/Wg5nmCqVU
         yRmZg5hiB04JvDO1PAyJAFW+vUMnH26Yv8qQA3cI83eoumLJ1BOwcuXvm7OjsfR/T5iz
         QHBcfX6FEYM1XPJB+/4o5+AHz2eAlIhoc9G5QpqSTIkDPAnW6dpVrZySRLM7gQpfnQ5B
         dz1QoVRRtHOAhw8QaqWKgfrjLtPTuzNSgn4Tkg2D/lOK1tvCGrgHuJB7d8y8EM2CrGn2
         zrkghKqrnlUSYwLnYMr2x1KXrAdCeNM0RFopmo3U9j5F6AaPdoRk856U7ObZFhdCTNih
         bqaQ==
X-Forwarded-Encrypted: i=1; AJvYcCU69fJaz//EIIRv3vMOYvnKLndl1B2YDAybq3sUEaxmvUUXK0bDmSrRVXVTq2X5OJj7bzTUr3coxjNo9rzDFdVGKUsCXLAsZtg=
X-Gm-Message-State: AOJu0YykEpcFH9ta/XGOt9jWHBN4Ra32aqUzN78R5douDjzdQRgjwZ7u
	TswxvLacC1Bs9dkncCUC0H0SqCMZOXD2TN3UxYLr0KFFWw41jlwbVTLo05MtCriIQmkvQciwjJb
	7
X-Google-Smtp-Source: AGHT+IFQ11quun/aQveOs4INi+09UbKTQlO3QbGzlMh+86lyk1vayfbc80X4LRdpdLCBpABhF3nIvA==
X-Received: by 2002:a50:d756:0:b0:572:7926:a0f9 with SMTP id i22-20020a50d756000000b005727926a0f9mr162926edj.41.1714675469832;
        Thu, 02 May 2024 11:44:29 -0700 (PDT)
Received: from ?IPv6:2003:de:373e:dc00:b298:a6be:282c:8242? (p200300de373edc00b298a6be282c8242.dip0.t-ipconnect.de. [2003:de:373e:dc00:b298:a6be:282c:8242])
        by smtp.gmail.com with ESMTPSA id c10-20020a0564021f8a00b005727e826977sm792109edc.19.2024.05.02.11.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 11:44:29 -0700 (PDT)
Message-ID: <f37205021bc5d7e57425022e57f315ff003d2214.camel@suse.com>
Subject: Re: [PATCH v2 4/5] libmultipath: pad dev_loss_tmo to avoid race
 with no_path_retry
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Thu, 02 May 2024 20:44:28 +0200
In-Reply-To: <ZjO50C2hB8MilnHV@redhat.com>
References: <20240425233517.2125142-1-bmarzins@redhat.com>
	 <20240425233517.2125142-5-bmarzins@redhat.com>
	 <9ee49b7c07938b38e39161a5a9143a472b01bff6.camel@suse.com>
	 <ZjO50C2hB8MilnHV@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-05-02 at 12:05 -0400, Benjamin Marzinski wrote:
> On Thu, May 02, 2024 at 05:14:56PM +0200, Martin Wilck wrote:
> > On Thu, 2024-04-25 at 19:35 -0400, Benjamin Marzinski wrote:
> > > Currently multipath makes sure that dev_loss_tmo is at least as
> > > long
> > > as
> > > the configured no path queueing time. The goal is to make sure
> > > that
> > > path
> > > devices aren't removed while the multipath device is still
> > > queueing
> > > in
> > > hopes that they will become usable again.
> > >=20
> > > This is racy. Multipathd may take longer to check the paths than
> > > configured. If strict_timing isn't set, it will definitely take
> > > longer.
> > > To account for this, pad the minimum dev_loss_tmo value by five
> > > seconds
> > > (one default checker interval) plus one second per minute of no
> > > path
> > > queueing time.
> >=20
> > What's the rationale for the "one second per minute" part?
> > It feels kind of arbitrary to me, and I don't find it obvious that
> > we
> > need larger padding for larger timeouts.
>=20
> The way the checker works, without strict_timing, we do all the
> checking
> work, and then we wait for a second. Obviously, the checking work
> takes
> time, so every nominal one second checker loop will in reality take
> longer than a second. The larger you have configured (no_path_retry *
> checkint), the further away the actual time when we disable queueing
> will be from (no_path_retry * checkint) seconds.
>=20
> With strict_timing on, things work better. As long as the checking
> work
> doesn't take more than a second, you will stay fairly close to one
> second per loop, but even still, it can be longer. nanosleep() will
> sleep till at least the time specified. If multipathd is not running
> as
> a realtime process, it will usually sleep for longer.
>=20
> Also, if the checker work takes longer than a second, then
> strict_timing
> will make sure that the loop takes (close to) exactly 2 (or whatever
> the
> next number is) seconds. However, retry_count_tick() still only ticks
> down by 1 for each loop. This means that the real time before
> queueing
> is disabled can diverge from (no_path_retry * checkint). And again,
> the
> longer you've configured it to wait, the more it diverges.
>=20
> I thought about passing ticks to retry_count_tick(), so that it would
> correctly deal with these multi-tick loops, but this can cause it to
> diverge from the actual number of retries attempted, in a way that
> would
> mean we disable queueing before the desired number of retries have
> occurred, which is a bigger problem, IMHO.=C2=A0 No matter how long the
> checker work takes, you will only ever do one path check per loop. In
> the worse case, say that the checker work (or anything else in
> multipathd) gets stuck for a couple of minutes. You would only do one
> path check, but hundreds of ticks would be passed to the
> retry_count_tick(), meaning that you could disable queueing after
> only
> one retry. Now you could limit the number of ticks you passed to
> retry_count_tick(), but even still, if the a path was 1 tick away
> from
> being checked, and the checker work took 3 seconds, you would still
> pass
> 3 ticks to retry_count_tick(), which would cause it to start to
> diverge
> from the actual time it takes for the path to do the configured
> amount
> of retries.
>=20
> We could improve retry_count_tick(), so that it actually tracks the
> number of retries you did, but that still leaves the problems when
> either strict_timing isn't on or multipathd isn't a realtime process.
> It seemed easier to just say, the longer you have configured
> multipathd
> to wait to disable queueing, the more the time when it actually
> disables
> queueing can diverge from the configured time.
>=20
> The number I picked for the rate of divergence is just a guest, and
> if
> you don't like it, I'm fine with removing it. After all, the whole
> point
> of this patchset is to make sure that the worst thing that can happen
> if
> paths disappear while we are still queueing is that a multipath
> device
> isn't autoremoved.

I was just asking for a rationale. This is fine.

I think we can, and should, improve multipathd's timing. Unfortunately
this has been on my agenda for a long time already.

For 4/5, too:

Reviewed-by: Martin Wilck <mwilck@suse.com>

