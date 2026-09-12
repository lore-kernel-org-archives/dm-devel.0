Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFCC47ACE6
	for <dm-devel@lists.linux.dev>; Sat, 12 Sep 2026 12:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217867; cv=none; b=Gdzai+XSNnSJ82EZ0Obzt16Qd5maJo90sfmyRTOAcKYGcCH/+5wpxwUfyiJXxLw8PjPTn/8SrdXgMBF8AOll5vSsrCipAM+qMv3gFbPGCmWa46BiO6gMHEqMUN3JvBxiEnti/AsVXTpAbs8S4xbQWK0Y0qUz/O4gO/X+qD2CjzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217867; c=relaxed/simple;
	bh=6N0ifHQ8O4u0BOZ6EF0w79HnCW/yPo/3nI3uyCXuO9A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UlpBQ8cj8bVrKfXHUyp0gbnY8Lbhmg/E8qRQFSg9Wn4zH69IpPFUyBc//TyZMW5Btb6AIQ4Mz/SFyYxSC7v7jfUQcpXq8LCDEeCZuDZuVxNvjIX9yZOZVYVOBSbhJ5Pap9NoRPm91lt/mdsP312Bt3TXHhra1Ph2MGc56jhL2JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZFoxWQka; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZFoxWQka"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f89so209065f8f.3
        for <dm-devel@lists.linux.dev>; Sat, 12 Sep 2026 05:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789217863; x=1789822663; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fAOw7eoVc0zYvL/f6e+XZRwdegk97u7KcjQYPN92otE=;
        b=ZFoxWQkamFhrFXp7jZ4mhdRb1Rk7TaFuq3SG1J1lngZToCMRgrm0o7s6uPfRljivY5
         EwN1mCxNUqN6CjflZRTfhdpd/J0N1FJXEiakTrFY1p9dgL5Vd7q568P6i2DLQM6WLUHi
         RwpJfamHx7Z9YT0y3/PXG8tZoyYvBLSHVE0SUDMvB3xG1AEdgDvxgre8xGWdYpoKDa39
         LYexEo9Zc3jGustipLJCdxo4LVH6omH+qqLtTUprTobuMTK7IGjTL2tMoT8atQKUjsk8
         TLoCfSYHPjvNB1PbLQxQpEPApkhL+b5dmYcgoi6Neh4X1TNe803Yd86HWjbZh0P+4l6C
         p03w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789217863; x=1789822663;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fAOw7eoVc0zYvL/f6e+XZRwdegk97u7KcjQYPN92otE=;
        b=I9t9k9xM2lA+632iqgdFMNUNsmLjWzijhZv5HZTSBC7sY+zOODOgQ7R6ZD+IX/+dij
         dmdove678R9fOKvRI0h/jqaMryDXyqIri69vM6oOU8bQjN+OJ4rxTMSymyzdonRmbsiW
         ZY9jxf8foUngGTN7cvdZ9t8vNXTdEP42poOtk6uD2yLe4/AcflpDkf+lVkhYeokQX/ww
         /rVc+KwIVbak0MxaBGgn1R6VI3eoJKT77l1ixMoGeEKZI6Q/hLd/0pIxy8zw6Oq6nKaX
         2QZp5/rWU6kisu6kdBf+mmS4jXfdg3Crk7VtKJY4gEok5fqTktCY2jfzDHP1L5kUZfLI
         6lMg==
X-Forwarded-Encrypted: i=1; AKwUvBzOh8QKsQuAlM0x2BTh5YGBXXMs+1t4xGUoYU8D5Dx2KcV1xGiQoHcIQ7CXxz7NqsACSSQGIhwXZw==@lists.linux.dev
X-Gm-Message-State: AFuF++kfevFDKh0j9MyVCLJVUZhe0somKRskCzVYdvR70nELX6o1cKl5
	h8yGdBfv//VLN5PjSiVZzPXsvt5ZDvkNmxm7aCykIKWg7Pv5UipGttlQ
X-Gm-Gg: AYBFou2ki28RQJvif+iA0I4/s1aRa6yxoVqHC3mZK9NsYjJdX5/U2mX28GcPNvO5Sn0
	1eo9P62e93e7cwrfo8Ak5GW4H6wjV2fGl+Po6GsTypJBQ8PZ4KqaqjxwoQ2k9x9BBQmIXV39o7h
	v50PdPKfRawkV5A5JacQlyfiQ9kSIZZ9ZXN4+lpp44agd2n9XQfq74qIBd/nIGIrHBPQbrNUybI
	Xsr2Zd9sz7KZdD6HYL1lxrBSF3c0wUMYfu5LCBHPf1Q0M92m7tUryMCRHX9ECDHRf7HPUyCGF+k
	JZPHXTRNwlNFaExvPGWJ/qvrYUj1Yxg3m7W2QlTty4W5Zd59o4MayvhS5rDH/ltRpLmqrPszSNA
	Lx3etoN0metKToVmyYL/vScnt/juXoC1Eyso4yZ2FMYG3sfdRfS3POCx0hK6i1R4u/iIS6jlRN2
	+rTt8uek2l1NTKiR/zy50qZAlbme+WHNR0TETCY0HqLoEMd7gCxic5/GE3fh8/TCf0wE0H4C2Va
	Xr/XDETHD2+L6Iy3TxDaCIKTPA3yemk75cIGBI5v75g479GsbzgBiaFD8uOVv2BL0KU0x/bu6Lh
	XL1ClX6thw4sZ/7++1BgnTssWdI=
X-Received: by 2002:a05:600c:6812:b0:49d:1d7e:4085 with SMTP id 5b1f17b1804b1-49e6cbec30dmr21535245e9.22.1789217862965;
        Sat, 12 Sep 2026 05:57:42 -0700 (PDT)
Received: from [10.192.161.217] (82-132-213-27.dab.02.net. [82.132.213.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb32e7f5sm12751635f8f.9.2026.09.12.05.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Sep 2026 05:57:42 -0700 (PDT)
Message-ID: <0c787163-dd07-4389-b9d5-916b8753f388@gmail.com>
Date: Sat, 12 Sep 2026 13:57:37 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/16] Add dmabuf read/write via io_uring
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
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
 <eb469580-509a-4895-a819-e7f3e4fa0b0a@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <eb469580-509a-4895-a819-e7f3e4fa0b0a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/26 21:58, Jens Axboe wrote:
> On 9/10/26 2:55 PM, Jens Axboe wrote:
>>
>> On Sat, 01 Aug 2026 16:46:12 +0100, Pavel Begunkov wrote:
>>> The patch set allows to register a dmabuf to an io_uring instance for
>>> a specified file and use it with io_uring read / write requests. The
>>> infrastructure is not tied to io_uring and there could be more users
>>> in the future. A similar idea was attempted some years ago by Keith [1]
>>> (from where I borrowed a good number of changes). Later it was brough
>>> back up to life by Tushar and Vishal.
>>>
>>> [...]
>>
>> Applied, thanks!
> 
> Eh no it is not applied, was just looking at the series locally and I
> guess it got added to the b4 ty pile.
> 
> I am, however, wondering if we'll see a v6 of this soon? I had some
> comments on the nvme dma mapping, that can be improved, but I'd rather
> defer that to post getting this included.

Working on it

-- 
Pavel Begunkov

