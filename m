Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80713364925
	for <dm-devel@lists.linux.dev>; Wed, 20 May 2026 06:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779260120; cv=pass; b=tr0Z5ywNM2n+2U0Nb7X7LCcp/hCbUZqLY0dx9njQdHEgg635nPBGMAjrjdQIw7arbtU0ps327HXIbqNvEYF2rw7pCsOtw3tJBm9hCxT7PQwQKpTC/5PkLHCo2vQM7aF+m4hJtloOtn30HqMjyYz0IYdxkOEwW/v00QJDX2w5Hvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779260120; c=relaxed/simple;
	bh=NwuQ7e5mtimqzvGFAGbcHGA2NGnO6/nI/fFohyTGecQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dJPKiA1NhcICZkxJSJYrzRofabELi16zENDrc8B9WUrWvTvB6HmclYpmOK3fNCGBXNsvlGj0id4FRSDqUQEMsWhwR2RLVqFfHG4X5A+B/JOJQAhfDoSr01CjGviIQ/W0lDNpmjoKjcadbU/pfNZbaHDiUkrjOw9E3a7LzXC36sg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PYjSDG9Z; arc=pass smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PYjSDG9Z"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-44b330c5cc6so3231356f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 19 May 2026 23:55:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779260117; cv=none;
        d=google.com; s=arc-20240605;
        b=YCLg72YgYcjRqPLyKsDo4XK/Z7Hm5Gk011fpdCEomNBhdL2vvmSETUbRNt+LDumiRB
         BxQt+7XUK4WbrNBaYoO1ZssqPEB0+00j7M0aettXR7HIY0JdE+DvieE3kxkCPzegNpwy
         2Vja1U7tw/b/R+2O3Jt16lQ0UbPqHhZ4/11J+oLd6/2wVb8sJwDXGbyu37c/ub8SaOeB
         Aj47iQQ0PMH3Jrd9ogldImlEq4NCwJ8i3hRAppZS72UFiDT59x/XxBTVyvq3cPIAS8Ip
         agZwv9wGoZbCXUlJglX6vJKgbPZ739iUZfK4XgXls7EGo4CLDbzwrfUxVT+u2aWkvqua
         tH7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=NwuQ7e5mtimqzvGFAGbcHGA2NGnO6/nI/fFohyTGecQ=;
        fh=TvnaRtejXFXtD2BIaCJp2CRobOEZmkjlV2zhZHDVRUk=;
        b=NIsehKSkNKbTSeck6ctkwxlcVlPSmDTL84uC14kxVhPZ1Lk5usCrCn4BQSFvLJOM9H
         7XuFr9RgTqLouhwO4k7LkZv7kyy2iaTXUHyXe0rZkoYcM1XKwX5s6kv47tKuLSNdDXYR
         +LdCzFN/fMJpFIAX7QedqMFUrleMHbPfC6PDGSf3Olm4P8r52YqThXNu+hmx7Uz3LICi
         GQmyt3oFlPRvE+EqCWS/Yn5/7zTrgEMSXd53AcQH7etBeuSCjb+QimVXgMZoXbKYKXhh
         Ru3orFh9vJMEvETksP9Rrgia/SuCsPT5ImDiNbrcWj8KM7tNS9RdTPr2V47pK2mlLIXd
         r7oQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779260117; x=1779864917; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NwuQ7e5mtimqzvGFAGbcHGA2NGnO6/nI/fFohyTGecQ=;
        b=PYjSDG9Z3GHEmYBvB2KBxUxSrqlHDv2nvcmbypBxmDL6gQdFsQf/TyEqE+IEh2mPsv
         mXwJk/311B/cJBtjCJ6wL0c7AabmKsgRHvMePAfiJUzaYc5SDL1JZqCpjdikn9+rfbBj
         1A4oveOKh5PZRU9Qiq96VmfPFRQU9QFzN1/JlrUKvE/2xA+KGKu9V/h4GEo/PzS1cuxi
         M8tRi7utywkOid8jELK1ZnHQhg9SYmO7nzndyfC0cT0Y8t1eJ1ebnhh1ozfmgcYlS2Ak
         Kn+WBtUBvaumMHRS6012ms9R9OU1T8UgZasyHUij1C2Wi+l4a58WWMTbAUtAWVQrp6I0
         opkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779260117; x=1779864917;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NwuQ7e5mtimqzvGFAGbcHGA2NGnO6/nI/fFohyTGecQ=;
        b=sTxMFn8VFxymI6izqXb4S6S4dN/RirRg+i5T7lfiSHv05OlK1KkDjSanY+AmC2B1Ok
         MbgT0N//YioJLG0SXGNA/5yLfFMP8Et5xdKNI2O4/it11g9SrF0jZa49148BTtIB4/Fg
         4qROy1GQOonj7Y/xpVlA7n/Y2lIHv42IkQhj7wzN1WJxDkXdW4+Rjag3NRuHozhtBZEv
         NER6rMCr8SrdW3IdQbiygPnPN5tP8UIEGgLs3P7lt1lQIZGmym6YkGSRdJgxAFbuW0cr
         CGJqAykljz6uv7YcO9jBjr5cODN5pT6FwzQUwX6iZlpRLR0tW2HgtjBtTo4Kz8TlgBCZ
         7d3Q==
