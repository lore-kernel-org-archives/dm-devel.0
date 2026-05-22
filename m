Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7938A392C57
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 05:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779429388; cv=none; b=t+tPXhxuujtbR72pFCq98NThRsT2fh0PIqZ3x2xwaKu6UP3Bp3cmV3b8IBhP4mwWiuOPu2cJ7JN63Wh5T9OrVPArhuapKdcKnOv7I6ItJffFWsW2fiXvQwGnl+OT8IimX3aoTym2W+QHz0NnWIDjxGNpVSMMmTCJqZvro6t22KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779429388; c=relaxed/simple;
	bh=Qt1n0KdM0wIAqdbqxxW54xRT+G2unHl8FzyI1UydKlc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mx6YbngtezuwBAHa3EjANLWHNYRkfIgdjtiuZYVvAyVG2UAwWisXmsx0/eSb4AUEIMJAfsTmtJi5U92sYaqbGFnKt/3ixmTxdCblxMM2zxtJ6ufMFhEAk+9DZpDtFdNtvAgCzz62IsftEGduvlsR49MY+qViSOZDyKbyJXKjqEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NqeIfyCV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=G09LEU84; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NqeIfyCV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="G09LEU84"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64M2wogi3532125
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 05:56:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LLUYimo4jYypFis8+6QYWL4/jJ4CGaTBz0co1X0lX4A=; b=NqeIfyCVxt8eVAxQ
	DKHom7HdAi6uhoaPXqY+sVBQS+fSAIjZYa8pKy6tNJxFPH7llUMxlKz4j5KggeP+
	A1Li842oc5d7NUfTEStDXAJ1sKjLyeICL4+QB0bnwfOhVM3GDNebBnhK3j3qNmO8
	4IEXMl5Qzudmh8Tt+Wt7FqnAYVhNTXH0uxmIK+yogQ/PPpMrskm+m8YpGjquCwWX
	U4KDxOTq2USO6kOhpL6A2YUEVWZYAuMbxcY/CztSM6eHEg3dKNHmF11IIMjzD2A4
	pta1yi56EbSpHnOX3938trwfyDO1n7WGVYJPMD/afwfhN5AqvbcEUVMHBQFf4lGM
	wRTu2g==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ea39gudnc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 05:56:26 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2f2d983d109so1439067eec.0
        for <dm-devel@lists.linux.dev>; Thu, 21 May 2026 22:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779429385; x=1780034185; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LLUYimo4jYypFis8+6QYWL4/jJ4CGaTBz0co1X0lX4A=;
        b=G09LEU84oGgF9k7kXaAUpsyvCiW5NCWjNiNiy9nBha4umtVAixcUmkCDqOpeXCta97
         /CdopZvDjIsndmqAIsRiiIF0QQ/S72ZImsRvfRizdbZG0ge3/M0FOQQkSol5M2yLdIQX
         w98j2piFSB1j4I176XG8FN7B9Lf4UR9i2UmFVLpbIu+oJliHDWzSlWib11K9/ZzFhDNT
         V9vfZ5oEnCHYzHgafPVoQ/Cm7v31+i9HDrnTLhsn6GJ8Q6F278s0mFwNxOCHkzfBDL+x
         8rYDzmg0tRyTRN7uoTHKAEeRZQ8V/eEni7K4LxbprZUEAiuuRUCwPgd0Rf5aZv4ZPdfy
         pffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779429385; x=1780034185;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LLUYimo4jYypFis8+6QYWL4/jJ4CGaTBz0co1X0lX4A=;
        b=hrxzfWKzsLdyw/5mw7yQU8NMZHc4k4bjeslCMQM4eKuFmisU/LkfdoCodyxvwmNCMj
         Bh1l8h+50OtaQs4495bBMXxxDHSDeij7NJYUXc8/sQ2yy8yTPKAQfy0DwejjxObAsI7K
         sDjfiRJKUofxN+TkKhwwYkzE60xDZVULpWTj+WFxTzvGVl66gSBySnyy0uNRGAgQ8Og9
         clGQ/1KaA9s/rf239TCq83shrephianede+G+NTMLy/8gaYLlNRmudPvG8rbyHRzi3YH
         2Ff17Oq6jPg8286IiY8tL0dkOVTm1kqWdCw0lBbkPMbW4AVOX+lkHfRa6CeE6RXWTgkx
         54mw==
