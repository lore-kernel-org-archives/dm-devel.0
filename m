Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C213B6347
	for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 20:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789073727; cv=none; b=GXjn3tVOkpqKLLoroZs3W6OBOHuQbpFat8TaIMLtWJeCzABv28oWkTjI0r1SdelSvYS51Kx7xXoKfi9QLdyj1vkSY9qh4v32YTlJORt/45zLvf752yOjNagcvLUgAepUo7IWh4a0Y4M6zkFxYwksjdlvq7GUwR2pbgyg8notx20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789073727; c=relaxed/simple;
	bh=hFrf47wiCRa+Xp/RSbKkY05XcZwBmlybD2veRYYsg0I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KlhOmF92RU/dVhHdWgDnoFkKfYKQ+yQl5jHkfbTA6+OJksAeWgZJbo+HGdpiP/U9h6szh4pZkLK0EOzDoUKqPski0NRiJUdNhKwjKafsJTS39XtfH3zHRAQylxmS4sVjWkI4Hkz/eeig39HlbDkZXGjtwOJKwpaAT7bAZxeqoJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=NC8MC8Yr; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="NC8MC8Yr"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7eb61bbeb25so289569a34.1
        for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 13:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789073725; x=1789678525; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pkbEmlLYOqHu2rT/pG1b8F4ZrumOvKHVAf/LIvXXM5Y=;
        b=NC8MC8YrWXVm6OvYPakfo0XLgjPJpuQ9f1DkwsOCM8NQ6WFvspW/KvI8xAHHsfnHVN
         aK3jcd9vFEiCq0DSsPIXM8IY1+pHj5klZhw0T+KZxt5SlM3dbGWLYZjF7S083UTHyG89
         ftfHIIU5ZjwAgQuc6NDTlWWWhFApFsVQG+IjyZhMYWsLi1upPWCK3C7Wn+TuNtmK47+f
         04QOTvlnskpj7inzTcKweiQPk+VwuRxnVvQqrMgJLpkgryUBAq/j8ydguvn+JIuw0Gos
         c+E+u0HL0kbrBSaW125lSsXQB07S5SXOgDjbdiZvpBPpYD9yvMnA4Mf93QmWihuTZJtw
         IHlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789073725; x=1789678525;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pkbEmlLYOqHu2rT/pG1b8F4ZrumOvKHVAf/LIvXXM5Y=;
        b=SNtU0PmFmHpHzdlCtrw32QIzSqik9EN4PEOjYj+M/6irnvDYrZVJvi7m9gTwxP54Ys
         7p8EtPIvtT1qVinGqDA5EqaDTgAUu07L8cGeNVU+vYhl1HdwTdYL/pjNMqVlwuy9QYn6
         tb/fujzsO67Y1YFbV3iWoNAnSW7xTj1WVzd1gBS2KTgHPvZZVxvZjIMd/mB48ynIeBCe
         KpkPWcDksscd3pPRB3Hj0JQc1nARzmkrZIrJfbq+Lds/Y0huciulkDdgTPXm6Am30xFg
         6Iri5ppxiCZBT2wh4ASoedRNgWPk8B8W6Koe4mzfvvuLdyn6adekEz9jwuxfaF3vDwCF
         iQYw==
X-Forwarded-Encrypted: i=1; AKwUvBy3EyMgSXC0DU+/cgPwPC48+FlJZrVqvS1JxEYUs4n7a7ZIJ4kl2+LYhrMOjTmnQr4xLKAUEgAV6A==@lists.linux.dev
X-Gm-Message-State: AFuF++lfXuuUB1nbL8ajPXvf5npzN4pWNqTz4NN0OrQgpfKVlVeZqtM0
	rUSWq84OxVOARGnlRsOKg6MvgnnWX6SF+lECuPCqqTw8vELvSeCacyVJ5FUbPgHBxNPDMTxOl+y
	OTXyYcG8=
