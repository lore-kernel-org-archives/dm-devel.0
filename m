Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CAB1AED45
	for <dm-devel@lists.linux.dev>; Thu,  4 Jul 2024 16:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720109379; cv=none; b=a7KJPkpRZ3CcAlHShlf4zA0Fny/fJGgYPMP4L+dzqwH0p8Ep7LeZzAQRXE+OSytg0+aul5SASkMnZMRXuiqbzZM6nnuScE2KFHbCKBp7MsYsVHEkhSymp0z8/YQgh0uEYBabGoGT6fL7iJoJUW579gpYjphQoQu19RLk57BOykM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720109379; c=relaxed/simple;
	bh=HtXK5ySOFaHbJOlE1sgbYdtN9N+9OaclzkOancLZJgQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xf/l4FINQxq8hPgETEc3hoLpRAL/qJwz4dsEqfpcpYan97/jwiJWbEqh7z9/XyMNF2k9L0G1HMozxHv8ogT542FtvZHIzxAIrq/mkuzrGfLdZ1rfRTDIa/OaBzZg0jORJWOiE6SoSPfoy14Wi7xzT+qTZvFyjYU51OMAAbdgvIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=guwCcIGm; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=guwCcIGm; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="guwCcIGm";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="guwCcIGm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1720109374;
	bh=HtXK5ySOFaHbJOlE1sgbYdtN9N+9OaclzkOancLZJgQ=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=guwCcIGmCmwuol04EIA2k1pjfL/gzmxD8xfcaQEwN54iWvwtMwwulRMVKmzm2m0R4
	 E10f7sC3GkIGciG3B+gGTRatikXCA0O5uoWZUhy0G8BpQBRPu4p4IbeAu6nkJxEduP
	 RhrNQEP16RD6x+5Wtir0YIWiBmWDgM1GVswNLIJo=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id CD184128184B;
	Thu, 04 Jul 2024 12:09:34 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id IRHOHPKvpp-M; Thu,  4 Jul 2024 12:09:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1720109374;
	bh=HtXK5ySOFaHbJOlE1sgbYdtN9N+9OaclzkOancLZJgQ=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=guwCcIGmCmwuol04EIA2k1pjfL/gzmxD8xfcaQEwN54iWvwtMwwulRMVKmzm2m0R4
	 E10f7sC3GkIGciG3B+gGTRatikXCA0O5uoWZUhy0G8BpQBRPu4p4IbeAu6nkJxEduP
	 RhrNQEP16RD6x+5Wtir0YIWiBmWDgM1GVswNLIJo=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 2B0651281233;
	Thu, 04 Jul 2024 12:09:34 -0400 (EDT)
Message-ID: <b81f499748b48d459febb980641921e1cbc4b36f.camel@HansenPartnership.com>
Subject: Re: [PATCH] dm verity: add support for signature verification with
 platform keyring
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Luca Boccassi <luca.boccassi@gmail.com>
Cc: dm-devel@lists.linux.dev, snitzer@kernel.org, jmorris@namei.org, 
	paul@paul-moore.com
Date: Thu, 04 Jul 2024 12:09:32 -0400
In-Reply-To: <CAMw=ZnQzAsNUg+AAbqZWWzz_=uBDwUzo4NKsaTAgzxCs7j9LkQ@mail.gmail.com>
References: <20240617220037.594792-1-luca.boccassi@gmail.com>
	 <544c16649bafe77d5ff4f6cecb09f3de3b97d9a6.camel@HansenPartnership.com>
	 <CAMw=ZnQzAsNUg+AAbqZWWzz_=uBDwUzo4NKsaTAgzxCs7j9LkQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 2024-07-04 at 16:41 +0100, Luca Boccassi wrote:
> On Thu, 4 Jul 2024 at 16:21, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
[...]
> > But there's a reason we allow mok users to distrust DB through
> > mokutil. It's because although you might be OK with these keys
> > guarding the pre-boot environment (because if they don't do that
> > Microsoft will be unhappy) and transferring control to SHIM via
> > these keys, you wouldn't necessarily trust the owner of these keys
> > to tamper with your kernel or install modules.  Doesn't a similar
> > reasoning apply to dm-verity root hash signing?
> 
> Yes, although to me it personally feels like the real benefit of that
> is avoiding being too exposed to the kitchen sink that is the UEFI
> 3rd party CA,

That's precisely correct.  We trust the regulation of the pre-boot
environment but don't want to encourage people to think db certs should
be usable outside it.

>  more than protection against an intentionally malicious CA owner,
> after all if you are malicious and control the first stage of the
> chain of trust things are very dire at that point. However, this is
> all moot because of the next point that you correctly raised:

I think we mostly agree the 3rd party CA is reasonably well regulated.
The problem is actually OEMs and ODMs that add their own certs to DB
outside of the 3rd party CA control (mostly so their own EFI tooling
will run).  In theory they're still regulated by the MS Hardware
Compatibility requirements, but we don't want them getting the idea
that they can suddenly also sign linux kernel binary modules or
additional IMA policies or add trusted keys to the system keyrings ...

James

