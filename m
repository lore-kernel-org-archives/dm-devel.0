Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECAA264F97
	for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 20:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739306158; cv=none; b=aLiEIXZMlU/BNWHmOpIrH53bJz6cMDFlWdyP6HNJBybvivqthHLExLvvZMO4oCzZw3sOfQ3aWyT3ajNsb4ffFY6r8797oD8N/2TfNrdXl4oxz5814D4akys5yFryCfERW9wTwXSZdjlotAOFn44tFURkN5ZALtCg0xFJ/sBizMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739306158; c=relaxed/simple;
	bh=ZchkPSSXFgRnVo7A6PptgITqvSMmN8SfTEUUT5Za3Ww=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I2ynhLlXZPYsbi2bWWngz/ZA0+wb+kPTHUzzOE06N70tkyMrniVUXtmz5yCWa9R6sj6XYPRlACfSZpP6AWUDh/bbfpM/cjfKz1LeSV4BYRWzYJ7/PrmpiZmQuoEcFNwT2N9hwunkhNuTnk483zWzj6+BCIlvW7ABni6Pz+rOHS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L2L6LbIl; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L2L6LbIl"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-38dc6d55ebaso86322f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 12:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739306154; x=1739910954; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZchkPSSXFgRnVo7A6PptgITqvSMmN8SfTEUUT5Za3Ww=;
        b=L2L6LbIlxRmuBrCuJpdZ0ISbso+IFfoPtZ4E2C4QytbHsqlOS4Nxr8TP7IB1wLcokj
         fuz9xApX48iVNzWDavrhfJ0nChYR9xKs9NTXh/9KLvcI9iiF9R0y9Ej0+0jt8ZNsl6Be
         dqImasg4S52J/AOWiP13nfwyqLIaII5PzJPc8BFMQyJK1KWp8WOiadFVixrlJRnGWUOa
         xyo0YCZ7Xhfb4yK82qgZpDQRqF+BrdSAop8vSR89b3AHjakXcy2cK/HeFYmFH/OOrW3r
         0Rf6j7qaJ/u9qbsi9/mvsK/MNRz9Guwh4mXaZDgEMRsjZ3q20dVPCS2g23K+1FJvAoup
         1jMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739306154; x=1739910954;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZchkPSSXFgRnVo7A6PptgITqvSMmN8SfTEUUT5Za3Ww=;
        b=W5WFLrCuDPPhQ7yQpY1LEbzsmEpZIY24t/rRc7P3/8q017I4b4aJcXi6JQCTJgFRhp
         OqIAGU4I+pEa9QizCTrh8jG4Vduv1Wow6uwNwZWkSDJXRme7gZUlc+pUJaOelwuIVqVD
         ccpZIVMc2q2dMQXdrNXpmAyPnxdzsuhqOk9+xdE42cO/q87hOuFLtt3mxf+GBOvodZgZ
         v9N4WkFFv3OYVp89BEZ6cH89v3S2Ub/j/3H7ygdn5gQGzwV0UYgrlSQaWQLi7NtF1JRq
         +089Gbguf0esPD6XkEoptHyDMhUFL6eBev0QYjU8skvYFl7A5JU/Gi5T7yOOcqo3uXTl
         0MQw==
X-Gm-Message-State: AOJu0Ywje4H4CCPixLRuMdiEWf6naMdQYow+aDK8xXbkk+t/VILlXwpN
	PBWN2L8aS0wCbHUZSQehaBmYVoj+rqv11JTTN0hmYtuQIKk4B5iPx5kBtmxSrck=
X-Gm-Gg: ASbGnctQSCJT2mQjZbKuB4IQJ0//Pk/OW0EQp8eHSzIVgW37vpAtwt3HopdWMhFwHVc
	om0AsF3dJL2x0K7heZPFvQiMc4pOCTSaVxw5+MCWjINuO2pQok5Jr7Hrw6pvD/hxOGU/EyWN0P+
	OBrfI9XRGRipndUj9XgVUonjoIt1bGiYuPrgnS1lTMept/QX1azTbbY1OMN3ZFe3LYfu8wvnIh4
	/vwqpB+ZP2Pq/lTHoUP4yHfpbEQ0RGCI4oi9i8JjWqa+ntHF0jvjsJYlCG6/dEM31GcG1tdVgm4
	G5D1RbwmwZjQYVCG5QVurd4HyUqJ+gD90vpcca9QpaqYmlAl/THF/mo=
X-Google-Smtp-Source: AGHT+IEwh5N8Jd2v3P5rPGkk+YpicpmiknapTDbxYaizhthMdZGmzm8xvOUfJeXhiDEcGW+UGKlF7Q==
X-Received: by 2002:a05:6000:2a5:b0:38a:4184:14ec with SMTP id ffacd0b85a97d-38dea1cf01fmr405380f8f.1.1739306153407;
        Tue, 11 Feb 2025 12:35:53 -0800 (PST)
Received: from apollon.wilcks.net (p5ddd307c.dip0.t-ipconnect.de. [93.221.48.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dc5c8c37esm13879736f8f.2.2025.02.11.12.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 12:35:53 -0800 (PST)
Message-ID: <e84bb9c89b323f4eb9aabdff82a190a498ec4390.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: fix compilation with latest
 userspace-rcu code
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Yaakov Selkowitz
	 <yselkowi@redhat.com>
Date: Tue, 11 Feb 2025 21:35:52 +0100
In-Reply-To: <20250203214342.503983-1-bmarzins@redhat.com>
References: <20250203214342.503983-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-02-03 at 16:43 -0500, Benjamin Marzinski wrote:
> starting with version 0.15, userspace-rcu can be compiled with
> CONFIG_RCU_USE_ATOMIC_BUILTINS. If it is, then any programs using it
> must be compiled with at least the C11 standard. See:
> https://github.com/urcu/userspace-rcu/commit/89280d020bf064d1055c360fb997=
4f128051043f
>=20
> To deal with this, check if compiling with gnu99 fails, and if so,
> switch to using gnu11.
>=20
> Based-on-patch-by: Yaakov Selkowitz <yselkowi@redhat.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

