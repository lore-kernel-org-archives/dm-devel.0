Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D3A3E1D04
	for <dm-devel@lists.linux.dev>; Mon, 18 May 2026 08:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779091898; cv=none; b=NIUUCKP69x7KJg2RwjQQWYjUYYMZpyTS3jEaps1S7JLSPVosM6fYCDhMc2jL08tXWTqRPrB8JlUSz1/l+sGPhLUga7U26aYeXiy2c2CDKCewWztNEWti/xZu09q/sk3SteiF7tOWaJtJHaMgdmKgpres72K3pocL3yx6985xQl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779091898; c=relaxed/simple;
	bh=YBMaR7qngUs9wRDn0DCClR2eVoOnrE7CKmd3V8buKU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lrTNme0AI8iFdl5IWMNzGko/yxUmMP44FRZF9YUmKJts/YzSEquBsHw/3fsXtW35kFrO+KK65Q+5TW6KTQs1UVS1bqrOEmPtXiMYhPK9EbLjGJyyPRP2SOAMWYdECl7rAlBlJptFu7qjwZ0RtmrM7rzRYqWbi1U72xvKeGfSPuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dIr8FOqE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Apd/b0ml; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dIr8FOqE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Apd/b0ml"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64I7fau82188804
	for <dm-devel@lists.linux.dev>; Mon, 18 May 2026 08:11:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/LLHOHY/l/59SbiNQNsEV2KFEmIYyrDJ225fUGc83jM=; b=dIr8FOqEwL8sqd8w
	29nFB/pbbQPZFztO32NV8w0ECOAgHb9YOLPE0Zhibk5ZBKSO87bSVgw1bj3KY3ET
	eZGynqAQoy5dSvGDSJa2H4kyTYVSl+fTDFjhORrn2IhIMFmnfFGFMDnzguiUL1cO
	4v9Q2kTbkdwWEQbhiBaEJshaRE5f5kyyOy5776sbiQUnLgejgIDcY2s1Il4j4iD8
	BueyDR9LmImD0IuF/QxB1MdtOAvg5mW6I2S7Ic+8qceE1vbE046KZSCQ/cClieO6
	iSXUBqroG4B+Armc0g9EG6WUTEINQ+RuzjH1ywkPrIR5vyDH5HhGdi1VrfYuvUhf
	EbnawA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e7xkug48j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 18 May 2026 08:11:35 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2eebb099efbso6535150eec.0
        for <dm-devel@lists.linux.dev>; Mon, 18 May 2026 01:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779091894; x=1779696694; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/LLHOHY/l/59SbiNQNsEV2KFEmIYyrDJ225fUGc83jM=;
        b=Apd/b0mlaGavZumL7zbzCtbRNBWcb3iCntAnQmqaJZ3Wr2iYtwsH6CXF2t4jCf70Cw
         pPvKrNxbrm+9qvEWEigW1lrV6/ynwNtQZwWihcHSodxA7xAMZB96igHTQQ8dCvEQjqsZ
         bkEKjTxz2UlZWZouhEd2aPk88WJEWoAy7AvEWYu5w7f+Ntvnaos63n3alU4dHncHsocV
         VB8RofPxtMVyNMRF2qEUE1z5JInKyutxeh8uu/3dVBWs3nnNjNEYWKGfRH1oG9pxDagh
         G1CQBijbGcGz7XKPXrUHjXs9XgDIo2X2J9xKIGvehtfWEy8xwG9n5AySH11Q4bjtN3aA
         pTYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779091894; x=1779696694;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/LLHOHY/l/59SbiNQNsEV2KFEmIYyrDJ225fUGc83jM=;
        b=Ck4u9sfIlcmJhSgeGMCiwNNIo2w0ycK/akV8vVyT7WvTSdESG7GTKnAMzZ1mYQ+0Go
         KQ+j8bdu7dHvjClmDk51AfUv5aPz9+CtmnTAOCmzUXjMy8IiPTS6/tQXD75xI4g8+AN8
         MKjHDWt4fiCHww49PB+JDshoPAMHENaA8P1uZ4q196OISNTSr0mu0kj9koZUsfgD/Vls
         Oej1oNTxMDJPaEgSbHY/shRRWPU8z92SPPxYbhm2+poJ0drDFRsNUWdPu/lvjrCgEXFv
         G7FY/dlNPDnUf4MjK2geGjt1ivzuPIvbsYrP1HJCRBXujbbo4Lae83cmfQY4fYJzOQUM
         2tZQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Lhuly+2wAdPLEBaLIg01MsaSO40E/x/nCorlotD4VOxFeUYxtSzKaQSoV7exi9FH0im0925e/bA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyL4EzD7zyflje8fXo2cPHUWSQQlSZC3tnaudOwiQ6U5XU1Yt25
	8hjxmBo7ogYL+Nw0jAkWgKqjNx5NYub4Ypk6MH8Fcr25avQ1vgCbeMV9o1x1xgcUk53YeqgMshw
	S88d/BFAcXeM9dp6UmU+rIndUb3gx64Rzh3Uy5SKVVz7Djr4eYAMoDbDlcwiO8Q==
