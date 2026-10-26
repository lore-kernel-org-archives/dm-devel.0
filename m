Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053242;
	b=LMpiBALlxJlzM0F1RVfr0CjZGlmcMRN2df0zoDIsXcr1KNSWSK7nGD+zB+QJ2dIIn35E
	 rmug0o6fJVOajvNWO5ur76geAMSrBX+ONQc4f+KHtLzVYYqCN/xuX25g3794tI7jCfVci
	 z4kJWRb0i3tZq02RaEr3GZL7WwOjBwAqFHq91qVryZLSPb9RgbqzyVhZ1r9kk3ftH8OPM
	 DvU87JymRUvpngh4xJAFTDG3L47p8RoQDwZ7DK1FMdANn8C7BvaRzJ/bFSU4JHHCiqfG6
	 +7OS2QdUPN4vwUGYQDpMX5dQrRLRhavOgl0s+yrrMhRVoJ6ahpwQN27SHA/AyVTOESA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053242;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=qJRU4K4rF8vhkBW6DRvjM8PrbXcQ13CQ6C60vkmBJpE=;
	b=bV27/bm1TOoPztEu8jTq2V4EM/nqJvANUkGlQemTDcaTH8KoXxGpypauwSRfH0vSprco
	 A/Pu2uU0zhSZUtCQFFlOP8TziFTlMDMH7pH765q3+1vUpQK/UQ4p+kklMlfaeIjMHLD2t
	 FdLCWF2wlxM0PCe9/hQ1m395HG4NVazcSsaT2d3XB2EKywiX8+Nmn7rXauthACAJyZZT+
	 YSB931gGrFJI5gwyMrWaMmtKngwXWzYXy7nuCrRHkcIR27jbm5G/ax00gSPIa3LPc3a7B
	 jtNAeER3N3A2PiyGmKHWIj4nR1MgKO/CqYMgj4npbPU3fJ9KoC323kEDVWNbW6cuHiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=DKX7OPAI;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B39606A31A
	for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 22:20:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20B39606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=DKX7OPAI
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48dfdd0678dso2578273f8f.0
        for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 15:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793053240; x=1793658040; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=qJRU4K4rF8vhkBW6DRvjM8PrbXcQ13CQ6C60vkmBJpE=;
        b=DKX7OPAIHBlMulVqU7ciPFF50PWWI3CDxhOCRiYBO1ROlCRCu8/6o9iR0HfXv+whgj
         7s2dnL54llsGihJm3zt0N7Y+hY5uVvrQhZ1UxxXl8tU7dnpn/kjZnAOCBbIDkdfLcy3y
         rpJ4MWPKT/WwsP+AM3op9Jtq/JQ8j+AG97jCfYcN6Njr3WWoBtOKivKUvv565y0ie3cb
         s36eO1X61+tzwYflKFZmWBfVA1ceIOaIcjLZCYQssEDAzRKg8d4s7pAeXMxuOebgZjpz
         DMT59JJjtXVNNUyTpVUCL1USQaNVV0K8ItR2eB4VH0vY+U9dK/8BJfH3ELOc9q29qPj5
         OwMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793053240; x=1793658040;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qJRU4K4rF8vhkBW6DRvjM8PrbXcQ13CQ6C60vkmBJpE=;
        b=uCHUXxZkidr2dHwzMdNtjtV5/q99PFFbYGiZpsQIR8+eZEzA2mClftPz+dhpBGz5s8
         HIAxeoa29FEj2LuJwz3SvBtLnqBWgXSF1jbprWvgjnaORdgu1DScse0ekvAzcv6swyUg
         OyY8vMTlzYG9jQjhxch36EL/Nnhpf6WRpgSiuscZbdiYTzjPFKmIhWnH892hd8gXJtMh
         iag98DjbF2QAHEou05nK5YnJtj903tRnPnUwZogk0jNG2ecGvGipez/5yDVJbKUecEM7
         2yQ/hih3WJKcHQd6U9U1QKihbDN3kOVr1SrzekOQggLxOm8BlrNKR21ydMzlBMR0wZvA
         JlVg==