X-Gm-Message-State: AOJu0YybmiZLCkjBCfiJyQUDdffN2uvMU5eJMEXno71KmHZnENRrKmrM
	+rSWTjLhPZRNYnGPyaTzZZlASWtvtS4i6GXo3RDToZFHIQJOISzB+aR1tWn/glffO74Iq9B1N8G
	dU1/WGjhPIq1uSxU/wlpY8EvTFYVqwd43dPGM/6k=
X-Gm-Gg: Acq92OGgRvDb7Gdx+rzUU0UTVeaim7kzIJfYZh6gIl7GT1Z0JVafT5B8Iu7VsnwOl5q
	lvLbmzgM4hZnV27ZBbsLPyqjZCdy7pfk+jXPrZEo/OhTzL7vyD6gh1iggv7eQtMZg09vtG+WZJX
	zJAb0hzeFPUkD3hgi3N2iZ9g7B6DgD1uKDEaHcLmhAFgiwsW9x+ufBrJ+7J9NkOXrj/N/VJis8B
	KiXBu8orN7YRtfp0UedkuorSc77fgtNz+t3vMwv31b96G1T6bECbhEeTNLfigp9/f6FrZVLiw5k
	zZGG3eRDhLKRb5itnQ==
X-Received: by 2002:a05:6000:603:b0:43d:7c6c:a0dd with SMTP id
 ffacd0b85a97d-45e5c609a1dmr35982987f8f.35.1779260116657; Tue, 19 May 2026
 23:55:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260519094132.1964544-1-maoyixie.tju@gmail.com> <f46045af-5705-4c5e-98e8-80b8c2c5387e@redhat.com>
In-Reply-To: <f46045af-5705-4c5e-98e8-80b8c2c5387e@redhat.com>
From: Maoyi Xie <maoyixie.tju@gmail.com>
Date: Wed, 20 May 2026 14:55:04 +0800
X-Gm-Features: AVHnY4LkhMFJR3pUEGRVje88gWGjfYvgrl5jJRxYCxuj0M7Bhkohh9sxhIkLwI0
Message-ID: <CAHPEe=Ft=JeMSkGdKuN20uuLWpbzGTM-0-tWtoh0HJ4Nr1kDYg@mail.gmail.com>
Subject: Re: dm-vdo: iterator after loop end in mark_slab_journal_dirty?
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Matt,

Thanks for the careful read.

You are right about the post loop access. list_move_tail()
reads dirty_journal->dirty_entry. Container_of cancellation
lands that read on the head's .next field. The memory is
bounded and well defined. Calling this UB in my original mail
overstated the case. The practical impact is cosmetic. I
should not have framed it that way.

You are also right about the timeline. The Koschel 2022 sweep
predates dm-vdo. Citing it as a missed site was off the mark.
Sorry for that.

I will not pursue a [PATCH] for this site. The inline insertion
shape you suggested would be cleaner than the current code. But
I agree it does not warrant a standalone series in isolation.
If a future dm-vdo refactor touches this function for other
reasons, that would be the natural time to fold it in.

Thanks again, and sorry for the noise.

Maoyi Xie
https://maoyixie.com/
