Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F92028980E
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 12:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768999301; cv=none; b=uoAA78/KlX3jLP6X/fR+opdO64NDlX17PtyCkmTvcaG8gMYme63WZEDRG6o4qtpbXSRF8zCCWdxuz6MDjxTeNsYilELUSt61R754HFcFIw03ZHhYdoStXWlvftIHc+HZ31ZExk+iC5BKRVDA38uS6tgeg1L9cn0524Drup41JVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768999301; c=relaxed/simple;
	bh=WvH1oFQpNa1ppqWsYcuCnfBNfe+d2q4GrzuTb43hNQE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L0nUTCW10EAoG52SpvecEoACL5hNylgqBOQTEgs9/P51IFdJ7MQc8FaINfuWbCZ+4DF4aWGS+HEBBWIGFD67iH2Bjug+ZtLb5laXDHvoSuMYbhjjI3iHi39hGfKb+xfeu+s8gpGYEsc2DalgfGj9ip9+xSKJ2Sg3IL7AC3DLRBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ddidMe90; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ddidMe90"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47edffe5540so57143185e9.0
        for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 04:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768999297; x=1769604097; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=px9VrZe2foxnUcxMjQ23lIFVvBNyc7sgekcheUHZoOo=;
        b=ddidMe90uC0DDucUqY1BAzSrkLxWyH7ki9Ms/r77SggGbPt6f/4u0H7ynBy6owJ9MP
         5XkX8hRFhRxN0hyXtpoLfNfaoUhNZHhoNYQBEfsaeqgJTizya0675+eE1wDvIM0GrIZP
         YJsRqNzYqYniofEjfMNz5dbhUFOhOu4VyGIryTPSSn2Q0Z2UjKKAS2O8poa8pw/hsW+g
         J4qb85xF4BGG5D4ap86nj2auzlSQqEuJbQJGw2DMrGJ24ZJgFyQ1qWV3tCIeTidTs15Z
         6uxR1bF1vp44PwRy99xKeE1EBjDI9QJbtJLv5DqVK+wg6mlcxT5/UXcirtxvBslV/Q6l
         mRJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768999297; x=1769604097;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=px9VrZe2foxnUcxMjQ23lIFVvBNyc7sgekcheUHZoOo=;
        b=fm0gw1ldckQJxWruxEpW0OEaFaa+LZDrk8ViJ6jSsvLyNy6QY5egRcZ6qRFplKBVK4
         XxgP81LAwa5SpLtJc/BJxs80ofc2upHDv/e1JOwSSSgXmnSZxrdzlx4BIAF/5eOK5KzG
         H99UND/UZHqIKSuKW0vSWKUhhCauZ6sH7yYO3vLHyb065NT18JXmp0+OtKRxOQ1jra9K
         1KywStJopGnwW/b8YaDKFPeJJJ0bGz/Ym1vINWVHHfJ4CiX3leAIf/AuRVBpPGFndi6Z
         1zn704zYBcuymC6ZtaxopsbsKQYh8xwfHjkZXndJdgBEgq/20OfynSuT9QAuVftYOzZ2
         Lr3Q==
X-Gm-Message-State: AOJu0YySOSqYLrjAoDMtpGiGp6iaLukAfpKM7tZFTAcP8FoqwNl52Rst
	1TH7XtrvwTzUc5+0Rs1RS0YZToHzkKdhOLZMb1MXDt/aM1skxvYaS79aPW0I/KA+cSbQ4VM9Ukk
	soqj0
X-Gm-Gg: AZuq6aKxzj7ZGdfUuBZTWHAFOF7ef1DtXKhN9LlT4Q3RfAWfN9eJFN7xOXQf3wLK880
	iT4EkG1tOUfCRCth4xb/ARujxiuKdrwCsGKaCv21grwEUef+lhrmRK3L/1SSB3S7oqhbnJSiv1P
	k7A6fKTgfwla0OegT2Nx5AMvt6xoKxPjJiXqWsZHH0Slr33nuWkKfrE9A7Iirh9/zJ+dvBMstKB
	AsbKgwBLqb4s768Za+1bi+jAc+ZJgPVodse2BiHR5q9ABEXiNKkh3T/ApgyFUNcsU6Qf7ZVyTGz
	qsG74q69gYYo0taDejh2KXpCQH+ALJmDJbH+ybhiBevhanMBAFQ2mrb3xKPFV2I7XDmMBC5oqQS
	4nIgtQKhshG5mNLnE+qx2NaNL/nJEzlkx9M++QLfVellZop/K/UkL5U6tzXh3wAHEce+yfUV0Im
	Vn9mVh8q/iyu/Shcf6QNMe47YhT/hcJFLf8kwFVTPtewFJu8+WT5vmF3JkaxR11TM8Wq/hDnHij
	Of0vD25i0k4v4aa2gXNFFuuWbirAufdV/TGWNIDlkBjLhvg7JHaxa6Bww==
X-Received: by 2002:a05:600c:3b1b:b0:480:3230:6c9b with SMTP id 5b1f17b1804b1-48041472847mr58329245e9.7.1768999296611;
        Wed, 21 Jan 2026 04:41:36 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801e8c9cbcsm306675405e9.12.2026.01.21.04.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 04:41:36 -0800 (PST)
