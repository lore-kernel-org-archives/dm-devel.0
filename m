Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B996763B0
	for <dm-devel@lists.linux.dev>; Fri, 10 Nov 2023 06:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="aqyuKInH"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-9c603e2354fso349462066b.1
        for <dm-devel@lists.linux.dev>; Thu, 09 Nov 2023 22:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699597546; x=1700202346; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=31LtcSKpeisTVB2mz3N5vJ0iqQnYWaagnM9xZbOW8hI=;
        b=aqyuKInHjmm6zj/yyQ8j6dMVcj22RlwJbrynMRyUyw57OJhRgYjT6pADTwWnOTVbeQ
         fakbgPJPaAtrU/aFYH3YqPPTwRgClFtc/Keg/Unkzjq77BrnTFvlHHY6VQQgKyZQdroV
         Rv0tAJOt09Y6CQeRgtMASGAtgiHeuI9FKrvyk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699597546; x=1700202346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=31LtcSKpeisTVB2mz3N5vJ0iqQnYWaagnM9xZbOW8hI=;
        b=KGNsOwVuXZBtA+h1tVPzqR1YojDuoM+H6Md9BPDMd7P+1y/g6DQoJC7eYSKtzByab/
         P1/BuogmqQ1LbnxK8VSka2sE3Y+RneSek0q19o7cXaBuKPl+ns7F1QZzkoPSLy59/Y2p
         eMgCuHq5qWeNJyjvaQYZ3vNyS02MoEZtQgZbgU9GDgKo2O6gGbPzUOvxdHxqkXGfwJtY
         OH92sQxbWCeDawjijAR7HPoDp5a8swBwSsKK6EsmxGtP1vbRKk3BW4uvrtVxRBDMzeQ4
         oRixyGAoFUTnF/iJrVtfMbm4xre7rXfQQ16yNGFkNUXG/rzOtj3tCCnSYvr1HT6o51E4
         Lhdg==
X-Gm-Message-State: AOJu0YxQS1Cy4yaSEsnWmz6KiLXLonwBExGSq6kotY+Z3LHZhO7h3ZJL
	PHGKP2vF+guOtw4rUkUc7/G5DipzaGIDacjA1QCARA==
X-Google-Smtp-Source: AGHT+IEXD1W//MfsTwxhlIUHRcn5eqbDoMdzk+7vyDeixRhGaCIaTU8BxZfUm8hNFI4xtXjq/4To+Yc/OCr/8S2kIzQ=
X-Received: by 2002:a17:906:5ad1:b0:9ae:3768:f0ce with SMTP id
 x17-20020a1709065ad100b009ae3768f0cemr1340464ejs.0.1699597545623; Thu, 09 Nov
 2023 22:25:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231110010139.3901150-1-sarthakkukreti@chromium.org>
 <20231110010139.3901150-5-sarthakkukreti@chromium.org> <CAHj4cs9pS0hgWBpz9bzoJBGwh1iK+0Nuzc5RmJNyZOR5s-7oLw@mail.gmail.com>
In-Reply-To: <CAHj4cs9pS0hgWBpz9bzoJBGwh1iK+0Nuzc5RmJNyZOR5s-7oLw@mail.gmail.com>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Thu, 9 Nov 2023 22:25:33 -0800
Message-ID: <CAG9=OMOsurTDASByqXWiY9W2arWsd6-vNLnRUk2SvgEbPSg5VQ@mail.gmail.com>
Subject: Re: [PATCH] loop/010: Add test for mode 0 fallocate() on loop devices
To: Yi Zhang <yi.zhang@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, 
	Brian Foster <bfoster@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I meant to add a reference to the latest REQ_OP_PROVISION patch series
that this patch accompanied, I'll reword the commit so that it is
clearer:

[1] https://lore.kernel.org/lkml/20231110010139.3901150-1-sarthakkukreti@ch=
romium.org/

Best
Sarthak

