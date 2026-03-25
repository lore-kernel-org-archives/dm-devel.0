Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A85355F30
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 06:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774420690; cv=none; b=Ey7LfjcOOseXc63EptpDHTeD3r4KsAkpQO2jxn+b1VO/HSRRYsy9kBmZ8AWK/k6ZInrz+wLehjN+Mch45YDw+oBVS8mniI3Y1BGR3b+gfyfGJyDd6A4T5o6s8O6hCbb9gjp4poOiaWrNmG1XpVpDEDUwFjM9gBh8SkTL/sdG370=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774420690; c=relaxed/simple;
	bh=F99NNH142cVuV6qyl8Gi7xgfaHq1mIY2grCnraXXwHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oi55tZh/oi4g96UUZFiKxPkyjDOFW7kthmKMSNmCJKnfkUQlnoNRihvuzRTb0S0GqXXYFYLu05tOCQDthcfVJcPmMxvvJ1oi/Tj3VltwrW3Xxd/JWkgcw4DIZbRIygZB1htKHjdUXc5nL6WLh4Is1elN3FFYphnQlb/IekwATZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Oxukk6zF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Wkv1KhBU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Oxukk6zF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Wkv1KhBU"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62P4BD582807972
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 06:38:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HSJTals8UsXDwHkyegnf3eODvdagjyaQcP+rJw3ExcQ=; b=Oxukk6zF0M0+HX/4
	ZTl+jziBReO4QZHHZdawOiOVxxXr8D4B8pD0gn+QMK0Z9yRC7/uXhIBM1cgs5FUB
	MZdGqxsvqxcwc5jSurA3zvHfqBo7uDoFiAM2b8lRNooUfA/WoNCywD0DGCjPp2iE
	wLGu8TMmJz1Ntt2D08WG/gXCWdfrW2bsZq/zg3QA4C+lQqDNUpi2jqxNgXSwLtMD
	Llbq32Ebt9+LdL5FR2HrJI8NW1hPPPYSihjzHSwG8W5FYh9aXvFu2PIfqyyDyYfw
	Lc+iUcYaINjtGhqlUvApt19ntd4FjIm0sRn1P2ecQZUXmRDgBltT7NulHGHa3uDS
	TX1W/Q==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d3t9ekpn4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 06:38:08 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2c0e264d802so22056770eec.0
        for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 23:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774420688; x=1775025488; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HSJTals8UsXDwHkyegnf3eODvdagjyaQcP+rJw3ExcQ=;
        b=Wkv1KhBUemwCVyN63nhIuVSDeBD/gk7JdNv2BfIEneeuvCr58/yvhJGlCMg5/+v8vF
         bMzuYw1R2aNQc5bGEa2z+syrVUf5H9zOulFWC0cvD2I4wuc74YNRYd7w9u3q+1GqYGvs
         CYivD52pp2IsVW7kPfkoDRiZmvbkrXJgrSam5N4jd7XvNpAyI22j0AGRFNytsXx36DpC
         4B45N6F0wpr/KcR6IStQwDdu0qqIsebR0XaEGntxKRMXIrOw9P423JuPKS35oydFMvjz
         I0MJCJfkvgIDahnvDzXvIB4rb6lhgHxV/Ep/631M5TGt13tv0PnVFw2gYFdgvOQTmo3A
         HMfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774420688; x=1775025488;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HSJTals8UsXDwHkyegnf3eODvdagjyaQcP+rJw3ExcQ=;
        b=iIi9mW9GB2Mn/XUmR2J2UZiFPJBpuCMnezVongKBMLMa2JZBd8fDOtSio3W7LRwm1N
         dXlPHS/jDrVnQhbxQV3Jhg1K4lnkLqEv7Vfpak5hmugyoNhzzOTxMjGFq6y8vEe+RyAZ
         dlBE3WnJ5i0UQTn0uM8nGZfGuG3gjyhfd2bX/20oFp9Y0RHAQ73vYAhtljvNO5he/ANq
         qluz1nORtNA70DCsLQ3Soju1gg0pLkA6XVt2dRjQddvhUm1jwIb45W3OwB+CpJaoIV6v
         0KfZaWGcUP9abtJWz4ahKkydoJV+hLcT99XmsGnUp35gPdXxLwQ2I5wWgZOU98qEE6N6
         fV7g==
