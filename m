Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.200
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794400175;
	b=ufhlzneHQ4XhzVkC+PdVL31jpX3HlyUgMZRPTikHhq6d9wTLsfdNZCxs36pUw7OeO+kT
	 K7aXTdDt5qPYFO0nM8th9m9I9WLtglsgptcej5OgLFc86hRZOmXpCjZBYF8BZTeEo5DvO
	 wEFAQtqf3Eo0lEt4jKSR3MKRFJMkrUzmBXWJe+KtTM60OcC19YQttLwOA7Qkib6maXXDz
	 77tM/3sISd9IxQsBdZAXTPzyvRw5PE9lwjp+VftuBlI2FmYWf1BRQPcKo1FePZiJq0Qei
	 HXq3dZrSxNmrmFi3WqXsYPseEHKoAC6LqpsxAxSgEtvJwmCjqwkv6patvvrW8EpF9Gw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794400175;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=ugQNukoG8zuOSCl9kH/Kdlpjvp5xVSCQl/EVqkaF+xc=;
	b=mChThIHTv4IEqxdE8ZSDFHIDWpM1eLfXF0zcjdlhDuysS3HCrSpJXPnmmV7gL4hPjMBB
	 Ol/B4AN3kshyG7kvocCWoOceXSKGNE0eFO0GOqEnnqNu9NODzBqj7jx4BhYpxc5p6dkD+
	 yqvcXYyyqtSdd7j6Up6cBSDkY/B2onDJ688optHXd+tBy5eFWl9B8pB9MMfMoJJASmYvS
	 GivJxqLGJ+PbCeL3rIqFcxpX2E/H/PU2AacMo5RlBzlPCEfgZZbhDn83v84JCJpXDt1aA
	 WaR5LfqAv4D2DeR9AnNXFGw0g/bCSY0ohTLPKMErlcLd4MBbGqlkv/Bnm47W0PSuAgQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kv030Y1+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.200
