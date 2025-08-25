Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0A52BD01A
	for <dm-devel@lists.linux.dev>; Mon, 25 Aug 2025 21:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756159009; cv=none; b=tDTkdZbFVXg29XdrPNZpa622No1sD+leh8G2yh66z4I+R7ZlvLW+7q7bxrtYbkVnsZePnclatu2MjCx+zJp9TUXxg/9Wket7/6P5N84mRnTb+ppIHpfFZZzfIR7uMKs7tawZUOq0RWrTMnZi23Y2wyHDa3n9rTYakPkn2idUPU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756159009; c=relaxed/simple;
	bh=xu6oMeYdl4NIkjSjikXlRMxnsUePVcZPe4Tzc+M4lLE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TnnAIlp5Vm0dnQM8ME0sXnBSKwE2g/PJWfBSEa5UZJRjwo7C1OjGljqMuP1QyvbSNm0CpHgEAins+BSBoxLcjuo7fHiDL7UuweDw1Hf3wpiA2YvyYtZ7tWvHATChKdBhk2vjFmAxWwcscskXEfOZSDr7oj3xrWvKtdNhtvaTOSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vs2z++Jk; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vs2z++Jk"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-afcb7acfde3so726187266b.3
        for <dm-devel@lists.linux.dev>; Mon, 25 Aug 2025 14:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756159006; x=1756763806; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xu6oMeYdl4NIkjSjikXlRMxnsUePVcZPe4Tzc+M4lLE=;
        b=Vs2z++JktLzl2AtQYfVwj0xP8LycXZx8VbuDdZKP+r0smi5YfOGLFuHWYt53Nle2BW
         ozz++kUMpE9dWbIUZMflQEYgKqYjLzteD6YyFwkvzUJCaL6yiu6mRXdDMH0G28fPP5ce
         aUIIp0nB1Vw5y00ehw+iYMPZWMAOFFl7inBK9olvdL6/nBHwZI2FmnsjHLaj0d/v0UQC
         WXPBIq6/6mfChX22B6j8QVzjEqEHat8yTQIFudWbURFwsyvl7dIbXbRBbY+E/kpOTzkh
         EXC4oeQU4pn/CS+2lGpbwyehbd7fXmooSe8W6q4ROYkX1jl5rBQc/Xfo/rVm/oVrzjWu
         W9xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756159006; x=1756763806;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xu6oMeYdl4NIkjSjikXlRMxnsUePVcZPe4Tzc+M4lLE=;
        b=n62XavoV3/6ycxifQsmobxE4cuHnR2kdVAhhQ6fTd1m7rhAln0rWbX7vxwNQA2jtnT
         HcE1MhOfTwj6ka9s//veRoXr/aBC4t/6vw7FMqvWfA83P2eHA74xqfEO8XsMCBZsuX8T
         Rq2inNZzU6wgFwT5/KsJwKTIZYVoE7BS+GLa5h2wVifldD8izZeZj3GBBzWwwPj4nNvq
         6IatdIdJq05H+2HWe6VU7bFq4TnFxbCWRBTooVBtgU6XUJnQB1ZHw1D/93pAdWtXzxoO
         hbu8cU/jGQ/psGE8Rd7rWkZgVcjqfe+F6aGPSAxyrz/rDJjcz+jZGgg1cT0osaDyZ2aI
         xYxQ==
X-Gm-Message-State: AOJu0YxEwhH75q4Ugkm00XhmEWdvR14Pr9vq+1Uq6sNYpITzlZTooeJJ
	u9W027u5UmVt+5zZOgb64D9lvIqW4aH1Az3rpTnXeoHfLryggE7O+kQOPvCF03iPn/TzxUT9fzo
	xfZadWbg=
X-Gm-Gg: ASbGncv0z+ekLCs/larNV4HNHNZaA2tEw7bceb9e3acyYK1s23Lz6xrFqJHD5mKSDBp
	brYQp/ogAMF6NTyRsuVMV0lj5tQEg6uykyBnHld87yQmMmeR00E7p42dqbrXbSLIXYpRmjE2WYO
	Bws4psQsmTnL7Pl8ICjSMkL9Tr5c5RZuIk4QCFv9LJ1u2G8qlMvhC6pJ5gfXsjmwpPo+cb0/g5g
	xQseIQxZeD4PLbtI5ogYMSCnv+R4JZB9pgIzGTVK1gX2xEoIa3gFZVMT7NdHFAGwqJ5eN8Dh9d1
	ECyRrM98QL8q6j8O/oOcs7UGTYWXQyjMgCyewO3rAqVO5ae2yW/p+wXQFUPjf+ox43erHzwelJn
	/mMJGTd1RGMVE01q/WpUBZdppms25BtpDLiPaZAHDDYP/Bmha25pb9SWSN13u5/IQNXDzgz8Dn9
	UvCwV/7HGyyxnFHgCdFdF1hPd985f/tNDn2EPjb5QeGzAex8Xl1a4RuiikSTTW+an6+g==
X-Google-Smtp-Source: AGHT+IFmm/Btht6socVvwUeTvvX0QR13pXT7fVqk7CxbJvjDpUlh6fYCdC4BqXJsJatlVsU/ydOkRA==
X-Received: by 2002:a17:907:6d19:b0:ae3:4f99:a5a5 with SMTP id a640c23a62f3a-afe28f76149mr1162550666b.6.1756159005636;
        Mon, 25 Aug 2025 14:56:45 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe4937a15asm627132666b.115.2025.08.25.14.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 14:56:45 -0700 (PDT)
Message-ID: <159c19fba159f5f414d020a6a72eb77e49656957.camel@suse.com>
Subject: Re: [PATCH] libmultipath: fix crash in print_foreign_topology
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 25 Aug 2025 23:56:44 +0200
In-Reply-To: <20250820183928.37402-1-bmarzins@redhat.com>
References: <20250820183928.37402-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2025-08-20 at 14:39 -0400, Benjamin Marzinski wrote:
> print_foreign_topology() called get_paths() to get a vector of
> (struct gen_path *) items and then called get_multipath_layout__(),
> which expects a vector of (struct gen_multipath *) items, with the
> path
> vector. This can easily end badly. Fix it to correctly call
> get_path_layout__(), and rename width to p_width in the functions
> that
> end up calling snprint_multipath_topology__(), which is expecting to
> get
> passed the path field widths.

Thanks for catching this!

I don't like the p_width rename so much, as we generally don't have
this kind of variable naming convention, but that's not a problem.

Reviewed-by: Martin Wilck <mwilck@suse.com>

