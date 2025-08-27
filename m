Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C422F318135
	for <dm-devel@lists.linux.dev>; Wed, 27 Aug 2025 06:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756277158; cv=none; b=GXg6dWXX830B8XetwPxVRzkrNZrV+/WIK7auyors77+o1EYiDS9hQMF7Nuc9O3pe+s+od/js+npdCmur0hbP9bZh2TDIGAOU7dxxNhqP1v5dW7EAoWmFecIUT91EghDdmUMOEWnRQ/RD2S9nefFyojYO3QcuNTgU2SGiQy8k6PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756277158; c=relaxed/simple;
	bh=XQMXPWmDYzL/VAHl1DmL2NPZh58g0jcqd5WIjsyRTUg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EW5/WjgRYDaE1aYSe7sGFreD3TvZLBHr0JJJjgn4eiLW9OgN0BqOve3XhtGhZdvS/44d3qu/z3rnA5Um1fvnNXDPcAT1pyFXpR+qxfFtrUMU+KsKxW9WWg5O8vAMMInOE/SgwwEVY7auRT0lGBM4uTFk5gzpS/d53D0JiTsz0wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DA9rReGi; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DA9rReGi"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-61caa266828so1664691a12.1
        for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 23:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756277154; x=1756881954; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XQMXPWmDYzL/VAHl1DmL2NPZh58g0jcqd5WIjsyRTUg=;
        b=DA9rReGi9w8W7knAhdy4AWE9E78xJnAw+x4ZP7CuLwaJEpaAUplPEOTumvPSulmDIh
         KEeKzhXkAlrEHB9SLzUgMCoi+jfTjQiU/2bxHuFMuQ8orcNZ6A3Q87fO0petJAES0JAe
         JuZ8C+nkjhDbk+HpQSm9qEoQqKewNpWttbKTPoz5sbq017dyK9OewJZUm7NkieArBeKJ
         SOpujVPdS4Iquh9oOCNfPKePBHFTAsxTPFZNvksz32p/XXyx5dRBkvcYbMD3DZD4Woax
         0s4xEKSLInYeDu6LoVpHb68/Bs/6Omo1aTLjLEGasFEBQR0GO5bpXP86wDpeBPUmU8Ew
         KOhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756277154; x=1756881954;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XQMXPWmDYzL/VAHl1DmL2NPZh58g0jcqd5WIjsyRTUg=;
        b=isv4ywO/qgvZCYhQoH+TaWn/x/Xp8qCBRj+csQsUDnWbNzvOsAnzdZZEZlX247lJk9
         XPnLfbq/uu7SNsNVqIf6vC2RKpWjBRZVdaWaLcMHwpDZg2BFDnlKkKVZ7FpQ09WFDtJy
         Xu3jAsgxzN3utZbKeoYB5LUCJUVTTEXkfYLQQ5y+OXr3CrrwuPZuSYp3E6FX7esMSnnp
         1PJq7Xu1KA3nrsVUgOH8ltE53T/aCBfVr2Jp6a902NgdKgQ+9Bb2G3YRcBWK9/Vz4UzY
         JbUXhBuJOFIXpGmk4OxcPOPbg4XClWmwdtJeo49sn2ZOzoTSWUgveIkB+SyGUiNC+Wa4
         TfaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQd0SEM159bMoFPC/x+ruHbiKNU7i0dED89q04LPjHWa5mZZWc0UTD+vDobWwbt+u6KPiPkBWs4A==@lists.linux.dev
X-Gm-Message-State: AOJu0YzCHrb8rVK/kMuTUdiMaIvFJqpoJcBKMztjf5uGWiod13g92B1U
	+zK2fzX752YppCIJKUgCx8AD4Fa8aqpVf4DCsc6mJ9xnyxO2ykn9+1D0ZcVT0NKgZ3yYvN/BQk0
	TPU7KuIQ=
