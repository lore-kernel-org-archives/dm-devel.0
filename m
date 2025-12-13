Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF06B289824
	for <dm-devel@lists.linux.dev>; Sat, 13 Dec 2025 15:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765640622; cv=none; b=mjLA5MtjNJ/SR9KLCgEEqsJgY8j13bn88yIxXTIIAjZK7YjzrQYuXsSZl9AXSLatqvIsNfS5cwJovuUEYd5xOnpHJ8jniCtJtwCcQuvKz1hIE+OlZyJw3BY0anFHZkAPKrM69FTY1MiHrswLj8CwsBP0lCAPSw+oOJ67oRTz150=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765640622; c=relaxed/simple;
	bh=k4ARQ+3QHbrUzqSiYdX5x2KQtRGgFHDLixhNg2iE+lA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fbIP6vOzTl0JG9X7u0UXfIKH1KKHv6OT+CrqLiaLAdqC5UWrOVrdUbUFLLFKEI2pUmeJfy6p50r/JSM/csPRxJVF4HSdGoFnlAQvcUoS5MZjP4+xJQGMXtIfNr6SW5j0faUIv4YqQY7LeWH1MmPW8uV00gJ+x3OVdHaQZB7RUFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B+GQ14/z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B+GQ14/z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765640619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=csA6PLTjRpBKe91s7i0iv/DIb7BGndRXTYeORxG/yL0=;
	b=B+GQ14/zBnAHbK1G2ioZR3JPVZ+4bT4e/YWxOPCY/uEOUQdqGwQ6j2DCHzomILQWgH89zv
	3ECmc+ieqVM7QXg27B6dQRyA4wdEoDtloSd8baDvR8kx0ENAbzrTATUNZSaxNkG2MZ/qIe
	i/1mGK1XOnluiQGne962woVCwyLa+5A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-uT2pk6A4OaCC9DD7seyOzg-1; Sat,
 13 Dec 2025 10:43:38 -0500
X-MC-Unique: uT2pk6A4OaCC9DD7seyOzg-1
X-Mimecast-MFC-AGG-ID: uT2pk6A4OaCC9DD7seyOzg_1765640617
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2DBD91956080;
	Sat, 13 Dec 2025 15:43:37 +0000 (UTC)
Received: from [10.44.32.23] (unknown [10.44.32.23])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A7A81956056;
	Sat, 13 Dec 2025 15:43:35 +0000 (UTC)
Date: Sat, 13 Dec 2025 16:43:32 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev
Subject: Re: [git pull] device mapper changes for 6.19
In-Reply-To: <CAHk-=wh-LQTLhD-vOqHfhb3cyust1aeU4UPmTyGkaD5kgDFLzg@mail.gmail.com>
Message-ID: <8d72105c-465e-b10b-1c9c-9bf5f69f6a66@redhat.com>
References: <2b7fa07e-cf1c-73a7-d1eb-5d6082e08b29@redhat.com> <CAHk-=wi4ckGEFjHhMHcSoWidgd+URdorcdt5KCP6rQvP_DDS5g@mail.gmail.com> <CAHk-=wjkgKyDHDpXJR7_fQ3AT3gohukyAGuxqOCU1yyiRradHw@mail.gmail.com> <b9a10a71-92a3-8e47-b842-46a30b1af82e@redhat.com>
 <CAHk-=wh-LQTLhD-vOqHfhb3cyust1aeU4UPmTyGkaD5kgDFLzg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vCDS94zRO6x90CPdQPYDbmRM9KW4rDmqbc5uFmQElCk_1765640617
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Sat, 13 Dec 2025, Linus Torvalds wrote:

> On Fri, 12 Dec 2025 at 05:56, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > I rebased it just before sending it because the kernel test robot found
> > grammatical errors in two commit messages.
> 
> That really isn't a strong enough reason to then rebase things late.
> 
> Rebasing is for *important* things, or for early development. Not for
> the merge window, or at least not without explaining why the tree
> contains a lot of very recent changes.
> 
> > What's your preferred time frame for submitting the device mapper pull
> > request? One week since the merge window starts? Or less than one week?
> 
> The code should be ready *BEFORE* the merge window starts. Not "one
> week after". Not one *HOUR* after.
> 
> Lots of people send me their pull requests the week before. This time
> around I had something like 35 pull requests ready to go for the merge
> window in my inbox when I released 3.18.
> 
> Other people wait for the actual release, so then on the first Monday
> of the merge window that number had roughly doubled, and that's fairly
> normal.
> 
> Does it *have* to come in that early? No. We have two weeks partly to
> be able to be flexible. But those two weeks are *not* for development.
> 
> They are for me and "it takes time to merge", and they are for other
> developers for "my goldfish ate my favorite stick bug, and now I'm
> devastated and an emotional wreck, and it took me some time to get
> over it".
> 
> So people have other things going on in their lives than just kernel
> development, and two weeks gives some buffer for that.
> 
> And sometimes there's some trees that have dependencies where there's
> a few "I need to go after that other tree" kinds of things, and the
> two weeks gives some flexibility in that sense.
> 
> That last case used to be particularly true back when Andrew Morton
> didn't use git, so his series depended on other peoples git trees and
> couldn't use stable git branches where two or more trees shared some
> common history.
> 
> But even with all those reasons for two weeks, the merge window is for
> things that were ready *before* the merge window started.
> 
> Sure, late commits happen because maybe there were fixes that still
> came in and people notice them and want to deal with fixes asap,  and
> there might be a "one more thing" there, but the merge window is NOT
> for new development.
> 
> And not for random late rebases that aren't explained. When I see lots
> of recent commits, that just makes me go "what the heck happened
> here?" exactly because that should *not* be happening. It should have
> been ready to go.
> 
> And as always - you can *explain* things. The merge message should
> have explanations for what the pull contains, but there can also be
> notes about why something was slightly off. Like explaining why some
> unusual late rebase happened.
> 
> But note the "unusual". It shouldn't be the pattern.
> 
> Basically, if a pull request comes in during the second week, you
> should have a *reason* for it that you also explain. If it's too
> personal to explain in public, feel free to just send me a separate
> private email.
> 
> Things happen. We have rules, but at the same time very few rules are
> black and white. Kernel development is supposed to be pretty flexible
> - outside of the "no regression" rules, pretty much all other rules
> can be bent.
> 
> But when the rules are bent, they should at least be explained.
> 
>             Linus

OK.

I will send the pull request sooner next time and I'll defer patches that 
come during the merge window.

Mikulas

