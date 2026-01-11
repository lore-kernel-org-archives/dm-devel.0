Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF043213E89
	for <dm-devel@lists.linux.dev>; Sun, 11 Jan 2026 17:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768154392; cv=none; b=rO7FYi0Xdxx1A0+IQOjHpNJyetptzmw0tLsWEWpYFpLSGpCGrl4G5Dw90qlCKTPAzdD+kZMxnnuIeFeDdomXoVBvZFCwigr0JaOdL4wzTXaHUbdlAyNS/crOi+mr9Dkuz/yS/F5f2OhEa97BfNLJG7DFbPxW7tIe53UDWk+hUkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768154392; c=relaxed/simple;
	bh=V3m4ismIJQAsbHN/8chmLCUaIjYZON7QgLdJUzqoEQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IjVN2whajP6cVg7couTa6QOm/9bHl1NQ87kb/hDCVqjxizfk3zuMuIWntF7i+qc9ALDws/IGiYIRBgwDQ/2SYatbviAXu5rKwuNPXPFWHvO0NTnuKck6mJ0eUNIcJTBCEsEzeOhVJ77XsdkXwVrnY77s6B/P4pL/Vl1L2wHsv1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XaWaHAkH; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XaWaHAkH"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65063a95558so8415395a12.0
        for <dm-devel@lists.linux.dev>; Sun, 11 Jan 2026 09:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768154389; x=1768759189; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2oFsCDvdf+K4h93poiIWzTcv+QuUqjOYDkJQOYyKG3Q=;
        b=XaWaHAkHfrNiXqRmWzps7RjQUnj4Qt1NjswAJIWPAFLY82o3VTZ7aFpo3Smu1SgARy
         v3JFr2Lai2dknpD2FIdIvQeNzMWdVMayqzYZzlQ6RhjNlxG73W5xGfKnMpmOzu5JirCz
         DT77kXBosHhmyMbzNK3b4D4RgFrcYEKAPeVGp+/zSrcsgDKdIv6uzmYReTKZsdORqjBS
         WlzSs8OI/B8LQmsDCRVNaAeNLPqDjf17KPnr6sbF5oMQCYB5tM0JduVYNbxPtR70meOO
         kaSrMB4HDOGrF1y6GQlui8eK/weMf7PZQGmKVSemROtp7LIX91orhFYiRImP/GqewrPD
         aujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768154389; x=1768759189;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2oFsCDvdf+K4h93poiIWzTcv+QuUqjOYDkJQOYyKG3Q=;
        b=GzfHZlIOi7EHUlSYLFPvjOvJh3svBQ3bOPVCdFLmhOApUrmz/qF6mC6nAb3jSURycJ
         L2JoS30gCQg/Hcz1riieho1LYcEOUcooifJUJj5MgXrWSp84LnzoUywCUbbrWcX5Txrg
         JBIyigKzJCp0aM1KdiOJp8p2F0aWGriTnHDxbcRfysKGg1xyrQT0YTlkZfOEgVB213Qn
         s45RXaguQGVSowlEx3iVFRbmQ+4fQsshWbVN/8xekWUHNJoAmXvwVEh/llbp4ddGv38K
         xtooSVhy0UhW+/LAcqSWB9pVlogU9+WDLwIjPOZFxKyo9MtIreSeuBQGmebFYLEPIcvJ
         qblw==
X-Gm-Message-State: AOJu0YzHe7ntjimDen+OKvmBkjKuU2ZYxCY5kjOUwApRrvTcfeEG/VDx
	Qm8i1YLYNsbZAwubk6kpY5M/CUzvNmgOFHgP81H9WtlLbCvhVCssAP7i