X-Forwarded-Encrypted: i=1; AFNElJ+t3ynxek9sXdyz5e+a9y3D49tSgZj7gXV3ZZkL3b6WTfVlyetsdpdXXJF1QOjRRnCHDGWQbhBejw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzjIAC2CyFe7oTwNbReepokMH2ypKjcaIzWL1nn0C0E4M0z4opb
	yVEpxcOAV9ynoyndhRC4ObnexmZhiPiwy1x5DHyrFHdfV0S1A7QAmq/EUVSJW35gLH6bIR6zkzC
	Dc4TN6b2rf2L47tQk7Nhr1r+GYtzax9q+NyN3KCfZGp3VndzoIaw2OTCdtaZd5w==
X-Gm-Gg: Acq92OGdjcawDUVoxrHivZN4KWLWMRT6JXIYJow2s0O4Jiczo6Z78Uvv2QMOHpwrRkv
	YqdyRaaDZwqqqZejFIHU0fCGRdPxQonmqCqFp2UilrcUAISQJXRnnBSXd053JiL+C+3GRgADG7V
	k+8vqat60f3di8fvY5pyQvVfwxmbS0UBtV/0hfp014NBMVWReXOPDSG8Wf8cL+hT/je3akbCljj
	S+Gy0AJJNQsmyQZZzJmLSsdHQYjhzKWMzex8DFvTBEd0QvuCUrlAyEb4lF56eOD/rQkPHPQJAa/
	nDnUt/oSr0hnmRUb32nFdHlDg/Oa18jm3BQ4O5SpAD/4uIOCM3xVJV9UWQf9rDWaGk3bQHNp6rH
	ifYd8Z56bSuioGnoDZGktIdinhgXSSfkiAAEiRnGA+eRQaPCwzMUO0pxByTsnouZQLr+OLG1tQm
	DFcT+R
X-Received: by 2002:a05:7300:434a:b0:2c0:c5e4:605f with SMTP id 5a478bee46e88-30449186bb7mr1185095eec.24.1779429385391;
        Thu, 21 May 2026 22:56:25 -0700 (PDT)
X-Received: by 2002:a05:7300:434a:b0:2c0:c5e4:605f with SMTP id 5a478bee46e88-30449186bb7mr1185073eec.24.1779429384859;
        Thu, 21 May 2026 22:56:24 -0700 (PDT)
Received: from [10.110.121.192] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304522314a4sm243736eec.18.2026.05.21.22.56.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2026 22:56:24 -0700 (PDT)
Message-ID: <16f929d6-2494-4ca2-b36a-880dce8bb019@oss.qualcomm.com>
Date: Fri, 22 May 2026 13:56:20 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] dm-inlinecrypt: add support for hardware-wrapped
 keys
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>, Eric Biggers <ebiggers@kernel.org>,
        Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
References: <20260516115045.3958326-1-linlin.zhang@oss.qualcomm.com>
 <20260516115045.3958326-2-linlin.zhang@oss.qualcomm.com>
 <3b57685a-09b4-473a-8810-bbb46769ab42@gmail.com>
 <2712f864-0f68-4428-9ba5-55fbf35de6e8@oss.qualcomm.com>
 <f7de4505-859e-6838-b8b4-1e55c8c0331c@redhat.com>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <f7de4505-859e-6838-b8b4-1e55c8c0331c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Yr8/gYYX c=1 sm=1 tr=0 ts=6a0ff00a cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=p0WdMEafAAAA:8 a=EUspDBNiAAAA:8 a=4AoxfBD4PrQTERy5mSIA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-ORIG-GUID: sQa8kXwWdcmivQJHxPEJ7a7teOVaxlyu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDA1NyBTYWx0ZWRfX6yEYfIoouG0P
 7VbjCJpm+r6yTbjUsOtk1cak/g2Bs8BW/21fe8IVaYiZ4t87H9luGCAs4uKbEFWuXLFlWhUqHnb
 dVVpFDEhyOs0naPJGL3YH3P1h1VSCl+s7EDVyQuc/MN/PCK7EW6+r6GhRtQz6G654eQMIQuO6zq
 ON+Mdpke/uFnNTSCoTA7pt9mbOTE3Mb5TZVUjz/ORiPMbXD2PkzQ9q66q37mfHucf8Zpg4LJyYc
 iMjz4h6x8stwzrqck/GWgleH40i0VAWjCcz/PLKxVOsl5jZL97z99jgXdaRMhWr+S6jbkxjo6mu
 xxgyjQPKz96knUyUr/2cKXBDqpPYPGqi4RtgBeLyCowEAnoDA/jsKLuydh2w+uwwQD0i+eEi2CQ
 4PVjtB8rKrNXT0eQCyvB4A+LKrKO8+Mkdfd6U6oSsfdjHaXgvh+AsNMFStHGaj1/HLkXiEz4W1j
 luy/5vg8p3GRKtZzloA==
