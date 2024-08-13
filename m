Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557218BF3
	for <dm-devel@lists.linux.dev>; Tue, 13 Aug 2024 09:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723542195; cv=none; b=WrHvMEAH5OaGdKRQZQTxELkahI/gTFTPxs62RAJsSjMk1Sf3fYpmzLKCxo+eYIeBoi7H+waQFLX/oTbYfF/2AzBSsEnG3LUvvVvLGXbVPscY126CTYRSMzf/vDpnUFitfmElpLTlJSF5t0ZgOPVC9AHGX6xUllnLQrNIIYl4cF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723542195; c=relaxed/simple;
	bh=fNFD50OxzpsuSsU83tTKZYbfG1MPV+n2WBzUCTiSq1g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EJ6BZHregUvZOaAn0+txS/KPhXWjPKkWQCQyBQ07YIscsMiEN73Dsng6SLs+kfodP90yve3TuJ6yqAQ/ztoyAt6qlTEQmweaZ+0JP5wdjh5D+Hp+CiaeVxrhOlPXFic0JomPqOgtvI09lSK0eedRKecq2Byi+AmeZZWTQzPI1V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eH1C6CbL; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eH1C6CbL"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5bb477e3a6dso5060991a12.0
        for <dm-devel@lists.linux.dev>; Tue, 13 Aug 2024 02:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723542192; x=1724146992; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xu277OY4oWJOt5FWIKRz6zqj81YJDYp9wdM/kepwK08=;
        b=eH1C6CbLEzfM/qUYUWQW2iZuOOxRK59/8U1Ji+nkCoeWI1PAhz5dmUKoXNA0PzxHCB
         AVf7iKCXz9bEMV0YMpGzNhxbPqCwC5+V7g9FCcPsYbEjlQ5D+2Vga1iwnI5Sd4lgsMYy
         S1ziQA4xjf1Dn4cvbYad2jCSqtpu6L6pzWvX2yAd06rxrzBZFw3U6PP7SyOhX00kWP9c
         gQSHZWgluQ5031y0kb8Ys3vZXE4jEG7489fOk7eIsbU7MDL8UNnDF2blCWq7HhZ2rqP4
         w9BM74fM4US1DvOkIcMJwNrNsSn+Gx64P81TB0V31bHNpZHNBAFf0Sk21ZVvV74m5NjR
         JLqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723542192; x=1724146992;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xu277OY4oWJOt5FWIKRz6zqj81YJDYp9wdM/kepwK08=;
        b=Db/qRbNJgWefq+ImH+8aNRI/NMkiJFn2VreHmYdW9cn5mzzS1dah2J16navQZZhtHn
         WD62HZXzovaA43HeGfcCA7DAvjEXkVdFVeDaGJUH64pMkQEN/TA0CWytC56YCG08W4/Q
         s/mLyjy/28+N+Xd+CNSvduhewIgk6BaVP5EyM/G5G5cPcd+OqwzojFs+VLUi8ZNY7oMk
         TlKPCnFa4nhfFmNP+DRkFryLabmbXjQN7rjR+2X3uZ1Zj229XJoVR7Ni/Ki9LSff3k0v
         DvmfnqNBJzFQBUhJWbQ9YMd5CEXAEEYVJci+sRkvAMsVNKpVzSeA7+rWJK/ffaM3ouW4
         KkhA==
X-Forwarded-Encrypted: i=1; AJvYcCXQo7mANC7g+lYLDl8axWBTidhSl1pVLsTOl6yjqmxkXMGIPisVEftOj2NHjc/x/M9aoXUdOHRcZ1s6FLk9IYjPw67xhixi4GQ=
X-Gm-Message-State: AOJu0YyvG1a9m7yHmlxZ8hbmnHCqbXS+n+uPE5Q4mer8bNOuN8vFrMNN
	7dfW3mRVt/zPnetalXCbBwTB14otDCHa98+j65QPwL96fqPrmPWmel6UvTdbzuQ=
X-Google-Smtp-Source: AGHT+IESueDYFz/aB+/xnlGaJQV/VC7K2zzYo/BsYMgRSKFtRCbEZ1zE5U4xkLQjq1XWYjRCmGxdNA==
X-Received: by 2002:a05:6402:354f:b0:5a1:7570:8914 with SMTP id 4fb4d7f45d1cf-5bd44c27370mr2121597a12.11.1723542191315;
        Tue, 13 Aug 2024 02:43:11 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:e6b3:18ff:fe37:a690? (p200300de37360a00e6b318fffe37a690.dip0.t-ipconnect.de. [2003:de:3736:a00:e6b3:18ff:fe37:a690])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bd1a60214dsm2762089a12.91.2024.08.13.02.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2024 02:43:11 -0700 (PDT)
Message-ID: <61f99010436e6fd8f07e1592294de11bde2a28c8.camel@suse.com>
Subject: Re: [PATCH 00/41] multipath-tools: comply with C library reserved
 names
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Tue, 13 Aug 2024 11:43:09 +0200
In-Reply-To: <ZrqHZDgAZ6C7pokR@redhat.com>
References: <20240808152620.93965-1-mwilck@suse.com>
	 <ZrZcgEz8dHRvyXk-@redhat.com>
	 <89cc73933e550cb26a380296f2f84d81cb062ba0.camel@suse.com>
	 <ZrqHZDgAZ6C7pokR@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-08-12 at 18:06 -0400, Benjamin Marzinski wrote:
> On Mon, Aug 12, 2024 at 06:44:54PM +0200, Martin Wilck wrote:
> > On Fri, 2024-08-09 at 14:14 -0400, Benjamin Marzinski wrote:
> > >=20
> > > Despite some small misgivings about renaming symbols (which quite
> > > possibly aren't being used by anyone) in our user-facing
> > > libraries,
> > > libpmathpersist and libmpathcmd, for the set:
> >=20
> > As the functions are only renamed, we could use (weak) aliases here
> > to
> > still provide the old function names if some caller requires them.
> > Would you prefer that?
> >=20
> > We'd still be violating the glibc standards somewhat, but the
> > probability for an actual symbol name clash is very low, so I guess
> > it
> > would be acceptable to do this in the name of backward
> > compatibility.
>=20
> While it's not that big of a deal, I do think we should prioritize
> backwards compatibility over this level of standards compliance.

Ok. Sending patches right now. I've given them quick tests with  qemu-
pr-helper and some trivial test program that use the "old" ABI, but I'd
be grateful if you could double-check.

Martin

