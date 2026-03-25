Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBBB2EBB86
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 06:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774421733; cv=none; b=YiOe/B3biW0DsF4rnoeg3hl9kAM1Wbl4Kjghc8nrxO90jbs7lnMH73aev+rEdXcmX2f0Z9HvPOkJ9xhb5xaM35UE7DcMOnhBQ42i70T7zr80mQsKy9ZX5yZziNvALI9jKkgjdRqc39Fu1tgy9RqZwupipE7qdktclvdOEzTY4rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774421733; c=relaxed/simple;
	bh=A9Bw7A93QwyB/11G0f5DcWqXROOckyJZYM3CCOgkNCk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nLkpZLlDuM3aOOaYNQTlVtm09mjP0/mOzGUBgY0w4RMfKAro1nn4ohUrooKEf+CzVWJ5lHL4SIhjwa28gZ4CC5t3SKlElJXVzubii3k3hsna5rtwQwdk/To+xoCYgzs6gCg5Sr0vWW3S2JKzDxJYAN8S8uWPIItnL73k5L5J3TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ci3z0clO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hmV6IGP1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ci3z0clO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hmV6IGP1"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62P3xGqK919620
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 06:55:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/OyRLeF1qiRXWOZLHBDozmhB2d8QM8xWWW+aAnLORUI=; b=ci3z0clOgC8UHxX9
	ynM7JYqI7e71SxHgKyxjQsM0LgoUdR0M+Ch0zQDKMAN/w7HWOb+s3t7K6SRdnO/9
	Gt5S8TbUkQV/fLKNN4x9g7398akOBzlnlH8E53kGYdUk/wvWvyDHwNahgeyX1Aim
	dWQ2z4Qg1ev8c6KzrmR5dzfg7fakeVamWqmYUVfcwlzrLrFDUJr08zEkk6lZsA6G
	IdmRJrDzUzaemRNRuuUrOW63i6jMxxPBoEUeb+qWOjBP5TzXuxFTWyi7ouC8oMkv
	86VaGqZJtnj+lsNi2NSHlp6P0lBFSTrchdOYmEWjlvcHcrBVJM2qFzUuJaH8mMV7
	NdhYUg==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d489mghb0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 06:55:30 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2c0f6593ef5so4583127eec.1
        for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 23:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774421729; x=1775026529; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/OyRLeF1qiRXWOZLHBDozmhB2d8QM8xWWW+aAnLORUI=;
        b=hmV6IGP1SwXRdLugfWphX8eo52rrtxQ6wloUFw6Y0wRorXfnseL/TCSTfbTeHcjqCv
         UBY73ozFFWJAxn14zzUl/UxLcP0FI4lx7nWritOZ0F6nafxHqlda1yZlv4Iexvgc7+mB
         V+8P8LIhkujsoFktVYImSXVt01qHoLQZMj1u/hWjZ7nPLEfB/y5nWADz3vIyCLI8z+DM
         51z0EIgEx57HZxSjCfuqagjEQwh9DIWvd3HIxNxueKO9n/6SdZyFhKdatgOR78ya87Et
         zTjH0tvJPYZjeq5/6M4uIq6M3m9GthiEGZcg05JatzpYLamV9HXaQDlnPBnu3bk1KgB6
         Lmjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774421729; x=1775026529;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/OyRLeF1qiRXWOZLHBDozmhB2d8QM8xWWW+aAnLORUI=;
        b=Kznnlbh+BODItX5hQVs40piqK48l4E4B5x+jWPBfFsB3OPeLJQp8d2q9D1HVx3htSr
         3csXkz4BLatvrjNSoPoZlbHxvUE+ros7oCBPUa5qj1oeGZ0FsCSHFcbVjuHGecjUmQfa
         loocKkH5T5K5ZdTLTdhllJJqBFz5w2Z2AaTu6I0dF92wXAELDFZWRCZnaQFh8o06syHE
         OWnP5h/KAeHbyA2akrHfgqGZKpbUgAaj9x/JK10kAJe1ROxhQOkIsyp9c2HoXqniJ8Wg
         6G3I7JjPKE4LsekNXqYT3IysB4uCTk+B7c9mt9NU+sDajCajMEppIOghtTNF/UKshfDA
         c1aw==
