Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89F62F1FC2
	for <dm-devel@lists.linux.dev>; Mon, 22 Dec 2025 17:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766424946; cv=none; b=T6Poa6uPiDXiO3yIjPm8GPHy1hVxj+qRPfpLU9ey/TPEo6dzFuiVKlRH492PCMY8zDUT1XfWYE+HwbOEvEZVlNs67U+7+KRAWSD4nxudW2DgDobS2dU1XJaVFxeAXoB91+DoOiM4vAlsLkHJQ77Aq6yLM4B/rAX8QOuxWR1bUYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766424946; c=relaxed/simple;
	bh=CqHIv114SKiPrYEE4FXGEDTR7vxZRSR9cpTJnRNfJtY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=tr0T+p8YBJRFZo+Wm5DWzFtCzRO+YbzY+itqVxAgRXkM5NrenzG+DumYIi6gxYtDewbcp4H0njuccNXtIT33WcS7i1+oD+PRxkGZrt4ucY+t/mSjmSmc7Rpz5pBOve8Fj0LiVPcyPClSBln6g5tNvjqJM5rnPnGsUN1k6wd8RkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O6DhCksZ; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6DhCksZ"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b7ffbf4284dso499501866b.3
        for <dm-devel@lists.linux.dev>; Mon, 22 Dec 2025 09:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766424943; x=1767029743; darn=lists.linux.dev;
        h=content-transfer-encoding:subject:from:cc:content-language:to
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w3Mn33v/1H+ltWqF1AvhNPLhQ1ZylmWQuhjl7K9r1LI=;
        b=O6DhCksZEeQ7XetK+x3IWfxlix3og2xzXgcRu/HJBC9mLrphLyHanpFXFLnQFawPS3
         rkinDhEenhghKWz9X2rzTfiWPikJlFf5eG9D1QyJN3WeSERMnQ/wUuMRFvYChclqn+sI
         As/mEAMZ2TO14i+uhMSvLE5rM/PF1t5++One/NRclJwc4/uhsp9l8oNL+yoC6M5rK3Tb
         jMTpOmjPDJZBQJOijAB3OXCE/BSnspIKfMrP6jDGJDVQMYjPJm+xrKg42HNZvUlYjeQd
         AHkoLlzE94vWHP8pfeA+NZ+txeMCeahIyZL9QwG1sm04VNQU2IH85+FSXmA5lPdGmV3J
         SQVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766424943; x=1767029743;
        h=content-transfer-encoding:subject:from:cc:content-language:to
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w3Mn33v/1H+ltWqF1AvhNPLhQ1ZylmWQuhjl7K9r1LI=;
        b=Nj0/8zZOXDkCklx49/PMEMubU1GrL/odqOofZEFFxoOOxIs+o6Ty+5MqOpmcvsG8uk
         FqT4HbdBISL4VKuRFrzC4IoOV9ynY2DPL9FygdVkshBPU34FqQPlYc67MotaDW/Ft9E8
         L95WotFYDCkjhUurqR1RDU9sXiOaInllQWA8TlDh2NaBrv/ODL2m3X4RoGSxsifWRJ9N
         NxhpJws7vTi4TSi2cDNulzIOgFwNaq2qSuwx23+cNPGehG0z3CljHGhrrmPQcKwjV5Q1
         2PRrErEjcLBoga1mOHVV1+U5i1Uj/01gpdAEyOhgfuyXD6wzXov31oaweX+XfJfgEDLz
         GWEw==
X-Gm-Message-State: AOJu0YyaUtOqWSuQS6ASIV2jghRTtYSZgXjjULS3fS93bXzVOr4qPZQH
	hcAqulGgQR0P6CFQIb2tUmNNv5FeFaauIW0KtAoAFhw39mrSeoZAmsfJeUGWRQHU
X-Gm-Gg: AY/fxX4OG6ivetvW8IPlQudgoVnzvjjLcQrLxzbkmu399n/SyImWQGRt7PVm1BZnL32
	JU2aFyWaaGRhTln42fkG3iHfxtwCbaLFrzw3FEwauhar1BJPx8M9QVTbMLvyy3OlxYvN4NKG0A6
	U0a7hHdXeZXEHuF84cq0J/SC08TdxyjAqx7y8ROM/6xZPx+2qXzRsCIcbWGzIm+flgSIUwx4m7t
	tbF2zbtJ/bLGsOFuaUKsqOoDKoYlsvYWl1kL4j6UOrCkjMym6t4eGtn42yxsXR+F0SJYVegeTKm
	Vt+cOcCq0rOoDUYP8s1ru/xHzTjJywbXTt224v7hmhR7G6kr32L40PhtkTtXs2eSiKxMDZWpcoR
	w0kwW+quO42yEqzl6YgXIpuPLkeRXZCpDcbVyaqXe7/Y33mGFNYaLmI/Ju3A1bNh1S/Kw+1skxS
	FTx2w8ZqLDC39IxjJQJ6Ktcz765CWF1bzFepIL
X-Google-Smtp-Source: AGHT+IEqWOiuX40PmC/Qx1dm3TtVaKv0w8fGrS9WDPXzkmzqenkclDsj22GWhGEUc0UU2yQkbRxdCQ==
X-Received: by 2002:a17:907:86a8:b0:b73:544d:ba2e with SMTP id a640c23a62f3a-b8036f62606mr1259037866b.25.1766424943090;
        Mon, 22 Dec 2025 09:35:43 -0800 (PST)
Received: from [10.137.0.19] ([146.70.124.204])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037f3ffbasm1154355766b.61.2025.12.22.09.35.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 09:35:42 -0800 (PST)
Message-ID: <022d700d-d3d8-4ef9-8d7b-505f7df89354@gmail.com>
Date: Tue, 23 Dec 2025 01:35:38 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: dm-devel@lists.linux.dev
Content-Language: en-US
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 =?UTF-8?Q?Marek_Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
From: Leo Samulis <anagon@gmail.com>
Subject: [RFQ] dm-steg : a deniable encryption module
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I'm Leo, the author of dm-steg ( https://dmsteg.sourceforge.net/Steg.pdf 
), a deniable encryption module for device mapper. It was working nicely 
in 2011 but I got caught up in life and never updated it.

What would need to be done for it to be accepted into mainline device 
mapper?

Would I simply need to update the code, get it working reliably, and 
then submit a patch? Or would the specification and use of crypto 
primitives also need to pass a separate cryptography exam?

Thanks in advance,

- Leo

