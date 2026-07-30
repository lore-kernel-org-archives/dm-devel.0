Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0452B3932E9
	for <dm-devel@lists.linux.dev>; Thu, 30 Jul 2026 16:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785429998; cv=none; b=Rq3SmsqQYzOWIVpkAVwF8+i9Q2xoZb/p7nHSwh12B9rTvubMVSSCP22qQLsBX9q/uIvQb5xCtb7tvOaZFTjKeL7etVw1WPpV7IHR0ChudmOovX0bxygrdSFRlmZOijf3vHkGZiVp4nulCcQkCu8uzCe0UkF+/rD6aQ85H+giTcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785429998; c=relaxed/simple;
	bh=ez/ftBKUFZXPMBA1j+BIjM+rYkY7cSycREcI8v/26vo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HBNdCcPaJZLfG5tj32tKlbdG0LnUyNdjUkkpbZx4voFJ+/zvVQaDrDuxOJkFU5lMtIbQjH0U2nYfHHZDe9uomj4ZNwDDMhRG1b8+2asJqShfw6IFMaBxEQT3mZCpk6Z9wyNdEUQ4LZWLLkMM/2nwyEPG/rCOy5Ib9/ZU9Vzt/y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CShf6cax; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CShf6cax"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c1671ec8692so298361866b.0
        for <dm-devel@lists.linux.dev>; Thu, 30 Jul 2026 09:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1785429995; x=1786034795; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dZlOLGFSy/CTNPahqtj7kyVyKyd2w+qb5becmlDJdco=;
        b=CShf6caxtITmJ2tC/xeHnYZUu00wZauf44myxHZdqqxekJag4WwTdSLUJxrupc5Gh4
         rTE9eBkq8fQjTkiVJ850uChXgyppJU00ObIWJ8W3wN2ZzFxH6sjYhgJYGcnBLS57dM1c
         bwrqeUwU5BlaqmSdF13gW4tCyaJ3nE/A544hA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785429995; x=1786034795;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dZlOLGFSy/CTNPahqtj7kyVyKyd2w+qb5becmlDJdco=;
        b=rvjw46bHP5kyhx7MyAR5BgljhrCCCPNQLtZYM20QU8YWiXITPTGNERCgREmwxDhipN
         3i9EioNRLqt2BP78nGHA27sqoo+oqz4rvRz1bSIcVzkbocPNIqXoze9DxzdPOKWbEvAM
         IkrSm0q9+WPSEveCJOd/8X6mXXgk3BGPVL9M+4Uzl6fgNxZPwgI9zmi8CBTIYL7HqSrE
         0zK5CpRRrojTVHnbCg6ok9pi7VXsRwH+ZCQBWEvERIwSRMwv+iSXhtsWiIDtK24qE3K7
         8uSO1sjW0LQ5FKZf4Yku+YDdrsFFoDpByNacrKjENVKjqIfrFhUHrViDwZj5sOhHXaeD
         KYgA==
X-Forwarded-Encrypted: i=1; AHgh+Rq2/XW9SqBccjqDCsgWOVGTQU23dyEzVwmPJ/r//FoF3HeSnBHYPv7sNhAkRkm5R9QpRKOucoVshw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxP/cOX6yHvJZ3ucXAvQRwcsXM2aChbZtuSsTWjbWkoTx/2k4kn
	ZUHJPcguwiwFfDCTAvMwFUBDdKz+5C5cyY4aNVl074O2AMDUvLNF5PwAXJE58SJXg8iCo36TXl3
	LkPSunXc=
X-Gm-Gg: AR+sD11VwQpo3UY+ETTAv6GUj+HJCxk6f/csCqeakZKGZGAIFiwD5XDMOd2cocrNMH7
	gz8RbqMdVYflOYRKE6dSVxAI5EBzI0Cb+HAQsMOcjQ5xkZYjeh8G8x272IJN5qj7T5SDXx9r7eQ
	p/NxlEaczCytThNRb38L5r836ajc6NYWg9boPzE83vTdBjntiKvAvF0SMil4gh2GZDPeC+lV9DL
	w04fa2ulnkUE2ewXDHc8DZ8+heyici/aRJpiXES+Z0+y2x5TAUkFsiHIyhWA8oI6QkIyTq85oid
	1FBfvVjCo3qCNiaCctuYo+F8+y1PoMtSywV4wfVTcyv366DEnQEIG/tfctJyDFZg8ht34kP7Ddl
	s3+uHyPZIKTUnJy4SCwy1vFFNT9uR7rrE1zXEgFlYDnd6OqzDSlx/3Rlt5HknR7oj4Cr2kcI1LK
	mEV4wL4uTU5rarEgBKCmcVV8C+oeid6RYarL16Jp5Q8tJjFJce5UCE8bTMGLF7bQSg/MfIulD5W
	HlQBUICT2OzQ50dm7xwgFUAsFTCYXq8tr51tPMaDxsqGC/iqw==
X-Received: by 2002:a17:907:3cc3:b0:c16:a402:9d8a with SMTP id a640c23a62f3a-c1fa554e5a5mr182677766b.11.1785429995249;
        Thu, 30 Jul 2026 09:46:35 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fa8bb5e1bsm90350766b.50.2026.07.30.09.46.33
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 09:46:34 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c1c24ec9525so402816466b.1
        for <dm-devel@lists.linux.dev>; Thu, 30 Jul 2026 09:46:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro+woqfREEpprJSB5Q0uV5OwspzEKIqJQWf3fmzcoOXl1PtzU7JzWd6WTai/kY1r1GUHeA/SquF1A==@lists.linux.dev
X-Received: by 2002:a17:907:c17:b0:c1f:1267:deb7 with SMTP id
 a640c23a62f3a-c1fa57ad4d6mr193696066b.62.1785429993415; Thu, 30 Jul 2026
 09:46:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720201057.1862857-1-kbusch@meta.com> <ampRQyXDbGgeg49V@kbusch-mbp>
 <fbe9e74d-c389-46f4-9874-3e9ffd9c91d3@kernel.dk> <ampce7mxSmxAwAiu@kbusch-mbp>
 <20260730112626.GA24827@lst.de> <00104e90-48b8-4419-90c4-ac0c4a2e1c44@leemhuis.info>
 <bd7249ff-d0a6-4a3b-8aec-3b5325f24b08@kernel.dk>
In-Reply-To: <bd7249ff-d0a6-4a3b-8aec-3b5325f24b08@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 30 Jul 2026 09:46:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiDsWYL2c_vpqArX+UL9k8v3qoge7HqjtcrxbVsLAjfXw@mail.gmail.com>
X-Gm-Features: AUfX_mzqOY3ca4Dui_O7sukC5vCEWaDgT57cEJGjc9a8_XBsD7VAxqL5ujTpsZc
Message-ID: <CAHk-=wiDsWYL2c_vpqArX+UL9k8v3qoge7HqjtcrxbVsLAjfXw@mail.gmail.com>
Subject: Re: [PATCH RESEND 0/5] block: validate direct I/O memory alignment
To: Jens Axboe <axboe@kernel.dk>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, Christoph Hellwig <hch@lst.de>, 
	Keith Busch <kbusch@kernel.org>, Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev, brauner@kernel.org, 
	djwong@kernel.org, viro@zeniv.linux.org.uk, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 30 Jul 2026 at 09:23, Jens Axboe <axboe@kernel.dk> wrote:
>
> Sorry that's nonsense, because how is Linus going to make that call if
> we can't.

There's not a big enough thumbs up emoji in the whole universe for this.

          Linus
