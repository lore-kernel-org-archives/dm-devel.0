Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1A43B79D
	for <dm-devel@lists.linux.dev>; Tue, 21 Nov 2023 00:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dHTCexeS"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a00d5b0ec44so95989966b.0
        for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 16:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1700524799; x=1701129599; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hvy2CV8CQ1z8xyF0eqyyieG0M3+ja1/tOprJQEZU3U0=;
        b=dHTCexeST1Viep8cI9dwUh14FKO+NpGEzCpReL9xjd75rDChkbxZvqVcWco9aq2EqO
         qiQuMECGqqhbPNL5KXBUSoBW2jBNNr3jLu9jnwb3DDTj2R056eWSyC/emE/1eOF23n1j
         F3bhO7M3O+oRbaRnWqNETyjsqqG3KqIBbCu8E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700524799; x=1701129599;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hvy2CV8CQ1z8xyF0eqyyieG0M3+ja1/tOprJQEZU3U0=;
        b=hVVC2nWqPlEaKCFWC9bBVZ3jyuuVLhPqBw9jSOqUtisu5m+WoULEbXu72hN/hA+9q3
         KsAxDkbz6oP4kv7bOECWRG3ylTiTBvjXDIksqWgFm5kouigilN0l47CI9Hp8Y7eaRM7R
         df2RbDLmkdjENyKiHe2dSXgRxThGDGmhhhpFf3wdBqNWLmtfHzMEhhtOS4VxJTMOjvJJ
         5FNT27vC3/2GT2HJ/Nth0N/Y408biDtzb8RuL561SLHfYONwT9/TRYS3TuKiN16UKE0D
         Xeg+4svCQfgwtlxJPEDmIyD4zPHUqNt32NERFOAA6FZYi7kUDnghjAte2rm1tgTobzg1
         c7mQ==
X-Gm-Message-State: AOJu0YxUsW5WCapvrJK5u/O6UNOzXXK1wFA5IpaKuacw5RroAl+102C+
	XLYN+dIdo/+edZVayQbPxKtaK6/RJEZ/4vXfE2edTg==
X-Google-Smtp-Source: AGHT+IGS/DMjLcVARh7/W+3Xwjr7CBqtoFkp2YHIj8I+RchJwxdGIbnk77jU2LOk1Rw8ir/jKvddnwjVTa6iwN+tqTI=
X-Received: by 2002:a17:906:5904:b0:9be:e90:5016 with SMTP id
 h4-20020a170906590400b009be0e905016mr6390836ejq.24.1700524799291; Mon, 20 Nov
 2023 15:59:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231110010139.3901150-1-sarthakkukreti@chromium.org>
 <ZU7RVKJIzm8ExGGH@dread.disaster.area> <CAG9=OMPFEV9He+ggq2mcLULnUZ2jm8fGU=4ca8kBoWtvqYcGVg@mail.gmail.com>
 <ZVvCsPelezZesshx@dread.disaster.area>
In-Reply-To: <ZVvCsPelezZesshx@dread.disaster.area>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Mon, 20 Nov 2023 15:59:48 -0800
Message-ID: <CAG9=OMMar0shTijQfehFSktir2vsvRkvH8t69gREzVyLKyPH4A@mail.gmail.com>
Subject: Re: [PATCH v9 0/3] [PATCH v9 0/3] Introduce provisioning primitives
To: Dave Chinner <david@fromorbit.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 20, 2023 at 12:33=E2=80=AFPM Dave Chinner <david@fromorbit.com>=
 wrote:
>
> On Mon, Nov 13, 2023 at 01:26:51PM -0800, Sarthak Kukreti wrote:
> > On Fri, Nov 10, 2023 at 4:56=E2=80=AFPM Dave Chinner <david@fromorbit.c=
om> wrote:
> > >
> > > On Thu, Nov 09, 2023 at 05:01:35PM -0800, Sarthak Kukreti wrote:
> > > > Hi,
> > > >
> > > > This patch series is version 9 of the patch series to introduce
> > > > block-level provisioning mechanism (original [1]), which is useful =
for
> > > > provisioning space across thinly provisioned storage architectures =
(loop
> > > > devices backed by sparse files, dm-thin devices, virtio-blk). This
> > > > series has minimal changes over v8[2], with a couple of patches dro=
pped
> > > > (suggested by Dave).
> > > >
> > > > This patch series is rebased from the linux-dm/dm-6.5-provision-sup=
port
> > > > [3] on to (a12deb44f973 Merge tag 'input-for-v6.7-rc0' ...). The fi=
nal
> > > > patch in the series is a blktest (suggested by Dave in 4) which was=
 used
> > > > to test out the provisioning flow for loop devices on sparse files =
on an
> > > > ext4 filesystem.
> > >
> > > What happened to the XFS patch I sent to support provisioning for
> > > fallocate() operations through XFS?
> > >
> > Apologies, I missed out on mentioning that the XFS patches work well
> > with loop devices.
> >
> > I might have misunderstood: were those patches only for sanity testing
> > or would you prefer that I send those out as a part of this series? I
> > can whip up a quick v10 if so!
>
> I was implying that if you are going to be adding support to random
> block devices for people to actually test out, then you should be
> adding support to filesystems and writing new -fstests- to ensure
> that loop devices are actually provisioning blocks at exactly the
> locations that correspond to the physical file extents the
> filesystem provisioned, too.
>

Fair enough, let me work on an additional fstests patch to validate that.

Best
Sarthak

> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
