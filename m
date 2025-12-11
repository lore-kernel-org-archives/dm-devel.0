Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F5E31A04D
	for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 17:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765475803; cv=none; b=KiVp2nF/BtYQ0vMHBwn8HTw9YOwrBi3CDQJkYlF2V47P+H1f7R3w38gnA59z2Ef3GdxKuJtOkTCAzyRzWFws0DgwcMmiXq+3xvzVbT1les5aIZapP8dBWWU/7mUqdPlZA3BWMrtu/o0GLD55LsdAXHTEjThcl2JjCiUqm7pyHPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765475803; c=relaxed/simple;
	bh=8HF8NcAQzBbdtusDNUq6UuPvAv7d6PKkG8QVyYqw3os=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mWEI8MlARjWiWWlCNJhQTgXXvoZZlJJdHFHI8Wik5qIi4p6HHla2fK4bE3b6mzV1WFiWsFoRqxs1LIgraDPBjOkVqZEoWm/FetpwKpduThGJ6Stlu+vQ2ANyqjC/kFQSC7EXfBdJZIEArjq/fFnjZ8L1AHdVAg0VjdldYU+HneI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FSr2UaBX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FSr2UaBX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765475801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zmsUSn/eoNtP1PF5OTtBkIAS9kb6ss+J+NGd5zfxkyY=;
	b=FSr2UaBXnW49wnwZ2HDtChSJacfVEGpEEeXJvDiORCYlUcJTsdsO0P/Popewe3+OgE4XL7
	3tXEpT3+FS8uRTk03jrYTqq7T0WW4uNj9YNVbFFL2o/yrhG1w1QMNcBapz9WPf8OA/mvEm
	Nio3r/dl/Uu/ESTf3h+O5wtk4KOaBd4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-9kMWcC9lO1KK1mbSyOyC8g-1; Thu,
 11 Dec 2025 12:56:38 -0500
X-MC-Unique: 9kMWcC9lO1KK1mbSyOyC8g-1
X-Mimecast-MFC-AGG-ID: 9kMWcC9lO1KK1mbSyOyC8g_1765475797
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B934619560B9;
	Thu, 11 Dec 2025 17:56:36 +0000 (UTC)
Received: from [10.44.32.23] (unknown [10.44.32.23])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1EA69180044F;
	Thu, 11 Dec 2025 17:56:34 +0000 (UTC)
Date: Thu, 11 Dec 2025 18:56:28 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev
Subject: Re: [git pull] device mapper changes for 6.19
In-Reply-To: <CAHk-=wjkgKyDHDpXJR7_fQ3AT3gohukyAGuxqOCU1yyiRradHw@mail.gmail.com>
Message-ID: <b9a10a71-92a3-8e47-b842-46a30b1af82e@redhat.com>
References: <2b7fa07e-cf1c-73a7-d1eb-5d6082e08b29@redhat.com> <CAHk-=wi4ckGEFjHhMHcSoWidgd+URdorcdt5KCP6rQvP_DDS5g@mail.gmail.com> <CAHk-=wjkgKyDHDpXJR7_fQ3AT3gohukyAGuxqOCU1yyiRradHw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ANFVwwKjZYwuvGsK1Ua7m-dYEkD8XxFoh3FsrUPVB1I_1765475797
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 11 Dec 2025, Linus Torvalds wrote:

> On Thu, 11 Dec 2025 at 09:11, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > This pull request came in late, and doesn't have a proper explanation,
> > so I'm less than thrilled.
> >
> > Get me a proper explanation of what has been going on.
> 
> The code has also been recently rebased for some unknown reason that
> isn't explained

I rebased it just before sending it because the kernel test robot found 
grammatical errors in two commit messages.

> I've pulled it, and written a better explanation for it all, but you
> are now officially on my shit-list.
> 
> That means that next merge window, if you don't do things properly and
> in a timely manner, I'm just not bothering to pull. Because this is
> *not* how pull requests are supposed to be done in the kernel.
> 
> The two-week merge window is *not* for random unexplained late development.
> 
> The two weeks are for *merging*, not for "oh, I have time to rebase
> code that wasn't ready, but I don't have time to explain any of it".
> 
>                    Linus

What's your preferred time frame for submitting the device mapper pull 
request? One week since the merge window starts? Or less than one week?

Mikulas

