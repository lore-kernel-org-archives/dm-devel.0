Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B32748F837
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 11:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.30.212.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789990643; cv=none; b=enWZuLDSlwj53FO5wAeK4LRbPqwNmvPT0p6zZiymW4dz5YZyU61TCDdSw+Vy7PY8cbia72mtesLerg131gRIO1ffCW3EMWQkQ6Cupnz2ePgLdMc06y5s7G99Or4DyFqPkmVgBiOHQvEU4uwnyXKgC4gwl+WHqZ9GpFtDS3pIK5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789990643; c=relaxed/simple;
	bh=LdM4mY9Nz0zcvD+YALzhKs/jO+4E95E5COO3p26ClF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pW1ewqXYZsd/0gwP+c6F8Hkwk+6/FCaOT54MT/00ug3kCeB7UV+L96YHa0QRKoD5/x9Oh8iNVMAk73US8u/xpkhGzyCdf61vnRKPfYCoX+S2bQABSkJWzrp2hlmASOx80zTPf94oCiEDVQ12MX0OOlpLHZbWm3UV63jbUFjoAXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embetrix.com; spf=none smtp.mailfrom=embetrix.com; dkim=pass (2048-bit key) header.d=embetrix.com header.i=@embetrix.com header.b=cdwoRbpl; dkim=permerror (0-bit key) header.d=embetrix.com header.i=@embetrix.com header.b=UvuQ778N; arc=none smtp.client-ip=46.30.212.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embetrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=embetrix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embetrix.com header.i=@embetrix.com header.b="cdwoRbpl";
	dkim=permerror (0-bit key) header.d=embetrix.com header.i=@embetrix.com header.b="UvuQ778N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1789990568; x=1790595368;
	d=embetrix.com; s=rsa1;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=9J5dZMdZm/gGQtb0P7U3KP1/b4Bcm8tjmsLOfVuk8/c=;
	b=cdwoRbplKWvHICnileGfxB+eTjKQJxiVwukZAvfs+474kMJIrgeaYLFPc5LGV7+YxU9iC/0pkYjIF
	 LLvxXV+m7LwE9OKTn5wZRhNS94Q+NuOxoW1M3CDGhePMBTnzzgwo9o/pPlm6VpHkEqLCAfNPrV+/jY
	 g1e5vPtFASSDbOfEt3C891y6ADj2wX6JpBLrR6im7NqVb12iC+vhRPzqquXjtFA9YumRnn/SaB2YUg
	 f17D4TB0evQE++0UYUFZgT/GHmmAeajPbklYPBEf31VqWg2MdFZHgKDso5riZmfAxtRsMRCcGaa2Sg
	 nu6zgq68ygQcE+qAmjXiZrjE1YcbpoA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1789990568; x=1790595368;
	d=embetrix.com; s=ed1;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=9J5dZMdZm/gGQtb0P7U3KP1/b4Bcm8tjmsLOfVuk8/c=;
	b=UvuQ778NPc00MPNTyAKhEUbQ5LBo2ysscpbi2nSi3lGDmMbGdNK11JYRH5VjQEbxY7Pt0iD6hTbI1
	 I0ccpOMDg==
X-HalOne-ID: a2218365-b5b0-11f1-81da-df8125a0c701
Received: from [192.168.1.130] (unknown [160.178.122.52])
	by mailrelay5.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id a2218365-b5b0-11f1-81da-df8125a0c701;
	Mon, 21 Sep 2026 11:36:07 +0000 (UTC)
Message-ID: <97f8d660-a523-4011-ba15-6f708cb1b589@embetrix.com>
Date: Mon, 21 Sep 2026 12:36:06 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-verity: add DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: snitzer@kernel.org, agk@redhat.com, bmarzins@redhat.com,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, corbet@lwn.net,
 linux-doc@vger.kernel.org
References: <20260907171939.355472-1-ayoub.zaki@embetrix.com>
 <a37a63f2-e45d-4e51-0c2d-bd19cca5fe88@redhat.com>
Content-Language: en-US
From: Ayoub Zaki <ayoub.zaki@embetrix.com>
In-Reply-To: <a37a63f2-e45d-4e51-0c2d-bd19cca5fe88@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,


On 9/21/26 11:46, Mikulas Patocka wrote:
> Hi
> 
> The argument can be turned off even with your patch - by specifying
> dm_verity.require_signatures=0 on the kernel command line (read-only
> module parameters can be modified on the command line during boot).
> 
> I'd like to know what kind of security problem does this patch try to
> solve. If the attacker can tamper with the kernel command line, he can
> already gain root (i.e. by using init=/bin/bash).
> 
> Mikulas

