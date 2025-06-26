Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B3520E6F7
	for <dm-devel@lists.linux.dev>; Thu, 26 Jun 2025 16:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750955888; cv=none; b=lX/ZnABIh8uAeUTgtI0hamt+XM3WOwZX/fE3VTuCawKa8mW7n0mkYVc5Zpu0MoxgNapIrD42glE54BpDlJBaeeQK0hYIAeGPaVNnf/dXnGckQLwtUZkrvduaAtOdD09iPM//zID1J3ZTTB50vYwNA2QCN78HnkXpCsXQNX2uNtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750955888; c=relaxed/simple;
	bh=vfQI62X40YId8QU82XnU3EamIkpLrh7FDAG2GLrPOho=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fuOz6qsxZ/YpBCsYGt2p4ma+p8piwsIf3VJCWzHmGH0KBL6qjFwYPt9YpTaw4yJO1bN9hKgNGooDUrijDhs/BlPrwHUHTFOyQQ4+LlnQdavX6HlApBtRdfkdIZc5BIG33tGtT+HjsQhR/2O+CWQxRmeCjaM4zPR4Gb3wxkEJEcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yVWJKZ6Y; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yVWJKZ6Y"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bSkrR68kCzm0gcM;
	Thu, 26 Jun 2025 16:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750955878; x=1753547879; bh=b728YBP7jWunzNXHTCBgFVLF
	3q/+OEUbW14loKh0JfQ=; b=yVWJKZ6Yjm4W28FKskww+2URsWK6goVofOLxx0QD
	uz1c1CErhogIdPtYoZc/Xq2uIk/caB+xARYRyEgJGMmWqqsatVWBCQ92nS+SId5H
	p0dztrmGapA4mdAHDGRPIchd4ZLh6mk36bG/h2CAU9NVQjN3yilQYj0jqjd0LGJj
	xp9T/pkKmviQKjSYWF2JV+AJVWmt/F/tp4sl04UR+dMBWosSQ2Ji/Xrx/kxRWO0A
	4zzYn+EfL50ifr7a8AbokumADiNdW/mAzlKqk42W++8yBpS9hf8iRjY8peAVr3eT
	sRFuvLNXpEA3RfDpekU+fO4bkxMlBuxa7VnhphBVvW1nNA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VN8G0RyQtc0u; Thu, 26 Jun 2025 16:37:58 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bSkrL0rhDzm0gcH;
	Thu, 26 Jun 2025 16:37:53 +0000 (UTC)
Message-ID: <d1c7fa0b-d4c1-4604-9db1-3ec566c74c27@acm.org>
Date: Thu, 26 Jun 2025 09:37:52 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] block: Introduce bio_needs_zone_write_plugging()
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20250625093327.548866-1-dlemoal@kernel.org>
 <20250625093327.548866-3-dlemoal@kernel.org>
 <38ddf5f9-80e4-4909-b5cc-cef0ffce19dd@acm.org>
 <0a3b97e5-ba1e-4f4e-90c5-07cb2dfeee07@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0a3b97e5-ba1e-4f4e-90c5-07cb2dfeee07@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/25 4:38 PM, Damien Le Moal wrote:
> On 6/26/25 00:48, Bart Van Assche wrote:
>> On 6/25/25 2:33 AM, Damien Le Moal wrote:
>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>> index 4806b867e37d..0c61492724d2 100644
>>> --- a/block/blk-mq.c
>>> +++ b/block/blk-mq.c
>>> @@ -3169,8 +3169,10 @@ void blk_mq_submit_bio(struct bio *bio)
>>>    	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
>>>    		goto queue_exit;
>>>    
>>> -	if (blk_queue_is_zoned(q) && blk_zone_plug_bio(bio, nr_segs))
>>> -		goto queue_exit;
>>> +	if (bio_needs_zone_write_plugging(bio)) {
>>> +		if (blk_zone_plug_bio(bio, nr_segs))
>>> +			goto queue_exit;
>>> +	}
>>
>> Why nested if-statements instead of keeping "&&"? I prefer "&&".
> 
> I did this because bio_needs_zone_write_plugging() is inline and
> blk_zone_plug_bio() is not, so this ensures that we do not have the function
> call for nothing. Though I may be overthinking this since normally, the
> generated assembler will not test the second part of a && condition if the first
> part is false already.

 From a (draft version of) the C standard, section "6.5.14 Logical AND
operator": "If the first operand compares equal to 0, the second operand 
is not evaluated." I think that text was already present in the
K&R C book.

See also https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3220.pdf.

Thanks,

Bart.
