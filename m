Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF74335BA7
	for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 09:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763543638; cv=none; b=boBM3ulEt58PyDqCf1oj0mwHYvFoB1Bu0yobUH0ZXR7/F2O9Mw+xwNYS+icH30CvuuPFcfLgDij76Gy88MfzDlzHgoHEMI40hMnsAI2WJjGl5r8M4O4uAo9lq9CHMYmZM1pCUCpc1W/5K9tDlbAxR5c8JMXQy5QpdWynBAXnOzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763543638; c=relaxed/simple;
	bh=xrd0pbkJkYuPT1dmfD9moXApKe5yYnfcDEzTmAiBdH4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0T9lMWXX3mfM1gTPc6dIlKvXcoYuG4I3fM9m+w2r9ra3pc4kiXt9x/ZWj05r9dhKH9iU0yCp1jKIyoJlYzMQistsTZ6TB5fq7ZgbTByrIH7f683aAz0kYNqaFobLoGUbtZNcWhuEI25rRNkiP+HuhF36TSpE3eg87U2w4Bo1OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cW/AA8lu; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cW/AA8lu"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-595819064cdso1025296e87.0
        for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 01:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763543635; x=1764148435; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s4heNJ11VPhj4A+ONOH3Nw6ZiF5xMnF7GZX1yEbUMo4=;
        b=cW/AA8luNX4f4HhKWuX3fabzDY76E0lQU3x1hwHM6jkL37ZCysBpmSXLELECcg7c5N
         4/tueZ9gJzGKSX88zGUHqBEhG+DCed9e/6Mk+uZLYdd/FmLWG+4MiZTclYVb5cIhxeHj
         PwX++YNW+4bJiIQrJa/e9Jo5GUbB22dj1MMzINJJ1dbpLNU/h84qJ8aWjt5rmj8kw9R8
         RUE+LRilE7v+8WVP6qwGN3SIVV/0gNnK0uv6EM/p2cMCkEzgzPtBCc5Rn/zlwCiKdxo2
         3VZrOwHmHYxnhuqjDM2pax1LbQEtV5RLraEfxbVqc3WIx1pXtFC5Lc+9KWbv0e5XEbZj
         e/FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763543635; x=1764148435;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s4heNJ11VPhj4A+ONOH3Nw6ZiF5xMnF7GZX1yEbUMo4=;
        b=a+xa21IXlASt+b9vfntmQLoWpYQR4eSTq+P4By1Be87spIIwOv07tniQPwQT5jA3/j
         ikT5Tv3ag6KPdjIk1YBTohW5bYEPt/PEcExrjMiu2jwQ2U7DL1cUz1WULB5DHCcjN325
         xbUVRxtROXa1g9WZSxS8DtfkkpO0R193YF6X+9ELW2plxHR9q0Uw7+b9IeWKArnrfq6+
         c2ZuvnRzjcuifUcYJftEGXidw/trdjpCHWlHD7bhNmUU032uert3YTA+bAi3GX6JKY+T
         a7LswSae6SanyZT+bEcnt+A4314NkZP8aJWRFZid6LgE4S1t8ogKU23rR8K0HL6iA/b+
         mXDw==
X-Forwarded-Encrypted: i=1; AJvYcCXGmO+7Lj2XLfZKyHfyQDPtKuanJPLBtAKBd+1hlqupLL6bR7UQ7/dlwe9l67sKa29X5UtasSTSfg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwGw2v+kCnTRIcpvuKudX0WGIf3r1OPbteckGPDk+k1We6z4CQa
	m6rgqlPQhVihYWuAASuHj1gEyqjJGUXP7lc0hRG90BwqFGVqxJ6znTlH
X-Gm-Gg: ASbGncvOaq07ak7A/v5W0UHPaZVjX/JV8dT5bKDHcQu7DyhGbLfRvdeJ4cGzvG9wvmu
	IF4EicJx5Wo8vPiIb3RhqUvJLuuA2wGeMLOzDKv5mEGevyeXi5zQOVZDKSyk5jkNo/xGVoySIxd
	R8djgLNogc2dXSTFTNi9S7KeWBeso3EYMTx84n9pH+IiN5xSH/XsRC0H3sR/mo3uAsvh0oHmPRH
	pBglw1FXAjBI4r5e/KEQabGO/SEG+vykozedWnV2e5mydfNLfPc1OVaSCTid82hmkMmag9zgbNG
	l5X3LpcdkxdtIipnLqcmlWxJJzt6iCyxhszhTqvYRdghH/BB4O3eixoimNfNAoS0BvXVObTjB5s
	diX+5myVj/G5MUtce5/tEi9k6Pov2dq4b2ZZlzpYfU6tN6R29i0HVzXslD5TPIl7HM0ZqvGhNWe
	dxwK8hSKp2dd44NtpcM0baZeLt6PoPz/jJOd9WnWzoJC7hQkRFw4E=
X-Google-Smtp-Source: AGHT+IHfI+GnFbek6X000m3JJ7m2RI0Vgi3c2UtRRA0Q6EHCW0IhaC67KQu1z+aySDT96mlLjcz/fQ==
X-Received: by 2002:a05:6512:b88:b0:594:37bc:f40c with SMTP id 2adb3069b0e04-5964b3942e9mr635054e87.10.1763543634399;
        Wed, 19 Nov 2025 01:13:54 -0800 (PST)
Received: from pc636 (host-90-233-212-127.mobileonline.telia.com. [90.233.212.127])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-595803acad0sm4492240e87.20.2025.11.19.01.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 01:13:53 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 19 Nov 2025 10:13:51 +0100
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
Message-ID: <aR2KTzMkZ5ThtywW@pc636>
References: <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com>
 <aRx_lCimJco5BPKA@redhat.com>
 <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com>
 <20251119054635.GB19993@lst.de>
 <aR2DIXsymZWD9EvG@pc636>
 <20251119085328.GA24461@lst.de>
 <aR2GjRaNWrfHbDGQ@pc636>
 <20251119090010.GA24598@lst.de>
 <aR2HZWE-v-umP7jI@pc636>
 <20251119090530.GA24770@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119090530.GA24770@lst.de>

On Wed, Nov 19, 2025 at 10:05:30AM +0100, Christoph Hellwig wrote:
> On Wed, Nov 19, 2025 at 10:01:25AM +0100, Uladzislau Rezki wrote:
> > Again i rely on this.
> 
> I'm not sure what your random quoting of low-quality comments in
> kernel code is trying to prove here.
> 
> Any device that does not support the LBA/sector size correctly is
> not support by Linux.  We could in theory quirk it in the driver,
> but for that we'd need to known the vendor/model and a good argument
> why we can't fix the device reporting, as this should just be firmware.
> 
> Secrecy is not going to help with that.
> 
I will not resist.

I tried my best to explain the problem including description and steps
how to reproduce it in the commit message if someone wants to repeat it
in qemu with virtual nvme device.

--
Uladzisual Rezki
