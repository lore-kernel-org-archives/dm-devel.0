Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A9543AA3
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 16:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718123294; cv=none; b=UvxmFQy1Tt6hH5HEZ4dVVAAZB46lufb4wftCaQhChgQstcvARi4BkaFw5LuPiQsZntsWM+wMfC3TXF2uS76992+3RVt1UmCWp9gIJpFiYqbTJDOhIZe1CkzZ2SvbXMcO6EGtQmycEMOXUUO58ctRTRl59hRR05663aWeoRAUa9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718123294; c=relaxed/simple;
	bh=N4evEqm5Lsj9muDRZ0FKGlEsgvOKjl0qugGTleH/ab8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bXYkniy54JewNoTMk8fZIJd5EKBV1NPWsWYWwecr6YqL8RupipFJlVzZGTOmP/z9d85Py0CXksYuwboZsPJILYQ+sLIXCkZLtpNvPt8e231if1jhwNKBq7ydl7a8LeGGPYD8nUFmWx81MgASAHgBC4RqioIXrRqXsGWo4+DQPqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qohxpE05; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qohxpE05"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3d226c5a157so1671192b6e.2
        for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 09:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718123292; x=1718728092; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BG7XPsDBrgukiLlYYahx3Tk9saQ0mEeAf77iSA+2xAk=;
        b=qohxpE052TXJjsmcMVpwSmZ2pvvzd3GWiJQJWO9n95V/ccHoPIeNtP0b7j59sPbIb4
         OyhOPq3MJRBzxiCvwI4HpWq4v8HQCEmgaCUFTJBR3wMh7R1uJ21tk1To+pFJEdKAPkrf
         vA3sMzR5Iv+G99bwTJ8gA/LPIJRmVoG3iMw8acPY5HOGhnkajTXJVR05k0OHo8XNrqcI
         m4AbTx9pNnMJDAsZqYBnHdZIefN1R8KDihp7xti0kd1E/p1MHIKCy8CDeGGbNg6Xa2Ok
         mgt1FPUetHM8TqPCxFS9X3vumkHcnQdfMhuATcuay/Kh6ECsFPOBU8MuXCAfvFFW01/w
         8f9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718123292; x=1718728092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BG7XPsDBrgukiLlYYahx3Tk9saQ0mEeAf77iSA+2xAk=;
        b=W4yD3wRqgnyZlRc23rLC68JgWMIgAnl1ko1zL44o0B9h5vy1/tdyM5atGEBKEBK4Mn
         pmji2g0CCIgJ51TCzt/oAEXBavcGWVJqGbCKdIUKKml+mJ3cvPW0/D3fydeDe8iV9Tv7
         JktsTJATQwOafO2jJl3jBtbUBPYYrsCCQZ4enFB6QFS1kc3XrKJ4Fcq+hxAWd2aH/1Pt
         oIbWhtapufu7UaUjdDqrlfA2cJ9K2IMtJmcRcw4PcAp+jBAmaSuZu9T4hOj0F6UhB6iA
         iym398Nc8UMjH+b3M7/+eOtqtHtINZU1UWKuiCFpLBx1dKRz41j2zVBM8xkHMDr0/0tL
         4RWA==
X-Forwarded-Encrypted: i=1; AJvYcCWTQitNgungNuu8GTmS0/IH2eD9OYqSsccQSeMXM36cwLOivcPyP5tOG9atI8ZYfXe5lb0sF9rRsl9IiqdGGZ+bVp6+9KROZtQ=
X-Gm-Message-State: AOJu0YyljI9qdv0vq5OvTsWNpnGF68M8yUSuMq3KGWOz35tUqzIlqMWi
	g2qOjjTcSY7k1XAukW40jA3jjZgL8FrVUYds5IdUxPZLJCRLSPVcI2N0SdXBvEVLIrZPRNccAAX
	k1AWnKXrpp/svFFQTsXi4IpoerKpw29wJwsXf
X-Google-Smtp-Source: AGHT+IGsoxkLL97yYbUdTS+m9HxBL/aA7VS6tK+dAweHiy1stwZYh0uBGwlgxKNC988k8KBFPrrE/j5bFzDX0CXaftQ=
X-Received: by 2002:a05:6808:2183:b0:3d2:1f88:3e86 with SMTP id
 5614622812f47-3d21f88455amr12786369b6e.37.1718123292024; Tue, 11 Jun 2024
 09:28:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240611034822.36603-1-ebiggers@kernel.org>
In-Reply-To: <20240611034822.36603-1-ebiggers@kernel.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 11 Jun 2024 09:27:32 -0700
Message-ID: <CABCJKuf-yUQVh_gpO80qbifGyonQYDC-=QxL+PPwUzprXqQBUw@mail.gmail.com>
Subject: Re: [PATCH v5 00/15] Optimize dm-verity and fsverity using
 multibuffer hashing
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev, 
	dm-devel@lists.linux.dev, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Mon, Jun 10, 2024 at 8:49=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On many modern CPUs, it is possible to compute the SHA-256 hash of two
> equal-length messages in about the same time as a single message, if all
> the instructions are interleaved.  This is because each SHA-256 (and
> also most other cryptographic hash functions) is inherently serialized
> and therefore can't always take advantage of the CPU's full throughput.
>
> An earlier attempt to support multibuffer hashing in Linux was based
> around the ahash API.  That approach had some major issues, as does the
> alternative ahash-based approach proposed by Herbert (see my response at
> https://lore.kernel.org/linux-crypto/20240610164258.GA3269@sol.localdomai=
n/).
> This patchset instead takes a much simpler approach of just adding a
> synchronous API for hashing equal-length messages.
>
> This works well for dm-verity and fsverity, which use Merkle trees and
> therefore hash large numbers of equal-length messages.

Thank you for continuing to work on this! Improving dm-verity
performance is a high priority for Android, and this patch series
shows very promising results. FWIW, I would like to see this merged
upstream, and any ahash improvements handled in follow-up patches. For
the series:

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
