Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64ACE13D891
	for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 12:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781352262; cv=none; b=lfOJXhYzbylzj3AnWIlIpDMVzUUDwHStLhd5CK6YfeOyv4JEf/GRMvLMYEabgwNSL0rsRhOdRLPjgEJSgT805jEBNXdDDUfU2J+L5AlW0+MBVtXkCHRVGiZgOBPBj4zySw6ow5zl0ER4uGVe//ePTALBKC+E9QqKaVE/io7BY+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781352262; c=relaxed/simple;
	bh=HHqD/ZMR6BCjCpA0JA1qH5zYY2UQoJx9Coz6SUpfiJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ciXmx5E3bM8UhE+dfbdwuwU/W4M2WCjitpq1pjQt5Yf3wbPY1gJz+Ch7YlaxQK0x/8eQAY8Fn4VvR6TPZbpw9rzGzADUXnIAdjW82LW8hqMrNmy2V9g5XG478ps/ES6ugQJYmvr/N+yA3z06Mcp9Di7pebayvlwuTZ0mc1DtdfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mKV649J8; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mKV649J8"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-45ef7720385so224432f8f.3
        for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 05:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781352260; x=1781957060; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m62+OgXmMnT1GfBieAqrtKMXEXmRpDXcfKx51aOoyG4=;
        b=mKV649J8sy2jj/C6fFuwHvXfTlkcN2NMdm5nL3R7XiMesJbzP1jTiT2ATh6lLDezpO
         /D2b8OquBiWPiNegabgr8YKOfLybL+tO/+lbQw6jtjrbFt9BRVpMVoLRSZTePJChfSK2
         mve4Up1LR3aWNMQofXg0ONTT/J+AxHDGeLPkPHZU6VNvi2mrrlPYbCFKwQD2uL2Jk2YR
         rBGxOPnSC3XjsRbjr5J4Jr2XMPtUFtg0iKKQZXDjSr0w2eqWeFFe9pWROHNzcP8ZzVET
         RJEycD7wmMENvmr8bi0EE5s+kZ9BAygCbtl9cEROoOQQhGMy5UxsGsz0M3ffKQYBrypP
         GraQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781352260; x=1781957060;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m62+OgXmMnT1GfBieAqrtKMXEXmRpDXcfKx51aOoyG4=;
        b=ot4uda+8s2ZcMf3LxwAHEsPk4dMvnPSDvQktTl9SZ2V8lP9PE5t4bqGotwkEG4s+dV
         2KbWJOAsN7DVVIuOhOVaN+AJDrwvMGtw+YurTDu5mKRagSrxCUzCZsilmINFZoEyu2u1
         zljlbqXU6DEJrTyYgUIhF2x2EH48yTbbkDsDvPbaPkBQwR7Z0M8VVYIhSTvBkdOSocgN
         EknGXVfDB0LgTuJEjM3Usrll8ibnNB+AvJ8zWyr7WncNuXtB02QvJVa9H8qXJCej5qDy
         gjDcsERJxhvKEiTzIzuTEjTOjH7iCR4GZhASxmnUZ6+EqdJJg5hGQ2GvbolGrAcQX2I0
         NpMg==
X-Forwarded-Encrypted: i=1; AFNElJ8/vNLJf9uD6g33OieKRIWnFHt9n7G5Pz6GaTaHHmSM44gsK6JTtQG6srtcvhn+VY4/1NjdWxRMcQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1ZE086D73OZ74bnps3DHvLkHE7+lyN/dCoie8tlieMwtZFelr
	bTs5nTWedtqavEshG0SK6lolnmLyUviqO5YOninkZ1dRerCvjHv1LPQ=
X-Gm-Gg: Acq92OESSjfJE80XMrbGs1BufGaCaM81cWfh/p7z8hRmzkJs3jmx+yRU7QP44K3Req5
	OT1gqLtREmryrdSbRHw7WHWPiAJXoPECgiLFB8sjPt2zSpsjtYdZbbuRC/V/z0OjirXj/KC4aAR
	sdoAmMMMBGXkXXQO7acKF6mZP6AsMTeSxnQuUh4VzffLSead1AgzJsECIfTbX2qWe7DvOq+08YL
	7Glv9A44YjkMAz3zTkI3j8EpqvgAmXRCEPhS/F18nznp76BVnLgVExODBBgjK60mB0j8c5c8P4f
	9FAOeVWmfIiIThPssFi0QpnRpCvHtqk5gjkrIRSMunvutnMubba6HuanEr/ljbwd5DIeSgEnenJ
	YI/UVE8KKzkLs6yjoMumEzxD6m2Y8x6vkzHqGzYqhd6aLZqbBnetoYr8Yj5wWWgm1gg7SNdo1T8
	HxC1VYC24n4cd7XN4677CepQ/zrW4kIVu3vBFafU1Ruhc8xf8e8OutSq5JQUHQfdPM
