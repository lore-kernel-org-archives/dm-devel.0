Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16FA37C0EC;
	Thu,  8 Oct 2026 20:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791490554; cv=none; b=LrT6eBdrJRam4yW1UNNj1yQxretwk+CNPKMuXWjhelQrVDJYg4ES9DEbkfl58jJ5uIjXDO1H7G9A8+9V7oTRNlQcctn+rLGFQd/3zTtDLoHiexgD36PFtMlC3dJSK9nq1TLGG1w/AY5t4L5gDW8iZJL4ogCSkBhxUz05P2MRyGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791490554; c=relaxed/simple;
	bh=bXxQnv/foLDDmbSk93eHOxtiE+zfvSULWr5EfJ1SzfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q3qIQhFUDjUrh53DbnoJRS/6+1QgGdDkgiSuFrBk5NZ5PXn2Hk3+VxAgwaSKgyr+YMFSVfC2mSvHrVAtucmNSRXg7CZXmgcMeG277XBG21265S7CEpUxPu4ixc9zSzU1QwkDdBtmDFhSoHtwKLXrb9J3PRqwKLLF9OtMmL1N3UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oqrZnUcl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oqrZnUcl"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 312D01F000FF;
	Thu,  8 Oct 2026 20:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791490552;
	bh=4iWC4txC/hGiO+U81FY2Efqs3MRlpdhy7EvICtlaB6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oqrZnUclFhqCNnr7LY2DFjptLhHSAeSnsDTIvc6sZnA2/3R7kIwFLT+8lSRxkv1za
	 uhi3C0uIQVDxuy0XtWbsanSXMyHjiYWB7YJAeOTWjbM4Vd0sX4SeGKiDUup8Lp5Occ
	 kNtK6T4Gg2B8Xcb6Xw5P7cXBthJeYPX0WPX3niJgWGYH23RhRXK6KuIu8T71Ei2nqY
	 gpprUmIm5EkQLb0M/ccaMIHCKdSmbuCe4GIjf96Ocd3VyvePcbl0R6RDbzZLc0h3RN
	 CxBCKllixOnq+GaKxeVl9iWDKe2j774G95JD9LQPZvLjuzkohID8DymdJ97I62uDpf
	 mUdylBUj3o4mw==
Date: Thu, 8 Oct 2026 23:15:49 +0300
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
Message-ID: <asf59fhpYD1z_diw@kernel.org>
References: <aqyiCavj3xeNqyAo@kernel.org>
 <20260914-ajhalaney-dmverity-key-identifier-v1-0-01922dc1366a@amutable.com>
 <20260914-ajhalaney-dmverity-key-identifier-v1-1-01922dc1366a@amutable.com>
 <715249.1789718726@warthog.procyon.org.uk>
 <aq2VxlttdlTNlHo6@toolbx>
 <arYzQN1ViuiCBemo@kernel.org>
 <asZlNEFdvidvMdJ5@toolbx>
 <asfT-SLkty5DC_Rx@kernel.org>
 <asfhi1DSO_mhqxWZ@toolbx>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <asfhi1DSO_mhqxWZ@toolbx>

