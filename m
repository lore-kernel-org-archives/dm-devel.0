Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A093C3BCD01
	for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 20:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789073926; cv=none; b=bY3SBWqz3WULy05MgMgWtjCcBU99B5yrIPBjHdZ+Uz1Tl3AOhbLJja3kZN/P0CAuA6zdNA48sszHDle5zsadSZFW13Gmi+jWVrO+XPIDj/TaPm8Ps9N9s7wApOZv43Ad1NtWJpqtmAYgkS0kYl83ky0EpJ2GnfIcsK41VWjh5rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789073926; c=relaxed/simple;
	bh=ylWdr8yhyOUHr5p7rV7V/FTvMFhwSjE7Fa4ndWREMxM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Rq3Hiz+RZQgp5Wp33NqlVRIhyrc6pqkxorYRzpzs77F0dv3Nb7ODo1pD2iwjDJUiX6R6wQ34QUYSv9U7BkgNegfbsGdCHUjKuiYZCT7+j/J/AwJGJ4NxKWva9mwpVqeU/+IXDgZqVYv1ih/mb4deVlNhvFrMt1j71LD7YIQlcNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=uSlXPRuU; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="uSlXPRuU"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-46fdd5884d0so97152fac.0
        for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 13:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789073919; x=1789678719; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=227EuAsNywH5Ru6uyjfcvigTr1soLZnaZRqqI+5pgxA=;
        b=uSlXPRuUorlD5sAy3Y+CvP9FzZIzk54OeIrkAWO3+legjN1LHODEUl825Yg0oaQ4sD
         m4FBfC3d0V/qS2uRNL3wQAv5JxG2s5r60yLqH/9XVLGaVKhn+QjLyVuSwHhTl0+sMgYv
         fp3JwjQJER3DOv2kTI4IT23LhjW7H0wVNJ8IdUvIVCa0lgt6faqCVG74l3mHqwz8FuT6
         eqaCVYAgft55v79CD0y1yaHEgMZQI2QUYmAnFh6NTn1lBWrC02guGOfmAOJOKhWkNpk+
         291XEEuKU+6z/1yIsmAOzm8/kKkjJpmr80fLISWsim/I4RxzolNmtQrNzPOr8issbhhT
         7yxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789073919; x=1789678719;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=227EuAsNywH5Ru6uyjfcvigTr1soLZnaZRqqI+5pgxA=;
        b=K89oZIzjbv0IInnwynZ08GT+tb/s5d/ObUFjkcGmwgaAQqn9kRP1QJeEprTtynYHaW
         dCu39YRUvxTzqm0xQ0sCUIxn3BBzfs1FEsYD1dkqiBoDQJSrLb5dKVY/VuZc/cUYlUpP
         uQkFHqaUf04M0taOuIaUN5chMjkHtxc96jyzxxcJ7k/BsLcguQmKu3XeirCbYLJEszee
         YRXdhvvt8KVhy5JfogbDmcFW160UARyFm8SviALMKQoaBYEFs/4NQT+wEBr387ao4pEK
         tRsVziUFKaCpjxvrqrfNuDBeWSgAWLOmz3PoT47O4PuiXp1FpkIzRVoXMGugRQoV6lNU
         YTOg==
X-Forwarded-Encrypted: i=1; AKwUvBzacDhVXzcE7KGGuVOOOwyvsEa7oBTH3L/JA6uANDANtM1n0qpQqnIHgR6BPGsenmO6JHA/RC0jNw==@lists.linux.dev
X-Gm-Message-State: AFuF++l91CHU68Z7h+PsnmAyFFSVIAu2nNjwwQSSG8gj+SZ+c11ojNu2
	5tp4QCkc+jnJmzPjEDn4IfhY5vsDWmB9Zekk1pNAXaxsgBlgqjFEIcRfgnwuNLwSYls=
X-Gm-Gg: AYBFou0XIhTWQdaKnZ2kBQFmISIHW3uVb8dEhTCAnQZ7X/9Ys7/A1cAY2nREwvnWubB
	YWryI2hKjfiEqbiIf5dv2ihRVVBXun/K0x/Nkxv4j6F3zSXygwOSk8Qe2B411aWpvkP26ICF1JS
	7DOjbtRbT69G/VMhEquWhgeslRmjq6a45e4Of/W2BlkUNNurPrOChoOH4ZN4Hm9KL+xxREdUI3i
	CH2G/vy5aTFIgWd5hj/cogLTQ6bhiifGKwJ+ABZSAc6F+ARf/+t9TSCX/0HqRNMsYANKexWxQP/
	8BHKOB7WVKdfXnbeWD7UhH/BB3344jbVhyHLFAztyTpdx+wxfU2UhGcdJKObqTDgBvQAjylAzY3
	Oc0YDvEbTHmI7T3ljTq9Q6lwXXYB+wnrS+6fklkudE1ti23y3ivrqB4/7zPYkn0IRAlAL464AX8
	1l3d6TlQtXZ+csbvPhNTOisgkR3Q8cEy+KiCN5GbeRKMtbbx5TEDa3iQGm1UBHtK3FMpHvVZmco
	UliGTjfQf9MAQBirseDaRi6I3ojkRWK4etfY25DAgLet3N2O80TEPOc
X-Received: by 2002:a05:6820:3411:20b0:6c0:5630:bdef with SMTP id 006d021491bc7-6c0bd97850emr353461eaf.67.1789073919642;
        Thu, 10 Sep 2026 13:58:39 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6c09a122443sm1108879eaf.9.2026.09.10.13.58.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 13:58:38 -0700 (PDT)
Message-ID: <eb469580-509a-4895-a819-e7f3e4fa0b0a@kernel.dk>
Date: Thu, 10 Sep 2026 14:58:36 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/16] Add dmabuf read/write via io_uring
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
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Damien Le Moal <dlemoal@kernel.org>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Vishal Verma <vishal.l.verma@intel.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
References: <cover.1785596451.git.asml.silence@gmail.com>
 <178907372259.484803.15807864431748251506.b4-ty@b4>
Content-Language: en-US
In-Reply-To: <178907372259.484803.15807864431748251506.b4-ty@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/26 2:55 PM, Jens Axboe wrote:
> 
> On Sat, 01 Aug 2026 16:46:12 +0100, Pavel Begunkov wrote:
>> The patch set allows to register a dmabuf to an io_uring instance for
>> a specified file and use it with io_uring read / write requests. The
>> infrastructure is not tied to io_uring and there could be more users
>> in the future. A similar idea was attempted some years ago by Keith [1]
>> (from where I borrowed a good number of changes). Later it was brough
>> back up to life by Tushar and Vishal.
>>
>> [...]
> 
> Applied, thanks!

Eh no it is not applied, was just looking at the series locally and I
guess it got added to the b4 ty pile.

I am, however, wondering if we'll see a v6 of this soon? I had some
comments on the nvme dma mapping, that can be improved, but I'd rather
defer that to post getting this included.

If the series is dormant, just let us know, and we can pick up the bits
and pieces.

-- 
Jens Axboe