On Thu, Nov 9, 2023 at 5:28=E2=80=AFPM Yi Zhang <yi.zhang@redhat.com> wrote=
:
>
> On Fri, Nov 10, 2023 at 9:02=E2=80=AFAM Sarthak Kukreti
> <sarthakkukreti@chromium.org> wrote:
> >
> > A recent patch series[1] adds support for calling fallocate() in mode 0
>
> The patch link is missing in this patch.
>
> > on block devices. This test adds a basic sanity test for loopback devic=
es
> > setup on a sparse file and validates that writes to the loopback device
> > succeed, even when the underlying filesystem runs out of space.
> >
> > Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > ---
> >  tests/loop/010     | 60 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/loop/010.out |  2 ++
> >  2 files changed, 62 insertions(+)
> >  create mode 100644 tests/loop/010
> >  create mode 100644 tests/loop/010.out
> >
> > diff --git a/tests/loop/010 b/tests/loop/010
> > new file mode 100644
> > index 0000000..091be5e
> > --- /dev/null
> > +++ b/tests/loop/010
> > @@ -0,0 +1,60 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-3.0+
> > +# Copyright (C) 2023 Google LLC.
> > +# Author: sarthakkukret@google.com (Sarthak Kukreti)
> > +#
> > +# Test if fallocate() on a loopback device provisions space on the und=
erlying
> > +# filesystem and writes on the loop device succeed, even if the lower
> > +# filesystem is filled up.
> > +
> > +. tests/loop/rc
> > +
> > +DESCRIPTION=3D"Loop device fallocate() space provisioning"
> > +QUICK=3D1
> > +
> > +requires() {
> > +       _have_program mkfs.ext4
> > +}
> > +
> > +test() {
> > +       echo "Running ${TEST_NAME}"
> > +
> > +       local mount_dir=3D"$TMPDIR/mnt"
> > +       mkdir -p ${mount_dir}
> > +
> > +       local image_file=3D"$TMPDIR/img"
> > +       truncate -s 1G "${image_file}"
> > +
> > +       local loop_device
> > +       loop_device=3D"$(losetup -P -f --show "${image_file}")"
> > +
> > +       mkfs.ext4 ${loop_device} &> /dev/null
> > +       mount -t ext4 ${loop_device} ${mount_dir}
> > +
> > +       local provisioned_file=3D"${mount_dir}/provisioned"
> > +       truncate -s 200M "${provisioned_file}"
> > +
> > +       local provisioned_loop_device
> > +       provisioned_loop_device=3D"$(losetup -P -f --show "${provisione=
d_file}")"
> > +
> > +       # Provision space for the file: without provisioning support, t=
his fails
> > +       # with EOPNOTSUPP.
> > +       fallocate -l 200M "${provisioned_loop_device}"
> > +
> > +       # Fill the filesystem, this command will error out with ENOSPC.
> > +       local fs_fill_file=3D"${mount_dir}/fill"
> > +       dd if=3D/dev/zero of=3D"${fs_fill_file}" bs=3D1M count=3D1024 s=
tatus=3Dnone &>/dev/null
> > +       sync
> > +
> > +       # Write to provisioned loop device, ensure that it does not run=
 into ENOSPC.
> > +       dd if=3D/dev/zero of=3D"${provisioned_loop_device}" bs=3D1M cou=
nt=3D200 status=3Dnone
> > +       sync
> > +
> > +       # Cleanup.
> > +       losetup --detach "${provisioned_loop_device}"
> > +       umount "${mount_dir}"
> > +       losetup --detach "${loop_device}"
> > +       rm "${image_file}"
> > +
> > +       echo "Test complete"
> > +}
> > \ No newline at end of file
> > diff --git a/tests/loop/010.out b/tests/loop/010.out
> > new file mode 100644
> > index 0000000..068c489
> > --- /dev/null
> > +++ b/tests/loop/010.out
> > @@ -0,0 +1,2 @@
> > +Running loop/009
> > +Test complete
> > --
> > 2.42.0.758.gaed0368e0e-goog
> >
> >
>
>
> --
> Best Regards,
>   Yi Zhang
>
