Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DC746982C
	for <dm-devel@lists.linux.dev>; Wed, 29 Jul 2026 16:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785344013; cv=pass; b=ZCwif83A/1ksRp4UZ09JyfX1KzB5sAsqKHg1Ea4YvKA69sUrqVpTl+noHKgLiLp9rFnEcuEdSi4loNvoohliW/i/p2dwcPJapANcD7P/tVxtw65bV5FtZETgK0UGSHkyPvhmC0NJsRZshh37uI9SfTmGtnNYP86v7n8YUIFlrJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785344013; c=relaxed/simple;
	bh=/YYV8EJ3uAY8vVlHWLu4xPFSaaoxJidP5IaWXw3aYyM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qPK/ede2tgN+1tuX+5oa+I7nF5UvTSn7RtKGSLv80gx5Cw+klC8wmgOF8LRmGyKU6xkkgCAOBBvpCH0Fjy41rixy3k10JSnjfSLGv7alu2240KN7gJy+Y4BBY+KXj2Q1tgXukB+JeoE/3PnQCx1pR/4g0MtPF5qL9WsNSgO5sjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VUa4DUnL; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VUa4DUnL"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-698a9f11776so1760227a12.1
        for <dm-devel@lists.linux.dev>; Wed, 29 Jul 2026 09:53:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785344010; cv=none;
        d=google.com; s=arc-20260327;
        b=RFIMx2sPxZPw4ijp8qJa2G2oS8YZdVwL0fbe+h1lT1n6XlZ9l9IBld27uEyUrrdP2h
         YJt4YmAaK5kMtWwaxnARzVGmlw0ChA8u5n+HmcrszJSlSnAkQF3j1QTfCqFTftHacZza
         gKIuGANubSb2nIN1E8BFziLi6DGzJ7aBe0cf1WyvHWLSRtdikHkx1PYpdmwlPfjvkQO+
         72swaeJALEhnSv4D9LmVm4GjPC6Hu4oLCXiU5bUydpuvXM6+eey6FEYh70Z2RVNXUAuN
         +wl2dFiZTxLuD5t4z537d4+5GukMtA2WpWoQ+vP8vR79LIbyzWhs+guO54VIz9XnAxCj
         Dc2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iRO7Ed4PohyaBZ/SmZ+npcgI12Qnh1MLhDgk3TF8jow=;
        fh=iL8EGNlEzLJtVV/OvQad7Z3jlNUB3ccARiQF8XVdiPc=;
        b=Mt13Wmtp/vpc6vDXHr6fdKdoLQgbSSt/N8tTzcmoKDbHl1cuSKlP5vgBXpUHJaAKF8
         pAOUcNKV/jYQ63eeYl0BfYH9GyIjQrp47DpOgWcZNCAcDdaOAc0hFPtg9Hi+nzq9wdNr
         u9BltNF4H1D5idSoQ064fXKmQfnSd9MMU0nqyPJTty18xy33ODi/fMH8+pPI6hoZrIbO
         dQGms05BqqzhQEVg7daehx8byWZ7wsMkMCS6ZDpgpAOrN8P7QJJ3f42XABXEqBOcS0CP
         RewJnK4sma/3Ui1A06mPvrhRDr1O1M3W8dXUs8sBkneiz3XxM1zwMQRK3w56A7XsRYfO
         /0hw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785344010; x=1785948810; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iRO7Ed4PohyaBZ/SmZ+npcgI12Qnh1MLhDgk3TF8jow=;
        b=VUa4DUnLOwJAp82inCc5111as4d7Rzd6+gfIcgYZuvD7N3LxnAEVrC8pF39WkiOvC+
         ujWnUdzylfe3EpXq7pn7nCaKWaKpnH1p4XA92UD3ySyLNtJ/yYiCifn9h8t6h7H7CspD
         jivcyuzaEm3hQUoqqQRglqMyBkC1Vw+MMEyApLtqi/B/f/1BJVFoTU/BTcfvKLlTra/f
         Hh0AgDmUz71FovxMAFbdUlq7pf80NZXyQok51gyGvIP0wvIrOffGeQN7D3HY0ZJamY38
         WxL5rerGJ/MT91+LsZGpsipmxMm+qpLhfwmStKqLAF2gmoMM0hcG9ZCinyzfXXZnHA8T
         mB5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785344010; x=1785948810;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iRO7Ed4PohyaBZ/SmZ+npcgI12Qnh1MLhDgk3TF8jow=;
        b=alWJrfCVb9mcPzh2TVTJXinwiBtek/E+6/JGzFKabFagbMfaaQmnPfP4H8IPGcOhLz
         Veyz4Jdl90oBjHRq6LT/r2yajjUQzZxVsl8WJSN3w44k4RbQN6WNqixPFaRmRx3mstxG
         mSz76teTMg8wUOrJWl4Q85wtzFAS6usXGuoccF99BrU+QSI7Zmem0k6hVM6Xb+HyIEn0
         smVRZ3Amr+fWXzokGUSOIGkINaQ4XUE0owzheUx7a11YKpVaJVRovgE9Mr3INKi7qgHe
         rVwsICPxjhOoXdYXAlHF9+LDShVhXZ/e9BFtYPkAgiJNLdkPTTxXAy/c2S1lEerowG+z
         vnRg==
