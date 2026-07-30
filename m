Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0654644C518
	for <dm-devel@lists.linux.dev>; Thu, 30 Jul 2026 16:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428267; cv=pass; b=WNBvvXqBIz9JEF562VRpvT1LYMoucKv/QCf/jsKMVJeZqlz6C5TWe3LnbiKM1B1TRFq9xxislKIQcz/MtAbeculkZgpe9+G8B6/UvHeFpnmUq0qE3kT1ZbzK15y/sejbeNMph/Ezd9WAnhdFPV0EJuHGUNb1v8csW6+dtagJ4DU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428267; c=relaxed/simple;
	bh=y9uL8axv/bSBp1hJEk9/5EREqK5uThhZ6LCPv7JfjT8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pjUKAFxKyQff/YqcllRibFAwd2WEYDxHDgauwOWWgH3eiY/tBIc2UICZ2BzEBAPIi/UhzyglUCVFcP2wG/pZHpreo3cCqXYiTOnwC2MMUmpNIRY10U7qc5sUB2eGw8qlz0rTDztEz9BUPZUvZ3UzSdaEQy0D9aOZZiznEXTNMxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=alxrqlQ8; arc=pass smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="alxrqlQ8"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-44c43edfcceso6622fac.3
        for <dm-devel@lists.linux.dev>; Thu, 30 Jul 2026 09:17:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785428264; cv=none;
        d=google.com; s=arc-20260327;
        b=HXYF8+r9l17qr43hzx+WX5zqyPprv+jwVJ2bntYLoZRRoNAZHrMrHwwG9HfZNPV1pp
         eIXCGiljMUZqbpjBdWFvSx2Tjeipe55JOKZdXFsZPtbBdWTXd8HHQdDmKvZlj/1sxO4D
         pQY3snPHlFVjpfuvW5899DNt9a1zA5/5tRsHXF1CLgmvnObZumrf8jSTX6kiWpbuvk/D
         sgz0p8t3X8BuOyO/8JsReUgfJF+uPUpIX9YKReGdYFJrqTjtaPRlmnYQUBIPzuzieAKA
         ViT2tM+30KYNM7X9rPd23Aha/MEKwJbUigoypNYAB4qR7YB6+F/Kd9KGBMCzbz3Lrc8t
         AXeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y9uL8axv/bSBp1hJEk9/5EREqK5uThhZ6LCPv7JfjT8=;
        fh=m5EQRcUi9g8vHZSFhbRkrBxnbZ7uL29Mqyd1qpx5iW8=;
        b=SNiJp3ooDDHdP/1NIDSps2EpCbXJyMNvmYPwbfkzIJskR080wJmA0wNvZhtDVC7Cnn
         3wG26+92r/B5pFpoNEhmN0l6oGt+z2eh+6SigudkUqSpwcJtIuvfrfExcCVjiTAQRgZI
         SoAHNyNx8TI6E2Itc2SzsXemYW30ZHTPBkGtSSxzTP1JchZ/on7tJBg1OEyPjfeKdvSn
         /WahXNrX7efrDKwMHn9K+zFe3qr3G02gL3aMDaBgZIVIuNn8CR+qFiiPDAFf00BPsyNp
         ebdXq2W/rbVg933nrj8uQprcw9+5I7P+9jybq41jNae40r6sfqU2fBvNZcEcOPMtkR3R
         jyoA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1785428264; x=1786033064; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y9uL8axv/bSBp1hJEk9/5EREqK5uThhZ6LCPv7JfjT8=;
        b=alxrqlQ8B9ZF2dBww0GZBnaMs1s5AM5svOYqzmjrWLZXqBD4BP19iw/T7qgUI5XQ8v
         lSpw4FQuj0/YxaUlvPrEgst81DDBM9RJN0RIVj5i9CwH9ShO8sFPLSYyI/0Fq3U2D0bk
         F9fQRvDzpnyZrVINWwZfh8A6pc4HOZElN0IP7Q5TxS+XG0Hk8Jy2bEQK85vVNrXKmGha
         jb+baDfa18LK863lDy91NvTI8kHaEv8vtjcDDjAhzRyFvlkFQ2wAl0j3a9pm4ny1Oblf
         nr6IhlhXcpMxuDNmczClIoWlMdyuXj+1Oa5ICFa6X2k4EvLUj6Yj0fZq2CQVZnLLAvT9
         evMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785428264; x=1786033064;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y9uL8axv/bSBp1hJEk9/5EREqK5uThhZ6LCPv7JfjT8=;
        b=TM5gO3stR75ba5zknzvOmKQNBwS47EVPKPakQT7bh85Hmrdn6+9HKZNbHRYJXJ8kv1
         saXlnaa+F6+Zu68AT9FlLNXCSUFmxjtFBSTI0Xk0ZjyfefYVgzbysmLeGusqciKcvRyi
         /u0Uzgu4V9lnE9iV/RZ9icIr8jZz05RO3rWzZFnUsumFgY3rV8FK7e1i/l1PIH4bmsj9
         ylWqGgeqhiN6HIqel0unghB5GGmXEeNGMq1sIWSZYzQmOwnji3fwEQFAAopZU/h1A96j
         qotCzJvFZO1fZMfLktztZN1wDI6YA4vnM/ZU7G3suAZF50dTSr7iwnpqH0a0apSwurI8
         eYtg==
