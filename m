Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536C0202C46;
	Wed, 25 Jun 2025 23:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750894593; cv=none; b=dG+c1k9y6aUhpZDgYFJZ32V8+DML/1SyCbQaFe15DDY1SOwoiMaM/OB8L4Ti1GSKe6C/JiOLA/rnmDF1asVPqjBRB9sdbFaa1uH0kRIlrFDodGuYnSiO0ZtE3r+hMEM8OUhnG+KYSRN1JxjzzmHvCKDF3Pt4kecEcg5qch8rLnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750894593; c=relaxed/simple;
	bh=dHeAbvNT7Gg/RURyvYMojUzvoQTP7FyN/Rb6GKk74j0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=En+oDomFkwjrLiDuLewjckTnGoQS75LQ7BaZY9NUhBzdbCB55oEXyEl1A4u0VFsF1fy1VzcBfgcD/ACGEahXonRFogH0kVxRoLFVjjD6nJxQeLgx1tNUeDBg0hNGHaotG/ds5WugIoKgjRtQ51IdR4JaKMdFEGf4ubWnN0pME/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZqJvWHmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZqJvWHmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA06C4CEEA;
	Wed, 25 Jun 2025 23:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750894592;
	bh=dHeAbvNT7Gg/RURyvYMojUzvoQTP7FyN/Rb6GKk74j0=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=ZqJvWHmTaunm+wRfs6HiSWfatW7LaEXt5HT/Ss/EEnxvsOImugEDCN98sK2MqPjkx
	 7832Xwdr2RhI9l1B6a2Rx2mtqoIhBVpp0pkFwECGtg6yOzMczWbFsn9GpSupSZkMAw
	 lPae0ub6+sQWfQgimwdEBOLsrfL6InpdlfCf+63K0QWleZusx2edKiREKQcFioBEsW
	 nj8SahK3H3FlRd8a2pM6C5tV0SJw3lVWjAqaruG4U1UsUVIblbjakgP4vIJYlX7Dnr
	 6ciOtnWmIUZ0WTg8BKDNzpcSa/1l0eF/vQMk10nAV5wagWOS0RwP+gvAD+zal/P7HT
	 RKg/y3EFa9mQg==
Message-ID: <d0ae85c4-8fd7-49e2-96b1-a08f01154cf2@kernel.org>
Date: Thu, 26 Jun 2025 08:36:30 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] block: Make REQ_OP_ZONE_FINISH a write operation
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20250625093327.548866-1-dlemoal@kernel.org>
 <20250625093327.548866-2-dlemoal@kernel.org>
 <3f292307-30ac-442c-a694-5fc3560036a4@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <3f292307-30ac-442c-a694-5fc3560036a4@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/26/25 01:29, Bart Van Assche wrote:
> On 6/25/25 2:33 AM, Damien Le Moal wrote:
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index 3d1577f07c1c..930daff207df 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -350,11 +350,11 @@ enum req_op {
>>   	/* Close a zone */
>>   	REQ_OP_ZONE_CLOSE	= (__force blk_opf_t)11,
>>   	/* Transition a zone to full */
>> -	REQ_OP_ZONE_FINISH	= (__force blk_opf_t)12,
>> +	REQ_OP_ZONE_FINISH	= (__force blk_opf_t)13,
>>   	/* reset a zone write pointer */
>> -	REQ_OP_ZONE_RESET	= (__force blk_opf_t)13,
>> +	REQ_OP_ZONE_RESET	= (__force blk_opf_t)15,
>>   	/* reset all the zone present on the device */
>> -	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)15,
>> +	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)17,
>>   
>>   	/* Driver private requests */
>>   	REQ_OP_DRV_IN		= (__force blk_opf_t)34,
> 
> Since we are renumbering operation types, how about also
> renumbering REQ_OP_ZONE_OPEN and/or REQ_OP_ZONE_CLOSE? Neither operation
> modifies data on the storage medium nor any write pointers so these
> operations shouldn't be considered as write operations, isn't it?

Open and close change the zone condition and act on the drive count of
explicitly open zone resources which impacts the ability to write to zones. So I
would rather consider these also write operations given the changes they imply.


-- 
Damien Le Moal
Western Digital Research