X-Forwarded-Encrypted: i=1; AHgh+RqIYpzL74gzQ4YlEIuzEpQSpV+oNT55I2XAwkPMCbJx9F598njzwloudl4BGESBCUIApmoQde6OdQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3W29lQHLXn12z+FW9kUpFbN/gm7vOBx3S1FF5TlFrSIfFb2EF
	hX+D//n6JgBpnOt57e6giX3muugS05SJpS8phVMjX1nH+MuVb5VvsAbcVy2t1mCFe1bLrcBe4y/
	pzv066iYnW4LJ1zFZIi/f5Gcba0pImw==
X-Gm-Gg: AR+sD120gugKxMpoktOit4APTFb+Qay2kzpcqgkpWtDSWnqSTtZv89G5kwjIahe7IAE
	8K3ts5B7XIN/Z9XIAbiylN3szaHSpcNB4KSkr9j8mLtLMXj3nV1w0Og6ixqQ8Shrpg4vsEH+liE
	kJ6spkDJVc02KmJmmI4WElukmRePjaWmjqDvY2Z7hwvMu5RIpwaqskyhNX6hofLwG0GrHj/7MnR
	UI6XsRMiL4yVxkJuS7GqdjSS4XSljjc5A3L0saLU7RROz8wKjloqPc2cBObUmihpiLGvSmlMjFw
	jpk7vyHsgqC8n/ClNj4WDB9w8uZW6uznY2XEv6YjynrGDNv8TIdfHJdylruOHmKoenZa3sL4byD
	p0wJQwP7MhTI4G+9lFg==
X-Received: by 2002:a05:6402:5018:b0:698:ae69:3992 with SMTP id
 4fb4d7f45d1cf-6a0349ec697mr4404066a12.16.1785344009469; Wed, 29 Jul 2026
 09:53:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785274111.git.asml.silence@gmail.com> <CGME20260728213020epcas5p1721e72ba5544abf0b61482da005120d9@epcas5p1.samsung.com>
 <26dcd0ae5c87a3ada5710b14b6894ef343cec6fe.1785274111.git.asml.silence@gmail.com>
 <583fdfb2-5368-467f-a388-6d388859c995@samsung.com> <0df2f832-e8a8-4fdd-a5b6-e08657c2891f@gmail.com>
In-Reply-To: <0df2f832-e8a8-4fdd-a5b6-e08657c2891f@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Wed, 29 Jul 2026 22:22:50 +0530
X-Gm-Features: AUfX_mw2n1ETd8ASN5Vcu4oMSqcqp6oKyV0zFdoD8l7zvxibNrqO80gPOx-5lV8
Message-ID: <CACzX3Atj+hJmF+Au1Yw5KMk--EHy_J=7Yof1aQNkUV0hCrdVEA@mail.gmail.com>
Subject: Re: [PATCH v4 14/14] io_uring/rsrc: add dmabuf backed registered buffers
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: "Anuj Gupta/Anuj Gupta" <anuj20.g@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
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

On Wed, Jul 29, 2026 at 7:37=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
> >> +static int io_import_dmabuf(struct io_kiocb *req,
> >> +                       int ddir, struct iov_iter *iter,
> >> +                       struct io_mapped_ubuf *imu,
> >> +                       size_t len, size_t offset,
> >> +                       unsigned issue_flags)
> >> +{
> >> +    struct io_regbuf_dma *db =3D imu->priv;
> >> +    struct dma_buf_io_map *map;
> >> +
> >> +    if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
> >> +            return -EOPNOTSUPP;
> >> +    if (!len)
> >> +            return -EFAULT;
> >> +    if (req->file !=3D db->target_file)
> >> +            return -EBADF;
> >> +
> >> +    if (req->flags & REQ_F_DROP_DMABUF) {
> >> +            map =3D req->dmabuf_map;
> >> +            goto init_iter;
> >> +    }
> >
> > O_DIRECT is checked only during registration; we should recheck
> > (file->f_flags & O_DIRECT) per request.
>
> Nobody should be able to clear O_DIRECT, unless I missed something?
> And fwiw, io_uring wouldn't be the right place to do it.
>

fcntl(fd, F_SETFL, flags & ~O_DIRECT) on an already registered, already
open fd succeeds. The consequence is that subsequent I/Os switch to
buffered I/O and cause silent data loss. Something on this path needs
to reject this combination.

> --
> Pavel Begunkov
>
>