X-Forwarded-Encrypted: i=1; AJvYcCV5E9YOYmwpsv4ipfMGFQZ/VFbjIFDsMXBwR2ENfurLlV291c2YnxYfJ4EGVgBZBFCPtHGQ9D/M4A==@lists.linux.dev
X-Gm-Message-State: AOJu0YxY2uhuFJRpYpyDAXzp2AZ6jZRzDt4xrkVzyhfaXEpU52h1FaSb
	poSswpiORhrxwyA3dpZa1zhNbjbiz0Aczjrnu4JL2Kgb3H6gWIRnfbJyY3deBTHlBLqOl5itLpN
	1x9RHYOlQzR6nSFc1UC9cjSyJrL8nT9yW6s3LJjlzkl420ID/mx/TS9WOK9cHlg==
X-Gm-Gg: ATEYQzyRF9APlFZajHGMMs3SdXDybZJBqsSptQUl9jvETLTTcIoBl51WLAFsLiWoaWR
	OtkT/2WTBRNR/FH9wBic9ZGTyik8NAnlD/Y3Ia+pgC5UZLXR7xUWCXerSUzsdw64mdGkfZ6KWWN
	hIPpigArG3hpvWfIFSlCXqZuaAfIgDp0RnBjaOMJ5s6hVSMYGVSI6aRaMCcklmzouoyq/3Zoh0F
	YQLdmO5lpdKPfeFKSPjZB6OcFT4XlRZ+rtUa3vHv3ZSrpHV5/wv5ftF37os4z3sz08JBSKdLRbN
	omCpWqPqZjSBXAEze10fzfukAlWG2eE8SQVLeTkz2GR2L25NteFUgPKX7Jrxx+f3Mo/WPniCRz5
	RoqgABuMpMW2EgM7VW0dmc09nN1AhB61mM3XheOPX0apAGQkwxaZKb83t+z0EpXOiz396J46WA5
	u958U=
X-Received: by 2002:a05:7022:6713:b0:128:d17b:e7ab with SMTP id a92af1059eb24-12a96ef7ce1mr1125003c88.36.1774421729178;
        Tue, 24 Mar 2026 23:55:29 -0700 (PDT)
X-Received: by 2002:a05:7022:6713:b0:128:d17b:e7ab with SMTP id a92af1059eb24-12a96ef7ce1mr1124976c88.36.1774421727992;
        Tue, 24 Mar 2026 23:55:27 -0700 (PDT)
Received: from [10.110.19.183] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12a733b4a99sm12883815c88.1.2026.03.24.23.55.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 23:55:27 -0700 (PDT)
Message-ID: <b837cfd6-a3fc-469b-9c92-8df6d3148a68@oss.qualcomm.com>
Date: Wed, 25 Mar 2026 14:55:23 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] dm-inlinecrypt: add target for inline block device
 encryption
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        adrianvovk@gmail.com, dm-devel@lists.linux.dev,
        quic_mdalam@quicinc.com, gmazyland@gmail.com, israelr@nvidia.com,
        mpatocka@redhat.com
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
 <20260304121729.1532469-3-linlin.zhang@oss.qualcomm.com>
 <20260312070110.GD2359@sol>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <20260312070110.GD2359@sol>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDA0NyBTYWx0ZWRfXwyDxbLvpV42+
 rgj7RMKWepYikd0egHVBmlOWVazwKaOtpm2PrBMOIeHpDUaC+2BD432e2MXDZZbWbse76xX6WZR
 gQY3XC5PvXArGfIpSOIluhVj7+/QRr04EQ8gx4uU+iL9036sKipiPFefdSopps6Z+SnRXZcJSL9
 9DR8ANtzTnQknk+S+NQJFeDzAiP1TLbL4wtkqMmy3nqjsxyMblU1yU0ds6UzGsjaR722puIZUpH
 IgqOMU34WTg5+knXA+SUEUQBiDqIcp+8wzyFpVNcIY+zxb67s16hoZTEPmX/cS1vnQ7L8dSiIZU
 Qp/MbjJThmR0U1u/749iK26Jo7ToSikRO4mH9QzbEINeqGuaCzaKrh8+Rg5KUsCsQ6ATO8VX4uy
 DrTLxx++inqUequgxIIiaA940tEseWh0mdWn0XH4eW68mjJ5m/ACY6dTLs3qixdWD9lvLbFtFAg
 CVXvDcIyiHYuHXziVNw==
