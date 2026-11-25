Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795611517;
	b=KEzwdhzcpexvus1mzXG5W0t48d9sEwctw/wXZI2TIGECc/bJVP/JIIaVPoPrchN4MW4p
	 E6fv4IMCWSdInYIPvLCwxUds5w39gpCbTEx+M+F6Ft5++ehU5Jzs1xQOkwekPkk9viXeW
	 ZPnzRlcgevfeXlyxpsk3aG1b+zJlRwajd1QcEdEoJQKpXInf4UypxToVPnveVErJR3w8g
	 h/c3uKO6bUaEybfCFSFXRyq8+gToD5fHk1zWW3BbEteriZSfhZxG5Spf8YqLjoZnPOQ12
	 WVbQH3SpnnOzesbf06bdENTuDE04/Rjg4vsJ5OuiXvDZmwnHla2zzdt6IkyyRQwQcRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795611517;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=wHwgEvRLW7cYzsJPUgL8ghQBzR/hMx2rrMKO2GW88b8=;
	b=xx9FTYaka7WJAhl44Dj57daosWxpy0MU6KYBVmPDy0T3APS9hyiWE6WmgIxS/Gk3qjk4
	 MNQEhwyDi3z7SV0UP3EObSJn/kNRF/oHfeMMCfQ7fmteyuPpV1NH+mHp8/kAXdMh7Qgrr
	 A53kaPjnsaYUbHvtWcpgz06DL256KBhpCwDJwpVpYvpna4aVLz0CcLSYD7pjnkopTzcAP
	 1untPTdVLbHBGzbyy5NJhfSpZYSKEeTwk9M5Os2SxfD49MiQvLMU6oGap6hRpAFDy/WI5
	 eGXLBJApzVhzK/KzcTZUdbWydHYE+yFaw3pbXZtKTPIXhkilUAy8afsj0Z6y5U5m46Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CSjKzCCk;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CDF606A321
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 12:58:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69CDF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CSjKzCCk
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4af52002471so6647445e9.1
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 04:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795611516; x=1796216316; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wHwgEvRLW7cYzsJPUgL8ghQBzR/hMx2rrMKO2GW88b8=;
        b=CSjKzCCkSZZfRLib9a+9fWBa07pv8M1+iuAKG5cl14NguvYUD1hQKb5a5OSqSD1oJX
         OSdtJAqN5+3hLT0T7GkUtfmHp/7TPE40ogsiqk3ANx22x3pdO0+JKxSgKkqLfVz6lp/Y
         yhz3JiaQs/k5uUDEp08HJ+fp/OPRvWZY27p78NnGvKdeJZAK5Yqg7WO8ktlhzNcAGkfb
         094tGHBjpy1Ii2wVyMhZn+u9NicK1bO3UGrvXrkBocfu/FCoe8TMyftNmFDWr546pRIj
         eeKtDXAv72qgRzkbPpFzMEJa7A368jyLAhW5ECW0tSDRu9BueQphulVhY0Sjj1Ghvgcr
         D1Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795611516; x=1796216316;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wHwgEvRLW7cYzsJPUgL8ghQBzR/hMx2rrMKO2GW88b8=;
        b=v8+kuYo5IYVmI9xStbhZgtFancOzuI/3H5RKQcRTJdAlwwy7NtWkjhNrpZUV61qIaR
         xNkDV2Zj+5X3qg2mniSutSGkLVW5DxdqPG57pkmfvndtZ9dOg20poxbRGn//YsnQ2jrB
         gdAhKI2dR0sKp4v7YrSDsTZoJ4TDg1nKqM9EvHmSHwWfyEbYZHiWYvP9uNLXPaMBTSTR
         RZ7pm0lFzMaMCHuFqNvA5cqeCPSozaB//Vdcz9I4wBcpQJ2Pe3194vCHFmUU8Qr9lUgS
         KzVZPZ6qPwp9mdzy6zo/PyKREZbQh8EEmdthsPbEP58rk0qufG+SNU1zaDUQDJfeDU+L
         3kXQ==
X-Forwarded-Encrypted: i=1; AL+hErHrugGOBdz/X3aLpiTfPVqfQfehxz1Vmp7lbO/QbVw0aBPoLXIlSARHwwQsOmvvsF3fva4o5MNlMw==@lists.linux.dev
X-Gm-Message-State: APuU4Z+QTsX5zhSCbhoDofxHmNkWQ+RQByYUi1YGW5nNk+yIU+geHFlW
	/7EWMbGM3h1fsMfe020OLA+HVHBafBNOmc9ScwmqF8xLCZbko49z4Ks=
X-Gm-Gg: AZFdTZe/aI5ECEKF6X69o9FdcykeWrfGYtNdn8mcbBC/xJqWKI/RnO6bmp5+r4+Z+Oh
	qg3s7LhQvbJsXLuFUdcAFKsigf+R5pXJQ8CBW6drmKN8oeOrDGWPoJFcq2UVwgXIP9PHpkAvigR
	dCbnBJ1AFD7SJSU/l39k1+R0ScdDX9Iwe5c7JKw4viN+bWVKq+ez5o2NOgiXhhwq/xIBvqSvJ8a
	vfainfmh7EyPU6mecHX60eA3qCb2ccW5CvUhDt7ojQjk+Nq0Q8WPA5M2a20KNyDq5R9hPEP7YnB
	n1FVxqAgCACzkHftis1vMc8ntjJbW4FbJGKdDR1vjKbazApZFyJNhm/uTvntzVgy3oKySw/NEri
	5lXyHX0BWpWeYyLrTy2lRe/jTWOrCwx7S1lPnRJSwPG7rymFgHszKuuo2iToMXWtrrXZHNvx8il
	Wd+uEdgR1V5AMyJOrRC7ybGHtIEwzq/4l/mseG3fXNbtVS/IslEObqg/p/34i1PCnhMtbozGGLd
	H7yAOTuMHcQZvYYcC9N/RCVuRRVzPqbZ5OQ6aqJ+JoYu2YWcUSXSTdElXd5pMyi30tlBC4jTsPv
	lNvHEET95p5+M4Ukx6knOkLGrqiG7+DbtB3cmRiMTdFV2djWbE6BJ5hjPSC6L3VSyQ==
X-Received: by 2002:a05:600c:8a18:b0:4bb:7ad9:301f with SMTP id 5b1f17b1804b1-4bb88806505mr263658895e9.2.1795611515523;
        Wed, 25 Nov 2026 04:58:35 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a9846sm608707545e9.11.2026.11.25.04.58.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 04:58:35 -0800 (PST)
Message-ID: <206823f9-af78-4838-bd42-dd5e7b2c8093@gmail.com>
Date: Wed, 25 Nov 2026 13:58:34 +0100
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Subject: Re: [PATCH 5/7] multipath-tools: multipathc: print version string on
 startup
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20261125102605.82009-1-xose.vazquez@gmail.com>
 <20261125102605.82009-6-xose.vazquez@gmail.com>
 <e187be141dc1e65cb643fc5ba77c4a1cff536f99.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <e187be141dc1e65cb643fc5ba77c4a1cff536f99.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/26 12:42 PM, Martin Wilck wrote:

> What for? I'd prefer multipathd not to be chatty, and I fail to see the
> benefit of this unsolicited output.
>
> It would be nice to have a "show version" command that would print not
> only the multipath-tools version but also the versions of relevant
> other componenents (libdm, kernel dm, kernel mpath). But that's a
> different thing.
Since the "help" command isn't implemented either, even though it's
documented in the multipathc man page, this is a quick way to show
which version is running.
