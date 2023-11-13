Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0DB2510C
	for <dm-devel@lists.linux.dev>; Mon, 13 Nov 2023 21:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ABY9q5cn"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-9d2e7726d5bso747099366b.0
        for <dm-devel@lists.linux.dev>; Mon, 13 Nov 2023 13:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699910822; x=1700515622; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mttVMjujBnJtfA9qmPOIHfeRm+JAOLtRVgarlviBSVY=;
        b=ABY9q5cndxweGXQp0xJIpfE1iJfwSYbhbMRLlIRTzQnPOrTorCSnQDXvX3Jlqv11g3
         yvsQYvFX1w36YePReE3yHbK3aILNfJmCEEEgU5TKzjn9hc41HWDmBWqWXAxbZrRznvFr
         IwnyRwwEYHY6ZYVzO5TXSNSQ/bLsIXENfsXig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699910822; x=1700515622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mttVMjujBnJtfA9qmPOIHfeRm+JAOLtRVgarlviBSVY=;
        b=XtIpuzRUZ9GSHSkehT+wCN3+E+h6z84zUkmcq0QuvU1HQmKhyXB7KcNQ97ikHaeyeD
         5+E9174vgoT/N6L3u8gGOQrfxzodu9pw4NNvTI2PYHZ2Ru1Nb38wTSIYkvHvxsQEM7ZR
         AZCZZRBebLdZE4h1y57K0LS6jmsvhf0W6hKqcOH466U5/RWgfddq/J/3/jSxqikL8ube
         E7WFA8eYnD5TNwRZt/YWrWjrodfZcz8wWhBRguMb3HosFOcUERppToTCCJuzh6KfbznY
         Ty1aajv21IrCxcIqiDuWJp6QPDX2br/5Wxg+R0uZDBeQvq+DdbjMguGbTAYs1tEUeICU
         FaIQ==
X-Gm-Message-State: AOJu0YwMRsizuMy2u4IFo6IH7Hlyp32o2L2HBgeymcQvdDu2czLs9M3l
	R5yL0ED8QAjG+JO4TnJYApYYbymwTbnOgWsDB/w7ag==
X-Google-Smtp-Source: AGHT+IGoL4C64VRkqMMt2Ko2g8gaFMw8YCcpuwoNcjFqFlvPZKJTDjJL2Bgl7LbSUmzZ0cB+I9TezFzC6HBD0IZ7Sjs=
X-Received: by 2002:a17:906:dfca:b0:9e4:67d9:438 with SMTP id
 jt10-20020a170906dfca00b009e467d90438mr5397879ejc.56.1699910821965; Mon, 13
 Nov 2023 13:27:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231110010139.3901150-1-sarthakkukreti@chromium.org> <ZU7RVKJIzm8ExGGH@dread.disaster.area>
In-Reply-To: <ZU7RVKJIzm8ExGGH@dread.disaster.area>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Mon, 13 Nov 2023 13:26:51 -0800
Message-ID: <CAG9=OMPFEV9He+ggq2mcLULnUZ2jm8fGU=4ca8kBoWtvqYcGVg@mail.gmail.com>
Subject: Re: [PATCH v9 0/3] [PATCH v9 0/3] Introduce provisioning primitives
To: Dave Chinner <david@fromorbit.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 10, 2023 at 4:56=E2=80=AFPM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Thu, Nov 09, 2023 at 05:01:35PM -0800, Sarthak Kukreti wrote:
> > Hi,
> >
> > This patch series is version 9 of the patch series to introduce
> > block-level provisioning mechanism (original [1]), which is useful for
> > provisioning space across thinly provisioned storage architectures (loo=
p
> > devices backed by sparse files, dm-thin devices, virtio-blk). This
> > series has minimal changes over v8[2], with a couple of patches dropped
> > (suggested by Dave).
> >
> > This patch series is rebased from the linux-dm/dm-6.5-provision-support
> > [3] on to (a12deb44f973 Merge tag 'input-for-v6.7-rc0' ...). The final
> > patch in the series is a blktest (suggested by Dave in 4) which was use=
d
> > to test out the provisioning flow for loop devices on sparse files on a=
n
> > ext4 filesystem.
>
> What happened to the XFS patch I sent to support provisioning for
> fallocate() operations through XFS?
>
Apologies, I missed out on mentioning that the XFS patches work well
with loop devices.

I might have misunderstood: were those patches only for sanity testing
or would you prefer that I send those out as a part of this series? I
can whip up a quick v10 if so!

Cheers

Sarthak


> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
