Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6558D3BED18
	for <dm-devel@lists.linux.dev>; Wed, 29 Apr 2026 12:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777466049; cv=none; b=C8PPWspVr9ci34qZ2YeCEaT3+rQxHZi7rvRsYHINvJAwC31ZSh5xnHMeutOX2A6zHTrXz4DinbBWl4dn6u24Rm7QvMc0Q/VhSXaZL72TQuFjbR51mEG/gEtZwu1udOHQXvca3tB9gurwHwTzJn4z2wtKx0g/0oc6HddbT06BOHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777466049; c=relaxed/simple;
	bh=sdcsv9NyXfxxr3df9sMar2q/gbpIVDepv6xljGdN+TE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cW8FvRbEToIJLxhA+/AEdPUpDhl6ONfGKSeUIAJ3dh/1GQaQqgzH0rzeiQSKbEJVZEuTg3Nggn8JiCiMjxEeTL3ZfkgfQj1+Zlws/spuvkhYaj5cZvTkZfIook49TyFV0EmAmxextV/poqoRDwDmGMPEsv0RbmZB6gxGGOThLJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Rpk6QOvj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XBJkedvp; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Rpk6QOvj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XBJkedvp"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63T8prGh1728584
	for <dm-devel@lists.linux.dev>; Wed, 29 Apr 2026 12:34:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ESKRVLao67V51kqXr2l1u0fZIaIK0uFsHy1DPkT8I18=; b=Rpk6QOvj/ExBWkDK
	ufF5Au2L4yaCwWKcCSGrKdknn0mLwhq0VfWLMbDJ8BZUS/uzbqCSCPfVGO8q032g
	5H3TwX85uHd6Q0hbQgczNaTTRUiVeF81tUKThK8yNfD/NiKy7Cq1MZKjRWQ775KG
	p+3hkT05Yb4PJiRCFLr8wpdrzg0r1/xSAVNwQDfrqE7RNjhVg7WVvvqbACu/nXYy
	9IwFrXZ4Awv5SRZB/6RRawSqrCKyGGXPZDfS3yjfoif+aZr5YpSNqe4YbVESXPeW
	Ojxn04MvZEKAqg0ZCGCXZI+skfpldbqzB0ZksyfsU1AspBExBcmfG+BVULN+2Exy
	SrpNNQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4due5ks0ss-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 29 Apr 2026 12:34:07 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2dd6fb4c867so27692603eec.0
        for <dm-devel@lists.linux.dev>; Wed, 29 Apr 2026 05:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777466046; x=1778070846; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ESKRVLao67V51kqXr2l1u0fZIaIK0uFsHy1DPkT8I18=;
        b=XBJkedvpInuRnqeQlY9B3zrffVQtMffVUdTG1k3rb92dfEMJ/Udrc0OdaxNp/hReqU
         H6XtJwh6yMBBZVqsl803jhFcNFbb+xvp8pK+dwBp684wDmLtqchY2UoUOVIByJNJOfIU
         9fgHsI2C6KNgGUbH0fTL0DdBTgVl8EkpT+GLhKgmNwj6xoq67BG+0C1wFeoBMZ8m4eZP
         3QCozLVNf2xQlLgocOUdu1nypA8KG8ujgIRg2wMNgn04CWodEY8JFe5Za+CITXGNhZui
         8vRu9gVeE04s4tsQ7QJnzZzLM7ENZLxslT8aypZ5qDREQgxqoc9g4y/lxlQoIQdAZTdf
         XPpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777466046; x=1778070846;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ESKRVLao67V51kqXr2l1u0fZIaIK0uFsHy1DPkT8I18=;
        b=a/Cok2J44PnjL6gs+rJkcsADmHd0cxWiWmCka3bgP1T0kEOxbF0jR3w18DkD20e3iy
         UNEQt9maOsLZXNqr2BUiEmmlCYzSCfRARj+JZ6x4AoBRcPtAZItU0JtDevSx88GjJOvW
         loZj4mR8T1aW0HoIL/6FYUtdxrGLb+sMSFlsmxdYcSyKDM+K2BaK1FB09sf+m4POvke9
         TqgATeYFiXYu+KB+HBLKooLQPD0R+q/E+ayTokuCYuo+5bllMSKuws3dKLpPFefWXzSK
         5SOWuzV7GSH0flRUkc68Z/cqaNM5UUYuiE5qj0vjVKtGZiG4mimlnGnunjIcM9CUWlTX
         axzA==
X-Forwarded-Encrypted: i=1; AFNElJ+DCErDQhUPVYZF6G/56DQltrrsmc/MXs4qf3Cpb914fC7cqYRbWZ2hXo+ctr4fk4ks+Q+CiY73zw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwAS9mMD07QD02+O8jN8GoI/hjjB9etjbn8/vu+GH1ohMnFYtB6
	Nma3tYx9D9kHVGuurbWRT7N9ceEg4svyKhHMQMI/7pPnNVesISyHcPyr8PrUuZAIFIqJDp8jiW6
	E2pguGqO6b2Gekv8gJQNn33yVZqtQAFSwSKD9FunRr341NwOZ0XNrYAMPAreuEw==
