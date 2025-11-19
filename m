Received: from mail-m16.yeah.net (mail-m16.yeah.net [1.95.21.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F7E24C676
	for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 14:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=1.95.21.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763560901; cv=none; b=nNh/LWi5AtcRZ7A5Vy/Mzu1fR2hX+0FcOAD/arNeATRgOHlGd9daQG4p2STtOcfv8pOEvErwqG78loqBn6n68tCbbQ1YgGyOCBwjhfZn24palqIQvyVR8gr7DbqwSKY6jDiNQ0NguIMAE/K9HuutJkCdOMlWfsl/kaGWKIEyww8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763560901; c=relaxed/simple;
	bh=3bkD/dqUxIL3R/tNIJz0Ov8dvg5CHVIgpTUupVIUp4w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LwHoDy/7Il4WU8sQK+Egnyf/keHpY+E/0YiwgdFh2o9zi2OO9hQ2omtx8Xf6/kT7XgbzELZE4mCdW9Ga2VsJhfKbi5ThvXF63aY7RiYp+PzPKafZw3YvgPBcDV7yvJd9wqEUkC5G7rVjGgoC9lRHvyeTaUBKgXTVhJ7ooo1Ljew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net; spf=pass smtp.mailfrom=yeah.net; dkim=pass (1024-bit key) header.d=yeah.net header.i=@yeah.net header.b=pDL/XsBu; arc=none smtp.client-ip=1.95.21.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yeah.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yeah.net header.i=@yeah.net header.b="pDL/XsBu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yeah.net;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=tjP/inNVO0eKHWzbjkHmUo+NPNSu5NIK9DW339sskyU=;
	b=pDL/XsBuiYyjJ7JbFRwFMNlVSujHBQx8jdjZF5H40/tL8Yy0pe3Pw5EuNg7QAt
	yzVTX6hPP9N6pIgug/0fmVf5+6U5QaeZZbw4Irsic2O2aQRy20/Bhnq6y26fDUAJ
	6fHAJXLUa9LfuCk8LN/860xcf6JPCDAe9WEyP1rgPAtLI=
Received: from [IPV6:2409:8a20:4e25:c041:b388:e8c9:49e8:6a66] (unknown [])
	by gzsmtp2 (Coremail) with SMTP id Ms8vCgD3_aWfzR1pC21ZAg--.45652S2;
	Wed, 19 Nov 2025 22:01:03 +0800 (CST)
Message-ID: <cbd80a43-abf2-4447-8311-a25a9b946b21@yeah.net>
Date: Wed, 19 Nov 2025 22:01:03 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-verity: correct the name of verify wq
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev
References: <20251118154506.17647-1-jiaheng_ma@yeah.net>
 <3192678d-7daa-4ecb-4c02-5c04c0c6fa52@redhat.com>
Content-Language: en-US
From: =?UTF-8?B?6IuP5q2n?= <jiaheng_ma@yeah.net>
In-Reply-To: <3192678d-7daa-4ecb-4c02-5c04c0c6fa52@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Ms8vCgD3_aWfzR1pC21ZAg--.45652S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7XFyDuFWxGr43Kw1xAr1UWrg_yoW8Jry5pa
	1vqF90kayftFWUCasxXF15uFyfCa45KrW2kFyavr18ZFnYkFy5ur1UtrW5urZ0yFykJay8
	tF4rWw4UXa1qy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jHrWOUUUUU=
X-CM-SenderInfo: xmldxv5qjbzto61htxgoqh3/1tbiNB88U2kdzZ9PAwAA3u

Oh, sorry — I thought it was a typo and was wondering how come no one 
caught it.

在 2025/11/19 01:11, Mikulas Patocka 写道:
>
> On Tue, 18 Nov 2025, Aiden Ma wrote:
>
>> The name of workqueue verify_wq should be "kverifyd", not "kverityd".
>>
>> Signed-off-by: Aiden Ma <jiaheng_ma@yeah.net>
>> ---
>>   drivers/md/dm-verity-target.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
>> index 66a00a8ccb39..e8f1300f5f25 100644
>> --- a/drivers/md/dm-verity-target.c
>> +++ b/drivers/md/dm-verity-target.c
>> @@ -1549,7 +1549,7 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>>   	 * will fall-back to using it for error handling (or if the bufio cache
>>   	 * doesn't have required hashes).
>>   	 */
>> -	v->verify_wq = alloc_workqueue("kverityd", WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
>> +	v->verify_wq = alloc_workqueue("kverifyd", WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
>>   	if (!v->verify_wq) {
>>   		ti->error = "Cannot allocate workqueue";
>>   		r = -ENOMEM;
>> -- 
>> 2.43.0
> Hi
>
> The target is called "verity", not "verify", so I think that "kverityd" -
> as "kernel-verity-daemon" is OK.
>
> Mikulas

