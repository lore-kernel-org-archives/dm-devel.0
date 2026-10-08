Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710273955C4
	for <dm-devel@lists.linux.dev>; Thu,  8 Oct 2026 18:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791484921; cv=none; b=kRMYMpBvBJnHAt0KUkG3PA8QR7U7A4piZ6PjyiN+16QT+wK92EEHSxwSrZzg1OWqvrYqqrC/v+SiUBlXtCXjQbaR2bVORFWbW3IvOZ31QSNVAeIBsrYAg6/a4lng0ZAp/TBT8GX1Z2RrZCJfgZUgtV3l7RMmtNuIH8yQ+2psuK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791484921; c=relaxed/simple;
	bh=N34rDJw1QcYA/gTRnyVDP3aU3+QlHxNGYqC4oNSCe0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QVB2j3VkIi3FplNHfrAKBt9CI+a8DMkczniYIQvKE8sLi09Rn4wlYSpZ+7MErezRBzoXeLkMIs3UeVJ0rykRkGizbVQaTBjimPhDNen6KrZmsCyYNdFgf047ITyuOHwppeOd004ZJIQNNGur1nQWpTqxDeOsJSPFzA0GNjb7qSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com; spf=pass smtp.mailfrom=amutable.com; dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b=QOl2lmba; arc=none smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b="QOl2lmba"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-6714595153cso932576d50.0
        for <dm-devel@lists.linux.dev>; Thu, 08 Oct 2026 11:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20251104.gappssmtp.com; s=20251104; t=1791484918; x=1792089718; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ec5a44X3oISFHgbKkTAE4U1i3Gpy1JGFD3SC5oC7PLk=;
        b=QOl2lmbaCAFyYzMIDzecTFI0UPjFYDyq9F9zvqe4aI8WVwBhTYRGtJGii0V8uPPGtl
         YV94mfFrWFxpGaanY0XTWCYqAufjk0tQBk+QjzcEICnRCelMlwfCgCvntWsmhpsK23sK
         fXWmwfeFPSDC0LTfgS60WqArlmOyoU8bMAbZd22y5K7JaYEHkKurrKhN+MqnHYzZutH7
         vfhVmZ7JNWkbV59z9tv7071N3PLHkR2HH3VWpaR8TxP0Q9+Ffjk4MVC8pEDRZtDqrm+J
         BxVQ3sp8aVQ6eyPt12rx6GHrkWek9ddnFJRklYLNhyYtEKvGmSdAX8+bltNLcOvke+tV
         d7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484918; x=1792089718;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ec5a44X3oISFHgbKkTAE4U1i3Gpy1JGFD3SC5oC7PLk=;
        b=V7snj/0aN2LmQ2w6yFhdkF8pSL2+nAAb4k7fJsGtIwj0LBeTkgr3M7liRcSq0QVM9c
         1D3iuB3LjsPT3NphYNg+ZaOl8CFQbMIZZyNfZh3hfKXhQwSei6fiwGCjRIpKh/mCDQSB
         DIWYKWOBQ6VzDDR9DStSuOe7RcxkAhk0EQbb0JFQefgjrYcfM0ai7res+l4waGy58Azi
         zHyk2mIO2J9pL+yxTL8QqaapLsMfLt4oQSZACKBgo/oGLwUENbJ13liHOonjDHnpQeIG
         8e0+65MPBPbuzs9odo0TkBi3UgLk8QwrPiR+GNE8m73L1Lcx7mnCHZnlcAMzeRsuJkqx
         232g==
X-Forwarded-Encrypted: i=1; AKwUvBz9HhL53cQYnFZyJ0AkETV1vXgRBuTkhiYIG6tGT+Ffu9hpnnUMdD+D1xWw/N1Ji+xlkEGHNXvGmQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYLxkIV/8MyHc0PlMeGSO8jgHsqam8/V+H9Q3ik7PJtYhB/0lPlu
	GfAGRk2TCoZOsUfNsqIgikP0/6bRltaW73BVnsVn0m1Nku4pPVX9rYBR+f/SivvkXxw0
