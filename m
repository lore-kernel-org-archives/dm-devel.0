Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7201B2F52
	for <dm-devel@lists.linux.dev>; Wed, 13 Dec 2023 09:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L/y7pQOb"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-551c03ae050so1484458a12.2
        for <dm-devel@lists.linux.dev>; Wed, 13 Dec 2023 01:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702459480; x=1703064280; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6vzSd8LynZJ//PvTW6T62UCX5dG9fVJhHRlr23lSsXQ=;
        b=L/y7pQObf7yb6nz6/wSKguQzKWXe7zA/RY7Qp8N5ekX1ahJRJzdRUfdH7VRmvwQj/z
         VjFMs1EijlVoD3a1UFOx/OpH0yG+2PwP2UdRIZdXeoyzG/N4w8sj3ffH3fshJ2xtY6tX
         Q7pqE5v9jl1TAQhXBN8KKPBMvft7V+BLViyRyHkbGdhDCN95sI/fmT5YMg7v6cL2uH9Q
         zeyZyASOpU3zyIaF6oQZCMXFB2eAsilF2lYUUyliklsGjJD/BJ4FMVqWDJnNAIEyeDmv
         l/ApIj839PSxUwGDPYmrW3MQa7XIZusSiGCKwvXWJLkuGSlL7zwhKtn9aUpop0H/Thzx
         Nu2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702459480; x=1703064280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6vzSd8LynZJ//PvTW6T62UCX5dG9fVJhHRlr23lSsXQ=;
        b=SQOpk7UmhlSWDPfkgSNV0ooxkQbvB1thNDH0u6EZuPRsN/aKAP7ev9ioK2ECUwiEXe
         0QUnUmnevLSVJ+ByOQZyFc7HPQhuV7d0o9rEWYJsjkkZzLpxq/6/oF7wdWRm8HOb9Fyg
         Zu677pa247Fw09Qzlcg67DwGFkvnDOXQu6HcfruudT9eLrZ0hOz7OVWceANpCv4jLghM
         j5Y7/galpBCkVOpVxPyZb2sZvQ3t4PbWr1unwy/Ys42vxuQYT07XRUrGoa2MZ2G/xg1K
         J7fTp8dzGCpmoQCrJb3LvzNAHXZnHc3m9w4ntnvhdNWFo9OmFmQNIHSnMQFgKwm/jQZE
         dT1Q==
X-Gm-Message-State: AOJu0Yx/KBDQRK7B4fhXNvafK7ToAd0/8fYPCK7uEvb2LE8By60Alpya
	Y8iF5CdnVufwjnIqY5e/wXbBDKpX7B1D39NsWME=
X-Google-Smtp-Source: AGHT+IHcfe/Yy5REgZDPMT/EQF4CdZzG5fkb9Ye0aKAvhtqq/Z+jC6Bly5Iskt6NjOOnjgZT7EnMoKsksMmyhIZTmbE=
X-Received: by 2002:a50:cd16:0:b0:552:2ad3:5d2b with SMTP id
 z22-20020a50cd16000000b005522ad35d2bmr193694edi.44.1702459480340; Wed, 13 Dec
 2023 01:24:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZXeJ9jAKEQ31OXLP@redhat.com> <20231212111150.18155-1-hongyu.jin.cn@gmail.com>
 <20231213044530.GB1127@sol.localdomain>
In-Reply-To: <20231213044530.GB1127@sol.localdomain>
From: Henry King <hongyu.jin.cn@gmail.com>
Date: Wed, 13 Dec 2023 17:24:18 +0800
Message-ID: <CAMQnb4MQUJ0VnA5XO-enrXTJvHbo6FJCVPGszGaq-R34hfbeeg@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] Fix I/O priority lost in device-mapper
To: Eric Biggers <ebiggers@kernel.org>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, axboe@kernel.dk, 
	zhiguo.niu@unisoc.com, ke.wang@unisoc.com, yibin.ding@unisoc.com, 
	hongyu.jin@unisoc.com, linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Eric Biggers <ebiggers@kernel.org> =E4=BA=8E2023=E5=B9=B412=E6=9C=8813=E6=
=97=A5=E5=91=A8=E4=B8=89 12:45=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Dec 12, 2023 at 07:11:45PM +0800, Hongyu Jin wrote:
> > From: Hongyu Jin <hongyu.jin@unisoc.com>
> >
> > A high-priority task obtains data from the dm-verity device using the
> > RT IO priority, during the verification, the IO reading FEC and hash
> > by kworker loses the RT priority and is blocked by the low-priority IO.
> > dm-crypt has the same problem in the process of writing data.
> >
> > This is because io_context and blkcg are missing.
> >
> > Move bio_set_ioprio() into submit_bio():
> > 1. Only call bio_set_ioprio() once to set the priority of original bio,
> >    the bio that cloned and splited from original bio will auto inherit
> >    the priority of original bio in clone process.
> >
> > 2. Make the IO priority of the original bio to be passed to dm,
> >    and the dm target inherits the IO priority as needed.
> >
>
> What commit does this patch series apply to?
>
> - Eric

Changes are based on the master branch
commit 9bacdd8996c7 (origin/master, origin/HEAD) Merge tag
'for-6.7-rc1-tag' of
git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
