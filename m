Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED0347CA84
	for <dm-devel@lists.linux.dev>; Thu,  8 Oct 2026 21:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791496648; cv=none; b=ipB8zw7jHBenm65oFxur+VXqOMsmA9pTjAU9KNLx+NaBYePX5yckcr47tCrm0UIY93+ybUPwar5/e/HKet1MDLbL9314gJlCE/RHNeuRaoE8J0e1oEwWtAO3B3zbDImnJkTfZd72vXnCmvkHBdazCvgPilRLVidZckGWXrA6/qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791496648; c=relaxed/simple;
	bh=TinDgVFxFR2tgZfjdVwALy4/9vsweDfT6mfWVmqTMUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j4qCMYZw9jHCUKFe12R4djaoUXBwifPiu5OlX0eqzj1ZwWc7PjXj15SWcy7/zBxxhoHSYIoEUtULyDiRTlqn4C6bcrbKbF9XnSWcbcMje1tzO9gPEbkKWzXbmTcQ1NY2UZKEXnfZ6PH6RFPQGBNN/lzS1aw887bsUNq+gXGETps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com; spf=pass smtp.mailfrom=amutable.com; dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b=wRzYlkXX; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b="wRzYlkXX"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-67687f279b3so3506698d50.0
        for <dm-devel@lists.linux.dev>; Thu, 08 Oct 2026 14:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20251104.gappssmtp.com; s=20251104; t=1791496646; x=1792101446; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Fco4QMlc4mAm6FzCcL+SMMWE++sU0VPdNedp39umucs=;
        b=wRzYlkXXZGoLdIyObFMgJQGhjgu0G7J5ZOus4wY9RU3ysB1T0UobuK17n/XAaa/QzH
         ZrnDJv6vkHE1PognLXj/mYy1qkZtVnjghcgtgohrKCqyaVrQDo7QZdUjqRkZggj+gI5r
         LevLxUhlMa1DAOJDrVpLgYRSRwRSrnYU3eiyoRoJPx5d66M9H6ZLcc5pfXYG9C/uvA4C
         VZl7h2J8Ajyzvy2LQYeyibF15yaPnWYwPcnCzYLH7T4iTIGYSV5DH/wsWDcSSXOyc+K1
         teKq56u3FHiyiXL4Cl+XdGtVOTAssIawPLZxlNsGoDaukZXiW1ZYzxbW9/H4YXEsRDoQ
         jWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791496646; x=1792101446;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fco4QMlc4mAm6FzCcL+SMMWE++sU0VPdNedp39umucs=;
        b=ZEVEtHHsWP061VbAj7Hag0m+jEheYmC/EnnUecqSwslsqtIPc84JE9XTzIgqGuAWzX
         Rt1qm5jPY8vk92mOLOjoepSDAh7EMU29Yx02ST6EOc7h/nD9An8zpiNgb1cq8GPxPRWJ
         TYzZGNaOlEz+mBFhefX8RrdQqZkRgRli1p6ogyCdMSM83P2xwe1yZfKLzOQsF7qj+7g+
         RPQzpK4xRo2j+1UlartTFbmu2Xe6+kIaA4GTLH57Z9p0ayNnyOnN2bwj2m8OCxF3Gnj2
         kpylnrbCwrQ2WWJ3MPjVdsD5SeuwRL1Jxwr39ga13o6ZwwgQZL5QY0XrH6xujPTF20ta
         kAQw==
X-Forwarded-Encrypted: i=1; AKwUvBzVKqwRSRrX5QV9ig3FoaX2wccN2jKs1Z9tsAE+8y8i8snYMBaoFKkEOMQYibu9P3VfXj0N9Ktc7Q==@lists.linux.dev
X-Gm-Message-State: AFq9FYKiAfwULJb7JHvlCOh8Xkpn7WKZLdvDR4mTCChS4GMRQTg2dmdX
	ifklya83Ep93uWYUSWm8mcBthjR7ju0pa0iP1Xxeobx2ZPPBjpA6xU3EfmSXzbyU3GGY
