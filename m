Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB234AA57C
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 15:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791387026; cv=none; b=K/P8DPlJKspVjFf9NaEMpOGYSzkpZkDDywKnjOHeREJ8a8Q0kADuGrVWesO5q+6QWLxgR1cerT6WS7I8bp+e6PfCs9NT10S4PnvIyaXdJmcHZ7zKHBxEB3ib3oGZdW7oLTQCUwvOayj1fM/KVSO/jlNIIXXyTFMO0NwKMKtqJ8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791387026; c=relaxed/simple;
	bh=5kpnZ69rpIeJK7I/vVJI1/Sd58TTWJsQUlkCNqKOhyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U+3jkK+5TBPTwkryXr7uP8EQoZBCFg4GLUJNEj+qiOMtIV1KBOSC07h50o5DEFzEJ03T6scnsLNjzEqh+d+kHzIKZs0rFZ2/6IOn229GkKAo7CUr4jeBMrp/kFF631hc9ZJR9bbu/sTOLpLX+Vbmbzj4rDuh5X3BcSgFzBfnnbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com; spf=pass smtp.mailfrom=amutable.com; dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b=nbIVZW8x; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b="nbIVZW8x"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b056d58f2aso14935197b3.2
        for <dm-devel@lists.linux.dev>; Wed, 07 Oct 2026 08:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20251104.gappssmtp.com; s=20251104; t=1791387019; x=1791991819; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fxMsGMJoi15xhCerKdZHKbDFnpM/+Dr7cx060hZaVDo=;
        b=nbIVZW8x6yRUaum0/NaXz+CYWEfQTRGJ4zJtngSWMsYQtkOGi8elr0WKM4KlycXf7M
         ZYtezpLIy/UKQKNAvTxmCB1sHTJ3MeYRATEv/eFP1y0aY56YZuc5gFvl04CP0A0g9x7y
         zm81vcg6RFEYXpp8LLx9OV4HMPrFFzVtkLw4rhKpCurEdhUwhRqRDdmjZTOT9Fy9QIU2
         huq0K3kQY5dMfN6mx2ywyrQQFt/cQMGhwmkGUWotJe7YflHDH/RNMDiqDV6mGAZOOD/X
         S74K5D9VNxhsZ3Yl0a/GXhf4YEPj5ShJCSkczcGOkEscqS3sjBt/F8wAb67jtIzemEpW
         dPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791387019; x=1791991819;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fxMsGMJoi15xhCerKdZHKbDFnpM/+Dr7cx060hZaVDo=;
        b=XmadHYXKuyWQvNyYAMlgX2xubkacA2BCgFCTxQTrT1eWDbvCKEbynvHd5+uImiXVex
         llVp7dU0pw7SuvrP9F9hNZ+6Aq6jmDrucxEJzqaHpPFu0i0x7Z8ZooQi03KYPZiqxqoy
         RoQCEEJozh46Sqd3CGIWtXv8dMkk3X5IYmFWFSD3phexb/xzdsMjZkDSvlHiyS1YTq0I
         JQVpT4kRW3zTGgESOZErae7e1ktdAVi8H0fbS9q3uuYIBpWPJOowpGiM64QRGXQ/kgSw
         9Adoh3f4eA4hMQRJNVPwX6urVRI/aVXi5Qcgc3yrwAZDQMK2p0l1ZyuUk02JcgM4TTYz
         h2Bg==
X-Forwarded-Encrypted: i=1; AKwUvBzvOhqQVYVSn5iYG+GyzXVsMXsUyKM6syNx2VkMEb8W4foaqvyBpsr48gB0hhFbiXNVNY4oAWxDig==@lists.linux.dev
X-Gm-Message-State: AFq9FYKuQ2Ek4Hxh5AHmsKZEav1ri0wQksEdz80WFDAP0iq/VBTF/8bp
	E15fBALlbEC7Shebx1zF+Pc2q/qm25kEXIVkHWXa/GqPp/z5uIoEj5kuz2miwC3kEjUc
X-Gm-Gg: AYBFou1Kxj8eKcH4bfe1FY4gZRLCiegkgMg7pdpHxaksTMy/OKLsKF5N3OXxyjs6I1z
	RB1gATPZojX2/5orqmQ5JnotBQTg3VCPap9bUYXcfOdt+jUIyKvUm4oHRlGoBQIZYUI0L/i80xy
	M/nJcldoPXiTDvXHQiZDD890y+Bwk3rgQ6F1nXgxSEjfECS9kPpBK06qPcBC5qdH3MP7lm5bZEi
	VE14jR8Ar2wG8yLR+bEVOlz0NXQfy0JMuipGQUdFl9hsjxT+kgok3s4j0O9/oGZVJD2Ake/PMzA
	ndmJw9xpYIuj8fF7dKLBKH7lEhmmUcLMdMUVW+WrWHYJphqjVqaUmF6Dd9EQl02OnuBpnB5rwVs
	+BDb9G+7np1ZzPK7Rf2KTxi8YJ4H84jttYfG5tfTJODKfcIAnqPyKeV36ECrtCff4ZH/O5U3yVc
	rPAFdiKFUy/lCnOqI5qNDMAvTWdeIp+nnFqv91uDrvUWCcC1fLH1zfmxzHHjxRNM8YbXuyjLU01
	yLhBRY4wOSOsJOHBgQGY0WjQWTderPxXHGZmxsOJoo=
