Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC9A3955D1
	for <dm-devel@lists.linux.dev>; Mon,  3 Aug 2026 13:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763303; cv=pass; b=SD0YWGPLrAvXgh+6iWVrp2T86boz0WQcU1EQK0fFa1XAFLYY7k61vO4upL8dFT+a+otT3dCIwcv3q6o2OiOzyGUhUuQe7M9XFFlR6l1+8dsbJ5abWnkSEWtL3AZYAn4uVtyjR53P71oqOncHa2UH2uKS00PmhsWT0JUmrpgZemM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763303; c=relaxed/simple;
	bh=Pgl5mTcqFOqWGOQn2TZduStirxwuSm2pRwIjZSucJwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hlgh5VyIKDr5S7i1WTuZHAhKYf0y1/xzvkRuzPT6JbajBWz5d2dy4wATyacZAgEG3ZAGscI1Hrz2uL/PNDxv7hbFylhOA0qHsQ3aqQRBTfM4Kt60o2D36E0Mg/LojN+89K3ECFj1oJJyhxFSV5ZUzS+ZzUhM8QCFWgJtt8JgVK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AJdh2FVL; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AJdh2FVL"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a063d211ebso4269927a12.3
        for <dm-devel@lists.linux.dev>; Mon, 03 Aug 2026 06:21:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785763289; cv=none;
        d=google.com; s=arc-20260327;
        b=UFrS6tQYW/z8gfYsvspjaIet58joN5yVtnzirFvLHeEZtXWfTH0/wP2HE120Z9JvB0
         cbTzNBZtQ7skgTWHX4ljYAHJSsRtGKWHz1rFV3/Xm/7m1a312H7mzgIIpo/ZufEx0JIq
         nMlHPMhHryciEZNWOwjTnNKo4OJq6GfLsQdgrRQ38tkxjcsR5qpdnREKu59Z3pSuHGiX
         ikBb4ZulFqA6Gx5o0+p26yN/AYLo3xfHspEITKCBAIlEW8KsQDp/Pb1HD9whcJPxKN6J
         UUmVWRcQUsxK+XB176hXM/oRRzGRRe1YdRl62GFOjU2gJpWx22iWq6p0GF79hw6DO+A0
         JB4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y/+lXFVTL8yRFLlIHwc83PXR9zbnjKq/x3zTQK5cH9A=;
        fh=MwCGKDOlKuSobosFmrpiRzLDnE32pXcuK5HNrfjKHeU=;
        b=ZH2sLBaqSSDFNfOqGkJpR7yTUdMfW5dH1HUYTaV0stZSOe3JNeVQPnG+xBcNo6gjhc
         CfsEhjTGhdKsCjtdVk8rNNei5MJS7Upk4zCXsS2fiTW0YyWPoqPEkTf62gJHKlbFMmXA
         tfMiD5sYWH8OqVELeGIJYzOmdocQ5xFEkQx3ksgmRX/+qlUUKtSV/h6HoW9OE3Bit9Ma
         /1YeJ3OdVYIdQ0Ubdv2es7X+aWlNF2kkUrPOH3YYuAdGc5sC+Yq8bG7V9upiB6UyJaUn
         gRtEQdyI/CzdIG1rs7eP3+gG8DL3fE3lgMU4vcMFm2SrrflVnS7feG2egPkarS37WDQs
         b1Cw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785763289; x=1786368089; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y/+lXFVTL8yRFLlIHwc83PXR9zbnjKq/x3zTQK5cH9A=;
        b=AJdh2FVL6gWbsWLNmfIk+ct1vGc/Asc90nSEqoScqLtt5vo9uy9sHuYQvAo4MHa6e2
         5dmwi45+/YxKX8pdMVQ6qha0VBD55vskwfTHjPQVDLStBltOhsf9bnI9mMbP9dkoRkrQ
         ATXkBlFhq+eW7CSRFEDQ1RG/0XYGGmLAZMqpr+9LMr5xTf2ptXVyLW9jVA9W8zYyLGDo
         97AoWbQSreA4iyUwOfShptGG2ULH8bcaBBi4nq3jyiDPMqMOwLCYA+C5PtCa/ZrLZhuI
         aqGu+cNuhY0ijoY1T3rPr0HvYkGi+nPmVgOGXEHrskmkv7zl4yWJ4urRBYsHH/7cnDa9
         CXGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785763289; x=1786368089;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y/+lXFVTL8yRFLlIHwc83PXR9zbnjKq/x3zTQK5cH9A=;
        b=oRAlXK1ZfQWDPyFoGM6mqEsGltx76/LanbIfnRABg/v3T9YJwz/YNl8uu+3SpwYZk0
         DvlTxbRw9Bbw28/gtp4lWI4Z6QfsPRZs78AqELizKW0ItKmqL8WynS58ghpTZ6h37ZWF
         yXFBkM7u5tfgz13A6+gCmHQfJK0Di1GbCW8h+ofxtZIYtLMJEHJU/but9n+Cv+gkPWq5
         eJq5WZESrKxoRDzyXYyfX5aEMuRX0h1Qb0ZdfQxgPXGnPAjQzwHlcIIaWwcFZyo/ahZj
         w9s6hycn/DYAmX2LNKA8G6vkJpC3wjFjBaFVNisQl8WcYq8lOwxjT/l2yeIdvwzKQMC8
         bw7A==
