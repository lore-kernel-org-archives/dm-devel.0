Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9AF28DA5
	for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 21:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719523923; cv=none; b=QaNyqyXIWKjMHhuPS9eNfAllF7542xMiXNpFcbrA+gfuYZu+SBDBsrnzXBlsF54ULvfmYeljl/A9SmVKyRYszb1CmJJCTS7ASy0AvSrpaCE3tzFJ0sLx93H6s3JAqRWNiwMswxTR7fjv7GUaHKifzRRhq87IudPPy6Ytc1mR4Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719523923; c=relaxed/simple;
	bh=9Jufq3Vvc1GOCCgCYGnQqUlmSCUYqAL1scJqYeEtUvU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uoxQgua72H8CsjL+lMRYI5ObdKv+hWpREcrNWMANHA6da7Q5ys/4OiyY+l0LygQJ17n4zKvBI5UYq8nQXxjSsFq3IrtCYVrKfbMMh6WVy9E2ij+J8vqQbnNXcddH6afuxN0aXnVueOoMvSuCLEfdDWPTHmgR6vMb/V7eGmHNGxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F195Yf52; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F195Yf52"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2ec3f875e68so92795811fa.0
        for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 14:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719523919; x=1720128719; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9Jufq3Vvc1GOCCgCYGnQqUlmSCUYqAL1scJqYeEtUvU=;
        b=F195Yf52HhLTPB3Ja/LDR/1fGOQxS0cBXyMSxOn7ifJi7+A62OIORf5RiGajNVwMax
         hWdNNC4u3oc6LsKRCDmlvBpya0lTmUjEuR+3+gJlhWD2HFmCrpF+qoNIsFe6y8EjbSdH
         sLFYG9zFv+QX63TpKibRAGbYpoF+Aodqr3+jUIbtb9+vTss3laxkYizOgP1B+ywYfFtI
         InWW7w3K1XQXO7zg7EOKmr2zEJwuJaTOOUpe/zB8ucy4ZzabGrqBq/m7CJdLkeYoOE+7
         c0ftl1ehSw9xLNPF+tFTNUKUmMaa1UiK3dALHztHkEpjk8U/qPyM0kabgdpNxybDdmPz
         4aiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719523919; x=1720128719;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Jufq3Vvc1GOCCgCYGnQqUlmSCUYqAL1scJqYeEtUvU=;
        b=JItR+B5IyaPtQVHRKbLHOehrIk4/sERoyh+CUqF9F65CEPTM+Cs5DF6AGbkxctqQlx
         4TKTfNzbxPC4vavH28gLZ1FfflvRdt6YuGBx6FIVqTQMTKQ2Ymw7v6Tz4m9moZZFpCiY
         s4WRoJsYNINpTsoCfdKuIOVMbRPlpnEO7SmPq1bnkTctE3/yINU1Gkt33KvohAVMfdyp
         19I5Qh/Hq0S2MMqhkKxfO26WgoV54MUyswDx08EzTlZVAYaenCGP9WG01SEMMrnrzHPV
         k4Sl2fDIGchM3E19krItbbVd+axsuOaUOTWluLqhrZ7LY+OYFs8w8MTccZGBghACZ/5U
         b0nQ==
X-Forwarded-Encrypted: i=1; AJvYcCVy+w8178/Sa5nbQDsimY6R2lg1j8ib+tmCdZithX2aeqAfGif/s0qQ91bm/tPSKI/GUnWFK4I/UGideBfvN64HbM9eDImjs3E=
X-Gm-Message-State: AOJu0Yzgfq7QJctDc0Xc1XxUhpUIcWWn1/bScK7xQqYNWNR6VFKQMqsk
	6PW2zWULEcBFMMxz3BtsoRmioRR7ZeuKFsDx0qTDYnJl2n6l3JLQVCQDKU2HLJ0=
X-Google-Smtp-Source: AGHT+IHC+nuq4u4zEAjYVdAwufUsxMTIeU0n0fMh9jI1ReJF3qMJlDhN9IiUiQXBY7k4QU/BswpVwQ==
X-Received: by 2002:a2e:bc84:0:b0:2ee:4aaf:5f16 with SMTP id 38308e7fff4ca-2ee4aaf5fc6mr22992771fa.1.1719523918447;
        Thu, 27 Jun 2024 14:31:58 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5861503b52esm171071a12.89.2024.06.27.14.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 14:31:58 -0700 (PDT)
Message-ID: <cd066f0b8d24626b0370e4a97dbf1471351dbab9.camel@suse.com>
Subject: Re: [PATCH 3/7] multipathd: refresh multipath before calling
 set_no_path_retry()
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Thu, 27 Jun 2024 23:31:56 +0200
In-Reply-To: <Zn2xzs0uxpWmIMyh@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
	 <20240605232254.623290-4-bmarzins@redhat.com>
	 <7551690cc28e39dc733c57ae1a9e657c469aafb3.camel@suse.com>
	 <Zn2wW55XxNn4ju2e@redhat.com> <Zn2xzs0uxpWmIMyh@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-06-27 at 14:39 -0400, Benjamin Marzinski wrote:
