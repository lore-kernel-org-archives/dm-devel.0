Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230F4313534
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 15:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763998231; cv=none; b=e1FDo74ZmIb0F8cSajPlcG/XAam78WqGXDohXJChTTnbEdTY+PDntFWhZUmGk+f1GbnUgJcGlxytWPrKFoL/+ejirCBJi935sA7sE6MXBI9p5AUhsVTGE0AMp/AYXDilZfPWiXqOyfNiTEcIuPVWErOh6BqiSgMhxeb8vh7fx8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763998231; c=relaxed/simple;
	bh=Koq7nupbyqygWfTt3eJxA8tO65rwhAKyZcUDi0cV4pg=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X90vxA/15OfjefboYWMtqFHfeXPEBeHWI5v5neQcihnewKo4JemYptEFE/2zraGGrG3vgLIrc35y6eUpUJkblx2YKS+bXXA6611KscVSt+PH9RZEUp0AVER71vkZT7fnzTxlvBHOUKo7dddmU1jInXUn6GMtxbEZOEwvDRg9m88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PeJTBQ9x; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PeJTBQ9x"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5942bac322dso4127738e87.0
        for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 07:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763998228; x=1764603028; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jpAZicEbV7PF1omS+qtAKskwicXqde/8+NG+Ffv60ro=;
        b=PeJTBQ9xFjm5Lim4qO2jjJiATyUObYzhunqHF6uA/T9arF/CdPQQHpV2EJ1lW5ttAx
         bX/q9nVb3hBUMNoy0EIK1fQQ0+nhYPSIm5r5FZbtZmfnU4rmoTlF7ubjZEqRT/T84Y+O
         M25giiMpfQFjHAVGr6gi4gXtO+b/Yr4etBOqbrgWTPh9C3hrY/bwWL8ZwTyuL95Fej48
         ew0tFbe6t3i3EcIZuRYRzTRQ+XtgIPZ8h4L5kBHc0+I2NEZNuAnFrsEjrGr0KUkJTAxR
         NAEJhu3fdUhA/vMOJGlNS/y3TCmercMOzlBPbw48GfU4z5gTekUvrQZlQ78a8tAMYx9N
         /r9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763998228; x=1764603028;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpAZicEbV7PF1omS+qtAKskwicXqde/8+NG+Ffv60ro=;
        b=SdUp5aefGgXA8KZ+9V95NNcElvn7+8AYcwQ5iM7JUuHvhuWYbTTxoRXHvUEQ3ev/rV
         2EcFwn39vCKN//ZPhS47tPKgfk4IBGaNJybofGGlmK/c0GhWBYjpU+yhRoLGqZrIP+qt
         lHj8OLAb9VqrNyvE3GYcgyw79iziOO9SOeXWYSJB8NNfUxvCCsYH6SRBFPIO4r7QfM+k
         cy+EUX88/yAL+4WcISeVr/15IhYGNGgEOqyLpqh9oCTFukvNzAMtQgY9pQUbE2wmMtEq
         bZQj6X2tvR0B7XRkgp5N17gHUJG37R4XR5qTGfJbxsch37bMOXC+gG+qRz1HkO1x1jHs
         SNtw==
X-Forwarded-Encrypted: i=1; AJvYcCVZldb/4kyURlJtWq8Ltuc+uPWE0RoALd2WlPA/Hl77KVEuzQBaJX4vkKmFIZ3FG9Q8APsb0Sqvaw==@lists.linux.dev
X-Gm-Message-State: AOJu0YynD0OYsfdd0GXHUVBBYQfXoqsbCOz8FJhcoFOlJgtu2pxC+YDY
	GVKKL77z5EgQnWlM2LCAwq7nA4OEqZ07Z7kkIUgKvC45sbnl1EqN86nId/RCO5cB