X-Proofpoint-GUID: _qeOALJhgom_PmZXgibxuq4Z-RaYlJA0
X-Proofpoint-ORIG-GUID: _qeOALJhgom_PmZXgibxuq4Z-RaYlJA0
X-Authority-Analysis: v=2.4 cv=AKSYvs3t c=1 sm=1 tr=0 ts=69c386e2 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=Oh2cFVv5AAAA:8 a=1XWaLZrsAAAA:8 a=EUspDBNiAAAA:8
 a=p8t-2gd-wzcZwGZBdWsA:9 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
 a=7KeoIwV6GZqOttXkcoxL:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603250047



On 3/12/2026 3:01 PM, Eric Biggers wrote:
> On Wed, Mar 04, 2026 at 04:17:27AM -0800, Linlin Zhang wrote:
>> From: Eric Biggers <ebiggers@google.com>
>>
>> Add a new device-mapper target "dm-inlinecrypt" that is similar to
>> dm-crypt but uses the blk-crypto API instead of the regular crypto API.
>> This allows it to take advantage of inline encryption hardware such as
>> that commonly built into UFS host controllers.
>>
>> The table syntax matches dm-crypt's, but for now only a stripped-down
>> set of parameters is supported.  For example, for now AES-256-XTS is the
>> only supported cipher.
>>
>> dm-inlinecrypt is based on Android's dm-default-key with the
>> controversial passthrough support removed.  Note that due to the removal
>> of passthrough support, use of dm-inlinecrypt in combination with
>> fscrypt causes double encryption of file contents (similar to dm-crypt +
>> fscrypt), with the fscrypt layer not being able to use the inline
>> encryption hardware.  This makes dm-inlinecrypt unusable on systems such
>> as Android that use fscrypt and where a more optimized approach is
>> needed.  It is however suitable as a replacement for dm-crypt.
>>
>> Signed-off-by: Eric Biggers <ebiggers@google.com>
>> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
> 
> I don't think it's plausible that this new patch was actually tested.
> The version I sent in 2024 was tested at the time
> (https://lore.kernel.org/r/20241016232748.134211-3-ebiggers@kernel.org/),
> but I see at least two things that would make this new patch not work.
> 
> First, the call to blk_crypto_init_key() will always fail, since it's
> being passed BLK_CRYPTO_KEY_TYPE_HW_WRAPPED but using a 64-byte raw key.
> 
> It needs to be BLK_CRYPTO_KEY_TYPE_RAW.  (BLK_CRYPTO_KEY_TYPE_HW_WRAPPED
> support would make sense to add as an extra feature, once the basic raw
> key support is working.  Note that when I sent the first version of this
> patch, support for wrapped keys was not yet upstream at all.)
Thanks for the review!
Yes, a mini change about key size validation is absent in this patch, which
leads to the failure of dm-table loading with dm-inlinecrypt target.
Similar to dm-default-key in Android, next patch updates ctr function to
ensure the key size not larger than BLK_CRYPTO_MAX_ANY_KEY_SIZE, and pass
this key size to blk_crypto_init_key().

> 
> Second, since v7.0-rc1, submitters of bios don't automatically get
> blk-crypto-fallback support; they need to request it explicitly.  So,
> this patch will not work with blk-crypto-fallback anymore.
> 
> If you'd like to continue work on this patch, it might be helpful to
> check the latest version of dm-default-key.c in "android-mainline"
> (https://android.googlesource.com/kernel/common/+/android-mainline/drivers/md/dm-default-key.c)
> and resynchronize this patch with it.  It already has the code to
> correctly support both key types and blk-crypto-fallback, for example.

ACK

> 
> Either way, this patch also needs to be re-tested with the latest
> upstream kernel, which doesn't seem to have happened unfortunately.

I'll share the test result on top of the latest upstream kernel in next patch.

> 
> - Eric

