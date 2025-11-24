Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729A731A046
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 18:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764007529; cv=none; b=sevbY67wXpYROZuCoheAZbV88l8P05hqpgxWqjz674SOQ3bj0r6eWVPeV0PuYxY/5XddxNNLVsRavapl8otrDNQGYH53HOf5Mkd9JwOIN4GzN4ZsvcU5w2NfX2MJlUpPoocuHc6NCc0WDfLif4vRoAwGC1AyKVPTXVicyRtv9h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764007529; c=relaxed/simple;
	bh=IL82dwWhdzDDgvYJoZEb5XPhBQ4kX1cjonI0bbduJpY=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aR0K29/qRMkhyanqPFL34nWAGbv+TWVT8Sx8Ws0uYfeer0K4tuvgDtlW4QMm6JIHkZPTczTlrWgf2/2sIz4dgHzOxBGZIWvQAmbMgs1yZ9PiEg9Nwi0uBlFh4cJeRxY0NDpuvHV60VTfGLjfb5ld2Y7hxZLaJbzZN9ErBmxe/jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GKCaG2jm; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GKCaG2jm"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5969c5af23bso4815320e87.3
        for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 10:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764007525; x=1764612325; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fdHxFN8jM7zLJM0/pC+5lQiWbP33CviN5JVgTeqzJbA=;
        b=GKCaG2jmq4W9IUPEtG4jAVnywHd+gIa70awtwThsm+9J4NQPv14ed9K4nSD87zHpHQ
         5wCWfmuAMdjHyWOld3XQz4gLstAlctrA1Q+Gup/oaVmAv+wCfInMZhvIbCSOr5iOFiAj
         NP/WLYq0NjpE5VyGRp3rekKP1RVHc+WIgQTio8+qUnYm1K+W7H6+473bla9mc58diYdP
         25txppjxxm0U4YOuIhoWhWBxuw6uNsJgQTffgq/SRx7xrBPWws9n3PTdIQihZOxNzopy
         vi+i6BEB9H24Jb4HciqOuAtUY4vSDYUQk494l+CEcZozo/EG8cD/m+JUEWLjgEkuqBlj
         G4WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764007525; x=1764612325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fdHxFN8jM7zLJM0/pC+5lQiWbP33CviN5JVgTeqzJbA=;
        b=rcCCpTmKHDvVVVW+fWolxY48foyRDkfXvwPUiJkDxApw/fPc4nwVYj36ejWFTF4b3h
         Cjxms+d2d2X4f8KwZ6mu/iGCdznbtTvtWAKLQPbflzjjNZWDlbalejq/t/AVLYxVbwEc
         E0T+XuMIufcYuLZEtekMch51+L/1p9PFTOnasPH+0MZpKe4XjJxBMAk0NTs/HNjREVWc
         JfVScuUXu08xvIxQqr4zMsQeScKS9c+oReubrKmBdSPegwG5RpwJAy7bxHCVKASlnIrs
         QZMf7Yd6obQOZmhV0sF5K7ON5apykGsFj7+vu1aCOaJyftuHiEqP7vMg+pcwG6Im90jE
         oaXw==
X-Forwarded-Encrypted: i=1; AJvYcCVyXbO94OtZa4R6ongUiIGpUqxPSJm4MowCNfBQqqvgU/EbnFj+4Ny9ChjGI1t8qlcqQRi2nmYBGw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzbt0DjGwJsfkMlcPlwQyJ2pivVDtKQJ2pVD3TvRiSqmImwdj1E
	ZKG+6GTzVUWAcuJRpZH27W6cygw3gbRoNLe5LRmolMjaPywhOG3JmfXc
X-Gm-Gg: ASbGncuMbe5ONnr21OCCba9r8VPg1M7/Y8IeG+pODpH2M8/9KRzK+/sfk+IkoIK0In1
	pkM3xhwY309YJIqjk8Do1YVBKSzf4DTTJpyqfNKLEz5jBVmuh5/FvPNjFEZ8iymeczU7jfaYCub
	401sHO77OZdqbAqELfgc1R0bfuQw92kbUydsjhDmJ4jG/PkeoknzSs9k2yIm0ojDdqAnpN+n/pg
	/JVSQ1799t2gSd0GG0BEwFUf8SaIy6bNt3vzcX2zKbZ8lBkZudhHYc9em3uHMmGvbJ0a8rseHJt
	lXJgkHXlVHWrQGb+LuK9Tt+c4IgGxbOr2cA04kzfTrvHPr4hLLQnh6KBxPOhCxIw39iBLb2rkB2
	p7HnWNYQK5v6pMAmnfqDAxYH9b1oqJdvLfxrrSDk4LlwkgS+Zx3lUCR3BZRu+4eGUBmn9z+ZiPI
	Zr6aSn7GVYxrOChlA2vOgMvJQ766mbOXMOh4lMuA==
X-Google-Smtp-Source: AGHT+IEb31cEdYX6Fjl0YQmjke6lqKMQFROt+NUuexZ2I5/D32bv+w6pJ6gQb/xuRuIM+V+OMBdYKQ==
X-Received: by 2002:a05:6512:1251:b0:595:7daf:9425 with SMTP id 2adb3069b0e04-596a3ed95d7mr4330824e87.28.1764007525187;
        Mon, 24 Nov 2025 10:05:25 -0800 (PST)
Received: from pc636 (host-95-203-18-135.mobileonline.telia.com. [95.203.18.135])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5969db75627sm4366210e87.5.2025.11.24.10.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 10:05:23 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 24 Nov 2025 19:05:21 +0100
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
Message-ID: <aSSeYQOl1db19yoJ@pc636>
References: <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com>
 <20251119054635.GB19993@lst.de>
 <bcd929c2-88b0-36e9-0e22-4bb0293300b5@redhat.com>
 <20251120062146.GA29990@lst.de>
 <aR8E2ZZtOi0RZt06@pc636>
 <20251121072421.GA29754@lst.de>
 <aSBnXqX9jmoKuv4Y@pc636>
 <20251124143044.GA17164@lst.de>
 <aSR6EZrxvlseRhZp@pc636>
 <20251124170037.GA28939@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124170037.GA28939@lst.de>

On Mon, Nov 24, 2025 at 06:00:37PM +0100, Christoph Hellwig wrote:
> On Mon, Nov 24, 2025 at 04:30:25PM +0100, Uladzislau Rezki wrote:
> > > 
> > > > 
> > > > Why in dm-ebs we need to offload partial buffer < ubf size?
> > > 
> > > I don't understand this question.  What is ubf?  What does partial
> > > buffer mean in this context, and what does offload mean?
> > > 
> > That was a typo :) i meant ubs - which is underlying block size or number
> > of sectors which define the logical block size of the device. In our case
> > it is 8K thus is 16 = 512 * 16 = 8K.
> > 
> > Partial buffer means, in context of dm-ebs, that within 8K buffer only
> > part of it can be modified. For example, since we emulate 512B to 8K
> > from upper layer to the device, a file system can write for example
> > just first 4K within 8K window buffer and only that part is marked as
> > dirty.
> > 
> > offloading or imposing the data to the lower layer. i.e. writing dirty
> > buffers to the device calling submit_io().
> > 
> > Is it better? It might be that i missed something, feel free to correct.
> 
> I'm still lost what the question is, sorry.
> 
No problem, i am fine with it.

Thank you for your input especially explaining the difference
between logical_block_size and physical_block_size for nvme device.

Appreciate it!

--
Uladzislau Rezki