> On Thu, Jun 27, 2024 at 02:33:00PM -0400, Benjamin Marzinski wrote:
> > On Thu, Jun 27, 2024 at 09:47:33AM +0200, Martin Wilck wrote:
> > > On Wed, 2024-06-05 at 19:22 -0400, Benjamin Marzinski wrote:
> > > > Make sure that all callers of set_no_path_retry() update the
> > > > multipath->features string from the kernel before calling it,
> > > > so that
> > > > they have the current queueing state to check.
> > > >=20
> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > >=20
> > > I am not sure about this one.=C2=A0
> > >=20
> > > refresh_multipath() is not a cheap operation, requiring at least
> > > 3
> > > device-mapper ioctls, and we hold the multipath lock while we
> > > call it,
> > > meaning that multipathd can't take care of other important things
> > > while
> > > it's handling this CLI request.
> > >=20
> > > OTOH, the kernel only changes the features string when the map is
> > > reloaded. Nobody should be reloading the map under normal
> > > conditions
> > > anyway, and if they do, we would see an uevent shortly
> > > afterwards. IOW,
> > > I think it's safe to assume that multipathd has the correct
> > > features
> > > string cached, except in pathological situations.
> > >=20
> > > Am I overlooking something? Do you have evidence of errors
> > > occuring
> > > because multipathd has a wrong features string cached?
> >=20
> > Well, I did run into a situation where I couldn't disable queueing
> > because of mpp->features being out of date. I fixed that specific
> > issue
> > in patch 1/7. But in a broader context, the kernel doesn't send out
> > any
> > events when it gets a message to change the queueing mode in the
> > features string, so there is always a possibility that something
> > outside
> > of multipathd changed it, and multipathd doesn't find out about it.

Right, and that's a general problem that can't be solved in multipath-
tools. All we can do is make sure that our own tool - multipath -
doesn't mess with the kernel state at all while multipathd is running.
If users use "dmsetup message" or the like while multipathd is running,
they're obviously on their own. Perhaps we should really disable all
code in multipath that falls back to local actions, or at least run the
fallback code only when the user adds an option like "--force".

> > Normally, check_path() will find out and resolve the issue within
> > seconds. However, if the multipath device lost all its path
> > devices,
> > then check_path() won't ever call set_no_path_retry() on it
>=20
> Err... It won't ever call update_multipath_strings(), which is
> what will sync the mpp->features string with the kernel and make
> set_no_path_retry() do the right thing.

Yeah, check_path() is not the right place for handling maps with no
paths.

I have thought for a long time that the periodic checker, instead of
blindly going through the paths vec, should follow the multipath vec,
handle each path of the mpp in turn, and when that's done, act on the
map. If we did it this way, we could also handle the special case of an
empty map in the checker loop.

> > and nothing
> > will resync it with the kernel state until an event comes in.
> >=20
> > Here's a (admittedly fairly improbable) sequence of events that
> > would
> > get you into problems.
> >=20
> > - There is a multipath device with no paths that is currently in
> > recovery mode waiting to timeout. It's opened by something with
> > outstanding IO.
> >=20
> > - A user runs "multipath -f" to remove the device, and deligation
> > to
> > multipathd times out so multipath attempts to locally remove the
> > device. It disables queueing and attempts the remove, which fails
> > because the device is still in use.
> >=20
> > - multipathd hits the retries timeout and disables queueing.
> >=20
> > - multipath restores queueing because the remove failed.
> >=20
> > - more IO comes into the multipath device.
> >=20
> > In this case, the multipath device will be stuck open due to queued
> > IO. The user could reasonably try to disable queueing to resolve
> > this
> > issue. This will report success, but not actually do anything.
> because multipathd never syncs the features string with the kernel
> before calling set_no_path_retry().

Are you suggesting that we call refresh_multipath() (or
update_multipath_table()) from set_no_path_retry()?

Before 0f850db ("multipathd: clean up set_no_path_retry"), multipathd
would always set queue_if_no_path to the value it deemed correct, and I
think this was ok, and generally race-free. IIUC, the main purpose of
0f850db was to avoid unnecessary message ioctls (which would cause
locking and flag manipulation in the kernel).

0f850db introduced the check of the current features string as cached
by multipathd. Later we added some patches to be more confident that
this cached string correctly reflects the kernel state, but we can
never by 100% sure, of course.

But if we now call refresh_multipath() every time in
set_no_path_retry(), we'll be replacing one DM ioctl (the original
dm_message()) with multiple ioctls, while still maintaining a race
window. That wouldn't make sense to me.

> >=20
> > Granted, there is an unavoidable race here. It's always possible
> > that
> > after multipathd updates the features string, it gets changed
> > outside of
> > its control. But this cuts the window down to something small
> > instead
> > of anytime after you lost all your paths. Any if you get unlucky
> > enough
> > to hit that window, you can just rerun the command and it will
> > work.
> >=20
> > My main reason for wanting this is that cli_disable_queueing() (and
> > friends) is not a command you run all the time. It's a command to
> > run
> > when you are cleaning up a mess. It doesn't have to be fast. It has
> > to
> > work when things are stuck.
> >=20
> > Thoughts?

I remain somewhat confused how this should be handled in general; see
above. But I won't insist on rejecting your patch.

Martin

