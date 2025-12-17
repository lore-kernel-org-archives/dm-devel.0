Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8A535C19D
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 17:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765993819; cv=none; b=mYeNczrIkDIkziLlUEwfDpF9cBpuZeV5ztDnPQP73a2l23fF1gR/Ax3NSGoTXFEKmEczRFmqdAqEMCVHweyDVBx5uueJl12XCMvX6wDuSGQJLL6DffmdNF0vILZpj360tDv4edk0Kz6w3WyHOO55TMjN0lxaso5PiEnwBq/uScA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765993819; c=relaxed/simple;
	bh=VSYTacfUxQ7ArQarNQCUJnxO9vH71J8cKFyn4hBh++U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MU/ylG2k6DPpRMRQuqivzWArlrg/PPD2DdC9ZctqiWxCx897JfYCxXP6dS2G+WgV7BuRC8XdPGepcbfOonW7X/r/rRzfUMrlTlHBsaNP4Dm7euCYP/YYkQrqWE2xp66bA7AMXwx1/ZfZ4/p5qD0y8vgqZUh/aJiiFg1YzpGoe2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QY8eIqLA; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QY8eIqLA"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-29f02651fccso4085ad.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 09:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765993813; x=1766598613; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3xhp+1qBtUxbsH2+oDGF7w9j3CH1HE7lPDRbg5WbMDw=;
        b=QY8eIqLAzBkW2dOCGmnMWiUqC8SU15nuzaofEX9+l03VEFC1UosLjORhkuXoXtIr9F
         8kaAXzxKbPa1MU1u0oPc8Anl3Rxf9akjXg23ytNTjijoMYydFMuIdouyRP62Zv7eZikw
         4Hi03+LTINeezFhzozSQiS22n3RoRrgbpqsETV2M9HZ8in64Tqx9WYq7ue0QHVjlKSsN
         4S0y3Qq7+acL9wUdSn5o40vY0nK+w+1BjArR4ECFwMdUv/qCLkRMFuTEHH7f8ogbL4fe
         kikZxSCKpasxtFrgp2sVuvs/KIstuIKaF+7ox9QRGoEgTcvhGSx7pVpuGEARjMVB8p4k
         4evg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765993813; x=1766598613;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3xhp+1qBtUxbsH2+oDGF7w9j3CH1HE7lPDRbg5WbMDw=;
        b=tKWEh6V7pUbHs5RLlNi/BXY2f+EWGycB8YYiRY562yWGj/7cOmRKE3dDvZYTcUpNUM
         skO2fXJwsOrVcumRucKofl7ns0SfaBpB+EG/h137SGQT8VmoSmWoiaJf90mI1Bj8aO2A
         K2keyumOjwfzWIZFk9GD8vzBgsSzlolB4y3EYSvVTZK4ELGcAEP/KJ0Shts2CRFwMeHM
         uhIPAXAH+422HtWyLCrPScO8L9lbWuFftxvAijTejgHMOqG/UlVDKm+YMSoA9u3kj0MD
         w3nfuOESbNJTVejL+aFQdBjBZvyEBKIxPVB/6yM2r/ByoWX1x5nGogJs6/UW4sJMcNBg
         lvHg==
X-Gm-Message-State: AOJu0YzDnKaiGXeh+y/7mrOWGVPWjvc2Umeb46B/WxxzNAHYOMOJWlOt
	scDPUftOkzNsV7Gsc2ZANpOViKMydd+GIFlr7kYhOx1smSZLTJqYj/LF/JS2IFF2Jg==
X-Gm-Gg: AY/fxX5HkhdJLCog2Ts1C3R+gRao0UU/Yo+uBf1cbGuGiP+6HOHwWZKGVxKwzeqVX5A
	uOkrd9fFpBbaY/IlTLxff+6WxWcLxEGTypIwHvvihSRkhs63c62NDdGOR/BkBm8s5pycAYQ4KTx
	zWO1w7TTS+lkgFWr1oZ40eCvEXB2QNZ9z47Ly0yvzSbId/mkBAhGrF0fYrFUaidikHG99m2x9kX
	6hoh77tqG8ycKHxE1O9fsqQrUWDwoHvpxlGob+rMRsb2rVxtNgXqRj3WQts4/GBoLPZeQIpVONd
	rY1Dy1g01z/vlAl+EQihWwHDm4BJwpXPi6DJGJ9dvoFQXkhZMRgX+RiYPxu4htttkUSoVAqS9/J
	IUmPy3oNtrrxBvA7ylxCFATScqyvn7GIidFYUqQYaBhhPiAkDvUkHlmv5raQxYWDMo4Ah4T76pc
	zzJyCmWihoPjYY3dPOR7GyGp8oa82xdPLLwGWsDazZaK9zIu5z3zarHi0=
X-Google-Smtp-Source: AGHT+IFK2VlOos5FzsK9VT7JjL/uMcHVcPWBiFYtwTGCMoPAHa+uZYr+UNkyhMCzItk9Z+tUDS6biQ==
X-Received: by 2002:a17:902:c94b:b0:290:8ecf:e9f9 with SMTP id d9443c01a7336-2a2060d6808mr2761895ad.7.1765993813325;
        Wed, 17 Dec 2025 09:50:13 -0800 (PST)
Received: from google.com (99.181.125.34.bc.googleusercontent.com. [34.125.181.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7fe121222bcsm92877b3a.19.2025.12.17.09.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 09:50:12 -0800 (PST)
Date: Wed, 17 Dec 2025 17:50:08 +0000
From: Sami Tolvanen <samitolvanen@google.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Eran Messeri <eranm@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] dm-verity: correctly handle dm_bufio_client_create()
 failure
Message-ID: <20251217175008.GF2944334@google.com>
References: <20251216230614.51779-1-ebiggers@kernel.org>
 <20251216230614.51779-7-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216230614.51779-7-ebiggers@kernel.org>

On Tue, Dec 16, 2025 at 03:06:13PM -0800, Eric Biggers wrote:
> If either of the calls to dm_bufio_client_create() in verity_fec_ctr()
> fails, then dm_bufio_client_destroy() is later called with an ERR_PTR()
> argument.  That causes a crash.  Fix this.
> 
> Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