X-Gm-Gg: ASbGnctR2r+WcwhkZEWB3/GgZmI8jWsSH6+b9ELOQi2GN/7oQbleA7d91Veuje6x/yG
	LSpGWH/UXe/v5DjzmAPwpDwTxPwWYk5TkjNH4Dg53liaAjwf5Z2gCgpu/L8fX1sVnRHmKHRBzyi
	7EmG6YZ6QWUz9ucoA0khlz7E7q9UE1hifQMswlLSx9jullAX/QuO3/hOiF672sn0U1oFObVNjxt
	NI++pGXtn186JdV1+jpu3x692pGIUC1mucszeyoDsSzcNCoj218mhWgeq3SoQE1go9p+cqfZdcS
	2gKQ4lapigBnFHuX/6qooaYQw7p+X0zq8Yg2Fjoa/AdgYeSvmfRR0HR8m1wfQPJR2KU5e7uN9u1
	CmBULX8fxcmxYQ4PtkOfwPMmMNwbhzSuPa89uknzaMoj58uh/9k8GzDZa8paM7sjdhof4sDejId
	v9OLKqR7ojOo42ksjqNr7e621cxOk+/M1zI3YXvQ==
X-Google-Smtp-Source: AGHT+IHpw1eJsk3wPrlTtylJwn1r6J3I3D/XS7hNtlwwly7OqIZfysgrEcwxi6bY2FA0tx6gjqCoww==
X-Received: by 2002:a05:6512:1154:b0:595:7876:7b78 with SMTP id 2adb3069b0e04-596a3eac7edmr4153498e87.15.1763998227833;
        Mon, 24 Nov 2025 07:30:27 -0800 (PST)
Received: from pc636 (host-95-203-18-135.mobileonline.telia.com. [95.203.18.135])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-596a710f00dsm2456626e87.0.2025.11.24.07.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 07:30:27 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 24 Nov 2025 16:30:25 +0100
To: Christoph Hellwig <hch@lst.de>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <aSR6EZrxvlseRhZp@pc636>
References: <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com>
 <aRx_lCimJco5BPKA@redhat.com>
 <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com>
 <20251119054635.GB19993@lst.de>
 <bcd929c2-88b0-36e9-0e22-4bb0293300b5@redhat.com>
 <20251120062146.GA29990@lst.de>
 <aR8E2ZZtOi0RZt06@pc636>
 <20251121072421.GA29754@lst.de>
 <aSBnXqX9jmoKuv4Y@pc636>
 <20251124143044.GA17164@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124143044.GA17164@lst.de>

On Mon, Nov 24, 2025 at 03:30:44PM +0100, Christoph Hellwig wrote:
> On Fri, Nov 21, 2025 at 02:21:34PM +0100, Uladzislau Rezki wrote:
> > -               offset &= -DM_BUFIO_WRITE_ALIGN;
> > -               end += DM_BUFIO_WRITE_ALIGN - 1;
> > -               end &= -DM_BUFIO_WRITE_ALIGN;
> > +               align = max(DM_BUFIO_WRITE_ALIGN, bdev_logical_block_size(b->c->bdev));
> > +               offset &= -align;
> > +               end += align - 1;
> > +               end &= -align;
> >                 if (unlikely(end > b->c->block_size))
> >                         end = b->c->block_size;
> > <snip>
> > 
> > and it fixes the setup which i described in the commit message, but i
> > have question.
> 
> And this patch, using bdev_logical_block_size looks correct.
> 
> > 
> > Why in dm-ebs we need to offload partial buffer < ubf size?
> 
> I don't understand this question.  What is ubf?  What does partial
> buffer mean in this context, and what does offload mean?
> 
That was a typo :) i meant ubs - which is underlying block size or number
of sectors which define the logical block size of the device. In our case
it is 8K thus is 16 = 512 * 16 = 8K.

Partial buffer means, in context of dm-ebs, that within 8K buffer only
part of it can be modified. For example, since we emulate 512B to 8K
from upper layer to the device, a file system can write for example
just first 4K within 8K window buffer and only that part is marked as
dirty.

offloading or imposing the data to the lower layer. i.e. writing dirty
buffers to the device calling submit_io().

Is it better? It might be that i missed something, feel free to correct.

--
Uladzislau Rezki
