Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7839A1B7FA
	for <dm-devel@lists.linux.dev>; Tue, 16 Jan 2024 11:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GqDy6LWR"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-40e72a567eeso22844355e9.0
        for <dm-devel@lists.linux.dev>; Tue, 16 Jan 2024 03:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1705404214; x=1706009014; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ecXtev8yehM++hTsxpdOd8MnC10pzqDqih2O8A0sXh0=;
        b=GqDy6LWR1nwrY1EmzwK48dkJm8Q5F/BemBnsaodR+OgNsrUC4ZtCYrPco2wF1i31u9
         j+hZHaNWtAAMrEVE3Hmfwd1Q4RNzao0aywccx8QmNb/imj/tbaIM4hElpWcJM+yyKLiw
         BtKtT5oF5SQ6qXbK3xF7s36l+vRn95sy/01otm14TW9Mpy4nKX1xEmSfIYi8ux1875jx
         hClodWu5DKu5u1mEnL7dlnYcOD1Y12VRLoVt5sicb+CkBdO6Vn7LarQtu0E8HfV0vUm1
         ZpPBwrpiYVEwTBuQW7iZYf5QN6XblquyUimmp8z1OefAd5OHJ22s0FgXMEwMOpAaKgt9
         5wnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705404214; x=1706009014;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ecXtev8yehM++hTsxpdOd8MnC10pzqDqih2O8A0sXh0=;
        b=UwiGzgPx6WdfMbFC1rsSZ3ej9pgyDQ3E+kIBorC7ghwOTjXvdedirGEjXG8VyP//CW
         XbThuv8MVTIZl7+i2rg4xbNltxJw9VblcasBGnY6kIczPdnjXxQ+bYpqxw4fVx4UXKJ8
         L6O94T+pLRy0BFcYrMYmTSI9CuAgl/diys5EBc0qeSKvhW4u62wf/HXd6p93QwTj5TuD
         IRHLTkT90CCjI+jPIbEexO/ymZ8URbrXfITHadib2IMX8WKZFwZDpzDcSNBVvCC2TaBG
         3uFsvHdhLUridEaSqf/VbBfFu3HLEKk/YN0aklAFlBIW4IzMQjVyVV8HqWeWpaJqJFbf
         g3HA==
X-Gm-Message-State: AOJu0YycnHkTaYB5PGdgAtbUBAFpnPNZ/O8m6LZL8yQ8kXhEm6QF3M+T
	N7h2g3eC33dtR9qq/DM/EtO2w+dhSvXMwA==
X-Google-Smtp-Source: AGHT+IFs3S+zeQnZZF7U8fpI+9UJp4untCPXoiybDY2BbtSxFb8/UCXffOseyv/xbrhoBcPj2QPceA==
X-Received: by 2002:a05:600c:8506:b0:40e:5cf9:9826 with SMTP id gw6-20020a05600c850600b0040e5cf99826mr2255700wmb.127.1705404214631;
        Tue, 16 Jan 2024 03:23:34 -0800 (PST)
Received: from apollon.wilcks.net (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with ESMTPSA id a8-20020a5d5088000000b003364a0e6983sm14255014wrt.62.2024.01.16.03.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jan 2024 03:23:34 -0800 (PST)
Message-ID: <623ac42b1e305d7ed685694694bb69fb69ec3203.camel@suse.com>
Subject: Re: [PATCH 2/2] multipathd: fix auto-resize configuration
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 16 Jan 2024 12:23:33 +0100
In-Reply-To: <20240116070507.10563-3-bmarzins@redhat.com>
References: <20240116070507.10563-1-bmarzins@redhat.com>
	 <20240116070507.10563-3-bmarzins@redhat.com>
Autocrypt: addr=martin.wilck@suse.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-01-16 at 02:05 -0500, Benjamin Marzinski wrote:
> The code acted like AUTO_RESIZE_UNDEFINED didn't exist, but since
> conf->auto_resize was never set to AUTO_RESIZE_NEVER, the default was
> in
> fact AUTO_RESIZE_UNDEFINED, which ended up getting treated like
> AUTO_RESIZE_GROW_SHRINK. Remove AUTO_RESIZE_UNDEFINED, so
> AUTO_RESIZE_NEVER really is the default.
>=20
> Fixes: 981b83ad1 ("multipathd: Add auto_resize config option")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

The analysis is correct, but the fix differs from what we did for other
options. We won't be able to cleanly change the default later on with
this patch applied.

I would prefer to keep AUTO_RESIZE_UNDEF and DEFAULT_AUTO_RESIZE and
just change the condition in uev_update_path() from "auto_resize !=3D
AUTO_RESIZE_NEVER" to "(auto_resize =3D=3D AUTO_RESIZE_GROW_ONLY ||
auto_resize =3D=3D AUTO_RESIZE_GROW_SHRINK)", unless you have strong
reasons not to do so.

Regards,
Martin