X-Gm-Gg: AYBFou2ni1tMx2RR2snBx272eC4wNRoqQt/GD37DG7cMXtpYUCje8f5p2BPmJtU1K1H
	gT6yg8RAqzRfpX28D5z0k5Kuv9zhTCWI3r0PyJd8GXiK9SHOhr2XwJdgP0BfqrvDGUdM/JTQhyH
	1Y8DKP2G2gOMD81JTyKdqjatd8WIL93GgRohAHXlHhUXgVnK7xNObbpQECbKblpxkrM4xcJN1WF
	sFyl7mxlUse5JmYRP3r0uA7n4p2no+X1PSQPJLBFBm8da1WUKK9knAWIz6+XEpFwyidUX/EJIcC
	79jq5iGLkkNE7lE/M1sS51rx6NSB9hSprkyOpqTb7hgPjvnHUTezrXIfH8f+Kux0e8+HGEMvEAt
	Lo9Hdi9BS1gxbzkBDVQQIaLHw3iLeUDqwPz0j1lEi1nJGVZ0z0TnWmDDtzeCeJFK/fVjQ6AYo5B
	H9bfCWRtJs0/oFt20Hwym/zoHQqCeZq4uAgs8d4CG63y6s7M0/O7+yUtML7jsFVaobjcBcNiofd
	+QcAjN0yBseFsnDW5/lMjk/JuVXHRC3cCfwP9zczKwWY26XO8G4zg==
X-Received: by 2002:a05:690e:4881:10b0:677:ed83:7ef2 with SMTP id 956f58d0204a3-679362620bemr51250d50.72.1791496645626;
        Thu, 08 Oct 2026 14:57:25 -0700 (PDT)
Received: from toolbx (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-679356ef60fsm121969d50.21.2026.10.08.14.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 14:57:25 -0700 (PDT)
Date: Thu, 8 Oct 2026 16:57:22 -0500
From: Andrew Halaney <andrew@amutable.com>
To: bot+bpf-ci@kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com, 
	dhowells@redhat.com, jarkko@kernel.org, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, ebiggers@kernel.org, tytso@mit.edu, corbet@lwn.net, 
	skhan@linuxfoundation.org, rdunlap@infradead.org, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, 
	bpf@vger.kernel.org, fsverity@lists.linux.dev, linux-doc@vger.kernel.org, 
	brauner@kernel.org, martin.lau@kernel.org, eddyz87@gmail.com, 
	yonghong.song@linux.dev, mason@kernel.org, ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next v2 1/3] keys: add KEY_SPEC_DM_VERITY_KEYRING
Message-ID: <asgQxTE-6YtEgvYZ@toolbx>
References: <20261008-ajhalaney-dmverity-key-identifier-v2-1-008456d189cb@amutable.com>
 <910460850fd4163dadb804fbdf6c17f6a9dfec060f4d865a17df87336ea3e165@mail.kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <910460850fd4163dadb804fbdf6c17f6a9dfec060f4d865a17df87336ea3e165@mail.kernel.org>

On Thu, Oct 08, 2026 at 09:44:46PM +0000, bot+bpf-ci@kernel.org wrote:
> > keys: add KEY_SPEC_DM_VERITY_KEYRING
> 
> TL;DR: Design/uapi question: was David Howells' v1 suggestion (reserved
> negative key ID block, common register functions) intentionally dropped? The
> new uapi value -10 should be settled before release.
> 
> > diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
> > --- a/include/uapi/linux/keyctl.h
> > +++ b/include/uapi/linux/keyctl.h
> > @@ -25,6 +25,7 @@
> >  #define KEY_SPEC_REQKEY_AUTH_KEY	-7	/* - key ID for assumed request_key auth key */
> >  #define KEY_SPEC_REQUESTOR_KEYRING	-8	/* - key ID for request_key() dest keyring */
> >  #define KEY_SPEC_BPF_KEYRING		-9	/* - key ID for the BPF-specific keyring */
> > +#define KEY_SPEC_DM_VERITY_KEYRING	-10	/* - key ID for the .dm-verity keyring */
> 
> On v1, David Howells wrote:
> 
>   I have no particular objection to setting aside a block of negative key
>   IDs for special keyrings that need to be accessed a lot - though I would
>   make common reg/unreg functions that take the ID to be registered and,
>   say, set the block at -257..-512.  Moving the BFP keyring to -257 and
>   DM to -258.
> 
>   (<715249.1789718726@warthog.procyon.org.uk>)
> 
> The question of whether this was being asked for v2 was raised in reply, but
> there was no answer, and this version still continues the one-off -9/-10
> sequence with a dm-verity specific key_register_dm_verity_keyring() and
> dm_verity_keyring_lock.
> 
> Was the suggestion to use a reserved ID block with common register and
> unregister functions intentionally dropped, or should it still be addressed?
> 
> Since KEY_SPEC_DM_VERITY_KEYRING is a UAPI value, would it be possible to
> settle this before the -10 value is released?
> 

With the BPF keyring ID already being merged here in bpf-next, plus
Jarkko's feedback/RB, I continued following the current pattern instead of
walking back the BPF keyring ID, and dealing with the
builtin/module/rodata differences I alluded to that would make that
approach a little more annoying (at least with how I thought it thru).

> 
> ---
> AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
> See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md
> 
> CI run summary: https://github.com/kernel-patches/bpf/actions/runs/37844805282

