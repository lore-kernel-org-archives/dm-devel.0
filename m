Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C53288CC
	for <dm-devel@lists.linux.dev>; Fri, 11 Jul 2025 21:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752268119; cv=none; b=AOUbanPG81ALfzdgen9a6fDLy547OgQaCpdacA4LAyipQmdIdTQjVrALG29d1MJUMAFXKboTFT8Gn1tc2Y5CbL00EjwdoVtSwM1iVSPz6304QOrWwvj+y+E8/cc2kGUs7GuyFavqYuGOUFRi8La358vY0SOf/HD4gr0FRd50W6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752268119; c=relaxed/simple;
	bh=R8EmTi5WKLW5VbVxCkpNmDMPAE7ad6OIII9O1vml/7o=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=CXHuXUlDsLT390S5hsEmjXz/KpkhC3BXdiHjENHJxRBHdrykMTdRGKrU5pJy70WK09STATHqAFez/1OIxPqZ9CbsvEhvH5M6pBiieOBpzhEUKPLTIPCoBfOMAjjLvnkUQgucDa9U3O3icb8nZ4rZC5up7bmqbkbJJx3xkzAT7R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ss7iw87V; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ss7iw87V"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ab3855fca3so128911cf.1
        for <dm-devel@lists.linux.dev>; Fri, 11 Jul 2025 14:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752268117; x=1752872917; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sohUOMgMyq9VrSNAQz2+G9XEfK1yeGhFOU613orpuJU=;
        b=ss7iw87Vs8IMpKYGKBiGC8RW0xvx+O+msgRMnGr/43ZAU+LtD4+ACWUGs8pXKuuP+P
         NHOTTIfyjCtSjDoz0zwaP7QMf50hEEvqmZeXQEE1OJPYafZS8+qHnh6r0gnQAGXdLkQl
         5/iuc1A+KghC8f9iZrxQfbDc+rQ5SG81p22WkOYKCvPi/n6s6oA/RDBrpehVDXzFbErm
         2QXCghZK+JMnuwNbyhrf0a9pz3ABvfO/9IIpmps0zgwmkUw3tS24xObGwfift8wnmOHz
         GJ40IcSEQEvXhcE/WA4U1XKZ8h+q8gq9BoyZ8r228a5NXKdM+X7WiGXPOrcD6lY/RGad
         X4/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752268117; x=1752872917;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sohUOMgMyq9VrSNAQz2+G9XEfK1yeGhFOU613orpuJU=;
        b=aZuRLmrz5f1i0j0OUNVXC7/ryba6HaQ3XL4gOWl8prMPO1HCa+C7CZ7ODqGRrbrp8V
         e/0n3s+V72yGep8zBY+q88tEnWRaxtp9lWlQAdgGz0d95GpZc5LX/Yv0W1RmRbfQEyny
         uled4gpBOhj7Gmc3CLpumRJxEiYXPz0pFqqvClv0bg1fU8KYvrqKVnNi8blyiVPiX2E1
         xlYHshRf2AJvGwQtFojSiaWXn7f6clMg4xEEjIvNE2GjXBg8SCePsgvQM2yWowZYEWBT
         UFRGIJEmDM+m0z/dAw3C/8CWhi+EAqbhGMRpH0d9/l7VJ3iw8Urw/8m+am/zkRjgEpx9
         DWRw==
X-Gm-Message-State: AOJu0Yzf4LPqMyDP3FawsJBx+PiPugdDDXMJp29HbCr0URW/MT1eyVOp
	rB3swMQ0zZHuijIwRy9mVZgXq+OlqHMpWTuxYIhBLS4SgpVmPzvdUU7lxHhsstbYYvD5xA+rZmn
	ln6e1PUyaaIpq5xxEuOfK2bsqOxfaETyRiPTCqQmKgy7OLCsBT4+DeFbdScI=