Thanks for reviewing.
I should have highlighted the change to bool_enable_only: with 
CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE=y it rejects attempts to 
clear require_signatures, including from the command line.
I followed the existing CONFIG_MODULE_SIG_FORCE and module.sig_enforce 
implementation.
My intention is to make signature enforcement a build-time policy rather 
than depend on boot configuration.
I fully agree with your point and that this patch alone does not protect 
against arbitrary command-line tampering.

If required I can clarify the scope in a v2 ?

> 
> 
> On Mon, 7 Sep 2026, Ayoub Zaki wrote:
> 
>> Add DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE Kconfig option.  When enabled,
>> dm-verity always requires a valid root hash signature: require_signatures
>> defaults to true and can no longer be cleared on the command line.  When
>> disabled, the existing require_signatures module parameter controls
>> enforcement.
>>
>> Signed-off-by: Ayoub Zaki <ayoub.zaki@embetrix.com>
>> ---
>>   Documentation/admin-guide/device-mapper/verity.rst |  5 +++++
>>   drivers/md/Kconfig                                 | 14 ++++++++++++++
>>   drivers/md/dm-verity-verify-sig.c                  |  4 ++--
>>   3 files changed, 21 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
>> index eb9475d7e196..bb48c001aeac 100644
>> --- a/Documentation/admin-guide/device-mapper/verity.rst
>> +++ b/Documentation/admin-guide/device-mapper/verity.rst
>> @@ -163,6 +163,11 @@ root_hash_sig_key_desc <key_description>
>>       also gain new certificates at run time if they are signed by a certificate
>>       already in the secondary trusted keyring.
>>   
>> +    Whether a signature is required for every dm-verity device is controlled by
>> +    the dm_verity.require_signatures parameter which defaults to off. Setting
>> +    DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE makes it default to on in which case it
>> +    can no longer be turned off.
>> +
>>   try_verify_in_tasklet
>>       If verity hashes are in cache and the IO size does not exceed the limit,
>>       verify data blocks in bottom half instead of workqueue. This option can
>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> index df27c7d066d2..59098d1f4534 100644
>> --- a/drivers/md/Kconfig
>> +++ b/drivers/md/Kconfig
>> @@ -610,6 +610,20 @@ config DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
>>   
>>   	  If unsure, say N.
>>   
>> +config DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE
>> +	bool "Require dm-verity root hash signature verification"
>> +	depends on DM_VERITY_VERIFY_ROOTHASH_SIG
>> +	help
>> +	  Reject dm-verity devices that are created without a valid root hash
>> +	  signature.  Without this, whether a signature is required is decided
>> +	  at boot time by the dm_verity.require_signatures parameter which
>> +	  defaults to off.
>> +
>> +	  Enabling this makes that parameter default to on and it can then no
>> +	  longer be turned off.
>> +
>> +	  If unsure, say N.
>> +
>>   config DM_VERITY_FEC
>>   	bool "Verity forward error correction support"
>>   	depends on DM_VERITY
>> diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
>> index b2b55c41e2cb..aadcf5e4a47c 100644
>> --- a/drivers/md/dm-verity-verify-sig.c
>> +++ b/drivers/md/dm-verity-verify-sig.c
>> @@ -21,8 +21,8 @@ static bool dm_verity_keyring_unsealed __ro_after_init;
>>   module_param_named(keyring_unsealed, dm_verity_keyring_unsealed, bool, 0444);
>>   MODULE_PARM_DESC(keyring_unsealed, "Leave the dm-verity keyring unsealed");
>>   
>> -static bool require_signatures;
>> -module_param(require_signatures, bool, 0444);
>> +static bool require_signatures = IS_ENABLED(CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE);
>> +module_param(require_signatures, bool_enable_only, 0444);
>>   MODULE_PARM_DESC(require_signatures,
>>   		"Verify the roothash of dm-verity hash tree");
>>   
>>
>> base-commit: df2908090cda368b01ff43709f51890076c56157
>> -- 
>> 2.43.0
>>
> 

Mit freundlichen Grüßen / Kind regards

-- 
Ayoub Zaki
Embedded Systems Consultant

Vaihinger Straße 2/1
D-71634 Ludwigsburg

Email    : ayoub.zaki@embetrix.com
Homepage : https://embetrix.com


