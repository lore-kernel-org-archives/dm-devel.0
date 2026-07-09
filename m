Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E04D402BAB
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 09:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783591057; cv=none; b=cjP/5vjw+YCXZW86JEAglt21M0aS9869w8BjZHd+cbtpbKO4wnDqxeVtlZmZsB2h4wNHTbRnKcE1e9bBcFeiY8nzyN+iBPwH164uYRj/s2xbHdvBeZ8G39GamPhxlaNWqCt1jSBN6fL210M1kMtKlYeVmLtc7YAZjB91ZKhsrd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783591057; c=relaxed/simple;
	bh=ScNDU72QZIGljZYAXX3TtqEW+QUCJIdbOtB91OHVf94=;
	h=To:Subject:Mime-Version:References:Cc:Message-Id:In-Reply-To:From:
	 Date:Content-Type; b=d5E4IeKEGU+Qk86FQZGjWYoBFHpGgfltBdn+S4pw/oI8RC60RIVkR165/wS6EfDHdXEXsUcw38WaGjnArFa1h0OPZ/blZhOyvwXupvQteIFD7Nrv+3LAv++95Y0mKgShujs5CU6P+D252zpRef4PSTcUEFFZfD6arADSLZ7IcNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=GKr+YBcv; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="GKr+YBcv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783591040;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=HOGu0DcVoj6IGMDLrDh2fK8YIc1W/aNya5uNQNN/KKs=;
 b=GKr+YBcv0NFr3xoiiCd7poxeeFYuqJw3Ssw/t0vRxeohJnXWLEBUUOLgO4sXJvs/1SWT9j
 ZjAdreVVOJuzGQofpZTmAECG0IVX0xb/2EZchMjOa25K4U3p/VEECoRuxp/GwjnN9rV5mQ
 QcG6NulqKgrLJ+rsthrOPE4LYVv7KdtDhauSFIKDpX3ekCGczn3YHRNRckWIOxRxMU/EPD
 JcFdw8uQjIeirkRxl3Lz3rf71q53c39Up0LgV2lwdH76qMdIPOFoznH5Dmyr7qh6Q48G3z
 9oaQJAfdFBbzY0+QLFjjE2rqf5YXQB+smaNvRxLDvDeXpzmRNtBc4zbEhi+CEw==
X-Lms-Return-Path: <lba+26a4f707f+b421f1+lists.linux.dev+yukuai@fygo.io>
To: "Christoph Hellwig" <hch@lst.de>, "yu kuai" <yukuai@fygo.io>
Subject: Re: [RFC PATCH v1 15/17] blk-cgroup: remove blkg radix tree preloading
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260704195124.1375075-1-yukuai@kernel.org> <20260704195124.1375075-16-yukuai@kernel.org> <20260709061837.GF16504@lst.de>
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Thu, 09 Jul 2026 09:57:18 +0000
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
Cc: "Jens Axboe" <axboe@kernel.dk>, "Tejun Heo" <tj@kernel.org>, 
	"Keith Busch" <kbusch@kernel.org>, "Sagi Grimberg" <sagi@grimberg.me>, 
	"Alasdair Kergon" <agk@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, 
	"Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Dongsheng Yang" <dongsheng.yang@linux.dev>, 
	"Zheng Gu" <cengku@gmail.com>, "Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Josef Bacik" <josef@toxicpanda.com>, 
	"Nilay Shroff" <nilay@linux.ibm.com>, <linux-block@vger.kernel.org>, 
	<cgroups@vger.kernel.org>, <linux-nvme@lists.infradead.org>, 
	<dm-devel@lists.linux.dev>, <linux-bcache@vger.kernel.org>
Message-Id: <e2ae59dc-14b9-48fa-a945-0b15acff338d@fygo.io>
In-Reply-To: <20260709061837.GF16504@lst.de>
X-Original-From: yu kuai <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Date: Thu, 9 Jul 2026 17:57:13 +0800
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/7/9 14:18, Christoph Hellwig =E5=86=99=E9=81=93:
> On Sun, Jul 05, 2026 at 03:51:22AM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai@fygo.io>
>>
>> blkg creation is now serialized by q->blkcg_mutex and no longer runs
>> under q->queue_lock.  The radix tree is initialized with GFP_NOWAIT, so
>> radix_tree_insert() cannot sleep while blkcg->lock is held and the old
>> preload dance is no longer needed.
>>
>> Remove the preload calls and the associated unwind path.
> Isn't the GFP_NOWAIT a bit of a problem because it can fail way too
> easy?

I think GFP_NOWAIT should not be a problem because it's only possible to
allocate blkg when the thread is issuing the first IO. And it's not a big
deal to fail nowait in this case because the caller should fall back to
sleepable context to issue this IO, and then blkg will be created. The foll=
owing
nowait IO issued by this thread should no longer hit blkg allocation path
anymore.

>
> What about converting both the radix tree and list to an xarray
> using the internal xarray to deal with sleeping allocations?
>
--=20
Thanks,
Kuai
