Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35522D47E9
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 09:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777368015; cv=none; b=QjuMSKd02C0vFtMo8rANOZtxvGSORMCGtZrhPooqr34WX6hB3J917U86vqcwDczeUlZJfQddIohc8FYVLmNqvT2NcuEJDDTWS8U4T0dIxWQo3v4CEehes9NrGifscLIAqAnZ3t0y1FHLYB3nZneJslO2XGVxKb1sRFX//acOqpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777368015; c=relaxed/simple;
	bh=E59q141eIMRoVS0CIFBNpImOnrZTdEnPeY4n1aRI5qI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PiNuMSnslAZ6XfrDysQjG5Rg7ArTzZ1HlQzr7jlYRuenVMkKNxICh/bn/oFjlNEKFwf0q1M5scA0qpz77eI2QkR0v+U5+cUbP+2hgqjrOFfBHAv+2quNIssiOjTGJm7+d2s9jQ5/8eygdwBIUNUVjGKHKsohqsZftyW9OabsGcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QEyvf2UM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dOaK06dd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QEyvf2UM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dOaK06dd"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S7vlZG1744834
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 09:20:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vpAxPHzEnIqyJBQRocZHAzzK0xrcj2x1AR2IF+lJmZc=; b=QEyvf2UMeBITgznu
	+c0glZBplK9L1i6Oaneda/tHjAbz6LNUlUwMrH0Jpxp8ViGgZEBprVEyNgn85/Tc
	TwLrPEcgFWBuxVHTSHUX0nJlMzkGWEjtsG7KuBooBBkBFhsE4Xj9zE62/Dalag6F
	F6lx98sxn4wrLMEMF5Q5ZcgrQFeGOxnhaQ57CU9xxtaRTvb8Q9w69P2XbAtXDRyS
	3HzBUOMTtgTdyJ/Hy0mZAW30tndjpuiVRCZVbMp/Ku8g7DOLK0gSQ4cujAUYp+Wn
	90gFXSWaT2eNtjZuzKSenmmPGazPCvNuaI62Hfc/V3u7oRS0Q/ZDAdD84nNgGy+C
	4Fd0AQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dtryd8ajg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 09:20:13 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-2de07c12745so36853814eec.1
        for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 02:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777368012; x=1777972812; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vpAxPHzEnIqyJBQRocZHAzzK0xrcj2x1AR2IF+lJmZc=;
        b=dOaK06ddRbpCXCx0N6oleHLl42HifWVOf8MR1gS15woKPA5Am8/+eyeQiFm3suFedl
         Yg2jkjlrMSt2EQtxO5wJGvN+JJwC9Qf85mPw9WFRvWC0bYg8IW0jB8nPodf8l8qo1BeJ
         ZvPejGrx+nUnXBajs0VEjy1Bu7iNCtSZDnug4fHoitakIESu5Ic7EwM11qZ4F66oHSdv
         rUrTryaRvEV24yos8xfnVxy1R2Ty5AcxlSP0zEUzde+XqKd8ORZXDBm8LzR4TbX4UZAY
         Uv4MtdFdI8NFdFgkBKnwAjZ7iWev0TdYPa532HwRmj6pKBp9QQ/NGShSO279Agg8CCrg
         nbRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777368012; x=1777972812;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vpAxPHzEnIqyJBQRocZHAzzK0xrcj2x1AR2IF+lJmZc=;
        b=Fvd0NWNxQn8QFZFZFpSLfXMSzV34jwVhnV+4k1bUkAFtzjGpCosgPnbDXFkR+UYYk3
         gaVigjmYEgqNXLAyfXGO3rucuNDru6UKYJl7HakEMVUWvEj64LSb4MgpvWHf8X0YUocF
         0DHNDXh8fFYrFoQvtKR8AxOLLzBQzQEmMyQ3bb0rF8VkBNbOEH+V4cAjoEdUHLWCK4DT
         2mTv8DKzlSbpWWwJ0EyjN8GpYF59fPOm5SuhcVou9vkYioxjK/AyTY0p6k+BhdLtKE8/
         VqMqtrPbyopuAhIGtNKVN2HzhBMq/b/A2xiJBd/wHzf67szDDsO046uA71+EgeQcpOYt
         aqew==
X-Forwarded-Encrypted: i=1; AFNElJ/6Uu8YuZrS4ZyM/qDeZfh5UXglyFAP5de0eD+RU607UNkqVXM241DQwsuCBfK4t90UhaPatD/NWA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxdtvEawXYWGJVInFgX1N/wDd0Hs5mLsSQOh8UuQueF+Sfz827h
	lb+7Uo8uHDr4lUx/XNydorYXJaYbvZ/x1jl5BX6wwUWqnKCQFa/MPBHpZ8ed36hmgfBSk7PBtFT
	1AePCF87JogxlZOc5R2fkpdgS954/TvRmSe/6HJPY3p2V9zMv6FttIuCXskU5rg==
X-Gm-Gg: AeBDieuVGq25qaInxKi7kn9rxUmxc9+8ZZjN/j65VTXxWX+bYHqgN236QHzWnI9po2v
	TqTXrFLr0Yx3XuWAUD1EeecDLcUWgnNRLVxb3rv6LhkynS4pBM9zXq7MAlfBJ2Ha3Gx7j2dbcGD
	fe/P++74pmwl6OVITu0ImzYmHd4h5c5MuaaKLGAMuk/bthCVe77508c8E4nKcEjkmbVY89/7mdL
	XcZuZol2vo9Xup+1YE0BgZWP7k9aY12k0OvZLHFYiW/No0cSRvvfUpK9RoAHFBurmB22KOHTAu1
	Xv+NvAjNIGYw/N7OGRoCPnj0CG2XStsAwtYo9/5DdEbjOS0bUS9g9I9tOW+RhClTm3tKPZeXHz1
	KSYlkNOS8WKgx2xYGJDNYcxuhQvXWXjEBtv/MSekoWKZYMRN4+/ecgEJ9eaGYcuTIuNlT5loRXs
	Ii+kUEcPZGR8i67w==