X-Proofpoint-GUID: sQa8kXwWdcmivQJHxPEJ7a7teOVaxlyu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605220057



On 5/18/2026 8:37 PM, Mikulas Patocka wrote:
> 
> 
> On Mon, 18 May 2026, Linlin Zhang wrote:
> 
>>
>>
>> On 5/16/2026 8:17 PM, Milan Broz wrote:
>>> On 5/16/26 1:50 PM, Linlin Zhang wrote:
>>>> Add support for hardware-wrapped encryption keys to the
>>>> dm-inlinecrypt target.
>>>>
>>>> Introduce a new parameter <is_wrappedkey> to indicate whether
>>>> the provided key is a raw key or a hardware-wrapped key. Based
>>>> on this flag, the appropriate blk-crypto key type is selected
>>>> when initializing the key.
>>>>
>>>> This allows dm-inlinecrypt to work with hardware that requires
>>>> keys to be wrapped and managed by the underlying inline
>>>> encryption engine.
>>>>
>>>> Update the target argument parsing accordingly and pass the
>>>> key type to blk_crypto_init_key(). Documentation is also
>>>> updated to reflect the new parameter and usage.
>>>>
>>>> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
>>>> ---
>>>>   .../device-mapper/dm-inlinecrypt.rst          | 10 ++-
>>>>   drivers/md/dm-inlinecrypt.c                   | 71 +++++++++++--------
>>>>   2 files changed, 50 insertions(+), 31 deletions(-)
>>>>
>>>> diff --git a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
>>>> index c71e600efb76..3a4ce2c5f228 100644
>>>> --- a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
>>>> +++ b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
>>>> @@ -10,7 +10,7 @@ https://docs.kernel.org/block/inline-encryption.html
>>>>     Parameters::
>>>>   -          <cipher> <key> <iv_offset> <device path> \
>>>> +          <cipher> <key> <is_wrappedkey> <iv_offset> <device path> \
>>>>             <offset> [<#opt_params> <opt_params>]
>>>
>>> Please use optional parameter.
>>> Adding mandatory field will introduce unnecessary incompatibility with dm-crypt mappings.
>>> (The idea was that you can simply switch "crypt" to "inlinecrypt" for raw keys.)
>>>
>>> I would probably just add "hw-wrapped" or "keytype=raw|hw-wrapped" optional argument
>>> (with raw as default, so no need so specify it).
>>>
>>> IOW the mapping will look like this (1 is number of optional parameters):
>>>
>>>    <cipher> <key> <iv_offset> <device path> <offset> 1 hw-wrapped
>>> or
>>>    <cipher> <key> <iv_offset> <device path> <offset> 1 keytype=hw-wrapped
>>
>>
>> Thanks for your suggestion!
>>
>> I agree that keeping "hw-wrapped" or "keytype=raw|hw-wrapped" as an optional
>> argument helps preserve compatibility when switching from "crypt" to
>> "inlinecrypt"
>>
>> My concern is that, in practice, this optional argument may effectively become
>> mandatory for certain configurations. For instance, "hw-wrapped" or
>> "keytype=raw|hw-wrapped" must be set for a wrapped key. This slightly blurs the
>> original intent of "optional arguments", which are typically expected to be
>> truly optional for correct operation.
>>
>> Would this be acceptable? which one is more acceptable for upstream?
>> incompatibility semantics mappings b/w dm-crypt and dm-inlinecrypt or blur
>> the original intent of "optional arguments"?
>>
>> Any additional thoughts or feedback from others would be much appreciated. Thanks!
> 
> Hi
> 
> I would prefer an optional argument "keytype:raw" or "keytype:hw-wrapped". 
> Device mapper targets use colon to separate arguments from values, so I 
> would use it here too.

Thanks for the comment!

ACK. I'll send a new patch with such modification.

> 
> I removed the patch that always sets BLK_CRYPTO_KEY_TYPE_HW_WRAPPED from 
> the linux-dm repository and I will accept a patch that introduces 
> "keytype:hw-wrapped" when you send it.
> 
> Mikulas
> 
>>>
>>> The second option will allow to add new key type much easier.
>>
>> Regarding the second option ("keytype=..."), I agree it is more extensible.
>> Could you please clarify what other key types you envision supporting in the
>> future?
>>
>>>
>>> Please check how other targets implement it, some dm-crypt examples
>>> https://gitlab.com/cryptsetup/cryptsetup/-/wikis/DMCrypt
>>>
>>> Thanks,
>>> Milan
>>>
>>

