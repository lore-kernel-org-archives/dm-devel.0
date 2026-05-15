Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B8B4C0401;
	Fri, 15 May 2026 16:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778863775; cv=none; b=lxS+3Fq8WftZ9qpGT9COgAx3RuYjbOrgo4uq/RET3Aq1A5iVvm76HYlT9cbGllRQfozrops/LqUM8TYx+EOYebMFTvauOeYcM7zWsm2ZrFd6akbl90MQmlLLqcQSwQA00YsYBNEmTf6p3hDTkyGoPp2jhqYy8fmZmb19IjUGN1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778863775; c=relaxed/simple;
	bh=p/DzNJ0ZFT3YunZjTo5emDl7we4MJDcdv4qMy/E59Ew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rwGxy9TjoVWSdO88vypSHoxkXTucDpmQpaSzkIzj2tybcuxL7S3H+df4I3CpduCx9WFaU8BwUAQqqbxQLeZbskNybOiar2SAuudIRuOpvvxif3B5/aycmt6xDDBTqHMjiR3B6A2fEanDKMUSwYBb9Di0hJCUfBcn3Z9zJm9K/l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Kt/oOoIw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Kt/oOoIw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=kpTdqu2lNMVtc5L56yZUrdrtD8VOiGhfVlKZKMtrnJ0=; b=Kt/oOoIwefGBYMcpFBsqU65p64
	CvnXWQQWHZAewr6HMWEGAo/aRIfz/UpURCos0+xqMRrxYv0t2ZZZOLv9A1Ybm9ihlFJDI/Q+LicCK
	xOnZOdjgP37wTUwMU6uiCyh3dfSacilCDzal7gn29OAx01ijuP8+NKGCiMFs3hPU3PM2UO6u/gy23
	4Gn/9ikLVOVlS7g17vTd3kRyy1V+VMIKKm4IWcJGaYkV0iCm3+IlSo+QDi2U5WxRiRykCxqmqeVew
	uQPLHLgRQCpeFucUpSLneMMoVsdqosv+uvHnkww+oN16Dk+I1I0oadZiRuQDIoKXvSwSrVCVgEyUr
	TWKqPglw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNvj9-00000008ui2-2fCQ;
	Fri, 15 May 2026 16:49:31 +0000
Message-ID: <39614db4-8b5d-4174-837d-73ce124ff2b7@infradead.org>
Date: Fri, 15 May 2026 09:49:29 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: fix dm-inlinecrypt docs warnings
To: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Cc: Linlin Zhang <linlin.zhang@oss.qualcomm.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
 Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org
References: <20260512180409.1193504-1-rdunlap@infradead.org>
 <878q9ksrpi.fsf@trenco.lwn.net>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <878q9ksrpi.fsf@trenco.lwn.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/15/26 6:55 AM, Jonathan Corbet wrote:
> Randy Dunlap <rdunlap@infradead.org> writes:
> 
>> Add this file to the index and use a longer heading overline string
>> to eliminate warnings:
>>
>> Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst:1: WARNING: Title overline too short.
>> ========
>> dm-inlinecrypt
>> ========
>> Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst: WARNING: document isn't included in any toctree [toc.not_included]
>>
>> Fixes: b4a0774bd7fd ("dm: add documentation for dm-inlinecrypt target")
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> ---
>> Cc: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
>> Cc: Alasdair Kergon <agk@redhat.com>
>> Cc: Mike Snitzer <snitzer@kernel.org>
>> Cc: Mikulas Patocka <mpatocka@redhat.com>
>> Cc: Benjamin Marzinski <bmarzins@redhat.com>
>> Cc: dm-devel@lists.linux.dev
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: Shuah Khan <skhan@linuxfoundation.org>
>> Cc: linux-doc@vger.kernel.org
>>
>>  Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst |    4 ++--
>>  Documentation/admin-guide/device-mapper/index.rst          |    1 +
>>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> This doesn't apply to docs-next, so I'm guessing it's intended for some
> other tree?

Right. It should go thru the device-mapper tree.

@Mikulas merged this file.

thanks.
-- 
~Randy