X-Gm-Gg: ASbGncsYxLzDhIxGahi1GGMnJ1e1mY1PSMYuVy1v0DMXqqed53r5jF/Ki0YZNp08QNj
	ygwHtniQYK87Fgm7dR7ePxc0K0UnxkdSPxEWSW05tiB3cREZ/ligVrEfIUwoluNg1ix0P88ja4Z
	UBYByq06aT0sq+gTZ7fBnafXm1VLZiaYj3R8Wwlsy4SKUH//WSMcfPFK1C53N39COu4GVUZHIR+
	+mBEw+BtZaDZXhM2ygQD8e+S6xDmlzBJ2X1Ib6Lo1Oro4Vr
X-Google-Smtp-Source: AGHT+IHAxu6061I/iyuK2OgeWgYStqm2yL4Cgx3UqBA9z7Z32CZ43IzuZLkL/41ALNRAgD1rJJ9dye9Bj8nj1nhnXgs=
X-Received: by 2002:ac8:7d16:0:b0:4a9:a4ef:35d3 with SMTP id
 d75a77b69052e-4ab544e9bd9mr100551cf.7.1752268116289; Fri, 11 Jul 2025
 14:08:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Robert Pang <robertpang@google.com>
Date: Fri, 11 Jul 2025 14:08:24 -0700
X-Gm-Features: Ac12FXzWx1oistnClZn_60CAXPUdQyaum9iAVD-qbQSg9Qixb-wgb9Z9d_WGakw
Message-ID: <CAJhEC06nnd5kMSqkP8P_WoXOE1doMryt7R8JYpsm77bS6NF53A@mail.gmail.com>
Subject: Question about dm-cache promotion decision in dm-cache-policy-smq.c
 (commit b29d498)
To: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Here's a rewritten version of your email, aiming for clarity,
conciseness, and a professional tone:

Subject: Question about dm-cache promotion decision in dm-cache-policy-smq.c
Hi,

I'm currently investigating how dm-cache makes promotion decisions and
have a question regarding a specific line in the
update_promote_levels() function within dm-cache-policy-smq.c.

Specifically, I'm looking at line [1] in the code snippet below:

static void update_promote_levels(struct smq_policy *mq)
{
  /*
  * If there are unused cache entries then we want to be really
  * eager to promote.
  */
  unsigned int threshold_level = allocator_empty(&mq->cache_alloc) ?
  default_promote_level(mq) : (NR_HOTSPOT_LEVELS / 2u);

  /* line [1] */
  threshold_level = max(threshold_level, NR_HOTSPOT_LEVELS);
  ...

  mq->read_promote_level = NR_HOTSPOT_LEVELS - threshold_level;
  mq->write_promote_level = (NR_HOTSPOT_LEVELS - threshold_level);
}

My understanding is that NR_HOTSPOT_LEVELS is defined as 64, and
default_promote_level() returns a value between 1 and 8. If this is
correct, then threshold_level (before line [1]) would always be less
than or equal to NR_HOTSPOT_LEVELS (e.g., 8 or 32). Consequently,
max(threshold_level, NR_HOTSPOT_LEVELS) would always evaluate to
NR_HOTSPOT_LEVELS, effectively setting threshold_level to 64
regardless of its initial calculation.

I've traced line [1] back to commit b29d498 ("dm cache: significant
rework to leverage dm-bio-prison-v2") [2]. It seems like the line's
purpose is to cap threshold_level to prevent underflow in the
subsequent subtractions for read_promote_level and
write_promote_level.

Given this intended purpose and the typical behavior of min() and
max() functions, shouldn't line [1] instead be:

  threshold_level = min(threshold_level, NR_HOTSPOT_LEVELS);

This would ensure threshold_level doesn't exceed NR_HOTSPOT_LEVELS,
while still allowing its initial calculated value to be used if it's
lower.

Could someone please clarify if my interpretation of this logic is
correct, or if I'm missing something?

Best regards
Robert Pang

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/md/dm-cache-policy-smq.c#n1057
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b29d498