X-Received: by 2002:a05:6000:41cd:b0:45e:f378:fd77 with SMTP id ffacd0b85a97d-4606db9988dmr4743120f8f.4.1781352259601;
        Sat, 13 Jun 2026 05:04:19 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b0c10sm15204230f8f.21.2026.06.13.05.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jun 2026 05:04:19 -0700 (PDT)
Message-ID: <3219982c-58f9-4b04-b5a5-774ac61382ef@gmail.com>
Date: Sat, 13 Jun 2026 14:04:18 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] multipath-tools: fix mandoc errors in man pages
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20251010092211.57426-1-xose.vazquez@gmail.com>
 <0580f369a7102ae07aaa2c23fd4bd9165cbafd35.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <0580f369a7102ae07aaa2c23fd4bd9165cbafd35.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/25 1:20 PM, Martin Wilck wrote:

> On Fri, 2025-10-10 at 11:22 +0200, Xose Vazquez Perez wrote:
>> Output of: mandoc -W all -T lint man_page.X | grep -v "STYLE: input
>> text line longer than 80 bytes"
>>
>> mandoc: ./libmpathpersist/mpath_persistent_reserve_in.3:26:2:
>> WARNING: skipping paragraph macro: PP empty
>>
>> mandoc: ./libmpathpersist/mpath_persistent_reserve_out.3:26:2:
>> WARNING: skipping paragraph macro: PP empty
>>
>> mandoc: ./mpathpersist/mpathpersist.8.in:176:2: WARNING: skipping
>> paragraph macro: PP after SH
>> mandoc: ./mpathpersist/mpathpersist.8.in:219:2: WARNING: skipping
>> paragraph macro: PP after SH
>>
>> mandoc: ./multipath/multipath.conf.5.in:93:2: WARNING: skipping
>> paragraph macro: PP empty
>> mandoc: ./multipath/multipath.conf.5.in:134:2: ERROR: skipping end of
>> block that is not open: RE
>> mandoc: ./multipath/multipath.conf.5.in:134:2: WARNING: skipping
>> paragraph macro: br at the end of SH
>> mandoc: ./multipath/multipath.conf.5.in:135:2: WARNING: skipping
>> paragraph macro: PP empty
>> mandoc: ./multipath/multipath.conf.5.in:1311:2: ERROR: skipping end
>> of block that is not open: RE
>> mandoc: ./multipath/multipath.conf.5.in:1610:2: WARNING: skipping
>> paragraph macro: PP empty
>> mandoc: ./multipath/multipath.conf.5.in:1807:2: WARNING: skipping
>> paragraph macro: PP empty
>> mandoc: ./multipath/multipath.conf.5.in:2020:2: ERROR: skipping end
>> of block that is not open: RE
>>
>> mandoc: ./multipathd/multipathc.8:23:15: STYLE: whitespace at end of
>> input line
>>
>> mandoc: ./multipathd/multipathd.8.in:571:2: WARNING: skipping
>> paragraph macro: PP empty
>> mandoc: ./multipathd/multipathd.8.in:691:2: ERROR: skipping end of
>> block that is not open: RE
>>
>> Cc: Martin Wilck <mwilck@suse.com>
>> Cc: Benjamin Marzinski <bmarzins@redhat.com>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

> Are these just warnings, or does mandoc render our pages incorrectly or
> in a way that they aren't properly readable?
> 
> I confess that I haven't had a closer look at mandoc so far, which
> appears to be mostly a BSD thing. Are there any Linux distributions
> that have switched from man/groff to mandoc? I found [1], from which I
> gather that mandoc mostly support he mdoc format, which is not what our
> man pages are written in (ours are plain man): "... and only documents
> authored with mdoc are guaranteed to render consistently and correctly
> on BSD-derived platforms".
> 
> I tend to think that man/groff defines the standard that we adhere to.
> AFAICS groff does not spit out any warnings except for some long lines
> ("cannot adjust line"). Have you double-checked that the WARNINGS and
> ERRORs above are actually caused by errors in our pages (in the sense
> that our pages don't conform with the man document format)? If yes, I
> wonder why groff doesn't complain about them.
> 
> Anyway, while I believe keeping the man pages in good shape is
> important, we should agree on a single tool to do the syntax checking,
> and that tool should probably be groff.
> 
> I believe our man pages have more serious issues; for example, we use
> so deep indentation in multipath.conf.5 that the page is hardly
> readable on narrow terminals.
> 
> Martin
> 
> [1] https://unix.stackexchange.com/questions/391399/what-is-the-difference-between-the-mdoc-macro-set-for-troff-and-the-plain-man-ma


groff/man focus on rendering text, not auditing code. They are permissive
by design and handle invalid syntax more gracefully.

mandoc focuses on structure. It parses the code into an Abstract Syntax
Tree (AST) rather than just drawing text characters. That is why it is
stricter than groff/man.

I will address this and send the updates in a new patch series.
