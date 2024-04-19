Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C0177F13
	for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 19:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713553442; cv=none; b=VzlCDxFwWQUp7tr5PgFlNL29UCTabf6S0Jdi33FHgIuLuBuk0EOE1WZ2FqRmROJt/spAXI1EYZCH8A3jIE/gTkldbWBkkpI1peAkYanUJ6lEpTf9PT9zpZmQl+x1rp9oewFY0ZeCGnaTj/BAhkC1Fe4/80n5+swv1ynvC9zHIC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713553442; c=relaxed/simple;
	bh=/mYbQFlur/LVTaT4mUviMzGm4tUBX2MifNBrliGgSVo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rmE+6XsbsBDkxTWlDjtbKtGAAqQVjIxYgFrZyXYAGbs+FFgxCnZ2qfg1ebg77Nrio/A77p4zz9MwbHRN+imAtqHJ73RHOZ/+a+J5rcEFFUVsB4btIEP7gzI445rVkqiEsuxmgVkZr53fAqfiBGzDaO2+b3tp0wTy6ezk7oq57/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=B2tqP/9d; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="B2tqP/9d"
Received: from [10.10.3.121] (unknown [10.10.3.121])
	by mail.ispras.ru (Postfix) with ESMTPS id AF65940AE01D;
	Fri, 19 Apr 2024 18:53:50 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru AF65940AE01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1713552830;
	bh=+26rAlNH7806Muus6XqPTlkD0tDo3WK75k13DvaF7gQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=B2tqP/9dFizaIOFLhP8C/oYYAhHdaMB/Vr5tWExlMGq/1k8ogdHzqDEUaBkngThiS
	 MCuEVjI8TET+Yt/3Y8d2AVA3s288JgtFuPia3LaUDFnR3YUegFqzrF/4akxXiHoXfn
	 m/19pvzqR342JALiHd98moVqsbxNtkQfwI0tnbqw=
Date: Fri, 19 Apr 2024 21:53:50 +0300 (MSK)
From: Alexander Monakov <amonakov@ispras.ru>
To: Zack Weinberg <zack@owlfolio.org>
cc: Paul Eggert <eggert@cs.ucla.edu>, Mikulas Patocka <mpatocka@redhat.com>, 
    "H . J . Lu" <hjl.tools@gmail.com>, 
    GNU libc development <libc-alpha@sourceware.org>, 
    Zdenek Kabelac <zkabelac@redhat.com>, Ondrej Kozina <okozina@redhat.com>, 
    Milan Broz <gmazyland@gmail.com>, dm-devel@lists.linux.dev
Subject: Re: memcpy is leaking secret data through ZMM vector registers
In-Reply-To: <d387436c-8c35-4f51-bf49-dc02d829c73a@app.fastmail.com>
Message-ID: <ae79e84e-5a69-dc3a-08da-ef03f6d17c34@ispras.ru>
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com> <CAMe9rOoErR0xLqf4wLzk13XwTQY9-+cRAxDWKW9HU+rB0GApzQ@mail.gmail.com> <a995c5bd-8f80-2118-4d4-86e5e062a77@redhat.com> <CAMe9rOpz5Uft3MKXneYd3VqW1CaSXFF_GLBqKEZFiZsidKA43A@mail.gmail.com>
 <e35dccca-a1e7-93c4-f797-b89246877370@redhat.com> <9cefd07d-2940-4865-bd77-3dd0899a539f@cs.ucla.edu> <d387436c-8c35-4f51-bf49-dc02d829c73a@app.fastmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Fri, 19 Apr 2024, Zack Weinberg wrote:

> On Fri, Apr 19, 2024, at 2:45 PM, Paul Eggert wrote:
> > On 4/19/24 11:04, Mikulas Patocka wrote:
> >> There's already "explicit_bzero", so maybe we could add
> >> "explicit_memcpy"
> >
> > Where would this stop? Wouldn't we also need explicit_memcmp, 
> > explicit_memmove, explicit_mempcpy, etc.? Pretty much any function that 
> > looks at memory could have the problem. Even C source code that doesn't 
> > invoke any C library function could have the problem.
> 
> As I recall, one of the arguments for _not_ adding explicit_bzero to glibc
> was that we couldn't guarantee copies of the secret data wouldn't hang
> around in registers.

bzero and memset have no reason to read data from memory, they only need
to overwrite that memory. This makes them different from memcpy.

In the caller of memset/memcpy, sure, copies of that data may be present
on registers.

> Is a hypothetical function __attribute__((clear_call_clobbered_regs_on_exit))
> what we need here instead, maybe?

As indicated upthread, there's a non-hypothetical
__attribute__((zero_call_used_regs)), unless you mean something else?

Alexander
