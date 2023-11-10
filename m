Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A40627
	for <dm-devel@lists.linux.dev>; Fri, 10 Nov 2023 01:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ikm9oFhP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699579687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zC+u4Re2AoTUGpqWOoMx+tYjldUA5tL8xtOql2ozAF4=;
	b=ikm9oFhPOb19kPDF/ogY5eyRNaXuCjl/99wVKoXm27tKhbLLoOqsMxz37O4X/P/pPh+IIu
	mabszhLa1gSa+QtOvzYfUMpxmLB7w/Kz5P3/hScEXrBhoI2o6KlNXcXhIjvn8DwsFkLnbl
	OtgAQlzihsRn+UzIepOT6dn9PQQ0PfE=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-4h5-hz7iMvuzqa4R2Mf0dg-1; Thu, 09 Nov 2023 20:28:05 -0500
X-MC-Unique: 4h5-hz7iMvuzqa4R2Mf0dg-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-1e987fa0d87so1386230fac.1
        for <dm-devel@lists.linux.dev>; Thu, 09 Nov 2023 17:28:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699579685; x=1700184485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zC+u4Re2AoTUGpqWOoMx+tYjldUA5tL8xtOql2ozAF4=;
        b=Jy2Qs/EDeOc4wVk/1LnL6sY8NM9UyFTFt831zIG4RFlZB1KrQsTgH8beQc7KG11jvt
         BqXVvzUn7AHyeBzHnat7K50U6FRF4FGCx9yT/oM5L+8k0fkBpDiipZc4umybPr3Pxorj
         KTW/nwP3RX3XggsLGwzkAQ6LEc7i4pOiME0fzl/bKa2WZ+qjBBFsCjrpTtlQDv6lr4jC
         Zf/ZmR4GSZtMpZyPi87Ef4seBqjEu36Xv3X8iP/qrdVfx9/PgL2YFo5lXCAtwQhJGZ+g
         9zqz12a8Lxx48CECzlWZidTSkht07arLa4SFexlTkLvFzG03cIQ3AhPTxmuQbVq3MdLC
         VBGg==
X-Gm-Message-State: AOJu0Yw4yxzUxOqNG7hS8D+VMASUFq7WifHkEc5qUkSNtl/XqvImHQ5w
	ouVwVF9HuLOE4VzhGRrzadSoM5gdN6yhwhGZJXx/zLdOAgFQY9rNwABH+4j8//ywup6rPKxCCnT
	y5XF8qHOnsq5x2NBCVMbmHf3oHkzFPpL8idA=
X-Received: by 2002:a05:6870:1314:b0:1ea:d76b:1457 with SMTP id 20-20020a056870131400b001ead76b1457mr6624727oab.7.1699579685236;
        Thu, 09 Nov 2023 17:28:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGY6J8ZouDEA5qQMJiaMxmBZIrQRVPu28NAIQ+CGdUvmcYPLrHluYLqjgbiUv9YwzmkiYQWWU0SJT6gXHqvqxY=
X-Received: by 2002:a05:6870:1314:b0:1ea:d76b:1457 with SMTP id
 20-20020a056870131400b001ead76b1457mr6624714oab.7.1699579684985; Thu, 09 Nov
 2023 17:28:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231110010139.3901150-1-sarthakkukreti@chromium.org> <20231110010139.3901150-5-sarthakkukreti@chromium.org>
In-Reply-To: <20231110010139.3901150-5-sarthakkukreti@chromium.org>
From: Yi Zhang <yi.zhang@redhat.com>
Date: Fri, 10 Nov 2023 09:27:48 +0800
Message-ID: <CAHj4cs9pS0hgWBpz9bzoJBGwh1iK+0Nuzc5RmJNyZOR5s-7oLw@mail.gmail.com>
Subject: Re: [PATCH] loop/010: Add test for mode 0 fallocate() on loop devices
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, 
	Brian Foster <bfoster@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 10, 2023 at 9:02=E2=80=AFAM Sarthak Kukreti
<sarthakkukreti@chromium.org> wrote:
>
> A recent patch series[1] adds support for calling fallocate() in mode 0

The patch link is missing in this patch.

> on block devices. This test adds a basic sanity test for loopback devices
> setup on a sparse file and validates that writes to the loopback device
> succeed, even when the underlying filesystem runs out of space.
>
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> ---
>  tests/loop/010     | 60 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/loop/010.out |  2 ++
>  2 files changed, 62 insertions(+)
>  create mode 100644 tests/loop/010
>  create mode 100644 tests/loop/010.out
>
> diff --git a/tests/loop/010 b/tests/loop/010
> new file mode 100644
> index 0000000..091be5e
> --- /dev/null
> +++ b/tests/loop/010
> @@ -0,0 +1,60 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-3.0+
> +# Copyright (C) 2023 Google LLC.
> +# Author: sarthakkukret@google.com (Sarthak Kukreti)
> +#
> +# Test if fallocate() on a loopback device provisions space on the under=
lying
> +# filesystem and writes on the loop device succeed, even if the lower
> +# filesystem is filled up.
> +
> +. tests/loop/rc
> +
> +DESCRIPTION=3D"Loop device fallocate() space provisioning"
> +QUICK=3D1
> +
> +requires() {
> +       _have_program mkfs.ext4
> +}
> +
> +test() {
> +       echo "Running ${TEST_NAME}"
> +
> +       local mount_dir=3D"$TMPDIR/mnt"
> +       mkdir -p ${mount_dir}
> +
> +       local image_file=3D"$TMPDIR/img"
> +       truncate -s 1G "${image_file}"
> +
> +       local loop_device
> +       loop_device=3D"$(losetup -P -f --show "${image_file}")"
> +
> +       mkfs.ext4 ${loop_device} &> /dev/null
> +       mount -t ext4 ${loop_device} ${mount_dir}
> +
> +       local provisioned_file=3D"${mount_dir}/provisioned"
> +       truncate -s 200M "${provisioned_file}"
> +
> +       local provisioned_loop_device
> +       provisioned_loop_device=3D"$(losetup -P -f --show "${provisioned_=
file}")"
> +
> +       # Provision space for the file: without provisioning support, thi=
s fails
> +       # with EOPNOTSUPP.
> +       fallocate -l 200M "${provisioned_loop_device}"
> +
> +       # Fill the filesystem, this command will error out with ENOSPC.
> +       local fs_fill_file=3D"${mount_dir}/fill"
> +       dd if=3D/dev/zero of=3D"${fs_fill_file}" bs=3D1M count=3D1024 sta=
tus=3Dnone &>/dev/null
> +       sync
> +
> +       # Write to provisioned loop device, ensure that it does not run i=
nto ENOSPC.
> +       dd if=3D/dev/zero of=3D"${provisioned_loop_device}" bs=3D1M count=
=3D200 status=3Dnone
> +       sync
> +
> +       # Cleanup.
> +       losetup --detach "${provisioned_loop_device}"
> +       umount "${mount_dir}"
> +       losetup --detach "${loop_device}"
> +       rm "${image_file}"
> +
> +       echo "Test complete"
> +}
> \ No newline at end of file
> diff --git a/tests/loop/010.out b/tests/loop/010.out
> new file mode 100644
> index 0000000..068c489
> --- /dev/null
> +++ b/tests/loop/010.out
> @@ -0,0 +1,2 @@
> +Running loop/009
> +Test complete
> --
> 2.42.0.758.gaed0368e0e-goog
>
>


--=20
Best Regards,
  Yi Zhang