X-Forwarded-Encrypted: i=1; AJvYcCU84UXq16DiXhRA5bCjbwSfw0Uh6RRRoC29t3IbtXEf9mSrCCHuGHMMQztR1syc6IXIkcD5Rk1ByA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzqWKelzBgZlrhm0ohVuKLqpFFrle+vLltiBoCLBOJNDSRKlAMj
	23xQXqqvfSN7PTyYBEBXyiSzZSmHx5E2VlEJCYLrenx1DRykMXQwbhHDOIRFhTcya2vP4Dqb2Kq
	4uO+jtu8AzwsPMVDOPfdA0blM8HZYKCv0F0P2pR6GUZPUY5kaxsNGXEsXjCwiVg==
X-Gm-Gg: ATEYQzyS8uNqAPKOGT0eZeStDW6yE7OqMLQxSDX5OjMWPE/ln7TGeS8vWSXL7/GVM/s
	/TpBtIX3yNX9Lam1aDegEXB4co0Tg+CM6WgQTpL3opZy3LbWKHCKS8YQl+e1EE4tEMYkSZxE4ok
	4vtJY1o0laM8s/Q6oWaLTLUkekXuZy1pbeEowc+QalM6ri/ZzoMRDI+WZPk3dkXg4bPZI+kKSfQ
	T6N5tr8aeq+sDthfQRhs+KT2u9bBORuuPlstvzyCvJwKm+ULyoRoAc8N0QNbkrJIwDCwunpqJW4
	hRo9o2tlYiI3l17GCVZSoBN5wWrrHZyjZEqLolaKYtu3NPCFN2NmdNWzUbQ2JCzq0SiegG5kBJ8
	8TKSJvlnpLRrvYah0qtrLAkbk3F8KauqO1poous8L7Fpcs4/tHIvktRVg9anGZome7oa5GDC03F
	V+YVk=
X-Received: by 2002:a05:7300:5346:b0:2c1:5b21:ddd6 with SMTP id 5a478bee46e88-2c15d382995mr1264221eec.17.1774420687790;
        Tue, 24 Mar 2026 23:38:07 -0700 (PDT)
X-Received: by 2002:a05:7300:5346:b0:2c1:5b21:ddd6 with SMTP id 5a478bee46e88-2c15d382995mr1264202eec.17.1774420687249;
        Tue, 24 Mar 2026 23:38:07 -0700 (PDT)
Received: from [10.110.19.183] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c1536aa870sm4779813eec.2.2026.03.24.23.38.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 23:38:06 -0700 (PDT)
Message-ID: <89565ee3-b5ab-4821-b5b2-fc20a10c7a00@oss.qualcomm.com>
Date: Wed, 25 Mar 2026 14:38:02 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/3] dm-inlinecrypt: Expose inline crypto caps to the
 device
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        adrianvovk@gmail.com, dm-devel@lists.linux.dev,
        quic_mdalam@quicinc.com, gmazyland@gmail.com, israelr@nvidia.com,
        mpatocka@redhat.com
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
 <20260304121729.1532469-4-linlin.zhang@oss.qualcomm.com>
 <20260312063534.GC2359@sol>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <20260312063534.GC2359@sol>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: cEb237hxpPE6zja8YSMXW-yYAS3AAAeV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDA0NSBTYWx0ZWRfX/4L5DCJzG5C7
 AJ577anfAZxuDyZd3a0LjY2rtNJDVom2IZaLviiRurhreh4Jb1vpdFfgDFdIoLa9R7ZOoD3BDY+
 2KejX4/zm0UesCHnVFE9BK4EjmseRbLuS44ecL6+riq8PM5PlW6TWsK4m2BLiyYQMfx7tETQUN4
 dClhiec/lQTx+HIbWFCfsICEbH2NCGNO3Nm6BFkkgHjSNFA2KtnTtzjLRSWlZ3EaW/Iq479SsXq
 hIF95c3fH2hFNMLUEvQjj7ePXEcrQ8Txn0/KeL962T6fTUu1+XnlrEk3cvXSC9vR3e1ccwxdPYu
 5W7k9GRLAGtjqLwp4ScyiloVwYc+rUG/u2JhpBbxh/d3SbYrMU4ZdDa6nvajc2LoZLdbYIgZK6e
 tL9SBSUgFXxSoja3X61UIOeMr1LY6ypZBV5uS1zFkGdNtfxm6AxwgjabMVIXIWsJc0YjfiPYZJp
 wMljatOm+gDS9di+eeg==
