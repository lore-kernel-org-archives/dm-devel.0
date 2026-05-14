Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B66D3630A4
	for <dm-devel@lists.linux.dev>; Thu, 14 May 2026 09:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778752152; cv=none; b=oFb5gzKiB2P9+9tbbJptoDVrQ8EHsMp7a50xiwYx9d4OfqKLRH/p+EP96+Fuacmzj2ifyeB8B2WpyE+EnsqawR27f8OOOJ4kA2EupEX9ZFfwJKh21Nf38SIMeu+WI+wXxU0OORJLLF+6O69z1Fz92qq2A/dQQkvR3ah1JkCDZL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778752152; c=relaxed/simple;
	bh=EJKnSIWDG+qBawg0tN7J/4Nqxp43amjV5mssW2TQf+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KNuos5yazmCzcRHE2P9QjCv8er63vfYHT23DItoG2tF30mf9NNo01xQiGnYm5NBWOKM8LXphTkQEAgasSb19b/1P3zwMkTq+kRtoT0UUM/guS/snVmdcMYKsrcOKLRPEyvsy188v2m8PaoX/axDp3BZHMKOHT0SD983L3JMhG7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=If7+FY2x; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=M5CrhSwf; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="If7+FY2x";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="M5CrhSwf"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64E9juFV2463964
	for <dm-devel@lists.linux.dev>; Thu, 14 May 2026 09:49:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	AVEiYz6tRQCmm/rjKinjP6TxKA1LuBsqtI9ukPY1hc0=; b=If7+FY2xTBwODo+v
	Dyq2A2RX7jopiaVhpTyrboHlBKS4oaKeqsLaZ6IkFXDHRbcl/InJoWbovBq4SSaW
	vGf9AfLU2QubYqYiLz23+SxaXFovqL3oxGd5jqqC36twqLcTfENhVLGAfkTLvH3L
	3LCiTUlvzULdOR7CMR/ojtWYI5q8H2qeIoLVwEWoqYfijiZHAKl2hUH/bkAD1PHb
	K/ddKUi9X8oPCLXtFcmdk6byA0NWll+qFIaesJ8yenkGJLzP2rlgTLKQyLIfyxYG
	3fJ4R04qLxlh6p55MqhNWWKYmU29xxxj3Nwgvq1aM6+sK+ZCyebfMbG7v/lyaBEr
	22DSmQ==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e58v88sds-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Thu, 14 May 2026 09:49:10 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-12dba1e866dso6937553c88.1
        for <dm-devel@lists.linux.dev>; Thu, 14 May 2026 02:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778752150; x=1779356950; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AVEiYz6tRQCmm/rjKinjP6TxKA1LuBsqtI9ukPY1hc0=;
        b=M5CrhSwfdALSFu0WDw8bQxG9q0c5F2XdgRFKFscXVXwTSqluG92wSpyTJa+6UPGkX9
         Cg8PxYfXSSVkEM8byLhBAJVyT/GBcip4z1ViS6bc3HCt+gY4Dkew4QpuTGwLQo5qvJVJ
         b2ggexk7sTGJtZ4OMXRmitRw3JH+HlIu7s8U94Ww4i75+3Pwup74fLENYBEk3wErBWHF
         kkcVfTFMFYaJzMouKHLemBwAixl29yITgueOEMWLQWAKC0Ja4HHuBDDgHuE/w+HveHZL
         1j2qxhHqP9Ac9bgJbnOv3JEISmVTjUOmyrNNM16GM8zSPHxJV+eSpYqup5oCjpf6AMIS
         1MvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778752150; x=1779356950;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AVEiYz6tRQCmm/rjKinjP6TxKA1LuBsqtI9ukPY1hc0=;
        b=m5wRWu9MQY4sxAFLCG6KqUBW0lcKVqYXkxKw2fru2gZZtvzXUNuUVdvawp1SpgElj2
         15CsRvgYGuIMRv1cLe19H3JVWWbFpNpizftLEp4BN+ht3rDBVBcOpXeesptoyv6b1Hxv
         qZnDsycTZKdZ83GUeVS6txHG4eULUwLXmjF9fgsb1PsCvVzMr8WVCkz/KkUpRDatkkRZ
         kQyTG1zKM2cLzdzZECATACCGE7Vq5hYMhiBBNGLeEDGCp46XHBPVLnWmUAlTptW413C8
         0FBfgfSesMggXrjgrQuFz3ty+HH6ZprITR5g9T6dwjwiXBaAwk16mh2ij421p3KWJ5Ar
         LHYQ==