X-Forwarded-Encrypted: i=1; AKwUvBwYiNomlKFFXdtXild+yTnlxSvvFKbarTmkXaDepQ4pebhiv9xd+quYTIWgV8Zp3vH+8ljaO6R3sA==@lists.linux.dev
X-Gm-Message-State: AFq9FYIRpi6YH/fyQAvvxc2PS6x/y3hMy4LGHNvOOcXJujGy2ZmJra97
	078ikrewFx3aS7D80Yt7tmU47KxyweW9t7Lc0qwDFRNUnOB86Rwz8zqeEgCpYiDGvoo=
X-Gm-Gg: AYBFou3NVllZTWRTPdeTBsMBytMZjIV/Pal23iPOJHgy7WSFhBOECFaUkOA5b/PzcEv
	xdfD1EoRqToF2Oe4elDxXkYKQZ+e5+26X8WYUjzf+f2txLpoEbljydHn/ab5mqov5IMUTCl7kCX
	zufOvydh5VCStWlBNgelKQURQjsqzzdDMxipuWYMwNLilqgEEb/QS9jvgG6P2Wl/ObSAvGQBs3z
	KCDLj12Y80koHJCreFNh3IuFSkODXt7nuBGslieNmMbMeMDz9HzVKRPsBdvgq0nkABoLZ+xsC5h
	04jGh1VRQuvaskVmGq/RKE6hYmL2J7aaoD5XKGmVzoeIZZl7zMbdEP76NNQKiLUJmzykdI67hY4
	DSBpRT2m67II41adsI5UK8sGiNbADKqKIO2uJTdmI3axrm2BVkYQnyo3qrLwupIUzwjjrIS8A3n
	AFhdnpFhaX7xuFd8fnmcFmW/pII1LrhiutkHU9TU/oCqW7qfKLwhm+vvN91COZ5NqnJDtYuOxnY
	yCbe8UG3PUxJqEiu9NsloE6BBWH4TLFXNZyEFO6XZ9A1QbYJGGTiDV0gS0Rsl8ZiW1OAAmIX/oq
	agkw5e/YldUffXTpQADHP+0StXilQQff8fKk6mNkeNmJP1eHOH6SV2CmqCcxr7HsoiCo5uRus6R
	c4kwyVrx3Eos+E2pRZdAJ850y9aQ=
X-Received: by 2002:a05:6000:25fd:b0:48b:4a2:8175 with SMTP id ffacd0b85a97d-48e3ebb1541mr13777500f8f.43.1793053240349;
        Mon, 26 Oct 2026 15:20:40 -0700 (PDT)
Received: from p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebc39a8sm19701599f8f.11.2026.10.26.15.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 15:20:38 -0700 (PDT)
Message-ID: <5bb12dded4b0686d4246274a467d6adf6044cb18.camel@suse.com>
Subject: Re: [PATCH v3 1/1] multipathd: don't leave maps read-only after
 write protect is cleared
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev, 
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 26 Oct 2026 23:20:35 +0100
In-Reply-To: <atvweCfhjWkT9i-U@redhat.com>
References: <179261848556.617150.17378002460197797656.b4-review@b4>
	 <20261021231959.69270-1-brian@purestorage.com>
	 <20261021231959.69270-2-brian@purestorage.com>
	 <179270025923.152861.15521453184442767016.b4-review@b4>
	 <atqpOBViqKWLZ7Q3@redhat.com>
	 <b018626bed433a84fbfa66c0c334cdb7bbbb53cd.camel@suse.com>
	 <atvweCfhjWkT9i-U@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.62.1 
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0

On Fri, 2026-10-23 at 19:40 -0400, Benjamin Marzinski wrote:
>=20
> To solve this, whenever multipath detects that a device has switched
> to
> read-only, it forces a read-only table reload, so that all the path
> devices get re-opened read-only (since their requested mode doesn't
> match their current mode).

I am sorry, I guess I am just looking in the wrong place. But the way I
read the code in dm_get_device() [1], the kernel will re-open a device
only if the mode is upgraded, i.e. switched from ro to rw.

[1] https://elixir.bootlin.com/linux/v7.3/source/drivers/md/dm-table.c#L398

I don't see how a switch from rw to ro would cause a device to be
reopened.

Thanks
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
