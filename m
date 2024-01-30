Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D5F7993C
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 18:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706641122; cv=none; b=jIG0Geaa9mRZpv1q6LjF658MWNdwPUFHFIygk46a7pW7M1kvQkSP28U1PT+9tkwsbtY9w+YrIcWAKSbvJYxxTigvhHd0P7azss7LPpTmWfkHHsxalX5VLxgYydASfrvX9CJxSBKqZbx9DMDqaROEcct02+iO3o13hHYYKwdy1A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706641122; c=relaxed/simple;
	bh=feOlOVjVoDFlYhJijI29hyyTBq3VHkJbnIkbQHkWo+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bOIOpdav2sWj0GSXYVFZ5pkx7608QHEGirS3+Hfv00p830jk2jHZGbDA9bhU+5G03xAjl0egP1eIFKFuXsJZTX+PrSN9mkxipMEyuC2NTuGZj7Ft/6I4sh70Tnda5Lh8acG+aPE7B49K5jt9oHDJaaWFyxmbnXsD+tIAWUNQWKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-680b1335af6so1008246d6.1
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 10:58:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706641120; x=1707245920;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQQdl1Z7hWzrJNQVbHBRvsLI1/jbn0qd6qXGr4XoIGk=;
        b=qJaWd+/hwWziIhXcrQyLHKZRLuAvAQfaGWX7mwxvJSYYycDghW125QFmhVbh5unG1X
         FyCLmuHu50AO9FjEPQOik8Co22aAvl0TBgxlnKo9/XA6o5SsqOs3OdpebHQ43HliQCSQ
         n+SS8op36sl7N+RgzfEP8kNrOV2qeczP0n+p5vRsJN8f7bqz6mQchrxSfbdYQOdOvWuN
         8zUT+ov8Ugh9RjrpxhUIrqBbGx0bK8+nAXVtw0gGwfjKmGwClwOkO5lwkI8wklGkC54J
         f7x2PDTjcBLVe4WDNchznIx4jMkfX0899MdP8m32IOLizkyR5OeDAta9g8rCRydmejr2
         nB/w==
X-Gm-Message-State: AOJu0Yx7uO0VMV23uPPGztboN/EHVlAGdrByuh981bm6t//HZIqMOrbh
	nui3WWrbFH3YjDLiRDOWOZwTAVWm+e5FbWKiqhfo1Hnm7mEzjV/QBXC+rl7szQ==
X-Google-Smtp-Source: AGHT+IFAvIv3XblWdgdQ8RQaDq6JHCKiCsKus1Crsy6Zo4z9JO1wUINYuy/SufWB3UTtR+pOQa194Q==
X-Received: by 2002:ad4:4353:0:b0:68c:4b59:d4ee with SMTP id q19-20020ad44353000000b0068c4b59d4eemr1868859qvs.21.1706641120069;
        Tue, 30 Jan 2024 10:58:40 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id or32-20020a05621446a000b0068189e9d3a3sm4322738qvb.112.2024.01.30.10.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 10:58:39 -0800 (PST)
Date: Tue, 30 Jan 2024 13:58:38 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-hardening@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 47/82] dm verity: Refactor intentional wrap-around test
Message-ID: <ZblG3sBtxv68aRyH@redhat.com>
References: <20240122235208.work.748-kees@kernel.org>
 <20240123002814.1396804-47-keescook@chromium.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123002814.1396804-47-keescook@chromium.org>

On Mon, Jan 22 2024 at  7:27P -0500,
Kees Cook <keescook@chromium.org> wrote:

> In an effort to separate intentional arithmetic wrap-around from
> unexpected wrap-around, we need to refactor places that depend on this
> kind of math. One of the most common code patterns of this is:
> 
> 	VAR + value < VAR
> 
> Notably, this is considered "undefined behavior" for signed and pointer
> types, which the kernel works around by using the -fno-strict-overflow
> option in the build[1] (which used to just be -fwrapv). Regardless, we
> want to get the kernel source to the position where we can meaningfully
> instrument arithmetic wrap-around conditions and catch them when they
> are unexpected, regardless of whether they are signed[2], unsigned[3],
> or pointer[4] types.
> 
> Refactor open-coded wrap-around addition test to use add_would_overflow().
> This paves the way to enabling the wrap-around sanitizers in the future.
> 
> Link: https://git.kernel.org/linus/68df3755e383e6fecf2354a67b08f92f18536594 [1]
> Link: https://github.com/KSPP/linux/issues/26 [2]
> Link: https://github.com/KSPP/linux/issues/27 [3]
> Link: https://github.com/KSPP/linux/issues/344 [4]
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: dm-devel@lists.linux.dev
> Signed-off-by: Kees Cook <keescook@chromium.org>

Please change subject to:
"dm: Refactor intentional wrap-around test in a few targets"

Reviewed-by: Mike Snitzer <snitzer@kernel.org>
