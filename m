Received: from mail.schwermer.no (mail.schwermer.no [49.12.228.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116D817B419
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 12:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.228.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718108957; cv=none; b=AU18doshUuVOXsDNV13Y1tvQZVwTZ665xG9rKO3xaSZFRsQ5tbHMc9ZUTnV4bLueIqpPsFS/sLfvY7uHvOXIsQiLonqMH53oxiAIxjzEXblzuXGXo4CJf+TrfgVTkn+Jx55OKy6EJU7vEyMSCzFiegrWAE0/mptjf4hV/Krhz/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718108957; c=relaxed/simple;
	bh=l8nsXbZNEcfbpapZ6b65ljtK1IteOsWKvbKFVtzSY+g=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=YYE/rkxJ/1IptGzKKe3VDGQpACeOGjY4r40tON8CjxBylxEBqHQEHjjbncXV8EGFUEMOHHneN66hcEV54V2rIxrBOfaqJ97wPSH86EJTwfFTfzlB7H1Uw0Ir23/mgBciTP1qgzGQhjRTyFMmKy4688RGlHu9gxq3lvkJsq8f4sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=schwermer.no; spf=pass smtp.mailfrom=schwermer.no; dkim=pass (2048-bit key) header.d=schwermer.no header.i=@schwermer.no header.b=yqZMq+G8; arc=none smtp.client-ip=49.12.228.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=schwermer.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schwermer.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=schwermer.no header.i=@schwermer.no header.b="yqZMq+G8"
X-Virus-Scanned: Yes
Message-ID: <b63323bd-542d-43c9-a972-da5ec30a2b9a@schwermer.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schwermer.no; s=mail;
	t=1718108944; bh=l8nsXbZNEcfbpapZ6b65ljtK1IteOsWKvbKFVtzSY+g=;
	h=From:Subject:To:Cc:References:In-Reply-To;
	b=yqZMq+G8UO+Q/FcboVJiNrl4PAOhxowwd7zPg1V28eNNNGb7EktGcEjlTy7n8ZYtS
	 XdoAeRj0CQ9G7XKx+9REyjOB/RXa2foMsSaT1LvkfRykK/++2MuuRz49ZWrWRsQib3
	 hW6fJnK59z1yTskE5K7Xflr+kACv89zBAJ80Xi0QMa4SwCfcdxeTSxyLTj1RhPtm5q
	 S8kFxVfcDaMQIuF6bNx6ybwkibZttgGek4DoQN+SCutU6hELeATHY/698C3b4cwcfq
	 fBahcpoHFz4qmPLzR/SgGL0ZVRe54cLrto1crXBBxct1jtCIrwqKIwoIqz+x+ooFh9
	 d9ONRAsXjnVgw==
Date: Tue, 11 Jun 2024 14:29:03 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Sven <dm-devel@schwermer.no>
Subject: Re: dm-verity requires WQ_UNBOUND with mxs-dcp
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev
References: <296810f8-367c-4a33-b315-3074690d4c36@schwermer.no>
 <20240528194201.GA1201@sol.localdomain>
 <744da05c-4adb-47e2-b4fb-ad30127d979e@schwermer.no>
 <20240607052214.GA38537@sol.localdomain>
Content-Language: en-US
In-Reply-To: <20240607052214.GA38537@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The driver complains during self-testing, however, those errors seem to 
be thrown during aes testing not sha256 testing:

# dmesg | grep -iE 'crypt|alg:'
[    0.316442] alg: extra crypto tests enabled.  This is intended for 
developer use only.
[    1.055440] mxs-dcp 2280000.crypto: Invalid block size!
[    1.060927] mxs-dcp 2280000.crypto: Invalid block size!
[    1.164247] mxs-dcp 2280000.crypto: Invalid block size!
[    1.169591] mxs-dcp 2280000.crypto: Invalid block size!
[    1.204738] mxs-dcp 2280000.crypto: Invalid block size!
[    1.210093] mxs-dcp 2280000.crypto: Invalid block size!
[    1.371876] mxs-dcp 2280000.crypto: Invalid block size!
[    1.377280] mxs-dcp 2280000.crypto: Invalid block size!
[    1.394093] mxs-dcp 2280000.crypto: Invalid block size!
[    1.399432] mxs-dcp 2280000.crypto: Invalid block size!
[    1.431509] mxs-dcp 2280000.crypto: Invalid block size!
[    1.436904] mxs-dcp 2280000.crypto: Invalid block size!

The sha256-dcp self-test is reported as "passed".

I have tried to reproduce the issue by forcing many concurrent sha256 
operations from userspace using AF_ALG but I haven't been able to see 
any issues. Of course, this goes through the userspace crypto API, so it 
might not be the same as the kernel using it directly.

Any tips on how to narrow in on this issue are appreciated :)

Best regards,
Sven

On 6/7/24 7:22 AM, Eric Biggers wrote:
> On Thu, Jun 06, 2024 at 03:12:26PM +0200, Sven wrote:
>> Do you happen to have some more infos on the self-tests you mentioned? Can
>> you point me at documentation, I coulnd't really find much useful stuff.
>>
>> Thanks
>>
>> On 5/28/24 9:42 PM, Eric Biggers wrote:
>>> Does this driver pass all the crypto self-tests?
> 
> The crypto self-tests can be enabled by unsetting
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS, and preferably setting
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS in order to enable the full set of tests.
> 
> They might catch something, though they don't test parallel usage of drivers
> which is where it sounds like the issue here might be here.
> 
> In any case the bug here is likely to be in the mxs-dcp driver, especially
> considering that drivers tend to be much lower quality than the software crypto
> (some driver developers apparently don't even bother to run the tests).
> 
> - Eric