X-Forwarded-Encrypted: i=1; AFNElJ/DBfhc7+dMRYqX0vUUN1V8MpeRaMU5aBB/BllPwJ8r8z5oND97Va0LTb0ODc39IO09sQvTdMQ0yA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzBQ42P6err7cVeUfAvilBcO3+73zCS6ZfizXMxTbaGKM+ncSm/
	1kTofIfa9Y+VGVSmnt6V1rBJM+QncQ4hlGCNXg0+D6uiJX/HpNlaktK3Es7Zc9GzfkbSAfncOaR
	n9U3UwJgiuCxHvpKR5PJu+xw+pwk1Ef7JCmXW9TuBqAfrskbxvJAVnye/Ht8KJg==
X-Gm-Gg: Acq92OG3CdP6o+6HyMQoHrDxDssZheLqubkrDy8qWmL0sGFBEGebiFe4T0Lyzv8Hyoc
	Rz8udqJQsfPaz1p+tKOyawK9zJgPDtFeBfTlUM2JR6Ki7X+D2Iv1GmCEC4K67wRpDp555gZ1JqY
	bIy22vgcn4z9EeItA9i4dIwE0jR1xBXzgrNqnsL0xV7duBQRZGljQDmDumo0OFQvM8vhzE9cHZf
	uEMtj3i33TmsBN9baiGuzZaOs7NMopeN+uxe2MKwh4N0ZbowgoFtSuecsdCXbbMS65y7SDLx/s0
	CkmiQlYZvVjsjeYnxGg5rNb6KGIkpU++9lyKQEJsqgt+ZVaD+sqkNl+vo/LsZkGijKN+4embLjk
	j69Uf9QBq5AtCJ1LOmlsdfgW0h+yGvaEl7YHAqEruiqh9RGcEK3Q+hDwsbDRGXfPT18OhWyRtjD
	gdHc8=
X-Received: by 2002:a05:7022:624:b0:11a:fb0a:ceca with SMTP id a92af1059eb24-134c8c3e3a2mr1862936c88.16.1778752149687;
        Thu, 14 May 2026 02:49:09 -0700 (PDT)
X-Received: by 2002:a05:7022:624:b0:11a:fb0a:ceca with SMTP id a92af1059eb24-134c8c3e3a2mr1862911c88.16.1778752149047;
        Thu, 14 May 2026 02:49:09 -0700 (PDT)
Received: from [10.110.104.67] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cbcb9ed3sm3573723c88.1.2026.05.14.02.49.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2026 02:49:08 -0700 (PDT)
Message-ID: <b0104f67-0886-4c40-89ef-bc8bb8a91689@oss.qualcomm.com>
Date: Thu, 14 May 2026 17:48:44 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] dm-inlinecrypt: initialize blk-crypto key as
 HW-wrapped key
To: Eric Biggers <ebiggers@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
References: <20260512095203.3688708-1-linlin.zhang@oss.qualcomm.com>
 <20260512095203.3688708-2-linlin.zhang@oss.qualcomm.com>
 <20260512185335.GA3085076@google.com> <20260513172204.GB2128@quark>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <20260513172204.GB2128@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDA5NyBTYWx0ZWRfXwEPCZ5B4/d3a
 QLZkSkSVeUw3sldsMveN2k9q6j9h94aZRAab6Il9ovy/7M92Ss+rq+1cXoz1sf4V0z0JQqJMTLV
 M0VxZGhRNZ+lVWk22K1iElKGSmS9/KCJMOZM58uoC4aDhO67XUABtnqovPqTx13vxj7mh8F+aHn
 EUe6xwiFTa2Ia6MrjnxCOIS+vatJG9D/K5p9TR5giDX5nehhoSJHYcRf1gb17NHhpFmrQ3aTX6x
 aSXEt6Y6It/g4HZRY1B7oA34QXpuLuqg/AtEnE/XZIojwWdMUoJj8YUOjO+r0SHKjmbyVmEJPDa
 nN1/A89VmjmnkNe2jG0Pibx9VeWrPVcjwkMkH5TGlAszN8sZKz3PKCOF5nF347HgFFB7W79NDca
 HL064+XZmlFWmad6Ero+4gWelgqA95uh6hOoQuYhrkJMzSrLx7O4oiELIaPxqSe8L6Z6fd/QeGJ
 cbpY5q3fUqOoPVAwofg==
