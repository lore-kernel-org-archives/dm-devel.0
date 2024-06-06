Received: from mail.schwermer.no (mail.schwermer.no [49.12.228.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1546A193080
	for <dm-devel@lists.linux.dev>; Thu,  6 Jun 2024 13:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.228.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717679907; cv=none; b=Amht7FuBui93NxzXmvBID5pDdbIhF60wjTjESUQge7dVWFF8fbH9RWrDgw25YlXRDeZx+0X/ERGYQWfhKWaX5QcsLOQ8cs1MM4DuESa3JyEv6vZvU4YuDAiu0j8Li/WRbmDoREaSJpjSkFqif5H++tbpEtNHNZFS756zxmhDKNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717679907; c=relaxed/simple;
	bh=hnVEIMwyXlFKGghAzLhucsOZOpkgrJ/oSJ9HOiEMfW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uT3y9kGPzxuit7ZHG10u0ZV4YZHMh5D+knQ2l9802WB76bw0PGtlBQ0WCcCGc0DyLaUUBTsaMptYT3cUPN79qqQIg3L3N4fB+UKOd7DUwtqoS2xLLUeSX1+cQbr6vIjHGC4nf4yW5ZxVG195qfRGbc65wzDVfpkLAZbY/Iu8SFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=schwermer.no; spf=pass smtp.mailfrom=schwermer.no; dkim=pass (2048-bit key) header.d=schwermer.no header.i=@schwermer.no header.b=049toeDq; arc=none smtp.client-ip=49.12.228.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=schwermer.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schwermer.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=schwermer.no header.i=@schwermer.no header.b="049toeDq"
X-Virus-Scanned: Yes
Message-ID: <744da05c-4adb-47e2-b4fb-ad30127d979e@schwermer.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schwermer.no; s=mail;
	t=1717679547; bh=hnVEIMwyXlFKGghAzLhucsOZOpkgrJ/oSJ9HOiEMfW0=;
	h=Subject:To:Cc:References:From:In-Reply-To;
	b=049toeDqaMq1bO2aMSYB3DUJlCNdNP2qnvHJ63yjZgUlt/LsCHWdYDfeo+yZSwPrz
	 y/PX1DLNs8hLJPYxFb71mvSGEu4oEU7XAJxaEW4D5HxU51KJi4iZKnvhL51BdzQGUe
	 YzMvTsiAdNwbxYVyC99WmOi002ZTic6XFSCZwwq/ttEuO+CVyZTTDujUTTtiE6zIdE
	 8YtSUYdbutN5SkQB7z8qx2vq+8uXGXrgqeeYAwgoiShD6n0d6WTJYt8tE3vsM/2Vr2
	 OMcRzG6ShJN7nse8sinGZojsS6tDmn85WX7xCADjzzZJ1D56LgCvG6SrzQQU6E7M5l
	 c/RibcHCc3jjw==
Date: Thu, 6 Jun 2024 15:12:26 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: dm-verity requires WQ_UNBOUND with mxs-dcp
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev
References: <296810f8-367c-4a33-b315-3074690d4c36@schwermer.no>
 <20240528194201.GA1201@sol.localdomain>
Content-Language: en-US
From: Sven <dm-devel@schwermer.no>
In-Reply-To: <20240528194201.GA1201@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Do you happen to have some more infos on the self-tests you mentioned? 
Can you point me at documentation, I coulnd't really find much useful stuff.

Thanks

On 5/28/24 9:42 PM, Eric Biggers wrote:
> Does this driver pass all the crypto self-tests?
