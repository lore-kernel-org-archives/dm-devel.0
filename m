Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017B3107B2
	for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 21:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713561121; cv=none; b=IyepNmykZ49+EWsndZXZ6d6OXxKfwe5Ox2xvpPeRS7A9l99ZF1auR89iLzaGjh+3an6Le2r0YOC5P/l8fpEA/rpLvUpIEHOStziFgWvLt0t5uEaE6FJ6ycRohwGpv0G2hWgwLFQJj9tBJTDIjVfcBN5g81OIvDC0waD2/6ywjtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713561121; c=relaxed/simple;
	bh=Ci26nmo8PtEi0S6i/YnrCgWmA0QTix1/C1LMrfhPqfQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=o6tVDL5DsxxzU9drQCg7E0uXfEQ4rrMwhqHriUHExxeDmyttUkn7EAfaXd+dzT9I3X30JLtL/BHJnBdS0ufNtY55BvUR7WOTolc6wyNmim+5T3H1UiVziekdTTLkCjOZswHFTIW2tyXGqEYqNOsHDc67DkKpW15M9s6/4z3akJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pb6dieyJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pb6dieyJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713561118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RXkjT1Oqh0EjNNEOMTmDYAjpMI7BNXVuukNVEccuuWY=;
	b=Pb6dieyJB60003q2HTThyIBglt5HV80GPWF1yXf4nJF1alXGRhc8uNSYuAeHlvJk/NM3tb
	fSq/BRYfTmGWrBfX8KUf5vg5+Sc5VQ2rDW78XPy2l3Ogt87+RBKnQdtKik78h0mJ32oeZ+
	BKRfEfaMN5/r8RLQ7qm0F0tXS0g5XcA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-npJFy6-GPzCg0w3fRjxmHA-1; Fri, 19 Apr 2024 17:11:55 -0400
X-MC-Unique: npJFy6-GPzCg0w3fRjxmHA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF4F71049BAD;
	Fri, 19 Apr 2024 21:11:54 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E653B1C060D0;
	Fri, 19 Apr 2024 21:11:54 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id CBAC930C2BF6; Fri, 19 Apr 2024 21:11:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id C7A663FB54;
	Fri, 19 Apr 2024 23:11:54 +0200 (CEST)
Date: Fri, 19 Apr 2024 23:11:54 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Zack Weinberg <zack@owlfolio.org>
cc: Alexander Monakov <amonakov@ispras.ru>, Paul Eggert <eggert@cs.ucla.edu>, 
    "H . J . Lu" <hjl.tools@gmail.com>, 
    GNU libc development <libc-alpha@sourceware.org>, 
    Zdenek Kabelac <zkabelac@redhat.com>, Ondrej Kozina <okozina@redhat.com>, 
    Milan Broz <gmazyland@gmail.com>, dm-devel@lists.linux.dev
Subject: Re: memcpy is leaking secret data through ZMM vector registers
In-Reply-To: <df151cf3-fb22-4465-81dc-34e0172a4fcb@app.fastmail.com>
Message-ID: <c5ac58cf-3e2e-3cc4-5a18-32c9acdef82d@redhat.com>
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com> <CAMe9rOoErR0xLqf4wLzk13XwTQY9-+cRAxDWKW9HU+rB0GApzQ@mail.gmail.com> <a995c5bd-8f80-2118-4d4-86e5e062a77@redhat.com> <CAMe9rOpz5Uft3MKXneYd3VqW1CaSXFF_GLBqKEZFiZsidKA43A@mail.gmail.com>
 <e35dccca-a1e7-93c4-f797-b89246877370@redhat.com> <9cefd07d-2940-4865-bd77-3dd0899a539f@cs.ucla.edu> <d387436c-8c35-4f51-bf49-dc02d829c73a@app.fastmail.com> <ae79e84e-5a69-dc3a-08da-ef03f6d17c34@ispras.ru> <a2369edc-7159-4f0d-8f89-9d41a79d7f7e@app.fastmail.com>
 <4f9517c-46e-367c-8891-e452d7983b67@redhat.com> <df151cf3-fb22-4465-81dc-34e0172a4fcb@app.fastmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 19 Apr 2024, Zack Weinberg wrote:

> On Fri, Apr 19, 2024, at 4:15 PM, Mikulas Patocka wrote:
> > On Fri, 19 Apr 2024, Zack Weinberg wrote:
> >> ... the copy
> >> of round_keys in the vector registers *won't* get erased -- the exact
> >> problem being discussed in this thread.
> >
> > On the SYSV ABI, all the vector registers are volatile, so you can erase 
> > them in explicit_bzero.
> >
> > On Windows 64-bit ABI, it is more problematic, because some of the vector 
> > registers must be preserved.
> 
> Oh, huh. Yes, that would work.

I've just realized that this wouldn't work - if the function 
explicit_bzero is lazily resolved, the dynamic linker would spill the 
vector registers to the stack prior to calling explicit_bzero.

> Call-preserved registers are not a 
> problem, because any function that puts secret data in a call-preserved 
> register in the first place, must erase it again (by restoring the old 
> value) before returning. Therefore, if we made explicit_bzero wipe *all* 
> the call-clobbered registers before returning, my example function would 
> be safe.
> 
> There's still a place secrets could leak to and not get erased, though: 
> register spill slots on the stack. Only the compiler could plug this 
> leak. Long term, I think what we want is something like 
> __attribute__((sensitive)), which can only be applied to variables with 
> automatic storage duration, and which means "erase all copies of this 
> variable's value, wherever they wound up, at the end of its lifetime." 
> Note that such variables must not be put in call-preserved registers in 
> non-leaf functions, because then they might get spilled to the stack by 
> a callee, which has no way of knowing that it's just leaked a secret. 
> And I suppose we might also want to worry about signal frames. Nobody 
> said this was gonna be easy ;-)
> 
> zw

Yes.

Another problem is varargs - if there is at least one floating point 
argument, the compiler will store 8 XMM registers on the stack regardless 
of whether they are used or not.

In the past it didn't do it (it made indirect jump based on the value in 
the %AL register to save only the used registers), but someone probably 
found out that indirect jumps are expensive and that storing all 8 
registers is faster.

Mikulas