X-Received: by 2002:a05:7300:bc1a:b0:2ed:e17:d50d with SMTP id 5a478bee46e88-2ed0e17d71dmr608534eec.32.1777368012412;
        Tue, 28 Apr 2026 02:20:12 -0700 (PDT)
X-Received: by 2002:a05:7300:bc1a:b0:2ed:e17:d50d with SMTP id 5a478bee46e88-2ed0e17d71dmr608514eec.32.1777368011821;
        Tue, 28 Apr 2026 02:20:11 -0700 (PDT)
Received: from [10.110.45.159] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ed0a103542sm2463767eec.21.2026.04.28.02.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 02:20:11 -0700 (PDT)
Message-ID: <6390db35-7f8e-4d00-9c1f-43d676007910@oss.qualcomm.com>
Date: Tue, 28 Apr 2026 17:20:07 +0800
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
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <ae_vacHQ75AgZbm_@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: rdqdHagcRJEs2vHL78QOcNHtsAmXFeNh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDA4MiBTYWx0ZWRfX4E2tRKF9Z9oq
 GYGPk7BrBQuOjiF2AVrlgJ/Q3YBOXI6hHEuclrygpPSlZp9X1N5VKaqRZqQXdfScJs/z2mGlNgI
 dw9flyUe8rkI2dza2XGRykCgZOL6HCyukR0LdLeBfX0h2ioYrxWgueFmz7Q6YYw5La+Hj5RBP2h
 NF7oqBv17v7RavARO93kYbaVJojjyjv1Bg8UNAWCDpC3m8azuxzilizsZCFZiYOJI/iSSBYwBel
 qx1cHmLpTVj7kgg/LKqDCrOBThJJHQ+ooEPccR+bBnYBKaL00ntCAJ78L7Kcl5nhU9FGBCXJYQN
 OfnehdetN2KV56YOy9BjEQG0h5I6XaPhYRQK8Ou0t4ryYZO/ULCM4qJMTF0F0esENTd06SFRSjN
 4uWpvLxiL/msv9M2zVGJsCS1srwTqZ7OysBwnFfDRkgmlxojRLuiRETmP8IFOcqHrMd5ZycS5mQ
 xIX8RZMmWvmtICx+MIw==
X-Proofpoint-ORIG-GUID: rdqdHagcRJEs2vHL78QOcNHtsAmXFeNh
X-Authority-Analysis: v=2.4 cv=cMnQdFeN c=1 sm=1 tr=0 ts=69f07bcd cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=1XWaLZrsAAAA:8 a=mLr8kJcTbZJnnLskd6wA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604280082



On 4/28/2026 7:21 AM, Benjamin Marzinski wrote:
> On Mon, Apr 27, 2026 at 01:23:27AM -0400, Benjamin Marzinski wrote:
>> On Fri, Apr 10, 2026 at 06:40:30AM -0700, Linlin Zhang wrote:
>>> From: Eric Biggers <ebiggers@google.com>
>>> +	/*
>>> +	 * Since we've added an encryption context to the bio and
>>> +	 * blk-crypto-fallback may be needed to process it, it's necessary to
>>> +	 * use the fallback-aware bio submission code rather than
>>> +	 * unconditionally returning DM_MAPIO_REMAPPED.
>>> +	 *
>>> +	 * To get the correct accounting for a dm target in the case where
>>> +	 * __blk_crypto_submit_bio() doesn't take ownership of the bio (returns
>>> +	 * true), call __blk_crypto_submit_bio() directly and return
>>> +	 * DM_MAPIO_REMAPPED in that case, rather than relying on
>>> +	 * blk_crypto_submit_bio() which calls submit_bio() in that case.
>>> +	 */
>>> +	if (__blk_crypto_submit_bio(bio))
>>
>> This will still double account for fallback writes (which call
>> submit_bio() on the encrypted bios, and return DM_MAPIO_SUBMITTED here). 
> 
> Just to clarify, I'm talking about the vmstats accounting. The IO
> originally gets accounted by submit_bio() when the bio is submitted to
> the dm device. For actual inline encryption and fallback reads, dm will
> submit the bio to the underlying device using submit_bio_noacct() to
> avoid double-counting the IO.
> 
> For fallback writes, __blk_crypto_submit_bio() will submit the encrypted
> bios to the underlying device with submit_bio(). This adds the IO
> sectors again, even though it's the same IO, only encrypted now.


Right, thanks for calling this out.

For fallback writes, the IO is still double-counted. Given that this only
affects IO accounting in the blk-crypto fallback write slow-path and not
correctness, I think this is an acceptable tradeoff, and we can leave a
TODO to revisit the accounting once a better solution exists.

Add the bellow to the annotate.

  /*
   * TODO: blk-crypto fallback write slow-path currently double-accounts
   * IO in vmstat, as encrypted bios are submitted via submit_bio().
   * This does not affect data correctness. Consider fixing this if
   * a cleaner accounting model for derived bios is introduced.
   */

Do you agree?

> 
> -Ben
> 
>>
>> -Ben
>>
>>> +		return DM_MAPIO_REMAPPED;
>>> +	return DM_MAPIO_SUBMITTED;
>>> +}
>>
> 