X-Gm-Gg: AYBFou3qlUf86HFQqOFsw+HkASwzMyFFfWSf4sM7yMjyH5HdK3+YS73Ps1/2LTGQjFC
	SB1yVEkfslwulfJ6cc2PdzI5nqubiwHx9g59jv7AF6o7eSRSmiaRwrc1WefBwvzSB7v4mi9nQoo
	t79K+KUT/cJ76iSs6SHK+PY0tet0IwlSzPgKymBMv47QTYVNBljNSR0/evcm1ZWVWaQW+A++M62
	OzUhH5kIvq57KU52utUh3zS2WElRjWjzLYpfY2txJetsPUaYdcf1g9XPRucQhfpFMi194eFukGI
	dCVEACy7fKtXiG9+/2437QmtQcGNGUFBVaQ3CCg+ZJqf07j6PUuDnDMSgrkKhc/YU712RZLOUR4
	lbfoB47hY0l5qgD74SsHmGPhgEuM4qULtWqY3wSvY2UDe1v15ryUS0rFhXYcIdpFV10tAiMd8Yw
	PwGCi8+15MSOqKtGrs+YZk95HxmyHbbEIuUE50ZyqW8tdmICumClMFnMuCkOp/swjMCb6uB2vvq
	Zt5Teap0ZTAgdN2Iq5rJ3RTNXw5GemoeUfUVBEvEds=
X-Received: by 2002:a05:690e:c4b:b0:677:b347:9b4e with SMTP id 956f58d0204a3-67922f30f9cmr1364658d50.11.1791484918171;
        Thu, 08 Oct 2026 11:41:58 -0700 (PDT)