X-Received: by 2002:a05:690c:6b01:b0:873:5bb2:6c3d with SMTP id 00721157ae682-8b05b14e894mr18727417b3.68.1791387018749;
        Wed, 07 Oct 2026 08:30:18 -0700 (PDT)
Received: from toolbx (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b05a9b8806sm9897427b3.1.2026.10.07.08.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 08:30:18 -0700 (PDT)
Date: Wed, 7 Oct 2026 10:30:14 -0500
From: Andrew Halaney <andrew@amutable.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: David Howells <dhowells@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, bpf@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-doc@vger.kernel.org, 
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: Re: [PATCH 1/3] keys: add KEY_SPEC_DM_VERITY_KEYRING
Message-ID: <asZlNEFdvidvMdJ5@toolbx>
References: <aqyiCavj3xeNqyAo@kernel.org>
 <20260914-ajhalaney-dmverity-key-identifier-v1-0-01922dc1366a@amutable.com>
 <20260914-ajhalaney-dmverity-key-identifier-v1-1-01922dc1366a@amutable.com>
 <715249.1789718726@warthog.procyon.org.uk>
 <aq2VxlttdlTNlHo6@toolbx>
 <arYzQN1ViuiCBemo@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arYzQN1ViuiCBemo@kernel.org>

On Fri, Sep 25, 2026 at 11:39:28AM +0300, Jarkko Sakkinen wrote:
> On Fri, Sep 18, 2026 at 02:59:49PM -0500, Andrew Halaney wrote:
> > On Fri, Sep 18, 2026 at 09:05:26AM +0100, David Howells wrote:
> > > Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > 
> > > > This is great for discussion but what we want for the commit message
> > > > is just motivation and resolution.
> > > 
> > > Actually, I think it's useful that Andrew wrote up the issues in the commit
> > > message - and I think it shows part of the motivation.  The 'writing a fake
> > > /proc/keys line in the description' is something I hadn't considered.
> > 
> > I'll defer to what you all want in the message here, I found it valuable
> > but I trend on the side of overly verbose admittedly!
> > 
> > > 
> > > > I don't think we need all this just to say that /proc/keys in a racy
> > > > query mechanism for production, which is an issue for dm-verity, given
> > > > that nothing else is available.
> > > 
> > > I think at some point, we will need a system call to search all for all
> > > accessible keys matching certain criteria by actually walking the key
> > > database.  The problem there is that there may be multiple hits, so we may
> > > need something like:
> > > 
> > > 	int count = find_key(key_serial_t start_id,
> > > 			     const char *type, const char *desc_prefix,
> > > 			     key_serial_t *results, size_t results_size,
> > > 			     unsigned int flags);
> > > 
> > > Allowing you to do:
> > > 
> > > 	key_serial_t dm_key;
> > > 	int n = find_key(0, "keyring", ".dm_verity", &dm_key, 1,
> > > 			 FIND_KEY_EXACT_DESC);
> > > 
> > > This wouldn't be as fast as a direct lookup since it would have to walk the
> > > key tree, doing name comparisons and perm checks on each key of the type.
> > > 
> > > > And secondly special keys are meant for implicit keyrings so isn't
> > > > that all there's to it?
> > > 
> > > I have no particular objection to setting aside a block of negative key IDs
> > > for special keyrings that need to be accessed a lot - though I would make
> > > common reg/unreg functions that take the ID to be registered and, say, set the
> > > block at -257..-512.  Moving the BFP keyring to -257 and DM to -258.
> > 
> > To be clear are you suggesting I do that for v2 here? Happy to make the
> > change and add some reuse to the registration functions, etc. I'm
> > guessing its fine to change the bpf id since its still only in -next?
> > 
> > The only awkward bit with making that more generic is that dm-verity
> > isn't __ro_after_init since its coming from a module possibly, and
> > because of the module usage I also protected it with a spinlock in case
> > someone's accessing it while you unload the module. Could just use one
> > spinlock for the whole generic array, and drop the __ro_after_init I
> > suppose.
> > 
> > Let me know if I'm not following properly!
> 
> I just read David's response and I think he made fair arguments,
> and patches look fine to me.
> 
> David, did you have anything? I could pick these.
> 
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> 

Gentle ping :)

Are we happy with these to get picked up?

Thanks,
Andrew
