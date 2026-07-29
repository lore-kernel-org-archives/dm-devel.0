Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB9844604B
	for <dm-devel@lists.linux.dev>; Wed, 29 Jul 2026 10:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785321663; cv=none; b=kNfL2ss73KrJOqDLu1jqvcgTgStH5EYbbEH2t1djFINPLd1fvkJo7VeXlmtrel9CMt1zdgEbHQstQyA1vHZrm4vkERNB9oAf5FtoI5z5uS/dagwD06CXMShc4ieNXw9I3W2Q66Go3fdqvVxmW6YSfdWddK814QgBlafDqzCC/JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785321663; c=relaxed/simple;
	bh=BlIgo2y4Fy5hrKd1QKUkkESSegtx04afaFtVA1ds1gY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tIdS2hb+S3jT2OSI09hJJUn0DKCEXwGVjUOC8SSt3un1BPpoAk9MyZhwnHomZWXCWOXd+VvJGRm5skhImcwOd2MMZ3IoBsNrdqPFq42K3FOUB2WW3ySYuyGh2X2vI7+QEazRAJ+UuMYzLECLNXCfn4M1vU0eN5I7V7mE4AzoQbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VOa8t/tn; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VOa8t/tn"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-69f7fa1c548so1138657a12.2
        for <dm-devel@lists.linux.dev>; Wed, 29 Jul 2026 03:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785321658; x=1785926458; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vFsiSXVzFdxW/ZniSNP4YKGbRVTSiHE8ZZ1h1zgY8AQ=;
        b=VOa8t/tnNuv01Y96DYgjfkLijzNZRZWKz4xTKyDTzMKmZLI47zHNm4j5dj+iTe2f7N
         qtMVn0lk/C4iihWaJuFVO1+calHv3R4tY7ovVj4cQNli2Oae3YYJU8dt+b/6aaWXT8vb
         Qyqxx4Ef6+JZt0PxzYB9A2Ef1NAj2bOq1pw+LxGObHRhNbQrwPuIukT2m6zK+tOBgWWd
         kFDv8AIpkf65DVerptd07wMWcCq0IVjspEsYztBV/WzWuvBRTIfacUpO9cFtsAYTa4OB
         5gjTxq2s/fkJIo+XbcoEJ5Ne5OQmW1JEpIHaTSssJjuhKidG4RQLEGSmnzDv1HgPs+iK
         1m4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785321658; x=1785926458;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vFsiSXVzFdxW/ZniSNP4YKGbRVTSiHE8ZZ1h1zgY8AQ=;
        b=tXigjN7LbdPtvVGxs28bkcwPbPQFf38TXtrNhKpZ0WlhPC6Yz2yGJFAup6/HkksCQs
         V4DnTxsJnaKgg1BcWjAtjhdUGMdF6MEFUyiVMpxk7Euc6BjGDxoe+8xABtArvhDQf0OR
         gSQ8iVJyXdyDK7YFFTf5ZnSNzoSDAWsMVo6TKEmLwhNBLf+7Yypou4Rg9hCqmsvpbk/a
         RFHAFIW1JViKS10EKldHfWRhOG2qwVQk/IDa5Ywn9VmyZo/ujuxc1wk3+h8LYCejaIL2
         gCnIAlUAW4+hZlhbM9rUbbvBZfeBL85zsYvHFjPt1AI/U6fda044gdhLPwn2doP+dufr
         ijTw==
X-Forwarded-Encrypted: i=1; AHgh+Rpeejs1orbn707avjaheIl+BuTJzPipi2JGBN7xzV+WhitcctcKsRRsAvMUFHbYX4y2ZpzHCh0RWA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzNlomz+aDIeGF+BksxaVS32VspDzVs0fHzom60z0liXjHEXKaF
	mdP0tS/BYAZYNRQz8NUrgkPK/XpjMyv71folzenvd5YzgzLDKWUgF3uT
X-Gm-Gg: AR+sD12b9qUbk9n5VQqLoovy56HLnBTXvRHyXqqPsEpsZ0R7Ir/d1KOtPXJsJU0Dlj4
	IzhXzUA8LnwpIcCGEH1Z3766Dw9bb/h4jD2AiisOcEwM0M7OcyNsB5uv/8+DTGgpc4xHuNq0d6I
	XFpaHyLr8JllM2/hst0BxLrnwKrWTgDVIzeB7dYdqLYhZ+0sKictXmYQlFzbY96eX6ESB0eW8jr
	RRctrSb05Wx8IYs5eOitZxiHL3RsoBDSrNQMydv+b3edEjgMTkgU49Xy+tK8kl3W3YqMzf0oxqe
	ho9VJG8RHIvYVcJi2rxvp/AA9r4Dh+BrRJZpVjmfCXGmwsptpQmRBgEp9orfKx15jFJ3EPySblT
	HuGuMz5l2eUI0eUVK4nn3Rp0gPzMVQ4wx87AqdOB12x5FDO3tL6H1Uk/8CveE6JIw6HqQqiipKb
	2+Fu/jyoW0PLUJ9qYLFl4rV8/PlxzgNZwx7GfwvGpjbLpB8TKFM+Dry0EXBgvcugIBfE6XPLqQF
	Rhomh6p7hWbKFWKg+sGiA+u42/8YvPpDK/4zIhw7Jqmg4cxPm/2D0aVGQtghGU0l43AMmdR7Bjx
	nliJhRIyIfwiqgtvwIA=
X-Received: by 2002:a05:6402:548e:b0:69a:596f:ba0d with SMTP id 4fb4d7f45d1cf-6a034a7f6camr3086746a12.33.1785321658080;
        Wed, 29 Jul 2026 03:40:58 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a050c5cf0bsm661299a12.23.2026.07.29.03.40.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 03:40:57 -0700 (PDT)
Message-ID: <7217c204-786f-4fb1-9c09-fc1ac7c8a249@gmail.com>
Date: Wed, 29 Jul 2026 11:40:48 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/14] iov_iter: add iterator type for dmabuf maps
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Vishal Verma <vishal.l.verma@intel.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <cover.1785274111.git.asml.silence@gmail.com>
 <132442812a40277a5904cb2a8ca1e02f4f6e82a2.1785274111.git.asml.silence@gmail.com>
 <20260729065953.GB9534@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260729065953.GB9534@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 07:59, Christoph Hellwig wrote:
> On Tue, Jul 28, 2026 at 10:29:14PM +0100, Pavel Begunkov wrote:
>> Introduce a new iterator type for dmabuf maps. The map in an opaque
>> object with internals and format specific to the subsystem / driver, and
>> only it can use that subsystem / driver for issuing IO. The task of the
>> middle layers is to pass the map / iterator further down, maybe doing
>> basic splitting and length checking. The iterator can only be used by
>> operations of the file the associated map was created for.
>>
>> Suggested-by: Keith Busch <kbusch@kernel.org>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks,

> I'm also pretty sure I reviewed this and vairous other patches
> before..

There was a lot of shuffling, so I dropped the tag after a 10th
amendment to the patch as I didn't know whether you want to keep it.
I'll keep it all for v5 unless anything conceptual changes.

-- 
Pavel Begunkov