Received: from toolbx (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67934e2c25fsm17489d50.19.2026.10.08.11.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:41:57 -0700 (PDT)
Date: Thu, 8 Oct 2026 13:41:55 -0500
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
Message-ID: <asfhi1DSO_mhqxWZ@toolbx>
References: <aqyiCavj3xeNqyAo@kernel.org>
 <20260914-ajhalaney-dmverity-key-identifier-v1-0-01922dc1366a@amutable.com>
 <20260914-ajhalaney-dmverity-key-identifier-v1-1-01922dc1366a@amutable.com>
 <715249.1789718726@warthog.procyon.org.uk>
 <aq2VxlttdlTNlHo6@toolbx>
 <arYzQN1ViuiCBemo@kernel.org>
 <asZlNEFdvidvMdJ5@toolbx>
 <asfT-SLkty5DC_Rx@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <asfT-SLkty5DC_Rx@kernel.org>

On Thu, Oct 08, 2026 at 08:33:45PM +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 07, 2026 at 10:30:14AM -0500, Andrew Halaney wrote:
> > On Fri, Sep 25, 2026 at 11:39:28AM +0300, Jarkko Sakkinen wrote:
> > > On Fri, Sep 18, 2026 at 02:59:49PM -0500, Andrew Halaney wrote:
> > > > On Fri, Sep 18, 2026 at 09:05:26AM +0100, David Howells wrote:
> > > > > Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > > > 
> > > > > > This is great for discussion but what we want for the commit message
> > > > > > is just motivation and resolution.
> > > > > 
> > > > > Actually, I think it's useful that Andrew wrote up the issues in the commit
> > > > > message - and I think it shows part of the motivation.  The 'writing a fake
> > > > > /proc/keys line in the description' is something I hadn't considered.
> > > > 
> > > > I'll defer to what you all want in the message here, I found it valuable
> > > > but I trend on the side of overly verbose admittedly!
> > > > 
> > > > > 
> > > > > > I don't think we need all this just to say that /proc/keys in a racy
> > > > > > query mechanism for production, which is an issue for dm-verity, given
> > > > > > that nothing else is available.
> > > > > 
> > > > > I think at some point, we will need a system call to search all for all
> > > > > accessible keys matching certain criteria by actually walking the key
> > > > > database.  The problem there is that there may be multiple hits, so we may
> > > > > need something like:
> > > > > 
> > > > > 	int count = find_key(key_serial_t start_id,
> > > > > 			     const char *type, const char *desc_prefix,
> > > > > 			     key_serial_t *results, size_t results_size,
> > > > > 			     unsigned int flags);
> > > > > 
> > > > > Allowing you to do:
> > > > > 
> > > > > 	key_serial_t dm_key;
> > > > > 	int n = find_key(0, "keyring", ".dm_verity", &dm_key, 1,
> > > > > 			 FIND_KEY_EXACT_DESC);
> > > > > 
> > > > > This wouldn't be as fast as a direct lookup since it would have to walk the
> > > > > key tree, doing name comparisons and perm checks on each key of the type.
> > > > > 
> > > > > > And secondly special keys are meant for implicit keyrings so isn't
> > > > > > that all there's to it?
> > > > > 
> > > > > I have no particular objection to setting aside a block of negative key IDs
> > > > > for special keyrings that need to be accessed a lot - though I would make
> > > > > common reg/unreg functions that take the ID to be registered and, say, set the
> > > > > block at -257..-512.  Moving the BFP keyring to -257 and DM to -258.
> > > > 
> > > > To be clear are you suggesting I do that for v2 here? Happy to make the
> > > > change and add some reuse to the registration functions, etc. I'm
> > > > guessing its fine to change the bpf id since its still only in -next?
> > > > 
> > > > The only awkward bit with making that more generic is that dm-verity
> > > > isn't __ro_after_init since its coming from a module possibly, and
> > > > because of the module usage I also protected it with a spinlock in case
> > > > someone's accessing it while you unload the module. Could just use one
> > > > spinlock for the whole generic array, and drop the __ro_after_init I
> > > > suppose.
> > > > 
> > > > Let me know if I'm not following properly!
> > > 
> > > I just read David's response and I think he made fair arguments,
> > > and patches look fine to me.
> > > 
> > > David, did you have anything? I could pick these.
> > > 
> > > Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > 
> > 
> > Gentle ping :)
> 
> Understandable :-)
> 
> > 
> > Are we happy with these to get picked up?
> 
> Can you just do a resend that applies on top of latest mainline
> or my tree? I.e. b4 shazam was not happy about this.
> 
> Full log:
> 
> $ b4 shazam https://lore.kernel.org/keyrings/20260914-ajhalaney-dmverity-key-identifier-v1-2-01922dc1366a@amutable.com/
> Grabbing thread from lore.kernel.org/all/20260914-ajhalaney-dmverity-key-identifier-v1-2-01922dc1366a@amutable.com/t.mbox.gz
> 
> Breaking thread to remove parents of 20260914-ajhalaney-dmverity-key-identifier-v1-0-01922dc1366a@amutable.com
> Checking for newer revisions
> Grabbing search results from lore.kernel.org
> Analyzing 10 messages in the thread
> Analyzing 0 code-review messages
> Checking attestation on all messages, may take a moment...
> ---
>   ✗ [PATCH 1/3] keys: add KEY_SPEC_DM_VERITY_KEYRING
>     + Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org> (✓ DKIM/kernel.org)
>     + Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org> (✓ DKIM/kernel.org)
>   ✗ [PATCH 2/3] keys: add KEY_SPEC_FS_VERITY_KEYRING
>     + Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org> (✓ DKIM/kernel.org)
>   ✗ [PATCH 3/3] Documentation: keys: document IDs added since KEY_SPEC_REQKEY_AUTH_KEY
>     + Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org> (✓ DKIM/kernel.org)
>   ---
>   ✗ BADSIG: DKIM/amutable-com.20251104.gappssmtp.com
> ---
> Total patches: 3
> ---
>  Base: base-commit 1a1de54f7369cd2b5bac0f265910e60ad3a6b4c3 not known, ignoring
> Applying: keys: add KEY_SPEC_DM_VERITY_KEYRING
> Patch failed at 0001 keys: add KEY_SPEC_DM_VERITY_KEYRING
> error: patch failed: include/linux/key.h:441
> error: include/linux/key.h: patch does not apply
> error: patch failed: include/uapi/linux/keyctl.h:25
> error: include/uapi/linux/keyctl.h: patch does not apply
> error: patch failed: security/keys/process_keys.c:25
> error: security/keys/process_keys.c: patch does not apply
> hint: Use 'git am --show-current-patch=diff' to see the failed patch
> hint: When you have resolved this problem, run "git am --continue".
> hint: If you prefer to skip this patch, run "git am --skip" instead.
> hint: To restore the original branch and stop patching, run "git am --abort".
> hint: Disable this message with "git config advice.mergeConflict false"

Egh, sorry I was on linux-next. I'm also realizing that the
KEY_SPEC_BPF_KEYRING bit this sort of depends on is only in bpf-next
(i.e. 264d8fd2794f ("bpf, keys: Add a bpf keyring for program signature validation")).
Otherwise as is this conflicts on mainline and we'd just have to skip
the -9 the bpf keyring is using at the moment.

Should I just base on bpf-next that and send thru there instead? I can't recall
how kernel maintainers typically handle this other than cutting a stable
branch that both subsystems pull from, etc.

Thanks,
Andrew
