Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB5238D
	for <dm-devel@lists.linux.dev>; Fri, 12 Sep 2025 00:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757635690; cv=none; b=goxTkz/GAPJkN2zA8I8sGb8E0Spju2zRA49uK9oXqlIRizTTv808XAlaUigDmxBn58EE8vgeBmnPIbNGudT2/otA8rlODBCeNqICuASDkwWRDF/AXUGajHwsxyxGsrag5sMgt6379UPEStD+vi0Ym0H6GZqP8RVHjEttSnj//xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757635690; c=relaxed/simple;
	bh=I3MvkIVfoCnhboohrKoUHclsHzADbafLcRG2fojIqUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n3TpGngsiMyLlrmT7KfbDOggDh+BEPSTzwhPnYXObJmyeKtaitynVhuy6HG9L2Cd+79PQYvIZ5JWcXpWz6ZmZpTM3c8nFENQ2Ux8yLEn+FbLh2/POrFalQpCjJ39C2Rq3sgyPCA/GiYPrj0kXL5YHnmxnmBYqzVOXB+tEnYTokU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bAe5G5Ii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bAe5G5Ii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F34C4CEF0;
	Fri, 12 Sep 2025 00:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757635690;
	bh=I3MvkIVfoCnhboohrKoUHclsHzADbafLcRG2fojIqUE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bAe5G5Ii9ct8UWEUUz3sVvi9K59504t7SUoMBODBh27rV/RTBC8o6rzsH4GrDKyTd
	 kAGy2Occ5qUaqlX7NQiOJxeZKiIMhF4IMmB74qWxG489aHKikhe9bXf05ArVXHG64u
	 d8lb9YLLIs36uBOM2ih8aD6iNyx1d4fOSo5qK5JLP44BkbhLlyL5di1Unz47DlgonT
	 see4klexBOuf2EXVKh63JV+0Z5dEar1BbTXn2v+nRoB0OPRF/VrwJyopegOy95gLFp
	 pTO9Fp1XZLfaBaKTkYeAptjDImUeBRHa3VVCTZftFD8mo3/hyC9g+S5c/8DzaPumRP
	 Xlc6oGqm+o8Xw==
Message-ID: <c108d8a8-ae2f-453a-9eaf-a9b30ba77910@kernel.org>
Date: Fri, 12 Sep 2025 09:08:07 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm: Preserve the order of REQ_PREFLUSH writes
To: Bart Van Assche <bvanassche@acm.org>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
References: <20250910172742.187645-1-bvanassche@acm.org>
 <4f959ea8-b3c2-402d-9777-48abdc488ba7@kernel.org>
 <c89d0b4a-35a8-46eb-b078-e65102a0b817@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <c89d0b4a-35a8-46eb-b078-e65102a0b817@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/12/25 08:16, Bart Van Assche wrote:
> 
> On 9/11/25 4:03 PM, Damien Le Moal wrote:
>> I suspect it is because this will be handled by the flush machinery during the
>> submit_bio() to the underlying device ?
> 
> Indeed.
> 
>> But if that is the case, why is it a problem with multiple devices ?
>> The same block layer flush machinery will handle that preflush write for all devices.
> The REQ_PREFLUSH semantics require that the REQ_PREFLUSH is submitted to 
> *all* underlying devices before the data that is included in the bio is
> written, even if the data in the bio only affects a single underlying
> device.

You patch would be much better with all this explained in the commit message.
Please add the above explanation in the next version with Mikulas comments
addressed.
Of note is that this seems to apply to all devices, and not just zoned ones.



-- 
Damien Le Moal
Western Digital Research