X-Gm-Gg: Acq92OHRrffRDEURyRTBQ1I2byn9tFPFCQLmkjVFgaIwOuqYKqerRoNTyWrKEzrTz0Z
	dI9AmywTV2wWT1PkPviUjck3GrbQ8v6XYLb1tL/bmGqO9YY/gDl8IVFPdKy64OwU81BdFAvy8RH
	9nR82Ll7NtEytNvhagrIjo28HCuMFvmnKFhNDg1nr81lFOo8S/qpYB4mDyaJ1lC89NN0fCW2pbc
	36uOGa2D8hMUrp7NT7QZ7ez4YrEbdp1iJhOnF6o5il3E9muDMkIcyS0Afg82RPQVogTlYEMZ/+C
	XgKmhVkZrk0c8Jn2osSkL21NrxkaH5C87QeFBa+yIOove5x9seCxCMwZQJhwfi5rnsYN51Uwcjm
	Q8q/+ihQBssu8Av9ag4TeL6a416W4QIshqDW4bzVHaZpxcCyk8B/RvIPvrJlrw17fGyTVMc3bu8
	ZG+Gfo/X2LqDQFlQ==
X-Received: by 2002:a05:7301:3d12:b0:2ea:5057:a304 with SMTP id 5a478bee46e88-3039818a65bmr6141260eec.2.1779091894091;
        Mon, 18 May 2026 01:11:34 -0700 (PDT)
X-Received: by 2002:a05:7301:3d12:b0:2ea:5057:a304 with SMTP id 5a478bee46e88-3039818a65bmr6141233eec.2.1779091893125;
        Mon, 18 May 2026 01:11:33 -0700 (PDT)
Received: from [10.110.122.43] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302973bbd50sm13061203eec.20.2026.05.18.01.11.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 01:11:32 -0700 (PDT)
Message-ID: <2712f864-0f68-4428-9ba5-55fbf35de6e8@oss.qualcomm.com>
Date: Mon, 18 May 2026 16:11:07 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] dm-inlinecrypt: add support for hardware-wrapped
 keys
To: Milan Broz <gmazyland@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
References: <20260516115045.3958326-1-linlin.zhang@oss.qualcomm.com>
 <20260516115045.3958326-2-linlin.zhang@oss.qualcomm.com>
 <3b57685a-09b4-473a-8810-bbb46769ab42@gmail.com>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <3b57685a-09b4-473a-8810-bbb46769ab42@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE4MDA3OCBTYWx0ZWRfX/V47ItQd55Df
 bErNIJL4z8k+wc+ZF4E6rWVvS0W1xgldEejRPV5Rm/2HfLXtYdMCz4/4OWuLywe/V8gUcN4Megn
 HHW0+XahUMSQT7nGNYtZ9cWpylUWt9fcqIX745+5JCfeNuXZ2BuT3PUDwfK+T5ABQwdB5tigIqW
 15Zy3lfKXJy58vp0RmGruF166Cse9AgoYlRJPRJCxvBV57Wtj/fOcFVmB6XS4+4pbD3klpH12Kn
 VUx28MTBQzBPVlZM1dbFdyL6N/Jrm558wQNjRkPEEGI2wCuhER2OwvTOokfXOlZCos/BeRsYq3D
 WB088XAk8S6TP+cwJHNO0W+3o5cW1N9UP7tpseRbxmOTRauxXIMCbET8e28Vbbbfw2JlWSYEgrO
 BMvASHXxbQNr0Sk1ELJxYF21wh+VQxsnzOK9Aeie2eMAU9wG+JU745Bz7YsvsVhbljBO8BOO1FS
 7ceX0L7Tvq1xte5+2Vw==
