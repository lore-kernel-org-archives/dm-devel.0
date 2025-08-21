Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1B81A76DE
	for <dm-devel@lists.linux.dev>; Thu, 21 Aug 2025 02:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755743617; cv=none; b=CksruApAsK48J5yelHJfsSlYcPnXk7eFzRUVK5xccXlhiPsHo4EFwWTLSGMNi8BaUbVMJXKDxbaxle9BEhFZigf4n6I0wwMEr70JcAePa70DZ5Df2N0l9OHguXSEK2fCVtlEr1NK2bqYWT59WFhX7bolH+tu179C6Tqz7Zp8HM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755743617; c=relaxed/simple;
	bh=cpjCVyc9vf/cCtYteEwMV42vdH0/pMIPJSUWh6QnjjY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pNXJyikEkEQw1dcl7FHzRWXN6S8yYEwRmyM0VCvt8Mo0TGStCcYPnHmR8/YvRIZk+FuThHl86ExZ36tceh0/E2DXF0Z41S2LjkX1JpU7PSNzOU3OLrAOun9pY4pUT40DZKeEQVyPCi4bNaZNLlBgr+id2ndxADRls1T+OSLgRB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=arwpOvD2; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="arwpOvD2"
Message-ID: <7305bd03-13f9-42a8-a57c-f0c9808df250@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755743609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NoZ0Pd3eoIIGJXgDKPP3hkQsdE/YBEaWMHrGd6crnEc=;
	b=arwpOvD2FMQfSuulaX7i2QVbExOAJ9p6AI5LNKyGTKQTzgqpNGe9I65CFcwv7nAQLyfNVP
	5CogIit/iXe0DreWAIZF7+jb6DumXMhxhCcKB+KK6wqI0UQIzFTEMKEo4KTSrSC7K0uLLc
	e8iqeYiarP7QLAFY0x3xl8+zldLG46Q=
Date: Thu, 21 Aug 2025 10:33:18 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: RFC Request: NVMe backend support in dm-pcache
To: Giovanni Francesco <gioflux@gmail.com>, dm-devel@lists.linux.dev
References: <CBAE8F39-7448-43F1-AA8D-1F4457530970@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <CBAE8F39-7448-43F1-AA8D-1F4457530970@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi,

     Thanx for your information. Yes, pcache currently only allow pmem 
to be cache_dev.


(1) I would suggest you to do some testing on pmem firstly.

You can use memmap kernel option to emulate pmem device:

https://docs.pmem.io/persistent-memory/getting-started-guide/creating-development-environments/linux-environments/linux-memmap

Then you can try dm-pcache, to see is that what you want.

Of course, if you want to do some performance compare, remember to use 
pmem for bcache too, /dev/pmem0 is also working to be cache device for 
bcache.


(2) I would suggest you add more io pattern in you testing script:

iodepth=1, numjobs=1 for latency when workload is not heavy but it want 
ack from device ASAP. That's important in lots of latency sensitive 
application.

iodepth=1, numjobs=32 or 16. multiple application are running on a large 
disk.


(3) LRU is already on the TODO list 
in Documentation/admin-guide/device-mapper/dm-pcache.rst


(4) NVME backend is not impossible, but my current high-priority task is 
to stabilize dm-pcache and ensure it runs well in the pmem scenario. 
Then, consideration may be given to the nvme backend.


Thanx

Dongsheng

在 8/21/2025 3:15 AM, Giovanni Francesco 写道:
> Hello,
>
> I would like to ask for consideration of adding NVMe disk support to the caching layer in `dm-pcache`. At present, `cache_dev` only supports `pmem`.
>
>  From my perspective, extending `pcache` to support NVMe devices (along with an LRU-based eviction policy) could make it a strong alternative to `bcache` in certain use cases. For example, `pcache` appears to work without requiring the backing storage devices to be reformatted, which I see as a practical advantage.
>
> For my home server workloads, I experimented with `lvmcache`, but I found both writeback and read performance unsatisfactory compared to what I was hoping for. My test notes and benchmarks are available here for anyone interested:
> https://github.com/TheLinuxGuy/ugreen-nas/tree/main/experiments-bench
>
> Would adding NVMe support (and potentially configurable caching policies like LRU) be of interest to the project? I am happy to assist with testing or provide more detailed feedback from my benchmarks if that would be useful.
>
> Thanks for your time and consideration.
> Giovanni
