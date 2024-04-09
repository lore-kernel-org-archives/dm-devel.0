Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7ED145320
	for <dm-devel@lists.linux.dev>; Tue,  9 Apr 2024 18:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712688322; cv=none; b=LOGpPegVppfjdTO5vA1AklFR6WEbWgh2Trt8WwbQLvnJHv+PwcJRyC34x2wAFtDa+qjvsSqQoMybIB4iBAqs4Iu0MPTv/C4DGAK4ntX2WZ2QCe+D5tUAtupovOoFU26pqKqh8n2ie5HRbS0q/VWlBHhW6UklkrT6RGxSCdWAa50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712688322; c=relaxed/simple;
	bh=d1Rj9EA9sxgBO33113eYVCT9gGNJrRLu9LSqgqAHOkI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XAtSaOiN4Q1OB556kspFL7rYSrjTge8bkedNDTpw7LbxY/1l+zn/ellUdkAh4mMZlyaJTwL1hRMm6ITEvzNNIpHjcXYGj/cxM1YvPxtgqVHiTMQLsZbSCNyWqbojuSdo4DLLZ7yNiQNL3bek/pupnzvk3wv+zQzfIPwQMSK5X88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bkuLpao0; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bkuLpao0"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a51c8274403so381832766b.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Apr 2024 11:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712688318; x=1713293118; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cKQ86nzHeGY7zaECdxKHLWYPV+6wR29mtraEnxWdWvk=;
        b=bkuLpao03X8I1c0rqZxoxBvBE0f/tZ5V1po7tdYNeXFRKEF8ppcmAKdtK/m/jc0T1T
         83pTvxM6M4oo0/5vNApkpfYTyIdi/TvTA10gmUvQTfvMf5d8zM0aOacaKX7V1Fu3eRM4
         xXdnOyYlP6+TiN/fY1o94MEC69Y26N+Z+V8mLBjfCYjlVhTgBELU3rf/4JGg6shl5MKw
         uFqBTnep+TahKZRo0okLfFyL1nwpCCgVNdfAd4lbxsTw8l3RpKPvorrexJ/n4MOl8zNJ
         tWZNF3IZkO0O9/3EOgnT8HucE1avXhdgwteay8C4y048Dyb/rWg8WFzcKBoCQWq8NMlT
         iw1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712688318; x=1713293118;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cKQ86nzHeGY7zaECdxKHLWYPV+6wR29mtraEnxWdWvk=;
        b=I80AcLNC+mzfj77k+xFOOCSvPxL4E9Ydq16lu2mRqTxH4CUjfkhpb/mI2NMHvD0mgc
         VbeaxJAFOIjrIMH6KrAt3pRRs+j/6ReB5zckGehTI0rb7kbQz/bCQtiULuwmEpTqHpOz
         5AZnjbEhvMuZRDG1KRK4LCeqCymN62qQirXWciaOHdRPX+MxBnpL1RHjE/lupoSk7wPM
         LYHASVerm0I2OMooXLzQhi06w7MNrBEB1A63VOxyv7a9QvsLXxTUww8qfISLQY3e12/+
         93zXavbDCf7Dsh0Ewg8YAIYCUpRSX3/Ayu8KOSwr+1TPqEfjst9S/PtJV1yeiIR5KTmH
         MJ9w==
X-Forwarded-Encrypted: i=1; AJvYcCXVQ5yJbchwZxiq+Ry3xC7K9M9iY483eDHGMWgDZmxHk/6ji4Mv+7JqHFmS5SJbP4PS9mJHXSQXOysCUwpO9yXlZW51i9tf2lg=
X-Gm-Message-State: AOJu0YzOPpHAMEh70NKqbmGeN2V9s2j442S1wCJ/BCwxChUNlXKNblk3
	xhD0DkBhh8ZB9ixuP2IWeOiMgkpGjgt49Y54Cpv5Jqp9ebggw0DXx0Xufe0jwYE=
X-Google-Smtp-Source: AGHT+IGFz37N92eiGsxy+EhX37TH4rHuGYso7mplORjexTU/mL6UPkjAACFwt7vvOYly4AEd26X/bg==
X-Received: by 2002:a17:906:1b4a:b0:a51:dc1f:a44b with SMTP id p10-20020a1709061b4a00b00a51dc1fa44bmr198615ejg.29.1712688317971;
        Tue, 09 Apr 2024 11:45:17 -0700 (PDT)
Received: from apollon.wilcks.net (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with ESMTPSA id cw23-20020a170906c79700b00a51bf5932aesm4447315ejb.28.2024.04.09.11.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 11:45:17 -0700 (PDT)
Message-ID: <bb17d09ef40d74489d1f8219355f559409f5ecbe.camel@suse.com>
Subject: Re: [PATCH] multipathd: make multipathd set priority to
 RLIMIT_RTPRIO
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Tue, 09 Apr 2024 20:45:16 +0200
In-Reply-To: <ZhVo9uHMm3-F1MIe@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240329182813.1455019-1-bmarzins@redhat.com>
	 <f6654d3ac12ff4621942e409340b29bb23d959b3.camel@suse.com>
	 <ZhVo9uHMm3-F1MIe@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-04-09 at 12:12 -0400, Benjamin Marzinski wrote:
> On Tue, Apr 09, 2024 at 04:38:57PM +0200, Martin Wilck wrote:
> > On Fri, 2024-03-29 at 14:28 -0400, Benjamin Marzinski wrote:
> > > With this change, if the SCHED_RT_PRIO compiler flag is not set,
> > > multipathd will call getrlimit(RLIMIT_RTPRIO, ...) and look at
> > > the
> > > hard
> > > limit. It it's 0, multipath will do nothing. Otherwise it will
> > > change
> > > its scheduling policy to SCHED_RR and its priority to the hard
> > > limit.
> > >=20
> > > This allows users to change the priority of that multipathd runs
> > > with
> > > by
> > > adding
> > >=20
> > > LimitRTPRIO=3D<prio>
> > >=20
> > > to the [Service] section of the multipathd.service unit file.
> > > Setting
> > > LimitRTPRIO=3D0 will make multipathd run as a normal process, while
> > > setting LimitRTPRIO=3Dinfinity will make it use the maximum
> > > SCHED_RR
> > > prio,
> > > which is 99.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > This looks good to me, but do we really need both the RLIMIT_RTPRIO
> > and
> > the SCHED_RT_PRIO mechanism?
>=20
> Not if https://github.com/dracutdevs/dracut/pull/2563=C2=A0ever gets
> merged,
> we don't.

Unfortunately that PR has caused some regressions in the dracut CI
which I haven't had time to analyze / fix yet.

>  Until then it seemed easier to keep a knob to let us control
> this ourselves, rather than try to sync with a change in dracut.
>=20
> Obviously, I'm still not convinced that it really matters whether or
> not
> multipathd is running with SCHED_RR, so we probably could just say
> that
> until dracut gets updated, we just don't run in SCHED_RR in the
> initramfs. I'm fine with pulling the compiler flag if you want.

I would prefer to have just one way to configure this, unless we have
really strong reasons to support both.

Thanks,
Martin