On Thu, Oct 08, 2026 at 01:41:55PM -0500, Andrew Halaney wrote:
> On Thu, Oct 08, 2026 at 08:33:45PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Oct 07, 2026 at 10:30:14AM -0500, Andrew Halaney wrote:
> > > On Fri, Sep 25, 2026 at 11:39:28AM +0300, Jarkko Sakkinen wrote:
> > > > On Fri, Sep 18, 2026 at 02:59:49PM -0500, Andrew Halaney wrote:
> > > > > On Fri, Sep 18, 2026 at 09:05:26AM +0100, David Howells wrote:
> > > > > > Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > > > > 
> > > > > > > This is great for discussion but what we want for the commit message
> > > > > > > is just motivation and resolution.
> > > > > > 
> > > > > > Actually, I think it's useful that Andrew wrote up the issues in the commit
> > > > > > message - and I think it shows part of the motivation.  The 'writing a fake
> > > > > > /proc/keys line in the description' is something I hadn't considered.
> > > > > 
> > > > > I'll defer to what you all want in the message here, I found it valuable
> > > > > but I trend on the side of overly verbose admittedly!
> > > > > 
> > > > > > 
> > > > > > > I don't think we need all this just to say that /proc/keys in a racy
> > > > > > > query mechanism for production, which is an issue for dm-verity, given
> > > > > > > that nothing else is available.
> > > > > > 
> > > > > > I think at some point, we will need a system call to search all for all
> > > > > > accessible keys matching certain criteria by actually walking the key
> > > > > > database.  The problem there is that there may be multiple hits, so we may
> > > > > > need something like:
> > > > > > 
> > > > > > 	int count = find_key(key_serial_t start_id,
> > > > > > 			     const char *type, const char *desc_prefix,
> > > > > > 			     key_serial_t *results, size_t results_size,
> > > > > > 			     unsigned int flags);
> > > > > > 
> > > > > > Allowing you to do:
> > > > > > 
> > > > > > 	key_serial_t dm_key;
> > > > > > 	int n = find_key(0, "keyring", ".dm_verity", &dm_key, 1,
> > > > > > 			 FIND_KEY_EXACT_DESC);
> > > > > > 
> > > > > > This wouldn't be as fast as a direct lookup since it would have to walk the
> > > > > > key tree, doing name comparisons and perm checks on each key of the type.
> > > > > > 
> > > > > > > And secondly special keys are meant for implicit keyrings so isn't
> > > > > > > that all there's to it?
> > > > > > 
> > > > > > I have no particular objection to setting aside a block of negative key IDs
> > > > > > for special keyrings that need to be accessed a lot - though I would make
> > > > > > common reg/unreg functions that take the ID to be registered and, say, set the
> > > > > > block at -257..-512.  Moving the BFP keyring to -257 and DM to -258.
> > > > > 
> > > > > To be clear are you suggesting I do that for v2 here? Happy to make the
> > > > > change and add some reuse to the registration functions, etc. I'm
> > > > > guessing its fine to change the bpf id since its still only in -next?
> > > > > 
> > > > > The only awkward bit with making that more generic is that dm-verity
> > > > > isn't __ro_after_init since its coming from a module possibly, and
> > > > > because of the module usage I also protected it with a spinlock in case
> > > > > someone's accessing it while you unload the module. Could just use one
> > > > > spinlock for the whole generic array, and drop the __ro_after_init I
> > > > > suppose.
> > > > > 
> > > > > Let me know if I'm not following properly!
> > > > 
> > > > I just read David's response and I think he made fair arguments,
> > > > and patches look fine to me.
> > > > 
> > > > David, did you have anything? I could pick these.
> > > > 
> > > > Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > > 
> > > 
> > > Gentle ping :)
> > 
> > Understandable :-)
> > 
> > > 
> > > Are we happy with these to get picked up?
> > 
> > Can you just do a resend that applies on top of latest mainline
> > or my tree? I.e. b4 shazam was not happy about this.
> > 
> > Full log:
> > 
> > $ b4 shazam https://lore.kernel.org/keyrings/20260914-ajhalaney-dmverity-key-identifier-v1-2-01922dc1366a@amutable.com/
> > Grabbing thread from lore.kernel.org/all/20260914-ajhalaney-dmverity-key-identifier-v1-2-01922dc1366a@amutable.com/t.mbox.gz
> > 
> > Breaking thread to remove parents of 20260914-ajhalaney-dmverity-key-identifier-v1-0-01922dc1366a@amutable.com
> > Checking for newer revisions
> > Grabbing search results from lore.kernel.org
> > Analyzing 10 messages in the thread
> > Analyzing 0 code-review messages
> > Checking attestation on all messages, may take a moment...
> > ---
> >   ✗ [PATCH 1/3] keys: add KEY_SPEC_DM_VERITY_KEYRING
> >     + Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org> (✓ DKIM/kernel.org)
> >     + Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org> (✓ DKIM/kernel.org)
> >   ✗ [PATCH 2/3] keys: add KEY_SPEC_FS_VERITY_KEYRING
> >     + Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org> (✓ DKIM/kernel.org)
> >   ✗ [PATCH 3/3] Documentation: keys: document IDs added since KEY_SPEC_REQKEY_AUTH_KEY
> >     + Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org> (✓ DKIM/kernel.org)
> >   ---
> >   ✗ BADSIG: DKIM/amutable-com.20251104.gappssmtp.com
> > ---
> > Total patches: 3
> > ---
> >  Base: base-commit 1a1de54f7369cd2b5bac0f265910e60ad3a6b4c3 not known, ignoring
> > Applying: keys: add KEY_SPEC_DM_VERITY_KEYRING
> > Patch failed at 0001 keys: add KEY_SPEC_DM_VERITY_KEYRING
> > error: patch failed: include/linux/key.h:441
> > error: include/linux/key.h: patch does not apply
> > error: patch failed: include/uapi/linux/keyctl.h:25
> > error: include/uapi/linux/keyctl.h: patch does not apply
> > error: patch failed: security/keys/process_keys.c:25
> > error: security/keys/process_keys.c: patch does not apply
> > hint: Use 'git am --show-current-patch=diff' to see the failed patch
> > hint: When you have resolved this problem, run "git am --continue".
> > hint: If you prefer to skip this patch, run "git am --skip" instead.
> > hint: To restore the original branch and stop patching, run "git am --abort".
> > hint: Disable this message with "git config advice.mergeConflict false"
> 
> Egh, sorry I was on linux-next. I'm also realizing that the
> KEY_SPEC_BPF_KEYRING bit this sort of depends on is only in bpf-next
> (i.e. 264d8fd2794f ("bpf, keys: Add a bpf keyring for program signature validation")).
> Otherwise as is this conflicts on mainline and we'd just have to skip
> the -9 the bpf keyring is using at the moment.
> 
> Should I just base on bpf-next that and send thru there instead? I can't recall
> how kernel maintainers typically handle this other than cutting a stable
> branch that both subsystems pull from, etc.

I don't mind if you would take care of the PR through that route.

You can add my r-by to each patch.

> 
> Thanks,
> Andrew

Br, Jarkko