X-Gm-Gg: AYBFou3u2pQ7wdWFQqCEq9vUzt11kJ4Ii9sWpg6KIS9iu+n7NYVrzeG8VSqlVvA1XnA
	aPQ1Fm6n+E7WsPCGG5ybUM1OiDJKx5nQMlUJpe+Z9f1KaHsENuSHBabY+pIi8FA85pyPDQftiiE
	hlRX4bj0NJZ/PC7zlHk0+yi+rzWUb0UlQsZix64MEbjTAw7NU+6na2WDYRXemfCl8odG21vX72D
	8PSaaXYjYe/a2dFqbjVThaEtNeuy9H76toODmyxCuiE75agYbEHG17yU7VdY6LprQzeAlE8k5Zr
	jA5C0b3g25ZmAOWZkj7rQcjS/JAdQqiDeKMOVgjF40g/eogQ8M9OCVNX8lPJ2lUb46K+Eq/ZQHb
	+KOpkJEEKfIn2vtBFNJ4yEPIK8vZGcJr/fMwLM3zlQzRDXoE69o0h+JO7cMU9g+wDFWIwtzoLQ0
	2BXR4Q27O2+Gw696StApT4vgGYb0vdbxG2tUwk60UIHXh1wavMA94G2en37CRDcwcDdFkmMKVp5
	dp0WW9JhVo8dCONsgH+kKCohhyoKKVBv15tx9NjNseRaAXStBQ=
X-Received: by 2002:a05:6830:2702:b0:800:d883:997f with SMTP id 46e09a7af769-803fec02e59mr471619a34.2.1789073724704;
        Thu, 10 Sep 2026 13:55:24 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-803f60fe54asm635779a34.15.2026.09.10.13.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 13:55:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>, 
 William Power <william.power@intel.com>, 
 Phil Cayton <phil.cayton@intel.com>, Damien Le Moal <dlemoal@kernel.org>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, David Sterba <dsterba@suse.com>, 
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev, 
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
In-Reply-To: <cover.1785596451.git.asml.silence@gmail.com>
References: <cover.1785596451.git.asml.silence@gmail.com>
Subject: Re: [PATCH v5 00/16] Add dmabuf read/write via io_uring
Message-Id: <178907372259.484803.15807864431748251506.b4-ty@b4>
Date: Thu, 10 Sep 2026 14:55:22 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Sat, 01 Aug 2026 16:46:12 +0100, Pavel Begunkov wrote:
> The patch set allows to register a dmabuf to an io_uring instance for
> a specified file and use it with io_uring read / write requests. The
> infrastructure is not tied to io_uring and there could be more users
> in the future. A similar idea was attempted some years ago by Keith [1]
> (from where I borrowed a good number of changes). Later it was brough
> back up to life by Tushar and Vishal.
> 
> [...]

Applied, thanks!

[01/16] dma-buf: introduce initial file I/O infrastructure
        (no commit info)
[02/16] iov_iter: add iterator type for dmabuf maps
        (no commit info)
[03/16] block: rename bi_bvec_done
        (no commit info)
[04/16] block: always adjust bi_offset on bio_advance_iter
        (no commit info)
[05/16] block: move bvec init into __bio_clone
        (no commit info)
[06/16] block: introduce bio_iov_iter_set()
        (no commit info)
[07/16] block: introduce dma map backed bio type
        (no commit info)
[08/16] block: add dma-buf support for raw bdev
        (no commit info)
[09/16] nvme-pci: implement dma-buf backed requests
        (no commit info)
[10/16] nvme-pci: rename nvme_pci_sgl_set_data to nvme_pci_dma_iter_set_sgl
        (no commit info)
[11/16] nvme-pci: add SGL support for the dmabuf path
        (no commit info)
[12/16] io_uring/rsrc: introduce buf registration structure
        (no commit info)
[13/16] io_uring/rsrc: extend buffer update
        (no commit info)
[14/16] io_uring/rsrc: add uncloneable regbuf flag
        (no commit info)
[15/16] io_uring/rsrc: add regbuf import flags
        (no commit info)
[16/16] io_uring/rsrc: add dmabuf backed registered buffers
        (no commit info)

Best regards,
-- 
Jens Axboe