X-Gm-Gg: AY/fxX73Oz1yeN0oL5J0piQDrtny4Va050D3n80I1a5TZEEpjB/tWVqC7mGME/MnoQB
	VCnhkF5HMFHbsKVNSwwDVZ53pH4gsWKNLwCGrLlbjN4WMDrXVOVv7hrKSP1rCeXRjQ1iWWecNCD
	aKUxAbchz3XlIMrpKb4VvY1e7UvJUANWaI7oIadXAAYXLuhJKOA/1w59WObhRE3DR6kxbtdUCIC
	2I7wtI9xwuhblbmh77BE3qBH4+/iHmI4yU88aEU7AJgW7GKQXNkhzsaxkHg9iXDGFsvkH+uPwRd
	8OMyRigwdOH5f+MKkqXz2JL/HSUGSEOYuo/nKhonFqijMpJhyX3wCt41MTm7dNz2BKb9DYFOkz+
	ezxH3BJV7f5nkFht+ELZjA4xOm4BieTXVOlkyutXOH+/zB9D93p5yNmQUrfYbNE/VIVHIRZPoKO
	avTO2+b2CRzSxbEIv+QpW6ccwKLwEw8odfMwyNrCpm0+9hZME=
X-Google-Smtp-Source: AGHT+IGIPNl5Gb4dhJtpebyqB7+K6TDnSvvsD53OVqfLpRxsLs6btnKavSQL/uO3vEnE9ZpSKR2uQQ==
X-Received: by 2002:a17:907:a08:b0:b74:984c:a3de with SMTP id a640c23a62f3a-b84452837c3mr1571941566b.28.1768154388871;
        Sun, 11 Jan 2026 09:59:48 -0800 (PST)
Received: from [10.137.0.14] ([146.70.124.156])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b86faa6be37sm413044066b.36.2026.01.11.09.59.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 09:59:48 -0800 (PST)
Message-ID: <3150e43b-523b-442f-a2de-a89be43a248c@gmail.com>
Date: Sun, 11 Jan 2026 19:59:46 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFQ] dm-steg : a deniable encryption module
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>,
 =?UTF-8?Q?Marek_Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, Milan Broz <gmazyland@gmail.com>,
 "Bryn M. Reeves" <bmr@redhat.com>
References: <022d700d-d3d8-4ef9-8d7b-505f7df89354@gmail.com>
 <c3e8ba98-2ac9-9424-f6ad-d279f22c2073@redhat.com>
Content-Language: en-US
From: Leo Samulis <anagon@gmail.com>
In-Reply-To: <c3e8ba98-2ac9-9424-f6ad-d279f22c2073@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/7/26 11:26 PM, Mikulas Patocka wrote:
>
> On Tue, 23 Dec 2025, Leo Samulis wrote:
>
>> Hello,
>>
>> I'm Leo, the author of dm-steg ( https://dmsteg.sourceforge.net/Steg.pdf ), a
>> deniable encryption module for device mapper. It was working nicely in 2011
>> but I got caught up in life and never updated it.
>>
>> What would need to be done for it to be accepted into mainline device mapper?
>>
>> Would I simply need to update the code, get it working reliably, and then
>> submit a patch? Or would the specification and use of crypto primitives also
>> need to pass a separate cryptography exam?
>>
>> Thanks in advance,
>>
>> - Leo
> Hi
>
> If it doesn't interfere with other kernel code (i.e. if it's just one or a
> few files with no changes elsewhere), it should be quite easy to get it
> in. There is no formal verification of cryptography required.
>
> Milan Broz is developing the userspace cryptsetup package, so you can
> discuss with him how to integrate it with the existing tools.
>
> I think that (if possible) it would be better to integrate it with
> cryptsetup.
>
>
> Just one big warning - it doesn't work on SSDs!
>
> If the attacker unsolders the flash chips from the SSD and reads them
> directly, he can read the mapping table for the blocks. From the mapping
> table, he can infer which blocks were written recently.
>
> I.e. if you recently wrote to the hidden area that is supposed to contain
> random data, the attacker would know that you wrote there and know how
> much data did you write there - he just wouldn't be able to decrypt actual
> data.
>
> So, I suggest to either disable it completely on SSDs or print a big
> warning that it is not as secure as it is supposed to be.
>
> Mikulas
>
Hi Mikulas,

Thanks very much for your reply!

Lack of formal verification for cryptography is both a blessing and a 
curse. I'll KISS.

Re: Milan Broz, I'm not sure how much traffic you guys like to see on 
dm-devel, so I'll drop him a private email. I agree that cryptsetup 
integration is the ideal, and I see no reason why it's not possible.

Re: SSDs - I already thought of this. See Section 4.7 Transparent 
Aspects @ https://dmsteg.sourceforge.net/Steg.pdf

Thanks,

- Leo

