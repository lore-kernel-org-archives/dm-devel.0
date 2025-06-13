Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE15221F20
	for <dm-devel@lists.linux.dev>; Fri, 13 Jun 2025 03:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749786020; cv=none; b=Ck4rtFSvIHV7nbGk1akdxidqwAJUZu5Wg8TpCT6QKGR/FLr2SgFpMFVZ3gF5sMerZDCMxK3LS8m6uiEVn6Uzz+SjNsaF04/04fMqicZLn1MAbc+poJVM8XnURcwup4VsgQx3Syyyhp3aDFmLQ1sbsTTwl3EteimKM9RwbioqCd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749786020; c=relaxed/simple;
	bh=fLcVpDCbE/6C30fzPDJZhmMsEXjlAvnVMrYWqOEtrfc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o1LMYEoLewDdpbVubYpwEuvQFTBVjTWghR0G9IpnEQXpAM7IqgOa6GIIu+P3ayPrspWkrlc6MvsCT6KFof6tObWo161oqDgHyrEBLPEstMyeGjcv+9AHlsVcQgqTKz+Sm1wbQHeS6EvVh/OIkwldtx507ScBEyWXm/HoB/hghf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l695HTCI; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l695HTCI"
Message-ID: <6543e8c9-5368-4861-aab0-47b839ffb701@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749786004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OK95Kex3pTKub48BpiYZovwebqHHH0GQqhXbdTXF7cE=;
	b=l695HTCI7hsjUMMiMu9lHICk5i4Txm3dezyKjuZacNkbXHYCthKDAev0WYaJwV8NQ76RYI
	MMLa504XZATYdfdyU27dZOZUBL0F7/ImHp8132p44JEE43rByFfyTZX6mozs30c46bvmZZ
	5FwKlt49II7uJBUJiQ8SuPFR7FPjRQQ=
Date: Fri, 13 Jun 2025 11:39:58 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: =?UTF-8?Q?Re=3A_=5BRFC_v2_00/11=5D_dm-pcache_=E2=80=93_persistent-m?=
 =?UTF-8?Q?emory_cache_for_block_devices?=
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 dan.j.williams@intel.com, Jonathan.Cameron@Huawei.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, dm-devel@lists.linux.dev
References: <20250605142306.1930831-1-dongsheng.yang@linux.dev>
 <dc019764-5128-526e-d8ea-effa78e37b39@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <dc019764-5128-526e-d8ea-effa78e37b39@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 2025/6/13 0:57, Mikulas Patocka wrote:
> Hi
>
>
> On Thu, 5 Jun 2025, Dongsheng Yang wrote:
>
>> Hi Mikulas and all,
...
>
> Generally, the code doesn't seem bad. After reworking the out-of-memory
> handling and replacing arbitrary waits with wait queues, I can merge it.

Hi Mikulas,

     Thanks for your review. I will go through and respond to your 
review comments one by one over the next few days, before the next version.


Thanx

Dongsheng

>
> Mikulas
>