X-Gm-Gg: ASbGncudzXkM/IfqGvy9VBHP/YQUoGNWHgPkaXQ4wvxmRB3pj2c6PJUaKlvAI4ZhMOR
	BfT6htW+qOHMtH3+1PO3L549o7Jr0wKIPurmAj5qC3hqna7Hlt58i2C+Gh4FDVM/ebFKMNGTe0F
	TaTuH3A4/tlIKkCDt2A4j5/VwggFymCiwsfYH03hjZNGfrjF8PU3S06glt751Yt3YK9ujlZK296
	HiRKmzJF3Jfm2Rog91umqG2vN3nVKHBEUpUPQ9k8bkvV+/SltWYCsme7SqP6U76kjDOYg1RjMZu
	FLjS/gMWk+9ffrr6NtXHz0HwFcMSXQpSYFzS4v+s5qKIbzCqVpnhVLZnkhz/WzEsO840epSEuwH
	2q5q3kH02xSWtXj4DOwjHT8xj0//jclXCh7m4T8vqeg4NGH82J2mcaY8K2WgIM2SvHvz+norYGv
	J47Aw46WWimiWOw1e79s+7ImNbyEZmIYQ6cis312Y0iW57nDINnpTIQkuqD/9VI04ahA==
X-Google-Smtp-Source: AGHT+IHEcvni8WBRCi1hUkLvIVXDg9w68Z0cN0gI2goNWcmU7TrYa+SleScAjZIcUm3F78qtlE11zg==
X-Received: by 2002:a17:906:794b:b0:afe:c48e:5d86 with SMTP id a640c23a62f3a-afec48e64b0mr94626166b.61.1756277153842;
        Tue, 26 Aug 2025 23:45:53 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe8d03f981sm482203466b.60.2025.08.26.23.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 23:45:53 -0700 (PDT)
Message-ID: <8b6167278eef97e88c4251ea121d2d088e53c78a.camel@suse.com>
Subject: Re: [PATCH 09/15] limpathpersist: redesign failed release workaround
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Wed, 27 Aug 2025 08:45:52 +0200
In-Reply-To: <aK4iGbsHLVXvhs1w@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
	 <20250710181100.3997759-10-bmarzins@redhat.com>
	 <dc941be94accce6ed554eac92f833cbb8e69263b.camel@suse.com>
	 <aK0FIY7cVE_LxNMg@redhat.com>
	 <c4abd405c8ba0f28f9e98212ff0cac8c85789bcd.camel@suse.com>
	 <5261990d40414f56f2476226e0997d728b81648e.camel@suse.com>
	 <aK4iGbsHLVXvhs1w@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2025-08-26 at 17:07 -0400, Benjamin Marzinski wrote:
> On Tue, Aug 26, 2025 at 12:06:50PM +0200, Martin Wilck wrote:
>=20
>=20
> The only situations where we will do the suspend is when a multipath
> device preempts the reservation key that it is holding, either
> because
> it was explicitly told to (which is something that the SCSI spec
> specifically calls out as valid, and is in-fact the only way to
> change
> the reservation type of an existing reservation) or because we failed
> to
> release a reservation, since the path holding the reservation is
> down.

Right. This is what I forgot while reasoning about the noflush
semantics. Which, thanks to this discussion, I think I finally
understand correctly.

> If we do a flushing suspend, all queued IO will be failed, regardless
> of
> the user's no_path_retry setting. We really don't want to do that

I agree.

> > I tend to think that sending PRIN or PROUT commands to queueing
> > devices
> > is an extreme corner case. Perhaps we should just refuse to do this
> > (realizing that we can't avoid a device entering queueing mode
> > while
> > we're processing PR commands, but that's an even more extreme
> > corner
> > case).
>=20
> libmpathpersist runs the path checkers before it sends any commands
> and
> doesn't send PRIN or PROUT commands to paths that are down. If there
> are
> no usable paths, libmpathpersist will just return failure. I have no
> plans to change any of this.

Side note: There's a realistic chance that persistent reservation
commands may succeed on paths that appear down for regular IO, e.g. in
ALUA STANDBY state. But I doubt that it makes sense to try that.

> 1. sg_persist doesn't force the filesystem to quiesce, so why should
> mpathpersist? Nothing that is doing persistent reservations should
> rely
> on that happening when they change a reservation.
>=20
> 2. We won't be losing our ability to write to the disk. Like I said,
> there are only two cases where we try to preempt ourselves and
> trigger
> this suspend: either we were explicitly told to preempt ourselves, or
> we
> failed doing a release because the path holding the reservation was
> down. In both cases, we keep our registered keys.

You're right. Sorry for the confusion, and thanks for taking the time
to explain.

Martin
