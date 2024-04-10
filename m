Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D90F13E3F3
	for <dm-devel@lists.linux.dev>; Wed, 10 Apr 2024 08:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712738263; cv=none; b=OhjrIZ2LV7VMrcu8TqvLNiuOuU0ekwb87tjj/xNA4bliHcWFvNdmZIrBedXaaEMDm1MC686fAXw7B0nIWlCDgv5WlXgATNhDSQps+fjz9eEooeraIv0NY/ddfj34fcEdHk/DGxSuDeAEIlPwhUw0Dc7y2BO9S2aV0IiqhJH2d1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712738263; c=relaxed/simple;
	bh=CG85IrO8Ir8b7KkxAlChagnHpQr0cpwoyjtgRWWuHVs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=odO19v2zBLspRgdm+/Ij7hqRjKxSSePAqGfDbrKOKdR8FEhuBcq94cjqUIl8DYG0u7XEYTa9fLKYlvQ7KQee4iWVWqzqbOKKxHMITT3fQPsi2JdZamZ2YjFJDZVviOGqQtoeYr4YdfetNhV+1w5m3N7yFglU/6BZTmkaYgNxtBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=M1xJNPfk; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="M1xJNPfk"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-56e78970853so1754938a12.0
        for <dm-devel@lists.linux.dev>; Wed, 10 Apr 2024 01:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712738259; x=1713343059; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CG85IrO8Ir8b7KkxAlChagnHpQr0cpwoyjtgRWWuHVs=;
        b=M1xJNPfkmqUA46friP4PpseDNVivUXJbAvP3uHw1+i/RgEm1SWn0xTe+JvksCMaO7Z
         V9uHTwOCUD8hDfw2EEr7Rj5DrJMKrGPMhe4jNZ2vpp5RYpcsKNQYXsbFgGo9CwjFBBXL
         74ZodCdfKztF84si078MpWhQpzJhdTJ78V+14QjGy/2IedUj2HXtJY3Q1BRtPzujbm44
         nTQKgPyEanOvFJ7as0uERByEATjCjJoFFCHfZCfnlCQKlB1Cfoh53ZdoWKYVePx7BUDM
         MLhXbUYJ102ew1vZgNc5H3I6PwAijndCs8lpXp9SYB6mB9CEwKKe3lzafAe2EoQ6uSUi
         4uKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712738259; x=1713343059;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CG85IrO8Ir8b7KkxAlChagnHpQr0cpwoyjtgRWWuHVs=;
        b=ju2Z9EoHUnPeTFIRCTwGvOcriDUEKfAyjMndB2N114FHaHbjTinOsTF+yraOXKVptT
         IHopUcVchzhq5h7HFCo1mwDel6TcvLuLEUY7qy1zwBLlVWzbm1i/AeGasluPKHVS2lRG
         uFiGAm94gwJ5h6uPzmb7/4dZSHkEDRKMPK3Sf6FpWQQogPYjGI3J2ORf0R0hj8hCh1bp
         wMGcsbH+ckY7Q4I0V5bVvnrkihm6oKsuR1yrpj9A9si3urN61XoRU0y0ssAW6KRZcojj
         TOpA0VuffQNOL4GIA8fEP0pIYjwf1yDfFHj9GfECxuy6EnxLbqvP6SeHD/Q8iFUQXst8
         TQXg==
X-Gm-Message-State: AOJu0YybeUbHst0Wn/0gMvwuVpLcVGPVjEIDiFlRBNOodb6WxCgE3fVm
	fHHXmx1PAMWsNNldv3T/Z29GBnmc7wYRd4oE7DkqkriVTrgv+7YVn8glUReVkXaKruE7V/v8/d/
	3
X-Google-Smtp-Source: AGHT+IFFXQ+PeJldrtQJ9H1Nr5+FJAxfSfbKmzC6PC0VyZsF5VjK7bz40J0RqP9+IEGBlIvHgHfzeA==
X-Received: by 2002:a17:906:fd8d:b0:a51:e188:bced with SMTP id xa13-20020a170906fd8d00b00a51e188bcedmr4550440ejb.37.1712738259335;
        Wed, 10 Apr 2024 01:37:39 -0700 (PDT)
Received: from apollon.wilcks.net (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with ESMTPSA id qx28-20020a170907b59c00b00a51a80028e8sm6439855ejc.65.2024.04.10.01.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:37:39 -0700 (PDT)
Message-ID: <19375aff6ea5ad4dfc4cfc64ec7efbf2f8a4c8d5.camel@suse.com>
Subject: Re: [PATCH v2] multipathd: make multipathd set priority to
 RLIMIT_RTPRIO
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 10 Apr 2024 10:37:38 +0200
In-Reply-To: <20240409225612.1837905-1-bmarzins@redhat.com>
References: <20240409225612.1837905-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-04-09 at 18:56 -0400, Benjamin Marzinski wrote:
> With this change, if the SCHED_RT_PRIO compiler flag has been
> removed.
> Instead multipathd will call getrlimit(RLIMIT_RTPRIO, ...) and look
> at
> the hard limit. It it's 0, multipath will do nothing. Otherwise it
> will
> change its scheduling policy to SCHED_RR and its priority to the hard
> limit.
>=20
> This allows users to change the priority of that multipathd runs with
> by
> adding
>=20
> LimitRTPRIO=3D<prio>
>=20
> to the [Service] section of the multipathd.service unit file. Setting
> LimitRTPRIO=3D0 will make multipathd run as a normal process, while
> setting LimitRTPRIO=3Dinfinity will make it use the maximum SCHED_RR
> prio,
> which is 99.
>=20
> To keep the existing behavior, multipathd.service now sets
> LimitRTPRIO=3Dinfinity
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

I will wait a while for feedback on=20
https://github.com/opensvc/multipath-tools/issues/82
before pushing it to the queue branch.

When it's pushed, I'll squash it with 1c4301a ("multipathd: make
multipathd scheduling configurable"), if you don't mind.

Thanks,
Martin

