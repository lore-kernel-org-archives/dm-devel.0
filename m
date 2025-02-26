Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DA018BC3F
	for <dm-devel@lists.linux.dev>; Wed, 26 Feb 2025 11:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740569316; cv=none; b=fZcMNhEFhBQHe4ZUzAAOoVjL4+6+away/8F4D0Pw/8HlcEEKQ7k8HTdD/upZ0gvLGnQBtH+LnmTQurdEC5UEjfCvsaw4zV/cOKEJpa/RpH0gXtHdjcSkb0OJDOQPvGgErcq6uibPlPBn1L45bUteHTw+kGTt3YfGfsfvdduPlM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740569316; c=relaxed/simple;
	bh=IHVV0VEiY51JiQMba95CWP2QqrEyuH8K6cJYGrV0vxI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d7e+ex6OYjRBlZiSkmRK+ejut4b1zT2MsiEf8HjurNcE19Yx5QzgqtbAKc+vr1RvadPFESHlYw/TNnfeJpLJRsQHY6DM30dKEEztkWOKS3T01mzsY0L372IYPlRITkTmtgoOkhUQd9Mh9/VMSq3cL57GRWUsu/QBPD5rWqEcXQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JEDF2DNs; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JEDF2DNs"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-309311e7b39so61553461fa.2
        for <dm-devel@lists.linux.dev>; Wed, 26 Feb 2025 03:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740569312; x=1741174112; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TGWA47ydXjPk/ArJwGLRdTzUR2JDCR2yxtlUSj8iJJU=;
        b=JEDF2DNsxJGG+xDps1ySVfQejO2qhN9PzIg2GAQ7H1R+azYQCcUMmsdW/SwZknZ245
         9UgH+ooIa9J4JbY41xUEKG22EEEX5rUTHvHnA3ch2M3KDx52MQkZpZ+fLHdD2R21Ev8y
         rKD5tRWOClo6DcA/8THQ3PlxSyjL3WT2skk7ESxbA5DLuDTfG8XiTxF1OqR7qRNhpzbf
         PCey6aoXAEZOMwp9DNDzB0/OOwbA/woE4eKX+q0K6Dw/j2NnA+epCvL9k870pm/C3gFX
         2EmYhwIDwYAL/f7CYwfwSVGXBFPgcQlzddFvjUd9pTQoZqhIwSYx3Z7pnCeuUrhTJppg
         ZX0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740569312; x=1741174112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TGWA47ydXjPk/ArJwGLRdTzUR2JDCR2yxtlUSj8iJJU=;
        b=kmGI4813Syu7/E5+UKxxcI2QG4GKKzSA6O2MjabTMaaot21seUxYEGTSDnFuguzUGJ
         qi9osQrO++cC9ZHigkYmHG0JlbrG7lZb7Q2SnMILaDVAZbuuwiJ2LRLw2LFDv4OUFTpE
         JP+LRz5bigQtlp5kX1fojRJeNZlogcr33VYOKUZWU6ROhgbXctHA0T4ie7Ry6lpgXSAe
         4YaxaICNNixxQCbk5pJUvYR/WR1It4RwvtAXdPBOxnC1uFuzlK4W6/T/kdC84vYnQum9
         7WSvUZnnDFix7M7D5PBq6vB6Ez985GwPvvgm/TpVK1eTe0axXw0LeOOjfw4xbl5il9jY
         Cerw==
X-Forwarded-Encrypted: i=1; AJvYcCXrCtAhrPi8KU8jgdo0wqGJRdDker7/IOCygP6clRyEVRdQD9E1D1osbE3xQ9eVTqrp9C81/Rw7tw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzkuhcQ5P/XtOK5byuGQy3K4FPR659xwBdvwK3bgi043TFaJUIi
	b+pbpDwTWZup2i0QhHBzAuMjVF+x9hWYq283GO22PItbC3xqDK01GeQviAzkGfKvSJkQbBXFw/8
	/RbUhTFvRqlCgWLN0+NWfEM0eLGQwUM0=
