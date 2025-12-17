Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3F3337BBD
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 17:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765993900; cv=none; b=Qbw4SJuLh8AIAnthiGLK+OvMb+Oh1tqJipUr03E53zu5SB9vGV5smVnemOyAYuJUfiDnx6rx3jjEjPNjBJnPl/s7C45gSlgY3HwPzUaGts51I/9stdLtE26fITunGIo2wIZ5H/nBubniFW/5CPGNZV0x2usaIAJO1N4Yryw+eic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765993900; c=relaxed/simple;
	bh=RCxp6y3XJ/hXVxOndc/GAG8xesvNhKJgedju7fzLXBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=guOPbkb+fIKUfgUAj+pgB4q7u494SRsRJing+MT1j43i2JoI6Vz9yfIddSuOvVchRbGQ7FiPkn1He1R1wJbNvtB0O64nYentqVS1cYB7mJQEv4s8MazUIZ9GIVhIGWTt6E3T+UdhrPVLjiMpffrB2RE2MZFl3LUQbfvsgDrlxhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J++82Mh+; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J++82Mh+"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a1462573caso3565ad.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 09:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765993889; x=1766598689; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZyTq6XmdfdDxSW4g2YrFks1A8iekcfCGj5INQxpHBvo=;
        b=J++82Mh+VU4Fq/UXH8B0qwZp5iZDjT0pCebBkVFOWKaNt/S/Ls/AgqjyLJyH1x4dKE
         E8p2ur9XGDWiIEUiCtBsyeSfvfxmp40zMvBhJeudVlBOjSlsAtokTSEUosNEq0ShXy57
         Ai/PVwZH/C+3DW8RAv7uqOJv6TP9FNUkDZI0zTvE4yZCjnBzZGWIhe8/5twAnD464pJQ
         n07GbdXG8AyHq7vIQljCCzb+REQ2QpT53gvr9LqBxVTMNxSbq21pNaiggOlr4sNA9BRD
         s+glBLOUfiN3ja5aBXDe+LNoywub+BQkXvbuYx16ztuiD6DL9FRV6OTRNoJJNJL86SAb
         WlZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765993889; x=1766598689;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZyTq6XmdfdDxSW4g2YrFks1A8iekcfCGj5INQxpHBvo=;
        b=FZSiog+jzd6u/tngkILRLCg9S099UJcjrV4o5vHyAdii+Iy+Fd/aCK2MlFgpsOJ7hh
         UBRLJcmIA1JEPXhIYzI4sGV5NXV2jzx50g1ScTKVJPVC42hOdDEE+0cl3kRnB2SohYv7
         ELawKQ9cXul25MdLkj/N1qppwgfnGFwTCj/3IcTyxAyPjEAN3kO4r6cwzUXumenE9kWP
         qWOSTyGOyiefWyTsxQpY2WAmuUu1+8SnGmbRSSxtONZzJfgqfkZWLfuCr9o2YkuBHgRc
         qYYqQaVWbTp/tNQ1Kr7cg1eN99Suq54B+L+UEa2mQfuBvy9m1p2z9HqPqFrVgekpKUBG
         RaTA==
X-Gm-Message-State: AOJu0Yw4YGt7mmHoY/OVd/wAs9mn9wy/8jWZcjLdiUQwIFPu9dRM/Vsf
	aZLZ5sWWuJX+ObnKdW4Hg4+7qvnus5Cb8PPBy3r3kXrpPR/h1vGifgvKOvYdhyFxhQ==
X-Gm-Gg: AY/fxX4jHKrM98duEOdeVl4Cx7N5p9yvB8xsaAKTZd9AL0/o8AsmrKuWzCiAd8yeENO
	aubdrhms5EA9lYlWvC2DE2m1hC1N9hf1XgAZHBcfjFSCMmVnwyiGkxrzK1W3LXffZj37Q+kkDSf
	ns4JNjj+ww4XH92HzZV6y/91ec9LCh4WKfB/VanMfGM/SGhY2SR/+7QaDavvux6omdGQFKDYHT9
	3fx6ddKNzT4BPuxVN05PmYD+eqfEcmRbDrtYf5XNRG5YMdVmdX8ai0m37uZ1NheMxNsy1ByKAJf
	Hu/bAONlxTemIYlOVrh/oxjvKDrKCXZQaQ0v8V46B+CseUPDKDd8DM3TOs9/U5n+iTLYBcQJmDT
	NTMK+5EA07lQULTSHL8yzWIIeEHL/Z0xY6tmc45VpL+Vlu0dOZa9HA9i0xVxa9QZP7ayXj1OXMb
	Q7VDPbpH9YPqgQGO7U9BOLfGpALpcKF7ToINPhIz7/OYL5O3dVUuwN1r8=
X-Google-Smtp-Source: AGHT+IFld/cVLkutGPIwFU6gTtgiNwrdStwKm/AuagaycEuqI9ldZygKeX4fyLGVXc23iyrCCgoS1A==
X-Received: by 2002:a17:903:b4c:b0:291:6858:ee60 with SMTP id d9443c01a7336-2a15f261df0mr3617535ad.4.1765993888769;
        Wed, 17 Dec 2025 09:51:28 -0800 (PST)
Received: from google.com (99.181.125.34.bc.googleusercontent.com. [34.125.181.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7fe12128ebdsm93892b3a.26.2025.12.17.09.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 09:51:28 -0800 (PST)
Date: Wed, 17 Dec 2025 17:51:23 +0000
From: Sami Tolvanen <samitolvanen@google.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Eran Messeri <eranm@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] dm-verity: allow REED_SOLOMON to be 'm' if DM_VERITY
 is 'm'
Message-ID: <20251217175123.GG2944334@google.com>
References: <20251216230614.51779-1-ebiggers@kernel.org>
 <20251216230614.51779-8-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216230614.51779-8-ebiggers@kernel.org>

On Tue, Dec 16, 2025 at 03:06:14PM -0800, Eric Biggers wrote:
> The dm-verity kconfig options make the common mistake of selecting a
> dependency from a bool "sub-option" rather than the main tristate
> option.  This unnecessarily forces the dependency to built-in ('y').
> 
> Fix this by moving the selections of REED_SOLOMON and REED_SOLOMON_DEC8
> into DM_VERITY, conditional on DM_VERITY_FEC.
> 
> This allows REED_SOLOMON to be 'm' if DM_VERITY is 'm'.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