Message-ID: <0e7261c3a77b44bb7a0c948cd041c83837a5bd5e.camel@suse.com>
Subject: Re: [PATCH 2/4] multipathd: finish initalization of paths added
 while offline
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 21 Jan 2026 13:41:35 +0100
In-Reply-To: <20260121042315.3914707-3-bmarzins@redhat.com>
References: <20260121042315.3914707-1-bmarzins@redhat.com>
	 <20260121042315.3914707-3-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Hi Ben,

On Tue, 2026-01-20 at 23:23 -0500, Benjamin Marzinski wrote:
> If a path in a mulitpath device is offline while multipathd is
> reconfigured, it will get added to the updated multipath device, just
> like it was in the old multipath device. However the device will
> still
> be in the INIT_NEW state because it can't get initilized while
> offline.
> This is different than the INIT_PARTIAL state because the path was
> discovered in path_discovery(). INIT_PARTIAL is for paths that
> multipathd did not discover in path_discovery() or receive a uevent
> for,
> but are part of a multipath device that was added, and which should
> receive a uevent shortly. There is no reason to expect a uevent for
> these offline paths.
>=20
> When the path comes back online, multipathd will run the checker and
> prioritizer on it. The only two pathinfo checks that won't happen
> are the DI_WWID and DI_IOCTL ones. Modify pathinfo() to make sure
> that if DI_IOCTL was skipped for offline paths, it gets called the
> next time pathinfo() is called after the fd can be opened. Also,
> make sure that when one of these offline paths becomes usable, its
> WWID is rechecked. With those changes, all the DI_ALL checks will
> be accounted for, and the path can be marked INIT_OK.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Great observation, thanks!

> ---
> =C2=A0libmultipath/discovery.c |=C2=A0 2 ++
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 52 ++=
+++++++++++++++++++++++++++++++++---
> --
> =C2=A02 files changed, 48 insertions(+), 6 deletions(-)
>=20
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 0c5e5ca6..0efb8213 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -2585,6 +2585,8 @@ blank:
> =C2=A0	 * Recoverable error, for example faulty or offline path
> =C2=A0	 */
> =C2=A0	pp->chkrstate =3D pp->state =3D PATH_DOWN;
> +	if (mask & DI_IOCTL && pp->ioctl_info =3D=3D
> IOCTL_INFO_NOT_REQUESTED)
> +		pp->ioctl_info =3D IOCTL_INFO_SKIPPED;
> =C2=A0	if (pp->initialized =3D=3D INIT_NEW || pp->initialized =3D=3D
> INIT_FAILED)
> =C2=A0		memset(pp->wwid, 0, WWID_SIZE);
> =C2=A0
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 61e0ea34..2140e432 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2572,6 +2572,26 @@ static int sync_mpp(struct vectors *vecs,
> struct multipath *mpp, unsigned int ti
> =C2=A0	return do_sync_mpp(vecs, mpp);
> =C2=A0}
> =C2=A0
> +/*
> + * pp->wwid should never be empty when this function is called, but
> if it
> + * is, this function can set it.
> + */
> +static bool new_path_wwid_changed(struct path *pp, int state)
> +{
> +	char wwid[WWID_SIZE];
> +
> +	strcpy(wwid, pp->wwid);
> +	if (get_uid(pp, state, pp->udev, 1) !=3D 0) {
> +		strcpy(pp->wwid, wwid);
> +		return false;
> +	}
> +	if (strlen(wwid) && strcmp(wwid, pp->wwid) !=3D 0) {
> +		strcpy(pp->wwid, wwid);
> +		return true;
> +	}

It feels a bit odd to use strcpy() and strcmp() here. I am fine with
doing that if the arguments are string constants, where it's
immediately obvious while are obviously properly null-terminated, but
this isn't the case here. I'd prefer using strlcpy() and strncmp(),
even if we are both convinced that it's ok without the length check.

> +	return false;
> +}
> +
> =C2=A0static int
> =C2=A0update_path_state (struct vectors * vecs, struct path * pp)
> =C2=A0{
> @@ -2601,14 +2621,34 @@ update_path_state (struct vectors * vecs,
> struct path * pp)
> =C2=A0		return CHECK_PATH_SKIPPED;
> =C2=A0	}
> =C2=A0
> -	if (pp->recheck_wwid =3D=3D RECHECK_WWID_ON &&
> +	if ((pp->recheck_wwid =3D=3D RECHECK_WWID_ON || pp->initialized
> =3D=3D INIT_NEW) &&

The readbility of this code would improve if you move the INIT_NEW vs.
RECHECK_WWID_ON test into an inner conditional, like this:


	if ((newstate =3D=3D PATH_UP || newstate =3D=3D PATH_GHOST) &&
	    ((pp->state !=3D PATH_UP && pp->state !=3D PATH_GHOST)) ||
	    pp->dmstate =3D=3D PSTATE_FAILED) {
		bool wwid_changed;

		if (pp->initialized =3D=3D INIT_NEW) {
                        ...
                } else ... ;

	        if (wwid_changed) { ... };
        }

Martin