X-Authority-Analysis: v=2.4 cv=DdAaa/tW c=1 sm=1 tr=0 ts=69c382d0 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=WmTw6OgLBKyD5lLRCsgA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: cEb237hxpPE6zja8YSMXW-yYAS3AAAeV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603250045



On 3/12/2026 2:35 PM, Eric Biggers wrote:
> On Wed, Mar 04, 2026 at 04:17:28AM -0800, Linlin Zhang wrote:
>> Add a new DM flag, which means the inline crypto capabilities
>> from underlying devices can be exposed to the DM device, and
>> the DM device consumes these capabilities, rather pass through
>> them to the upper layer.
>>
>> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
>> ---
>>  drivers/md/dm-inlinecrypt.c   | 2 +-
>>  drivers/md/dm-table.c         | 3 ++-
>>  include/linux/device-mapper.h | 7 +++++++
>>  3 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
>> index 251760da9f7e..eda56893d430 100644
>> --- a/drivers/md/dm-inlinecrypt.c
>> +++ b/drivers/md/dm-inlinecrypt.c
>> @@ -396,7 +396,7 @@ static struct target_type inlinecrypt_target = {
>>  	 * Do not set DM_TARGET_PASSES_CRYPTO, since dm-inlinecrypt consumes the
>>  	 * crypto capability itself.
>>  	 */
>> -	.features		= DM_TARGET_ZONED_HM,
>> +	.features		= DM_TARGET_CONSUME_CRYPTO | DM_TARGET_ZONED_HM,
>>  	.module			= THIS_MODULE,
>>  	.ctr			= inlinecrypt_ctr,
>>  	.dtr			= inlinecrypt_dtr,
>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>> index 7be1d8dc8bdd..f0580935394a 100644
>> --- a/drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -1407,7 +1407,8 @@ static int dm_table_construct_crypto_profile(struct dm_table *t)
>>  	for (i = 0; i < t->num_targets; i++) {
>>  		struct dm_target *ti = dm_table_get_target(t, i);
>>  
>> -		if (!dm_target_passes_crypto(ti->type)) {
>> +		if (!dm_target_passes_crypto(ti->type)
>> +				&& !dm_target_consume_crypto(ti->type)) {
>>  			blk_crypto_intersect_capabilities(profile, NULL);
>>  			break;
>>  		}
>> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
>> index 38f625af6ab4..6abd1b4fcb76 100644
>> --- a/include/linux/device-mapper.h
>> +++ b/include/linux/device-mapper.h
>> @@ -306,6 +306,13 @@ struct target_type {
>>  #define dm_target_supports_mixed_zoned_model(type) (false)
>>  #endif
>>  
>> +/*
>> + * A target consumes inline crypto capabilities itself and doesn't support
>> + * passing through inline crypto support.
>> + */
>> +#define DM_TARGET_CONSUME_CRYPTO		0x00000300
>> +#define dm_target_consume_crypto(type) ((type)->features & DM_TARGET_CONSUME_CRYPTO)
> 
> This patch doesn't make any sense.  First, no new flag is needed, as the
> behavior is already correct if you just leave DM_TARGET_PASSES_CRYPTO
> unset, as far as I can tell.  Second, the new flag is numerically equal
> to DM_TARGET_PASSES_CRYPTO|CONFIG_BLK_DEV_ZONED.  Third, even if it had
> a unique bit as seems to have been intended, the behavior is the same as
> DM_TARGET_PASSES_CRYPTO, which should not be used on this target.

Thanks for your review!

ACK. The key can be evicted through the real block device (the backend of DM device) during
the removal of DM device when a blk-crypto-profile isn't tied to a DM device.
I'll remove this patch in the next review.

> 
> - Eric

