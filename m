Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CD653D9EB
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 20:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791922833; cv=none; b=MFfEus31SfcbkjiZ/C2+1DAp3EavkIYwXJY+gU72SjkDITKeLjq6EkhMQ2zjGWaVKWj8MuEcOuCMgWFz798u/Y8zJQTloNxosLy5PmVFL60c4Cng3L7oSGKGfgLDJusapdYvvMF8wLatYCjx+jbdvE9AcMuPGUb+fD7GI3ugyd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791922833; c=relaxed/simple;
	bh=52S8eIGd/kdNc5YUeahu1cnDerc/gG8vGqhjAz+A1V0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H0q4+2DRslegnG3eyCGxTEUOUacNWawoKZQGXeSYXWhXOjP8CjrTHauBT52zqVcneV6AsXIJ0Hp31nuFYGLBXvE/21ig1sTFpYiqaQgX2ywbZ2HTlM7lWDeVHb22gLigSJ1mlkg9ng4+EaFzYDzpSufsQd2FKx9DKZbjF2kCRWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f+hyDHaC; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f+hyDHaC"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a022fee0caso31587745e9.1
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 13:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791922829; x=1792527629; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cFWmLiUqCazwiWkaP/d2QvvXVbxF3nnToJUN5Fd7XEc=;
        b=f+hyDHaC5uYfl3xgGRnWi8rvMOFvOgHwJll3E9+LPNiRSvEHb/t5IvVs5Sm1+taYRU
         TOlIpZu4Y1aZfWXicRfMAfxYF/DDFB809uSzPeCmMrT9Y48TdRSVaBOxO9DlH84qt1IL
         HXVOXcrNZy3ELziQ/aaN7j0mZrzX7JuyubvQcfkUMdtPFpa8Va0x9+eK78dGvHVBNaS/
         TgITqAUhrp+U5EQ/X8dw+un/W4CSFHomF9ZZFN62CnVjNj4QqPMYfm8oV/yPQ301BvOB
         MdARmRtVsonOW8Iv69bvUEMY733aeBR9mqUxneAkjZ9FaV4c9gb89Yl4q2X1oaxmtH/g
         T5YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791922829; x=1792527629;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cFWmLiUqCazwiWkaP/d2QvvXVbxF3nnToJUN5Fd7XEc=;
        b=i6W8sUJZjDRpHDwYGMafPT7j+73AzXkbyobzRD055qzmiHNpRSf5peKm0nT1YxP+/3
         ljUCoOeIYftW6fNdVjw/UI2I/yhYeek76BA3zlLZ0SMabCn0woCLGMN3ugO7CulVlVSn
         J4vO/81ysWZKUv1Rigxv5HyVwROqLWs3VnNgXlpAgF3WjqjAE5PmLv+2w6fk2E+vxL3E
         YR7ZDBVMndHrPNMSX/0oK3FrKm6DGMfdbdGa7OBra7oPZuJuZc8DohT++x+RC2DD4eps
         0H6WIIvPyXtzN+MriPg2QpP3oviSmW8oLCvFlC6j7sYmPPtLY6oxoJ6Ym9BKzhhutXBJ
         tgJA==
X-Forwarded-Encrypted: i=1; AKwUvBzpZ0kHQhpN+avsSRsCoAR3YiUSCf0HrxSZMzor16+IVBWbuFNZSU0uQJoHs6xIa5M8pUW+NWxUGA==@lists.linux.dev
X-Gm-Message-State: AFq9FYKcRpNCQSrMTiEhbL3+ULo1oh3I3BrrPUaYbw8bW/aLAcy9SqPw
	8KFcqBCVhqJEUGGFqd2Q7evVQ6afac5Fv+JWnIGtt2U52cYUkf9ho0CW
X-Gm-Gg: AYBFou1wskHtKU4XBtrtNhfhxYTtvTh7SPbGnSRgKi4XJJNfdSTZ2Pfizuiz0Icxr0+
	iBRhJoemTPDUFaSz94au2Mi1Ug3tR9DTwJTpaPxFoQ6dmI5kcz+RNJ7XhblZ8bA2RrpGoIhRXbU
	0UKaYZAi0ynmN106SuuBRsUmg3GDi1bgqF0Y8iwEVKAFRRZhl/u9ikyl5dwPRADd/ecfmg/iswG
	ocYiJ8eMhz5bTStXtEfaOO3gDRHFNROv36Vypw8pG2LXn/QH+qiT1ZFqjMW8nTknIQfh+eRAuCJ
	svEANdVumkTcyt+Bv3o7r2cFLfZboNyxksG7VD7d3yizNisms5hREarSQEWug9D85S4sMVrLmxi
	f5o/axvmwz0r/mL+Na1r3ahS54FCL9MuEFw52Y49uKfvX5u36reEHSVYg6aZgCygLifQgGMrYlX
	xL0VLd2ao2FwlARsNd+GKUwW80C4HSHJbMujlIDZITKMkrEXkHkRQiFVRlLpCQG5vchRg5NJEcw
	eOVPS2RJZXL/dfShv90Rnanu7HT3BCxbfmup1JAxCzduXpZcg3I4FqyBzXvQ1EXfiYtiEJxPkSX
	Lnd2vKRXhxpJOsGia8sBbVOeN7Emnjd24Vr6T5nivyUBoUXq
X-Received: by 2002:a05:600c:4594:b0:49d:1fa8:b266 with SMTP id 5b1f17b1804b1-4a18e4d6ac3mr267044135e9.26.1791922829049;
        Tue, 13 Oct 2026 13:20:29 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf2caf4sm426025355e9.10.2026.10.13.13.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 13:20:28 -0700 (PDT)
Message-ID: <32a70bda-de28-416c-84d8-a56c261063dc@gmail.com>
Date: Tue, 13 Oct 2026 21:20:20 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/13] Add dmabuf read/write via io_uring
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>,
 Matthew Brost <matthew.brost@intel.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
References: <cover.1791336930.git.asml.silence@gmail.com>
 <d00e43fa-8f5b-4a8b-8b83-421d637ba519@kernel.dk>
 <20261013141046.GA12680@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20261013141046.GA12680@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/26 15:10, Christoph Hellwig wrote:
> On Mon, Oct 12, 2026 at 02:21:41PM -0600, Jens Axboe wrote:
>> I've queued this series up for some testing, in a separate branch. JFYI.
> 
> More testing it obviously good.  I've been waiting for addressing
> of the Sashiko comments on the nvme patches before doing more ACKs,

The nvme array out-of-bounds one is sashiko getting confused, we
check all sg chunks on alignment, and seems like sashiko ignores
it.

> and while I can't really judge the code those in the dma-buf code
> also look somewhat serious.

Should be false positives as well.

   So it would be useful to get them addressed
> and the series reposted.  Same for folding in the PI vs dmabuf fix

I was going to repost, I guess Jens staged it before. I'll send
v10 anyway, should be less confusing this way.

> from Anuj, although making the combination work would of course be
> even better.

-- 
Pavel Begunkov