X-Gm-Gg: AeBDievPjQNnWfhKTMVWMKcaFSKVYzEVhocwdQMU7YDPIdpCSYr5qOTIaY0muRveHw9
	/7UIy07RepddiM3zi1mVffR8JtDFXH7sdc+V6ZEDhM2qCDpC91mCf79JOGulWSlbeLKUMQkrCeN
	2SrXE8JBpVJVCq8yFW/Tc4S2TwTWnDdDqXDNIoGk3WM5KB+H7cAe3VjOI7NFoFrItYm6/hbOj/0
	ELoy1vRLmtjutVMC9FeAwGaRfA5yrsiNsekgVx7w5aPiOxVaKL37m1Yv/BPfBiwTlYeOVpJ+qEG
	9mopYrh2+nbaX36WVsYp3zAC4LFW0f5rLHyYk9/GObWgv+dLaO5Z5Dw+aQZqZG4Vqt7zCKNoIBG
	Qhw0iy5zM9rffhQDU77XbGfBmMAYP6qGrw3MKLMAwJRfrHxVCkzq1Ay9BeHUVsCOr395JLPmDNT
	zekZgQui3NszTYxA==
X-Received: by 2002:a05:693c:3017:b0:2df:7b88:a1b0 with SMTP id 5a478bee46e88-2ed0a1a9028mr3495475eec.27.1777466046140;
        Wed, 29 Apr 2026 05:34:06 -0700 (PDT)
X-Received: by 2002:a05:693c:3017:b0:2df:7b88:a1b0 with SMTP id 5a478bee46e88-2ed0a1a9028mr3495449eec.27.1777466045450;
        Wed, 29 Apr 2026 05:34:05 -0700 (PDT)
Received: from [10.110.45.159] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ed1c09c6e3sm1847750eec.25.2026.04.29.05.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2026 05:34:05 -0700 (PDT)
Message-ID: <7ab5cd97-30b7-42ca-80ce-6d9cd8c45b73@oss.qualcomm.com>
Date: Wed, 29 Apr 2026 20:34:00 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] dm-inlinecrypt: add target for inline block device
 encryption
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: linux-block@vger.kernel.org, ebiggers@kernel.org, mpatocka@redhat.com,
        gmazyland@gmail.com, linux-kernel@vger.kernel.org,
        adrianvovk@gmail.com, dm-devel@lists.linux.dev,
        quic_mdalam@quicinc.com, israelr@nvidia.com, hch@infradead.org,
        axboe@kernel.dk
References: <20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com>
 <20260410134031.2880675-3-linlin.zhang@oss.qualcomm.com>
 <ae7yzw-5wz9cqZt8@redhat.com> <ae_vacHQ75AgZbm_@redhat.com>
 <6390db35-7f8e-4d00-9c1f-43d676007910@oss.qualcomm.com>
 <afDh8XRWW_JgaUP3@redhat.com>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <afDh8XRWW_JgaUP3@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI5MDEyNyBTYWx0ZWRfX4SPpZwygXZFJ
 TgNvMJsjBJhJCDl4KOmVHMdLX4p1eu6CsgTVBZ/plTzSb3X4AxKzyJz/hpizKHUQ0MCZ7BL0JhF
 ElBg5/aDNnZwm9mtner1I5fcBuzgjtDkD0HyL0FLmjZ33BeT3ObgI004Btrbv3jJ/OK4XlLR0Q1
 z+gKuUQyd77Vk2ooAQ2xP9d589ZwnSVWHJZsgVltqevMcVWTKDLUqdBFCAkiTnikonmOLfR04yE
 uj6mvrPOo4WCcp8RN5LXxA+FbMyO7bo6eKEM5AluU2eYKxTgA2C0UBKFgCm3+AwGQl4Q09/k1nl
 iUustZBRxlN2e1e/M7Ro7l7LvOBIED2iVrTZLyxjQk/PQCr3RoDnUEkgjGtzlXpOs4qLgSOXnyS
 hxtG2/svFGWuVkInqHcHEpb9ze/NCZg4AVvLdvVzybw2NDDVb8nstGOeL57B5IQSIciah/ItD5N
 G66Lvf1VGBQILnVlZFw==
X-Proofpoint-GUID: oRj4aLov0_2iHyD6VQaOD1cvK6ALFsK1
X-Proofpoint-ORIG-GUID: oRj4aLov0_2iHyD6VQaOD1cvK6ALFsK1
X-Authority-Analysis: v=2.4 cv=CL4amxrD c=1 sm=1 tr=0 ts=69f1fabf cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=1XWaLZrsAAAA:8 a=PdZeKNdsCEgzLFXmAeUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_05,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604290127