X-Proofpoint-GUID: zuB0re-s-UgVtL_QkG1jLo7WOYCLlz5G
X-Proofpoint-ORIG-GUID: zuB0re-s-UgVtL_QkG1jLo7WOYCLlz5G
X-Authority-Analysis: v=2.4 cv=FsY1OWrq c=1 sm=1 tr=0 ts=6a0ac9b7 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=p0WdMEafAAAA:8 a=EUspDBNiAAAA:8 a=ne3KJlC3Am1FYSLfDcIA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-18_02,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605180078



On 5/16/2026 8:17 PM, Milan Broz wrote:
> On 5/16/26 1:50 PM, Linlin Zhang wrote:
>> Add support for hardware-wrapped encryption keys to the
>> dm-inlinecrypt target.
>>
>> Introduce a new parameter <is_wrappedkey> to indicate whether
>> the provided key is a raw key or a hardware-wrapped key. Based
>> on this flag, the appropriate blk-crypto key type is selected
>> when initializing the key.
>>
>> This allows dm-inlinecrypt to work with hardware that requires
>> keys to be wrapped and managed by the underlying inline
>> encryption engine.
>>
>> Update the target argument parsing accordingly and pass the
>> key type to blk_crypto_init_key(). Documentation is also
>> updated to reflect the new parameter and usage.
>>
>> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
>> ---
>>   .../device-mapper/dm-inlinecrypt.rst          | 10 ++-
>>   drivers/md/dm-inlinecrypt.c                   | 71 +++++++++++--------
>>   2 files changed, 50 insertions(+), 31 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
>> index c71e600efb76..3a4ce2c5f228 100644
>> --- a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
>> +++ b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
>> @@ -10,7 +10,7 @@ https://docs.kernel.org/block/inline-encryption.html
>>     Parameters::
>>   -          <cipher> <key> <iv_offset> <device path> \
>> +          <cipher> <key> <is_wrappedkey> <iv_offset> <device path> \
>>             <offset> [<#opt_params> <opt_params>]
> 
> Please use optional parameter.
> Adding mandatory field will introduce unnecessary incompatibility with dm-crypt mappings.
> (The idea was that you can simply switch "crypt" to "inlinecrypt" for raw keys.)
> 
> I would probably just add "hw-wrapped" or "keytype=raw|hw-wrapped" optional argument
> (with raw as default, so no need so specify it).
> 
> IOW the mapping will look like this (1 is number of optional parameters):
> 
>    <cipher> <key> <iv_offset> <device path> <offset> 1 hw-wrapped
> or
>    <cipher> <key> <iv_offset> <device path> <offset> 1 keytype=hw-wrapped


Thanks for your suggestion!

I agree that keeping "hw-wrapped" or "keytype=raw|hw-wrapped" as an optional
argument helps preserve compatibility when switching from "crypt" to
"inlinecrypt"

My concern is that, in practice, this optional argument may effectively become
mandatory for certain configurations. For instance, "hw-wrapped" or
"keytype=raw|hw-wrapped" must be set for a wrapped key. This slightly blurs the
original intent of "optional arguments", which are typically expected to be
truly optional for correct operation.

Would this be acceptable? which one is more acceptable for upstream?
incompatibility semantics mappings b/w dm-crypt and dm-inlinecrypt or blur
the original intent of "optional arguments"?

Any additional thoughts or feedback from others would be much appreciated. Thanks!

> 
> The second option will allow to add new key type much easier.

Regarding the second option ("keytype=..."), I agree it is more extensible.
Could you please clarify what other key types you envision supporting in the
future?

> 
> Please check how other targets implement it, some dm-crypt examples
> https://gitlab.com/cryptsetup/cryptsetup/-/wikis/DMCrypt
> 
> Thanks,
> Milan
> 

