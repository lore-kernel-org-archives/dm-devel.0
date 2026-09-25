Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3EB391845;
	Fri, 25 Sep 2026 08:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790325579; cv=none; b=DBVHOse5cgvr6cZplt4+FqkK0ZEZvb/KWUS4u6TOQzJE1HODl/lfqX01dtLr4souLjiP2+iQYUFYwmhGpjTv6EbfmcNDK3rhBBIKCd5cJtNlDmWWJYZTZU6r+TJb6eNxgtA62Ic9DuyuLm0oEVvzwDmrYy+N5mlcro4s37TGVY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790325579; c=relaxed/simple;
	bh=2bV/6e/zD+/zSR/D0Yr5ooqOrIdjNNV3DzaBWajLvUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NGuRFOoxRBQ2D/S22wfmI6mSSRohNS6YuVVcTjVlb2m+T+oSOhRrIcRQyihgY0Nf9jIPsNx2Yp/IgnAl8IOAw4HAlkOk1lLeZbd4CDfzCL/sPHEGxE9n0PKa/g4slc6WHIn98GjkTbdTOd+NjJZqrkCDb/aEZctXp7lpKT5Uy7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQCyeCGv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQCyeCGv"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AAC261F000FF;
	Fri, 25 Sep 2026 08:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790325578;
	bh=I21Y0zUxOqibpDhaQPCMpK8pLAjRT5+UlLhgvlp695U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nQCyeCGvMCdv+YYwH0LCsQ5KneRjMND2h9b5QnylcqFyvRS2neveSn9WQRDyDQQCM
	 Xldvqml5GKwOFcMg3I8smcHRBSmwaLJfO38RSFTmxxKco8mKA8EbEzhEzsVHUjxOJ0
	 Z9R3gsqAhlPO+KH2ODgcwXibY98xP2zZX4kgoNuicqW4xRDk/VSIm6d6XTr/81Ecy9
	 0/nRCMsEd4aDpINKgR8VutD+Hp04JK6bpJgTUOkq2xWRbMWTet573H/F/8htfwGvtz
	 HjBIUByVIXg7h23nQktDinStpwnTL2dJ22uUEwmYP15q1H8KHoQcvT0+yzQTif36XN
	 4A1cnE6eQjiSA==
Date: Fri, 25 Sep 2026 11:39:28 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Andrew Halaney <andrew@amutable.com>
Cc: David Howells <dhowells@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org, bpf@vger.kernel.org,
	fsverity@lists.linux.dev, linux-doc@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: Re: [PATCH 1/3] keys: add KEY_SPEC_DM_VERITY_KEYRING
Message-ID: <arYzQN1ViuiCBemo@kernel.org>
References: <aqyiCavj3xeNqyAo@kernel.org>
 <20260914-ajhalaney-dmverity-key-identifier-v1-0-01922dc1366a@amutable.com>
 <20260914-ajhalaney-dmverity-key-identifier-v1-1-01922dc1366a@amutable.com>
 <715249.1789718726@warthog.procyon.org.uk>
 <aq2VxlttdlTNlHo6@toolbx>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq2VxlttdlTNlHo6@toolbx>

On Fri, Sep 18, 2026 at 02:59:49PM -0500, Andrew Halaney wrote:
> On Fri, Sep 18, 2026 at 09:05:26AM +0100, David Howells wrote:
> > Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > 
> > > This is great for discussion but what we want for the commit message
> > > is just motivation and resolution.
> > 
> > Actually, I think it's useful that Andrew wrote up the issues in the commit
> > message - and I think it shows part of the motivation.  The 'writing a fake
> > /proc/keys line in the description' is something I hadn't considered.
> 
> I'll defer to what you all want in the message here, I found it valuable
> but I trend on the side of overly verbose admittedly!
> 
> > 
> > > I don't think we need all this just to say that /proc/keys in a racy
> > > query mechanism for production, which is an issue for dm-verity, given
> > > that nothing else is available.
> > 
> > I think at some point, we will need a system call to search all for all
> > accessible keys matching certain criteria by actually walking the key
> > database.  The problem there is that there may be multiple hits, so we may
> > need something like:
> > 
> > 	int count = find_key(key_serial_t start_id,
> > 			     const char *type, const char *desc_prefix,
> > 			     key_serial_t *results, size_t results_size,
> > 			     unsigned int flags);
> > 
> > Allowing you to do:
> > 
> > 	key_serial_t dm_key;
> > 	int n = find_key(0, "keyring", ".dm_verity", &dm_key, 1,
> > 			 FIND_KEY_EXACT_DESC);
> > 
> > This wouldn't be as fast as a direct lookup since it would have to walk the
> > key tree, doing name comparisons and perm checks on each key of the type.
> > 
> > > And secondly special keys are meant for implicit keyrings so isn't
> > > that all there's to it?
> > 
> > I have no particular objection to setting aside a block of negative key IDs
> > for special keyrings that need to be accessed a lot - though I would make
> > common reg/unreg functions that take the ID to be registered and, say, set the
> > block at -257..-512.  Moving the BFP keyring to -257 and DM to -258.
> 
> To be clear are you suggesting I do that for v2 here? Happy to make the
> change and add some reuse to the registration functions, etc. I'm
> guessing its fine to change the bpf id since its still only in -next?
> 
> The only awkward bit with making that more generic is that dm-verity
> isn't __ro_after_init since its coming from a module possibly, and
> because of the module usage I also protected it with a spinlock in case
> someone's accessing it while you unload the module. Could just use one
> spinlock for the whole generic array, and drop the __ro_after_init I
> suppose.
> 
> Let me know if I'm not following properly!

I just read David's response and I think he made fair arguments,
and patches look fine to me.

David, did you have anything? I could pick these.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

> 
> Thanks,
> Andrew


Br, Jarkko