Received: from mail-oi2-f8.google.com (mail-oi2-f8.google.com [74.125.231.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4F4606A33A
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 12:29:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C4F4606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kv030Y1+
Received: by mail-oi2-f8.google.com with SMTP id 5614622812f47-539edfadfa9so1119939b6e.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 04:29:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794400174; cv=none;
        d=google.com; s=arc-20260327;
        b=MIXX3TyEoUHtqv5tXJa3mvn24RsuW0jl7U4r8tiw1rxn7g5DSOuWum7jXxALN+pASJ
         /gqkGAMSVcZDmOIPdIoVDKBQgJdQ9tR39uTXwJQykG7VB2H9hxmeNIvuKYoO4soBzIyi
         EEbpPAmrOy+bb1YweDFgDtX2FHying4qOgMU6j7xNDB4ibkpUxkFpgsyaPAwKDYwN64V
         WootaZett8c7m9WVw8VtOQh34dkCwecYyYqgGHS9MGinXwj+oqUymnZZ7Jm6D/Yf45k0
         YrzpE9X0KmqRtPLCEV9O0YNj1Kp3kotoywjIrIeegDlyp8d/FbkIMrWkMHazPACrNlAC
         i+Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ugQNukoG8zuOSCl9kH/Kdlpjvp5xVSCQl/EVqkaF+xc=;
        fh=D12fQXpCvR17N+Sig4Xk6G/4hdIA6lkofiij7G+4Dtc=;
        b=VRtld55jc2F/DfebCp1c8W28XRtaIpkOCaTNg4BJG+VhL2WcrQDw36w0J54S0mXGDe
         XhHKwc9pVpxNG7f1Zb40kqa12/TtOLyf90L8g0Q2gFQsMj5O+aq/9Fsbq2LosmikSsZp
         1y93LZAmPk/HM1/Gk77WOfD4mrGw+vpCrjGJclosst02GBdXA1SA9lqXkIwXKdGe2md6
         ynqedUTvEvzM1xbs24dD5zVCLMxh6P3LN/45cnXec+AQkWla7R42NgX4j6kNh2VtOH6w
         SDYdSmsFMVpdwd045M8CkGkRrdVeswTgqGmljHGYGUvXxO4UYXhGpD7lf1buuUM0uEqq
         lQFg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794400174; x=1795004974; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ugQNukoG8zuOSCl9kH/Kdlpjvp5xVSCQl/EVqkaF+xc=;
        b=kv030Y1+ztdfqUzrxkYudQ91jRCPFM3Q4UetZvWf0kTr4kJgmUk5GSIQoNkIDSuMky
         TtgdIEQXfJfsNA0tm6XjJL7rcnwZ9xW0xegXQOh/xsyfPOSIX6tqOO5zsmfwsYN+8QrO
         BIrd3fb+Gf1NOZKqXl3tVR8UIjStRVxC9XJcGU1nYkx1vzX06oXhUUym9SIAuFRRM2AW
         kWd+1aQoLFAEAzahk2b82RS+0yadR9kM57HV8FG9BlIhhcJPOlBypaFV1QyHoxy4UVie
         7tE5tJC7M8H+5KypJqloIFnNaLgpo2kg6i/ktjrJHNouOexwgv/mwLMNFx5U/bIkP9qa
         g79A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794400174; x=1795004974;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ugQNukoG8zuOSCl9kH/Kdlpjvp5xVSCQl/EVqkaF+xc=;
        b=cFQjNuT3nHmNcgGVm4rSR4pcnJa/0CepZFqf+DWUmPIYjxKI5l0yIrfY+aQAXzUVNM
         azNdxlZ1qHwY+8dl7Jjl0IAUeqHmmDMjP3g3k4lNfRjSRqbKToc+D7W6qaGP6dHEDzO1
         RUQU5u9Bkf/JVp5H3OAOvJKfUtz4azQorCnkOChURBmMQSratEKT+p+aXoq4E/q/D/1J
         5be+3QmtwcqnPyAC7+cUEDCmOAQ6qw16Wai/5MHGD2/sWboouhnIcI4XuJf9oZoToLmj
         /q7P0JxpaW0pgFxW3IF7phOWW8ncnF+v60tBs8HB7jOh835GQtoNWyYW5/h626+fSNPn
         6BUA==
X-Forwarded-Encrypted: i=1; AL+hErF9+EWZrdQRzs3wMSwrzC4wuoywb2JmWgBbgNFr99Tik5Bg69xg7WxyWxiRWt0o1mJ8pCwe6W/sDQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z+BmMsC/xSsOhwB32trXF3KnnvMs+4HP0SkAkyDNZWp5aBz0FXD
	SpVQ7doy92GNElwSZOJYfrfiMzsj9hiNFwzk7PP5DDVClijVuPlbMQ/a0rzwwJWD6QP9xRvwvW3
	UNt2UcGIX9ae4CWhQ+HUWpMNWe7hMoLU=
X-Gm-Gg: AYBFou1019/6BeB95k5w/ljqZk0pCQZLUBmAKa7AnqyaUce2GQoKiQjcf7Y1uLPtaAT
	FnLiUbot6Cx63IX3kanZduhUxp8p6gf/v4E4uPzI5x1MKT5plzWbNNn8BPFPokXOh1OcuJacSQU
	HNV5Qh+E3TE8RtW/jpbwD527em1NNsFHiwfjUFV/e4xw4CGVkZQQDkBSXuX0r10+wDtUpCGJ0SJ
	7PFyhy471ka4/SZG2T3MOD8WdfdedVu6NV0rOjLm5g4Ne1e4QmUJtN3lT77KinRRP0at7iAgzqw
	5CT7ZfbSK5mM5+BcebmWMeXfhpsx1fj1jk5uNB+iApJGnFclgfZytAXUV7bbdvdyNGsSr5tTrJA
	i3ZfzLRlFnTpXD1jjQA7BIuDF8yzAoS2lPm5o8ddd8Y/LuCWtRhpz/DecrXwN2FeOvn5m9kyK95
	sMPaORKK0RotnUnGSK4OdMY6qoHT9cLDnesldwnTcAAClkI7wFQIGT3A==
X-Received: by 2002:a05:6808:4f13:b0:55c:888:2a15 with SMTP id
 5614622812f47-56b97d216eamr1759866b6e.53.1794400173914; Wed, 11 Nov 2026
 04:29:33 -0800 (PST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261103185909.71843-1-dennylin0707@gmail.com>
In-Reply-To: <20261103185909.71843-1-dennylin0707@gmail.com>
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Wed, 11 Nov 2026 04:29:23 -0800
X-Gm-Features: AclHuK_f_I8U-R4ghS55caM--h46bxgyAYf2JvxTYf0GJGfw8SL-RER2v_qKYxk
Message-ID: <CAGEkeHfW2ADNSV7g5JMss8B80T+x8US17Bo51Ypp+1nnoxSPzA@mail.gmail.com>
Subject: Re: [PATCH v3] block: fix discard alignment for non-power-of-two granularities
To: axboe@kernel.dk
Cc: hch@infradead.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, mtsai@redhat.com, 
	sashiko-bot@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Jens,

Could you pick up this discard alignment fix? Christoph has reviewed v3.

Thanks,
Hungyu