On 4/29/2026 12:36 AM, Benjamin Marzinski wrote:
> On Tue, Apr 28, 2026 at 05:20:07PM +0800, Linlin Zhang wrote:
>>
>>
>> On 4/28/2026 7:21 AM, Benjamin Marzinski wrote:
>>> On Mon, Apr 27, 2026 at 01:23:27AM -0400, Benjamin Marzinski wrote:
>>>> On Fri, Apr 10, 2026 at 06:40:30AM -0700, Linlin Zhang wrote:
>>>>> From: Eric Biggers <ebiggers@google.com>
>>>>> +	/*
>>>>> +	 * Since we've added an encryption context to the bio and
>>>>> +	 * blk-crypto-fallback may be needed to process it, it's necessary to
>>>>> +	 * use the fallback-aware bio submission code rather than
>>>>> +	 * unconditionally returning DM_MAPIO_REMAPPED.
>>>>> +	 *
>>>>> +	 * To get the correct accounting for a dm target in the case where
>>>>> +	 * __blk_crypto_submit_bio() doesn't take ownership of the bio (returns
>>>>> +	 * true), call __blk_crypto_submit_bio() directly and return
>>>>> +	 * DM_MAPIO_REMAPPED in that case, rather than relying on
>>>>> +	 * blk_crypto_submit_bio() which calls submit_bio() in that case.
>>>>> +	 */
>>>>> +	if (__blk_crypto_submit_bio(bio))
>>>>
>>>> This will still double account for fallback writes (which call
>>>> submit_bio() on the encrypted bios, and return DM_MAPIO_SUBMITTED here). 
>>>
>>> Just to clarify, I'm talking about the vmstats accounting. The IO
>>> originally gets accounted by submit_bio() when the bio is submitted to
>>> the dm device. For actual inline encryption and fallback reads, dm will
>>> submit the bio to the underlying device using submit_bio_noacct() to
>>> avoid double-counting the IO.
>>>
>>> For fallback writes, __blk_crypto_submit_bio() will submit the encrypted
>>> bios to the underlying device with submit_bio(). This adds the IO
>>> sectors again, even though it's the same IO, only encrypted now.
>>
>>
>> Right, thanks for calling this out.
>>
>> For fallback writes, the IO is still double-counted. Given that this only
>> affects IO accounting in the blk-crypto fallback write slow-path and not
>> correctness, I think this is an acceptable tradeoff, and we can leave a
>> TODO to revisit the accounting once a better solution exists.
>>
>> Add the bellow to the annotate.
>>
>>   /*
>>    * TODO: blk-crypto fallback write slow-path currently double-accounts
>>    * IO in vmstat, as encrypted bios are submitted via submit_bio().
>>    * This does not affect data correctness. Consider fixing this if
>>    * a cleaner accounting model for derived bios is introduced.
>>    */
>>
>> Do you agree?
> 
> You could add an extra argument, for instance "bool need_acct", to
> __blk_crypto_submit_bio(), and plumb it through to
> __blk_crypto_fallback_encrypt_bio(), where it could be used to choose
> between calling submit_bio() and and submit_bio_noacct().
> 
> We could even add a flag to cloned bios for stacked devices, that could
> be checked in submit_bio(), so we didn't need to have
> submit_bio_noacct(). But this is a pretty niche case with other
> solutions, so I'm not sure if it warrants adding more checks to
> submit_bio().
> 
> I do agree that people probably aren't using dm-inlinecrypt for devices
> where they don't actually have inline encryption capabilities, so it's
> not a major issue. What to you think, Mikulas?

Thanks for the suggestions.

Adding a bool need_acct parameter to __blk_crypto_submit_bio() would require
updating all existing callers, which feels rather intrusive given that the
accounting issue only affects the blk‑crypto fallback write slow‑path. I’m a
bit concerned that this would broaden the scope of the change more than
necessary for the problem at hand.

An alternative might be to track this at the bio level instead — for example,
by introducing a bio flag or metadata that indicates whether accounting should
be charged for a derived/cloned bio. That would avoid having to thread additional
parameters through multiple blk‑crypto entry points. However, this likely needs
a broader discussion to make sure it fits well with existing stacking and
accounting semantics.

Also, as discussed, the current behavior does not affect data correctness; it
only results in double vmstat accounting for fallback writes. Given that
dm‑inlinecrypt is expected to be used primarily on devices with actual inline
encryption support, the fallback write path should be relatively uncommon in
practice.

With that in mind, would it be acceptable to merge the current change as‑is,
with an explicit TODO documenting the double‑accounting in the fallback write path,
and revisit the accounting model in a follow‑up patch once we have agreement on a
cleaner solution? What do you think, Ben and Mikulas?

Happy to iterate further if there’s a preferred direction here. 

> 
> -Ben
>  
>>>
>>> -Ben
>>>
>>>>
>>>> -Ben
>>>>
>>>>> +		return DM_MAPIO_REMAPPED;
>>>>> +	return DM_MAPIO_SUBMITTED;
>>>>> +}
>>>>
>>>
> 