X-Forwarded-Encrypted: i=1; AHgh+RrLRIhps4z8WNDp2u/dQv81iM04mr1/s3eqwqQqi0xYpMbzP9ViTQoRjcjQnyK6fbdBBTEWpuZvbw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxIT2wJTSadnnDMDWoq2OsiBAzl5LFxc+SR/ob+Yz8dtfBuDcre
	/Ad1ILatW9Et8uRNM1ya+Kco3QCO/THhCp+qgzGN2w5XtkAZrvAn6RdDo6g2+hLIju8jOKKsXPH
	CEqY+ctg7f6N3K/aUbDDizMLHBW+qiQ==
X-Gm-Gg: AR+sD120SGGJP2fUpyxDHlOssw19bw2DvNJJiqOTNtOS36tCuttZZzudBAyL68I9Nj4
	BUAcuGHPf2cfziIEIjyoMvsOG2wFM+9jItE58IeU+aRNZy2NODAHjOSSwuSS0vTOXl69+jn8G49
	XS+1QiZf91xA11LK1xhoPCoXY1t26vDLQKHHqWB+/zKUIrDcwAHd1uroRT5ObMt6n/jrMGmiMK2
	iHeoqnwQwmKtIe8pUk1rSey45A1bTZLN9PtHZISPBYgUG57Q8htE5xH89gCq7Sj6OUtLo/YHMfu
	y6v8z1DexXBG9FO94UUD86mwVC0uXbKVkPmV20gpVY4lLGOjp+/zGHoXx9hBLMhTKDmFzhpeFrm
	Qe9AhfdhQ9TCKdR8=
X-Received: by 2002:a05:6402:21d9:b0:69c:794d:4862 with SMTP id
 4fb4d7f45d1cf-6a0a7c614f9mr7875783a12.7.1785763288576; Mon, 03 Aug 2026
 06:21:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785596451.git.asml.silence@gmail.com> <c1ab6c0db3853b339a89aee0b1a9c5ac0c48b79e.1785596451.git.asml.silence@gmail.com>
In-Reply-To: <c1ab6c0db3853b339a89aee0b1a9c5ac0c48b79e.1785596451.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 3 Aug 2026 18:50:50 +0530
X-Gm-Features: AUfX_mwnLWCAPfRurFp37qU73Xc2KDpD6en6Q3cA2kgelroMq6uNFVC_YKEZqSE
Message-ID: <CACzX3AvwBF32_ODomei3XHSZ=KtRaWLN-_Tfkwv7sV3Ssc3wmw@mail.gmail.com>
Subject: Re: [PATCH v5 02/16] iov_iter: add iterator type for dmabuf maps
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>, 
	William Power <william.power@intel.com>, Phil Cayton <phil.cayton@intel.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	David Sterba <dsterba@suse.com>, Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev, 
	nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 1, 2026 at 9:19=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
> @@ -841,7 +857,7 @@ static unsigned long iov_iter_alignment_bvec(const st=
ruct iov_iter *i)
>
>  unsigned long iov_iter_alignment(const struct iov_iter *i)
>  {
> -       if (likely(iter_is_ubuf(i))) {
> +       if (likely(iter_is_ubuf(i)) || iov_iter_is_dmabuf_map(i)) {
>                 size_t size =3D i->count;
>                 if (size)
>                         return ((unsigned long)i->ubuf + i->iov_offset) |=
 size;

dmabuf_map shares the same union slot as ubuf, so this reads the map
pointer as a user address. gap_alignment() below already returns 0
correctly for dmabuf - this should too. Checked the rest of this patch
(advance/revert/restore) - none of them dereference the union pointer
for dmabuf, so it's isolated to this one spot. Doesn't affect the
current series, nothing reaches this with a dmabuf iter yet.

> @@ -872,7 +888,7 @@ unsigned long iov_iter_gap_alignment(const struct iov=
_iter *i)
>         size_t size =3D i->count;
>         unsigned k;
>
> -       if (iter_is_ubuf(i))
> +       if (iter_is_ubuf(i) || iov_iter_is_dmabuf_map(i))
>                 return 0;
