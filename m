Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8F134C818
	for <dm-devel@lists.linux.dev>; Fri,  6 Mar 2026 23:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772839847; cv=none; b=haY5BKgUDvhsOj9XNvQBLZ9O/odS0azRUX4ZCjxjmK9tCz1vGSy4Fy3AdYp61tfi0TlfJOe85xeB8gC7JumO+Vo9PPUZlgT1se1+bsbFR1gpTXIAa2SuAiw/vy1FVZcJFg7m8K9W456KCCStKRTvKIYhOm8QqbksE/bDfskmuMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772839847; c=relaxed/simple;
	bh=B8OXISIEZkPKglgcU/n7w9lHRbtSzcDoEZkN+H2EBXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=r/Sr+xlesmYP+y46dhMwieL3x3PHIIOLHws3XlmPpYEAbmj5vUige1nGoEEhFiO579r0ujdEDUJBjSMbL4Ew9OX8+GrWNf7iWxh/K0IHYrzQuIsrRkNpJ5rLVNhu8M3tJU6x1szY6V9ng8zlGawotMF6zA3HWnXuyAVUuJE9XYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eJzp/m3c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eJzp/m3c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772839845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IMuVqFdsOse2FIZd38PIpBrI2asQ3A9tWxkbvmRm7p8=;
	b=eJzp/m3cDYS9ux1oxQDXpSXdSQli602iLXK6SuArnzJnBm5GXCOsSSnwcFcB7ijNDeBcXD
	5H34EGVCmEa6GLChBdeqzmK70JnVu5g3AQuCNCM3LtVUW7u8hKO8lUOgQ+zmVnBEqGhpOQ
	hukJmY5eBE2nH2AvI08jSnrJVx4zYjg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-375-g2rnh3UCPxuGNuBG7OaqGA-1; Fri,
 06 Mar 2026 18:30:44 -0500
X-MC-Unique: g2rnh3UCPxuGNuBG7OaqGA-1
X-Mimecast-MFC-AGG-ID: g2rnh3UCPxuGNuBG7OaqGA_1772839843
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3FD291800365;
	Fri,  6 Mar 2026 23:30:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DCC391800361;
	Fri,  6 Mar 2026 23:30:42 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 626NUfJS2025875
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 6 Mar 2026 18:30:41 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 626NUfdD2025874;
	Fri, 6 Mar 2026 18:30:41 -0500
Date: Fri, 6 Mar 2026 18:30:41 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Brian Bunker <brian@purestorage.com>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 0/1] checkers: fix race in async TUR and ALUA result
 collection
Message-ID: <aatjoS5MGnXDqcfL@redhat.com>
References: <20260224010058.35337-1-brian@purestorage.com>
 <d9355e67dc64b7af940f6b8e6845d0f37565dd34.camel@suse.com>
 <aZ9ec_ce8dCCBzR0@redhat.com>
 <d223eb7cb4088d672b0312d929fa7d2c0e723875.camel@suse.com>
 <aaCVelI_vQZEBihM@redhat.com>
 <2ae78a2af1cc187a0cee9f0660e31fbd7cc79cd9.camel@suse.com>
 <CAHZQxyLzqG-N5jOOrODL-O+RRLmwHiNO1wSUGC=gvYpVkQTbnA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAHZQxyLzqG-N5jOOrODL-O+RRLmwHiNO1wSUGC=gvYpVkQTbnA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: A-7mZqWYpGanax4Gz2pi6IFnUTtdN1Fc4PYsmXJJbeQ_1772839843
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Mar 04, 2026 at 09:38:50AM -0800, Brian Bunker wrote:
> Ben and Martin,
> 
> Sorry for the delayed response. I sent this to you both initially instead of
> to the list because I thought you might have some insight into the issue.
> I have an 'alua' checker that I will post where I found this issue. I
> didn't actually
> find it in the 'tur' checker but I could see it is prone to the same
> issue. I have a
> test I created to show the issue called test_tur.c. I will send this
> too if it helps.

If you have a test that can trigger the issue you are seeing, that would
be really helpful it seeing what's going on here.

-Ben

> The problem when I didn't use this patch was that my checker the entire
> checker thread would stall. It didn't just correct itself. Until other
> paths failed
> the checker thread was deadlocked somehow.
> 
> In the 'tur' checker without this change, the 'running != 0' will lead
> to PATH_PENDING
> and MSG_TUR_RUNNING without looking at what those actual values are.
> It might actually
> be finished, but running hasn't changed to 0 yet, and ct->thread is not
> 0 on returning. I am not sure what extra conditions were true when my checker
> thread deadlocks, but with this change the deadlock never happens.
> 
> Thanks,
> Brian
> 
> On Fri, Feb 27, 2026 at 12:36 AM Martin Wilck <mwilck@suse.com> wrote:
> >
> > On Thu, 2026-02-26 at 13:48 -0500, Benjamin Marzinski wrote:
> > > On Wed, Feb 25, 2026 at 11:00:44PM +0100, Martin Wilck wrote:
> > > >
> > > > I'm still undecided if it's worth changing this code in order to
> > > > reinstate some paths 1s earlier in certain sitautions.
> > > >
> > > > Thoughts?
> > >
> > > I don't see any problems with this. But I also didn't see any real
> > > problems with Brian's version (although this version does remove most
> > > of
> > > my theoretic issues. Like I said before. If we hang in the condlog,
> > > we've got bigger problems than a stray checker thread). If we do
> > > this,
> > > we should probably document the uatomic_add_return() call,
> >
> > Of course, this was not an official patch submission, just an idea how
> > we might improve this code. It's not exactly the same thing; Brian's
> > patch meant simply ignoring ct->running, while mine would make the ct-
> > >running check reliable, albeit with changed semantics.
> >
> > >  or just use
> > > cmm_smp_mb() directly. But I still not sure what we get out of this,
> > > other than a very slight chance to finish the checker a second
> > > sooner.
> >
> > Yes. But it's also a fact that the simple atomic_read() test in the
> > current code isn't reliable. It can well return true when ct->running
> > has already been set to false. I guess the implementation tends to be
> > as light-weight as possible, avoiding a memory barrier (or taking a
> > lock with the side effect of a memory barrier) in the "fast path". That
> > comes with the price that we may miss an already finished checker
> > thread.
> >
> > > don't think that really makes a difference, but I don't really see
> > > much
> > > risk in the patch either, so I guess I'm fine either way.
> >
> > If the risk was truly zero, I would agree. But experience tells that
> > it's very easy to get these things wrong for corner cases, and I tend
> > to want to avoid even a minimal risk just for "very slight chance to
> > finish the checker a second sooner", as you've expressed it very
> > nicely.
> >
> > @Brian, feel free to try to convince us otherwise. It might be helpful
> > if we understood your use case better.
> >
> > Martin
> 
> 
> 
> -- 
> Brian Bunker
> PURE Storage, Inc.
> brian@purestorage.com

