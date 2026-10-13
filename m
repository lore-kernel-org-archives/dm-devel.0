Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A4353E2E4
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 20:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791922400; cv=none; b=JBu3QKi6mDnJQ+d1DkhXRBI8liZ1bCX6tRIE1H7P26nmV3K7AmGbkEg7VqoNhTLhlsHvwZlWqVbJzPlTVnBrFzKf+aKZmGCU4TOlRWd3HWPegD3lacSGGSnYXDhJqeaEpowfLHwoMlKUYqoewqXRMecF/iHyPz+L7ujLjm6E8xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791922400; c=relaxed/simple;
	bh=jhbx9laNPy92AqwKrICB3iCZDPZ5wNo0jYJGltxXPiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C++P4HZa+B++1JFIaXetwzMDkyh337eXvzNvCTMVqt3pZ+xpTIQncHep7wc7CAYzsJ3/53GhVpTkKj/1vhWFtyepEN62yX038qK/x53xZy9s94UgUNrBbXye+ZbS2Gg+la9oQ40CvhhlJjsaNjwDIGyJPZXG9IZuFVn3JWAgPfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jFGWNDR7; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jFGWNDR7"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49d0da752ffso1964195e9.3
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 13:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791922397; x=1792527197; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z2hIuYUY9dxFL1uM5B7+C8H4OaVqNBpDv98EiuOQjRo=;
        b=jFGWNDR7V7ha+nGWp5u8ofWu7jYsk2/IVPA8gbed3dnyKQmXCTiMfORvUg/Ycvhmh7
         Ye5LH2anUI4HDrZ5f3vSJ9kvawS2Wb2WKtb7zUJiLo6qvcu6t5o9NgJEZh78Y0ZOTfGN
         bpox8f/h3w0PFinWlKnBna5LDppZpp3x/nUkfWueBRpEwC9wW6jrNw8xDI4s9qRgsQ6i
         UnwoGBm6vR7Cn8idPfNhgIP+2XcB4KBEjQofjMkMR2i5kpQc7rKieXGtcRCqT7iK4q96
         ECKlMOOYY5wzAp9UK3eurSzfCOsTbroyC5qKLZtDcXSe7viZYUfQfCxHOhCwsj4CtkFY
         xhwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791922397; x=1792527197;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z2hIuYUY9dxFL1uM5B7+C8H4OaVqNBpDv98EiuOQjRo=;
        b=w6jesQK5QTSbosuBTdaLuX34NwCCrYoE0rC56u8PUMjoCjIVbWRAZl/YwkW6ZAxR+1
         bcaHcK9ww0b1MCkUd8ufIVNIr8ugOqxr8904NvAAQZNryhQEQ/RmkWk/1jp++w3gm0hb
         6MVJU13q3+0R8+AAVYDjEZMqh1nL5rjNzZSo7+Vdex+nvUfTIEIDhd/XbE77Wn/yPGd+
         /XwqnfaKyscD7PYl0FeVfJlu2Emf9dS17OA7hstqa2PMBx5V/+JIDyvFisKFFj7C+RZz
         hMOPiObCSIA6nppfCShO/E8fBbChBx4DP+x3+iu6FZH6mgqlNMYCB8XZTPu+bdKFRs/J
         rQ0A==
X-Forwarded-Encrypted: i=1; AKwUvBz0vk44hujCLavngb9vP6kg62sus8XAqbO+EZlI0mBByM4q+w107vXFwLwAvb91m5kFFjLqxhTcHQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYIMkJfMVAcFYTmqPpT7JH3MCQpsCo7xzhWDFh9WLqAFRVgYcNTB
	WK8Pa8JNEkeVUnqYca3u5v0yvU0B7cNcwE7XDalmJ+c+2r03QgcHUiED
X-Gm-Gg: AYBFou1D1PIdlxzjYXXbnBCzwFG48JRWdMMdjGg+R7MseWrY4BBM+TJjhjMonGmGlQA
	yH6kg4gh8KhUFf5AARjNdZsyDKlOAHOflg6hfTvRuvnM78VWAzGM36F0OB+SBW+OSulxre/2BJW
	eEcwMz4cXZf+Xzh+WAR0Iwa8kZ+ecqVykM4Ku00WVgIDvm252uDbgHYthi99T+4V/WHFU6q0OUv
	ZWUfhL+UNmBrSmmZuJv6rP7YJ/r0GsjzUKRZUFDEVG5BCRTwJJoqYewKOviuUuDqhUbFJc98w7e
	s1VprFnGmFcp+bigAYGPIXcG0sZXZX3UJYolRgebDIglQ1EwH5D8LNYeB7VaM9TACvNGaEEWIRH
	ol1MTz0nuFUMWt9lwCjudFtXSUgbVRyw9bzlwzvWdnKwSUg+1kNrKo/rE8yQb3v8KcVGFMienGA
	aO+JJCww5wxxsU/Dig2h1IFjVev9WPQn4EPKuH2knsJnLBYmeVo12nh4gGkyUXZFR02ssVXxmK5
	1L8iwVSR/XRXv3CmQF2bWGUFUmFn16UoX3bj6ROFa0W+5zX49PZFhXDfIrvRL65LcICkgYjAYdR
	G5LzNmqYylta7mI8e6aqdE9NNNdRmNE1ve826V1b//k94TOl
X-Received: by 2002:a05:600c:4f42:b0:4a0:b6:4619 with SMTP id 5b1f17b1804b1-4a18e3ecfc8mr324117205e9.0.1791922397398;
        Tue, 13 Oct 2026 13:13:17 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18be97d1esm608335675e9.8.2026.10.13.13.13.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 13:13:16 -0700 (PDT)
Message-ID: <736950e0-c890-441e-bfa0-ef5d2b7b7d4a@gmail.com>
Date: Tue, 13 Oct 2026 21:13:09 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/13] block: add dma-buf support for raw bdev
To: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
References: <cover.1791336930.git.asml.silence@gmail.com>
 <CGME20261007014324epcas5p2a7f3b03f118c9a1d1c633fe839ed1e46@epcas5p2.samsung.com>
 <af2b48a490186edf38f1d4a5dfd9513574f7a350.1791336930.git.asml.silence@gmail.com>
 <bbb87d6b-b7a3-487a-8be4-27f3f9ce4a1b@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bbb87d6b-b7a3-487a-8be4-27f3f9ce4a1b@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/26 13:27, Anuj Gupta/Anuj Gupta wrote:
> On 10/7/2026 7:12 AM, Pavel Begunkov wrote:
>> +static int blkdev_init_dma_buf_io_ctx(struct file *file,
>> +				      struct dma_buf_io_ctx *ctx)
>> +{
>> +	struct block_device *bdev = file_bdev(file);
>> +	struct gendisk *disk = bdev->bd_disk;
>> +
>> +	if (!(file->f_flags & O_DIRECT))
>> +		return -EINVAL;
>> +	if (!disk->fops->init_dma_buf_io_ctx)
>> +		return -EOPNOTSUPP;
> 
> dma-buf doesn't work with PI: bi_dmabuf_map aliases bi_io_vec, and
> blk_integrity_iterate() walks it as bvecs to generate/verify the
> checksum. rw-dmabuf liburing test hangs on a PI enabled NVMe. Something
> like below is needed:

Thanks, I already took it into v10! There is some some confusion
with the branches, but will get incorporated in either case.

-- 
Pavel Begunkov