X-Gm-Gg: ASbGncsvR6xtf3i/mZOWdTy9GVLT6urUGSAuZkOfU2GLAHebNPMkIk5FSDtmg5W7hOL
	Y0X0v95vQalS9A+XDrHQ+VoGD3XlDK9PCE1zrzJG/poR05BL63NuXycJuutYER/0QITfRU9gHzY
	/AiSGte60=
X-Google-Smtp-Source: AGHT+IH+Zjc+bSh26ZsVjU3bqp76TTCLT0O7VaVEWFGY3H7jTf7GiuF0ZJl8GQK9eeazQ/KZTqZRV1mtBf3J32sedzA=
X-Received: by 2002:a05:6402:254f:b0:5e0:b542:fb32 with SMTP id
 4fb4d7f45d1cf-5e4a0d88ac4mr3401857a12.19.1740569301171; Wed, 26 Feb 2025
 03:28:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250225044653.6867-1-anuj20.g@samsung.com> <CGME20250225045514epcas5p10d06ab361a4125a94933fa8235fe3fa8@epcas5p1.samsung.com>
 <20250225044653.6867-2-anuj20.g@samsung.com> <20250225150626.GA6099@lst.de>
In-Reply-To: <20250225150626.GA6099@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Wed, 26 Feb 2025 16:57:42 +0530
X-Gm-Features: AQ5f1JrVzXdezh5PQ5o_BGjgjz3qnhupiyvcy-dL-1mUwfQLc2HYvilNGs8wJSU
Message-ID: <CACzX3AupuX0NYqBxq-7hBxU5E1v3BhHeYoeuWxYuyXqu++iMcg@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] block: Fix incorrect integrity sysfs reporting for
 DM devices
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org, 
	martin.petersen@oracle.com, nikh1092@linux.ibm.com, 
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev, 
	M Nikhil <nikhilm@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

> > diff --git a/block/blk-settings.c b/block/blk-settings.c
> > index c44dadc35e1e..c32517c8bc2e 100644
> > --- a/block/blk-settings.c
> > +++ b/block/blk-settings.c
> > @@ -861,7 +861,8 @@ bool queue_limits_stack_integrity(struct queue_limits *t,
> >
> >       if (!ti->tuple_size) {
> >               /* inherit the settings from the first underlying device */
> > -             if (!(ti->flags & BLK_INTEGRITY_STACKED)) {
> > +             if (!(ti->flags & BLK_INTEGRITY_STACKED) &&
> > +                 (bi->flags & BLK_INTEGRITY_DEVICE_CAPABLE)) {
> >                       ti->flags = BLK_INTEGRITY_DEVICE_CAPABLE |
> >                               (bi->flags & BLK_INTEGRITY_REF_TAG);
> >                       ti->csum_type = bi->csum_type;
>
> Hmm.  I wonder if this is the correct logic.  Basically we do not want to
> allow mixing integrity capable and not integrity devices, do we?

It is about a situation where a non-integrity-capable device incorrectly
reports integrity capability due to improper flag propagation. The issue
is that BLK_INTEGRITY_DEVICE_CAPABLE is set incorrectly even when the
first underlying device does not support integrity. This part of the patch
tries to fix that.
For example, when I create a dm-linear device using an integrity-incapable
device, the resulting DM device wrongly reports integrity capability [1]

Rest of the handling in this patch would not be required once we correctly
initialize in blk_validate_integrity_limits as you suggested in the other
reply [2]

[1]
# cat /sys/block/nvme0n1/integrity/device_is_integrity_capable
0
# echo 0 409600 linear /dev/nvme0n1 0 > /tmp/table
# echo 409600 409600 linear /dev/nvme0n1 0 >> /tmp/table
# dmsetup create two /tmp/table
# cat /sys/block/dm-0/integrity/device_is_integrity_capable
1

[2]
https://lore.kernel.org/linux-block/20250225150753.GB6099@lst.de/

> So maybe the logic should be more something like:
>
>         if (!IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY))
>                 return true;
>
>         if (ti->flags & BLK_INTEGRITY_STACKED) {
>                 /* check blk_integrity compatibility */
>         } else {
>                 ti->flags = BLK_INTEGRITY_STACKED;
>                 /* inherit blk_integrity, including the empty one  */
>         }
>