X-Forwarded-Encrypted: i=1; AHgh+RpFt0qh6GYV4NblR9PC7QB51/3r1szjj0FuDm7ytTxEpFwq28q4awKCq46pN0zlYABf/uhzhrJkrw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzMpdqkBoL6l6fslIuF49zmtsfz+KxcVNr5TCBKHGvfBcuY3T00
	/wV9SHnY6boBZjdzjZwjDSDVmi3rFLPH8bIXPTgR19AkcZdRL1hbg75Nr1WOLwcHmwfcuc5YBzc
	pEhgM2DYkYgPNSCpsQRKv3fsFiRcRhHNBofzFuQZUKQ==
X-Gm-Gg: AR+sD13Ot26QuoAsswfT9W3kNzXOyGehW0KqfsYfwKpu/9dvY7QpU4w8d6efoZ+PZay
	MQtJxq1DRvCM/gmC7SLcV28l2496a/wjwq5Q2ywq5RbF7Sba7GDmCBDYH7jNZ+yCVMrbFi/YKCI
	454dXvRxxLYggGOG+A2wFGoQlJxnJ6KHkwez6BOQGQtkXIOhpj0+dK78ltNzG4YU1sl79X35Vw4
	MNxpg0t6t0WGM5H+9a/U4tew1M4DKZ8WP5MnFxBsV0HMPu4evJTN992SZZTzlxpKpvQuhLx+sMh
	JzYXXHlm/GO3i7QCQjTAittk0qk2OfDNEXzKCPsl/KHr
X-Received: by 2002:a05:6870:610c:b0:448:8595:1e8b with SMTP id
 586e51a60fabf-458dd203cc6mr828125fac.4.1785428263717; Thu, 30 Jul 2026
 09:17:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785274111.git.asml.silence@gmail.com> <19e5c945ea8114320c10f7951d19197d48b59249.1785274111.git.asml.silence@gmail.com>
 <CADUfDZpwF0jp2e=+c3w_NjWPbnQ858bkSD731M6+x27jzgcJiw@mail.gmail.com>
 <CGME20260730104131epcas5p4b52720519486f7ac774c317923a79c81@epcas5p4.samsung.com>
 <de4ec386-42ba-41c3-bcbe-1fe8b2f71ba9@gmail.com> <09134617-6d9e-4963-9319-1855e88a4df9@samsung.com>
In-Reply-To: <09134617-6d9e-4963-9319-1855e88a4df9@samsung.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 30 Jul 2026 09:17:31 -0700
X-Gm-Features: AUfX_mzVuCLkHKoQjKU1BgpL-X0Ty4OF1wEt1trnCKGouEKw-m3DZTMxHTHiuQw
Message-ID: <CADUfDZoVUHMWK0KBnznB73o6Vg+iQBBzJE2NmF1Tf22Zvh4=Yw@mail.gmail.com>
Subject: Re: [PATCH v4 08/14] nvme-pci: implement dma_token backed requests
To: "Anuj Gupta/Anuj Gupta" <anuj20.g@samsung.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Sumit Semwal <sumit.semwal@linaro.org>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, David Sterba <dsterba@suse.com>, 
	Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 4:36=E2=80=AFAM Anuj Gupta/Anuj Gupta
<anuj20.g@samsung.com> wrote:
>
> On 7/30/2026 4:11 PM, Pavel Begunkov wrote:
> >>
> >> I wonder if it's possible to perform the PRP list page allocations and
> >> initialization in nvme_dma_buf_io_map() instead of the I/O path. The
> >> NVMe dma_pools are per-NUMA-node linked lists protected by spinlocks,
> >> making them significant CPU hotspots. If the dmabuf registration set
> >> up a contiguous DMA-coherent list of PRP entries for the pages of the
> >> registered buffer, any command using the dmabuf and requiring at most
> >> 1 PRP list page (i.e. length <=3D 2 MB) could just set its PRP list
> >> pointer to an offset into the dmabuf's PRP list.
> >
> > Possible to an extent, predecessor patches tried that, I left it for
> > later to keep the series simpler. I guess chaining won't work in
> > general case.
> > I mentioned this to Kanchan, Anuj and Nitesh before, they were up to
> > playing with nvme optimisations in general, and since sgl from Anuj
> > is ready, maybe they already have a prototype somewhere for that.
> >
>
> Right, I have prototyped the PRP list optimisation before. I will send
> it once the initial version of this series lands, to avoid adding new
> review churn while the rest of the series is pretty settled.

Sure, landing it subsequently makes sense. Glad to hear it's already
in the works.

Thanks,
Caleb
