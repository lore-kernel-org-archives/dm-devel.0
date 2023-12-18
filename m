Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8532129ED2
	for <dm-devel@lists.linux.dev>; Mon, 18 Dec 2023 14:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="H1M0oY4a"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3365752934bso2364860f8f.2
        for <dm-devel@lists.linux.dev>; Mon, 18 Dec 2023 06:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1702909309; x=1703514109; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q4YndRjz/lshVDjwOeY3wsprGdpZdH7ZtWrZ9j1eEYI=;
        b=H1M0oY4aAGmoFpbaFcDGQWUBCN3ycV+GithmQ82J5qiUM7Ib1dN3bUJeDtKFUNs7t1
         OWGLMz6Z+r2aVug4lEVAUsKN3u6srgB0SQ1FK/iW5KWtgCqjlwRkAOJjuBI0IrWLwphV
         RirPcCqKlfxfrnh3Ce4Us+kIjUosBaMqOw5EEWIDRE3JJHKpBobYVDjWrcEG5D5EbzDX
         LL7OPFmDhaD1I8Ns2xAv8Uxzir6TZr9g5AaEJ8/BLQJ63O233CRwYSu2CP8KEhIp1SSe
         CjxSYYZsltAOc8710dyViHinpVAJkm9JsFyXXpCfe2q/3gMsZkbsxN+RHONm60QldvIs
         /aZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702909309; x=1703514109;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q4YndRjz/lshVDjwOeY3wsprGdpZdH7ZtWrZ9j1eEYI=;
        b=FAE0chxI6O3wBopmXxQFwsf1VRmRF079eMu3Kr0kjqdFjDAu0wltvSayv43/R+qJaG
         i9413f/HOh6dx6gbfMzkE59ROJpWSrqfW09aCEGk8d2SROa15iSfuFyKQlZXvX3XRY0u
         qKcTs4mukBGhWZPabc5OZR/Dgw+Ec5hPO/Jo3jiiN+HbqJdELwVG/LXY4fUeWN+PnNPS
         IpTzk9S9z2elCWrqUoT7RO3ItXh2BCXZJGgxKxsdb/YZ1O8I+GNKEvpRv4GkFSwCuAVL
         Klq0flSoMYABHeWqhPTHnMw/+7x9o7t/xZ1spmh+Waz32L2yYs/7YedeKIxJuF/fuzux
         jGXQ==
X-Gm-Message-State: AOJu0YzXMzEzGRCqt7jqd5a+hudxTwXU4V9shmeNhBNYHk85SsgWDewo
	6/3nTzmPn7Gxy/h3B1em7U84jw==
X-Google-Smtp-Source: AGHT+IFkCs5xngJ3e1HKqAnTAwEq0GV+DPPqChNGc3UdH+5v9JqPB1rGgl7eEubDZ+ww1Moeesh6dg==
X-Received: by 2002:a5d:4ec3:0:b0:336:6d62:7659 with SMTP id s3-20020a5d4ec3000000b003366d627659mr444014wrv.21.1702909309071;
        Mon, 18 Dec 2023 06:21:49 -0800 (PST)
Received: from apollon.fritz.box (dslb-090-186-000-097.090.186.pools.vodafone-ip.de. [90.186.0.97])
        by smtp.gmail.com with ESMTPSA id z1-20020a056000110100b0033668b27f8fsm2633345wrw.4.2023.12.18.06.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 06:21:48 -0800 (PST)
Message-ID: <4a28fe48c4e3f5f1291a3ed74ee966ed351b7e81.camel@suse.com>
Subject: Re: [PATCH 16/16] multipath: Don't always retry deletgated remove
 failures
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
	development <dm-devel@lists.linux.dev>
Date: Mon, 18 Dec 2023 15:21:47 +0100
In-Reply-To: <ZX0bXu0mvP9cPxWI@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231212235320.440336-1-bmarzins@redhat.com>
	 <20231212235320.440336-17-bmarzins@redhat.com>
	 <7e24501a5434ed0d11108c23062f407156aedce8.camel@suse.com>
	 <ZX0bXu0mvP9cPxWI@bmarzins-01.fast.rdu2.eng.redhat.com>
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

On Fri, 2023-12-15 at 22:37 -0500, Benjamin Marzinski wrote:
> On Thu, Dec 14, 2023 at 06:26:58PM +0100, Martin Wilck wrote:
> > On Tue, 2023-12-12 at 18:53 -0500, Benjamin Marzinski wrote:
> > > Now that multipathd is running the same code to remove devices as
> > > multipath, multipath doesn't need to automatically retry the
> > > remove
> > > if
> > > it fails.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > If we know that multipathd executes the same commands that
> > multipathd
> > does, why don't we just call delegate_to_multipathd() repeatedly
> > until
> > the retries are exhausted?
>=20
> We could. The benefit of the multipath command is a more specific
> error
> when the device is in use, and it will work even if multipathd is
> wedged. On the other hand users can always check the logs for the
> specifics of which device was in use and we could handle ETIMEDOUT or
> a
> reply of "fail\ntimeout" specially. We might want to do that even if
> the
> user doesn't ask for retries, since it would be useful for all the
> delegated commands to failback to doing the work in multipath if
> multipathd is timing out.

Good point, I agree.

Martin

