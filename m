Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFB7150981
	for <dm-devel@lists.linux.dev>; Tue, 23 Jul 2024 13:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721740306; cv=none; b=is1wPB8SkdXIeY+BrSppGv9j3hlzLidkNwyXjXG4rPQBZJ0Vwv6kKk9JiNjjNqZshTtKpqcyvRELhWFOzzME0JRGLkm57EQS1qiCPOvb+ba5ZyM4unNqc12XtGX2HKveiOmTVJgdsulfMN6S6gcRF8qbotnMjq0NeZQM1AbPf8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721740306; c=relaxed/simple;
	bh=tqg9ZDnn7abveVBNBGqM0xGeg6E3o4gkwa1atwwkjbg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bcvxyp/Uy7OW7+UKH1vkJWKU5BXQVXemVQWAgZN01nyAaG8VAeFxSXyZrt2Bd6y32eZJbMBzgI4zcfA9Cs4Dvia1t94D/rCoUDkqa3wm4yIa8fd2QhhUr47hNZNOZnu02XOUuWe7zE+jReC4T7mj5XdOZt7T3Yz3p1xTDu1S4NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HsFaVkEj; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HsFaVkEj"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-58f9874aeb4so4424481a12.0
        for <dm-devel@lists.linux.dev>; Tue, 23 Jul 2024 06:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721740302; x=1722345102; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iFtSsxWtRthRuaPHYKwLiagJ8YkwPf9cDZq3BkTUzUw=;
        b=HsFaVkEjY87DKqabmiDnyDosNYvShdWPeP2OHgLRjWAcy3A4OPkjXe4O6ZLw+quF1K
         7DGfEEPymEZ7ZT42bmPP0H8YwYdiVc/fpDCbyCy8K6+oQaSv9t8RuZREdl735RJPVwpS
         CguzhPqLHSY8ly0Nhf5dbFrWLdQIBlt4RGjUP+TdD7Zw3l26UgkMCOZa5j5EBUurWyra
         55ggzb0Rv3ZcNR2qn+G4ZG465ijwbjmJ34pO/HzQ4yszJMRugEpYaA5LOAS6Cj/+ntIP
         UTH+bfudK7E2FHarSkx1Wt7sSAb61y9TD/YbQMWsAaHHP1XqP7Uxofu0jGyI5yxooFG5
         4UJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721740302; x=1722345102;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iFtSsxWtRthRuaPHYKwLiagJ8YkwPf9cDZq3BkTUzUw=;
        b=ZeJCCAbfWMIDdNEuNKPtp5BhYmzH817BrMzUvnjYU2hC0nSr3BMUdXmWipkv5Xl3sd
         g4OvEovQIub8DjceQJ4rKOnqdynw9eUzH0Cwo0rj6KlteUNU/qHB+NkZq6GJz7rFjiTm
         HESqWAVg+25KABtpi6nghYsCX3bJs1AIOUtijdRz/QA2/mjd0aZjS/vOKVRURaiS3j3R
         Hvz9xNMLJwAH9dXso7ixihutanBWOPkPxtXl/1Ly+BfCz62zQkObb4No27VrHbZ7tCuJ
         pAbB5j5HCigWRrq//aKmZwQXRclFvqzBhG++aySsps0w4o+hn9DnJuaObwRtxHwzWGNy
         k63A==
X-Forwarded-Encrypted: i=1; AJvYcCXfHOHfjo52rJR77R2ApsNbdix6AJAf9x98eV1kbWv4SMAWMoOsqeeMpIXd+M9X2iHDGRglvn3mZteikQi1YQ6RhQCcCdNuUts=
X-Gm-Message-State: AOJu0YzMAm0K09EsizPwCtt5teXgwKSIqm/JUN4zOIQaSmFyN0lo1q40
	T8vsSioCBNvnIjTnT70zwxp7/kApQESeK2fzj7nqp3Sqwfi4P0a9
X-Google-Smtp-Source: AGHT+IECDg37JXoANp03eWcpMeYZacIl3j7qii6dBzTLX4GZA4N5VX3DGNBDx5+CRyudmU0XKQS+5w==
X-Received: by 2002:a05:6402:4303:b0:582:5195:3a79 with SMTP id 4fb4d7f45d1cf-5a3ee8a9f88mr8449710a12.6.1721740301837;
        Tue, 23 Jul 2024 06:11:41 -0700 (PDT)
Received: from ?IPV6:2a03:a900:1000:7e9:1b66:bd88:3ed1:3fd2? ([2a03:a900:1000:7e9:1b66:bd88:3ed1:3fd2])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5a30a4d6bf8sm7494317a12.18.2024.07.23.06.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jul 2024 06:11:41 -0700 (PDT)
Message-ID: <99266e5d-de9d-4d31-a1f2-d003bddb7b44@gmail.com>
Date: Tue, 23 Jul 2024 15:11:37 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] dm ioctl: fix erroneous EINVAL when signaled
To: Mikulas Patocka <mpatocka@redhat.com>,
 Khazhismel Kumykov <khazhy@chromium.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Zdenek Kabelac <zkabelac@redhat.com>, Joe Thornber <thornber@redhat.com>,
 Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, Khazhismel Kumykov <khazhy@google.com>
References: <CACGdZYKbdyALADEMDV+Vg+eog+UjjgGigEpmJTSKw_64RM8rbA@mail.gmail.com>
 <20240717231833.2090430-1-khazhy@google.com>
 <34139e33-3e7-4895-bd4-2d9f7727e9fb@redhat.com>
Content-Language: en-US, cs
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <34139e33-3e7-4895-bd4-2d9f7727e9fb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dne 23. 07. 24 v 14:51 Mikulas Patocka napsal(a):
> 
> 
> On Wed, 17 Jul 2024, Khazhismel Kumykov wrote:
> 
>> do_resume when loading a new map first calls dm_suspend, which could
>> silently fail. When we proceeded to dm_swap_table, we would bail out
>> with EINVAL. Instead, attempt to restore new_map and return ERESTARTSYS
>> when signaled.
>>
>> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
>> ---
>>   drivers/md/dm-ioctl.c | 23 +++++++++++++++++++++--
>>   1 file changed, 21 insertions(+), 2 deletions(-)
>>
>> v2: don't leak new_map if we can't assign it back to hc.
>>
>> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
>> index c2c07bfa6471..0591455ad63c 100644
>> --- a/drivers/md/dm-ioctl.c
>> +++ b/drivers/md/dm-ioctl.c
>> @@ -1181,8 +1181,27 @@ static int do_resume(struct dm_ioctl *param)
>>   			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
>>   		if (param->flags & DM_NOFLUSH_FLAG)
>>   			suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
>> -		if (!dm_suspended_md(md))
>> -			dm_suspend(md, suspend_flags);
>> +		if (!dm_suspended_md(md)) {
>> +			r = dm_suspend(md, suspend_flags);
>> +			if (r == -EINTR)
>> +				r = -ERESTARTSYS;
> 
> I'd like to ask why the "EINTR -> ERESTARTSYS" conversion is here and why
> it isn't in dm_suspend?
> 
> What do libdevmapper+lvm maintainers think about it? Does lvm hadle EINTR
> by restarting the ioctl syscall? Should we return ERESTARTSYS when suspend
> is interrupted?

In general - with suspend failures - we are just stopping whole operation - 
and restoring previous state - so user can run operation again.

There is no special check for exact reason of ioctl failure.

Regards

Zdenek

