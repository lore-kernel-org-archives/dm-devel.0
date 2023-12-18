Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343761D159
	for <dm-devel@lists.linux.dev>; Mon, 18 Dec 2023 14:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PWDfRbi3"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-40d12b56a38so20230865e9.2
        for <dm-devel@lists.linux.dev>; Mon, 18 Dec 2023 06:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1702909131; x=1703513931; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ed4JuLbs5dm1YxnLhPLf1CtlUgH/p/Ma4XVOi/VIdsM=;
        b=PWDfRbi3DBYCjCk+BdIEUeIrL1ibUPT4wvV+PH+dx231PuXmfOqwag1iDSj00SAjMQ
         h4GZPeIiRHxwvwjsIncVv4hAWV2/iLBwYR8x34t1kOrKca2M+TuKRk8tapO1jJUMGxhJ
         eq7lg3mN70dpo4QueN1FiMEwDBbgYKIqSkRu/i0VEN8bceML04xhPEbK3y35NBe7o+6P
         cpswBCsAbfT+VTxblFZVlhCPRYYSDEpwE/b0R1m/IaoR2ABJDMvw3JY8PhYmbp0UUMPC
         HFvH3s2yXZg+mSGlyr7o8Lo14osBp++L1a24Va67JGNKxol1K1iW5aqOx5i9TkdebMh6
         zH8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702909131; x=1703513931;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ed4JuLbs5dm1YxnLhPLf1CtlUgH/p/Ma4XVOi/VIdsM=;
        b=kdQIP8rd9RDBcTHHn6Jy868NE0Q0i/t8iH/7DYHN2qCTmNBP1aZOg9cjl8shop3hCL
         YUEFNPeCba0F8MLmoRRW2j0U+DTaY+76SUV07ohUaH1erMrV/JE6oFB09KYLPG73ylnp
         9bdtZIhebvD8tAASAoLvqF/N+zuzFbEZiYVXGw9PrI0yGzKjz0Q7wWDUFGXNGpTf6D1m
         fArToDY6nXqlJ0Ju9YiF6prYbCQqaZqxNjFBfN9Bj25xko/SyEomPM/A6xZ8CkXT6tLG
         S/O26fLHX26yVE2njFqEzRcrv8MXVwhEiq794Sd1Ro3b/dOJFv51q2Xa8NL2KGahMvcR
         4E0Q==
X-Gm-Message-State: AOJu0YxxxBSvX7v9MMQO74Lbs0NeN+KVolRtaoEVD7/Qt9N8jHWSX9wm
	d1wuoatHxh/Ts5AA3PZoDzjIlg==
X-Google-Smtp-Source: AGHT+IFEqZPEXGHVH54qYVJDXhR+ja6eJ/PH6fX1TmPSKQWJ1G434rUyvu/yZCNrLnHhzF+FFJTuAg==
X-Received: by 2002:a05:600c:198f:b0:40c:4575:204e with SMTP id t15-20020a05600c198f00b0040c4575204emr3818164wmq.47.1702909131345;
        Mon, 18 Dec 2023 06:18:51 -0800 (PST)
Received: from apollon.wilcks.net (dslb-090-186-000-097.090.186.pools.vodafone-ip.de. [90.186.0.97])
        by smtp.gmail.com with ESMTPSA id z11-20020a5d4d0b000000b003365b2047c5sm8164832wrt.114.2023.12.18.06.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 06:18:51 -0800 (PST)
Message-ID: <72aa33b79bf1894c36128c843e04497ddb94ce32.camel@suse.com>
Subject: Re: [PATCH v2 2/5] multipathd: don't modify the multipath device on
 show commands
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
	development <dm-devel@lists.linux.dev>
Date: Mon, 18 Dec 2023 15:18:50 +0100
In-Reply-To: <ZX0RLeZM1w14Y1Jn@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231205235704.355125-1-bmarzins@redhat.com>
	 <20231205235704.355125-3-bmarzins@redhat.com>
	 <a365676f9d92a1deea8399958de4f94dac0b1d81.camel@suse.com>
	 <ZX0RLeZM1w14Y1Jn@bmarzins-01.fast.rdu2.eng.redhat.com>
Autocrypt: addr=martin.wilck@suse.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2023-12-15 at 21:53 -0500, Benjamin Marzinski wrote:
> On Thu, Dec 14, 2023 at 05:15:39PM +0100, Martin Wilck wrote:
> > On Tue, 2023-12-05 at 18:57 -0500, Benjamin Marzinski wrote:
> > > The commands to show a multipath device are supposed to return
> > > its
> > > current state without updating it. Even when reset is 0,
> > > update_multipath() still can update the device. Call,
> > > __setup_multipath() instead to just fetch the current state.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > __setup_multipath() can still call remove_map_and_stop_waiter(), do
> > we
> > want to avoid that, too, maybe?
>=20
> If there really is no multipath device anymore, I don't see a benefit
> in
> keeping it around in multipathd until the next path check, do you?

No, but that wasn't my point. I thought the rationale was that a "show"
command shouldn't change the internal state of multipathd in any way.
That would imply not calling remove_map_and_stop_waiter().=C2=A0
But I agree it's really a corner case. I just wanted to make sure that
this was no oversight.

Martin

