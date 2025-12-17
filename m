Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A557359F85
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 17:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765993733; cv=none; b=jbDLudby8web4C1UMVd2kGVYmksQdld2Sfu/4+7QbFwHQDZR51nucL5/30RJAHsT43iJdSHWwmyKNcSw23G5ZrRRW6s2lZZuFkYL7UqoC9lxqW9zhz+tHB4CiSrjWS8Wsqw9OKXFWhMc1gMDxXmyoMkx4oK0i9tuLbPqJov33LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765993733; c=relaxed/simple;
	bh=jYSS8HFvwDoh2G4DbtjPpMIONxP7G4oeK+Tv+Y4G7mU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o53B87cPbjhPMZCb+SFlhX9HZRKrbzPMUL//oWOiG4EgnUphPPkzuv34kjdVubnGAhTn1ohX4esq5WVEb/gAP8eFqigC/jrbdrCgijbH/2jzs6UMAOgibBqEg/4AunCA28Y2Sm/oPxlbVR8hBGr6uF92cKXYVPS1DFBbjuHZYV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MKhkvXAi; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MKhkvXAi"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a0d06cfa93so1605ad.1
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 09:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765993732; x=1766598532; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EU185RjSO4ekuCjIMjoMPj8fqAXuFh5/aDCCW+ejDoM=;
        b=MKhkvXAiTosfHcp1aXlZVAF3+LVMMDRZqG4ZSgfieOdKE3GnmkdGLGYUkZs/48XHPW
         7mteKPuz8nu27xbyPp45awVllosAyRdHajHqR04PpQKVGp46/7f+invL1DvcDOB5C+5B
         xnFNMTq0wQuYUckDtypJWN2vwVgtyZqxu+HBtVq/V2NybFP2A4kQ+GJzjJCYE0YnDNWK
         bGhLmYnzuOLNizW8f7Y/+aEXDNb8kcSgVZaCBCyFr9qF1M0L9p7Xe6Sx0IGUSpAD/rQB
         l+uW9nRix8vwzec3cTTsimbawkHNlWKAHl6j+qJ0PFrKJ1LpLXAjU55rwfR9ujvQ19HM
         C+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765993732; x=1766598532;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EU185RjSO4ekuCjIMjoMPj8fqAXuFh5/aDCCW+ejDoM=;
        b=UMRrBJMZoKVhjdEbtQgg2HWuPH5yvG+J1woRnkYKPmGVK/K+RGONYmPQkxgHSOtGYG
         8Il8pgZy+dI3H/CVzYhoWi7bWsW6LM2eEtXJDLlBPOltKc/qM7QNAnqafVd4GgB6kSuG
         ixk+b8nOL18dwoRvrKcAO6u24G7+oXZwbZAJSw9jOfFN8fDJJROhviNwJMJioWVG0QWy
         Uv53Yk2ZQquvmWKqzCiB24tiUzs93IIuyZof3hgiW1VQgOlDVJDqFIK6GqggfOwyjdVo
         DFQwh31npHxDlnO6n9yYIL0W+VbagdtMnJpdlJQ4HyW2TpC4TWOhQqg22eUHTRxCYNt6
         fSQw==
X-Gm-Message-State: AOJu0YyBDAF6Anhr3Nm47mTnRfsNejvXNhZIIbSZBUlb2vySJZAq3oL0
	uKrXtyH+/5omwMOTLvM8BUlJZ7mEByzC3sWY51I5jSBZSCU4ZZC1OyBqbG+s5hWBsw==
X-Gm-Gg: AY/fxX7VL8p1OKYQ5wID+mIwqf/lOfSJcpGBPiyrTxoSJAGA9FTXm33/IuPMtUrBRLz
	YNgOxaWyfHCdPCjvr8baGzNI1l8MrJff4fMZRprcvRubPU/lnhKQg4qS9doPzTlsd2Cs8w6sRAH
	WqrETfmJ+vScOpqo71cHc+/Ymvf5UaxoUbbrRrw7uuMSZtPBp39Oh8V5zpuVdPNmbKhsy+wKTWv
	oStVcSSmUWCqI1TCd6IzMWe5HmH1odh8XO3z5Dgv7dSN254QtjYSPJzJmxMfTM1boD8ERHQgHle
	h8QN6vpDrnF2zjZmyKnVTO43f61W7t88dBNNXhP8+AbccxCnVKDreGJa+ubx9idx1WAHDKu1Pco
	FDUYiSnf3WElVUJkt5R++S0vfisNFQBMAybYNAK4bb8upnw8AS9pxJJpiPd+EOxOsVBuM6lbxeL
	kvxuf7MVO/F0iR7DcNvl8a91TZgNK2+BFPgAc/h6c332YWTCSkkTYZx/ERS8iSku+g2Q==
X-Google-Smtp-Source: AGHT+IHBTWxdeazqskyM2LDpsop2mgoS5Bl97koH74Wr7QVNHLq8o12VKmwR9XMQw4QcijgMFZ5pTQ==
X-Received: by 2002:a17:903:1a70:b0:297:f0aa:d466 with SMTP id d9443c01a7336-2a15f25e918mr2998435ad.8.1765993731299;
        Wed, 17 Dec 2025 09:48:51 -0800 (PST)
Received: from google.com (99.181.125.34.bc.googleusercontent.com. [34.125.181.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2cdd7fa28sm828485ad.52.2025.12.17.09.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 09:48:50 -0800 (PST)
Date: Wed, 17 Dec 2025 17:48:46 +0000
From: Sami Tolvanen <samitolvanen@google.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Eran Messeri <eranm@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] dm-verity: make verity_fec_is_enabled() an inline
 function
Message-ID: <20251217174846.GE2944334@google.com>
References: <20251216230614.51779-1-ebiggers@kernel.org>
 <20251216230614.51779-6-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216230614.51779-6-ebiggers@kernel.org>

On Tue, Dec 16, 2025 at 03:06:12PM -0800, Eric Biggers wrote:
> verity_fec_is_enabled() is very short and is called in quite a few
> places, so make it an inline function.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