X-Proofpoint-GUID: tOnwxFlApiXglaN41JtWH3wcJM5OGUEH
X-Authority-Analysis: v=2.4 cv=YZSNIQRf c=1 sm=1 tr=0 ts=6a059a96 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=89lHFPsNZDq2Qp6-QJ8A:9 a=QEXdDO2ut3YA:10
 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-ORIG-GUID: tOnwxFlApiXglaN41JtWH3wcJM5OGUEH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_02,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 bulkscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605140097



On 5/14/2026 1:22 AM, Eric Biggers wrote:
> On Tue, May 12, 2026 at 06:53:35PM +0000, Eric Biggers wrote:
>> On Tue, May 12, 2026 at 02:52:03AM -0700, Linlin Zhang wrote:
>>> dm-inlinecrypt currently initializes the blk-crypto key using
>>> BLK_CRYPTO_KEY_TYPE_RAW, which implies that the provided key material
>>> is a plaintext software key owned by the block layer.
>>>
>>> However, on platforms where dm-inlinecrypt is used together with a
>>> hardware-backed key source (e.g. TrustZone/TEE or other secure key
>>> wrapping mechanisms), the key material passed down is already wrapped
>>> and must be treated as opaque by the block layer.
>>>
>>> Initialize the blk-crypto key using BLK_CRYPTO_KEY_TYPE_HW_WRAPPED
>>> instead, so that dm-inlinecrypt correctly models hardware-wrapped keys
>>> and avoids incorrect assumptions about key ownership and visibility.
>>>
>>> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
>>> ---
>>>  drivers/md/dm-inlinecrypt.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
>>> index bd8e58a028c5..bcbf363c533a 100644
>>> --- a/drivers/md/dm-inlinecrypt.c
>>> +++ b/drivers/md/dm-inlinecrypt.c
>>> @@ -386,7 +386,7 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>>>  	dun_bytes = DIV_ROUND_UP(fls64(ctx->max_dun), 8);
>>>  
>>>  	err = blk_crypto_init_key(&ctx->key, raw_key, ctx->key_size,
>>> -				  BLK_CRYPTO_KEY_TYPE_RAW,
>>> +				  BLK_CRYPTO_KEY_TYPE_HW_WRAPPED,
>>>  				  cipher->mode_num, dun_bytes,
>>>  				  ctx->sector_size);
>>
>> The raw key support is useful too, and it should be the default.
>> I recommend adding a "wrappedkey" optional argument that enables
>> BLK_CRYPTO_KEY_TYPE_HW_WRAPPED.
> 
> This patch also makes the variable called "raw_key" contain a key that
> isn't a raw key, which is confusing.  "key_bytes" would make more sense
> for a byte array that can contain either type of key.  See e.g.
> blk_crypto_init_key() which uses that naming convention.

Thanks for your comment!

ACK.

Previously BLK_CRYPTO_KEY_TYPE_HW_WRAPPED was set for blk-crypto-profile entity
by default, a raw key won't never passed down to ICE driver, so I replaced raw
key type with wrapped key type directly.

Now I see it already changed to query the supported type from ice. There isn't
above concern. I'll update a new patch with both wrappedkey and raw key support
and adding "wrappedkey" optional argument.

replace "raw_key" with "key_bytes" as well.

> 
> - Eric

