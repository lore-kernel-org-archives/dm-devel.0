Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFB530E846
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 17:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765993670; cv=none; b=EDhvHTWNlVAO8yCQxmUaXUPFIXjq7UeIUl+4wlB80CyFvFnsyRkivbyIhdG3HXeZCuY3SeHKejQYG5CwX7JSZ9izWJ0QSPEATh+qrEtSVW2DSE/LDhj/MyFvvJApNH0unzGVTdUXpWdeqKaRbqmr0LadnWcteiCubCwd1pcnw7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765993670; c=relaxed/simple;
	bh=GgCzxs6yCCjo4n8lCt7m+gPC5leWE2dj0HndVAgMrwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gkdx6hZVzvYAVzjWH3RcjTpwXRbOF7tKUl1zb8DOMl6EJnCsS1t5UtgMbKMdmldxiNyAczC6F7Hm1psaDFP++V2K2EOYCJoCH1o1HoMPKfEriGzgauzKu0olPOQg/s8BLsn3FZGlEWm8x3AQsJPEs2lRMekWBcfN87y02byQ2/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eUPnWHiF; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eUPnWHiF"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a1462573caso3005ad.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 09:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765993669; x=1766598469; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1fFiqTSL7yCDoXrJ1tXWeyno0oX2/+d7bhTpeAdDf3A=;
        b=eUPnWHiF2sCGspxA0rjbpUZabcUmaaNFLVFRCRkWe/cJFTVE9CoYM6OsF6Q9zlRw9H
         senJRtmcmF/DrEGE9FV/d7LxewUY13rhJccvxQNNmnz92J1HTkAwWUFgVSRTHrYY1AVj
         s6fYFXrgtpkmh3YyvShPpY5QTx6jAS7dN1hiXyUHdo8OOsgkuyZF/BheOmqW4bZTP81T
         L3rBKzaKT25ctcHY8EF11UMEoltjebMHXPR5XrN2D2CjiqZPeY3xQtTDkcV+V2vXDUGT
         BYJPbSukx+ZM4Dx3bwa1h3fiKoerCVLa0k625lCivOxCjfFx3KBIXVc/kxno9ItcIdXQ
         kOdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765993669; x=1766598469;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1fFiqTSL7yCDoXrJ1tXWeyno0oX2/+d7bhTpeAdDf3A=;
        b=iSC+fEYlpABJmCizMy/E0Pz9YC3xuR9q4Mg22p86R5iDwjAOtzPzVCF5tACMBa0NEM
         T/x1/tLWkTeHJP5gYYnMxDnPHrCV4Y2PLXHvZDyYx0TVJ1AVHfwfFtR5BqoWNLmPMhhU
         n8YAJlHsgU4OJbrgGVihn9DirCmdvP5aN1r2oQ2M7TwPLR9Vs/sRBOR02dJYtPehXHkf
         hGe4Oj1pnoVa+fDXKD1o+1IwNJUaPL+NwbcabKo55FYGH89BEhxdq8u1HaJevSBd5lkG
         iNm9n8Cw7c1G0rB9wKOkfm5WfnICcMZy4QpIn4X4wzR1Cq9+Fy5+CMpVErbgdqu6O9Fo
         h2Bw==
X-Gm-Message-State: AOJu0Yw7eoRPfj+/u2zi+idYYWFjmsrwIQXkffoxIhp+Jl6JmtGasd38
	AlqDN2qokzv1AqWor708P3jWjkKPN3WDhgkGxlQHFDUp+mKtKYiUp7zCFHePpV/Mwg==
X-Gm-Gg: AY/fxX7Zx67SYvBaVWmiU+/p7QwWZ3B19BFdTTSD1vTFJA0G2GxbMWCDJDHvdaYJ9Pw
	7eVhnngV+QpvGECXfwk0RonsHVeyDUwW7CQuBFLo9ja5O7AxPkbpFjS+8/IJjLSGwuqvI6xSGWB
	lmDqY/ZIXjbfX4pZmRTbvhTPHNs+uFiNZY7pFKUqDQd0WaIBc1dwef9hQSSjwoRy3mTrCRaR2Kb
	43XZNCI+1nWOXhDKI5e6nk6ymFEaLHVOHN6GUv448tIi89GBwtBJnRk+T/RrOU4+SHuQIm3W9GV
	qAWukufpF5V/PBRXhOKFDHU/MQA1oLYtGhfm9iyMFLSC1MmP1bCgMAyJf0y1DZhxAzJ/K6t4+Wz
	zHRL/sSkruHyvT5CHtqmIhKrWMP2yvRwdNXFnnpVp/qlSVkpTTH26Nknnhg4fvEMyryS8LwKhGJ
	e126uD1/j4tI/x8LE4NuA61pS4ec20V+w/U3QryU7AonxjXpeHLf89AAg=
X-Google-Smtp-Source: AGHT+IF2y3m9yTyiECAbH3k4RuEmBzXvMx1/zEco6PRwZ3AiWCUA9zhqe/FxfjHyu1mqiBcjGhrJVw==
X-Received: by 2002:a17:903:94f:b0:2a1:3cdc:7720 with SMTP id d9443c01a7336-2a206105bf1mr2498625ad.21.1765993668372;
        Wed, 17 Dec 2025 09:47:48 -0800 (PST)
Received: from google.com (99.181.125.34.bc.googleusercontent.com. [34.125.181.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7fe1456bc5asm69693b3a.55.2025.12.17.09.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 09:47:47 -0800 (PST)
Date: Wed, 17 Dec 2025 17:47:43 +0000
From: Sami Tolvanen <samitolvanen@google.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Eran Messeri <eranm@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] dm-verity: remove unnecessary ifdef around
 verity_fec_decode()
Message-ID: <20251217174743.GD2944334@google.com>
References: <20251216230614.51779-1-ebiggers@kernel.org>
 <20251216230614.51779-5-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216230614.51779-5-ebiggers@kernel.org>

On Tue, Dec 16, 2025 at 03:06:11PM -0800, Eric Biggers wrote:
> Since verity_fec_decode() has a !CONFIG_DM_VERITY_FEC stub, it can just
> be called unconditionally, similar to the other calls in the same file.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
