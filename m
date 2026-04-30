Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54093A0EA2
	for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 09:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777540900; cv=none; b=k/MkkdmghTn/XKxfV1KWWuJxJ/a2Y/XH/3T60bXA6cYxY8NyBc9LIfWUgVb7PtP6hPhhlignv13vYQQLN6oS9mLaMKrutt1Z+AlR0xnUP26GMLhXAQDlbitnQnb+SS8c1vJiKA30nQ/1nOrqluETZmOkivN3osaqcDngO+zPWuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777540900; c=relaxed/simple;
	bh=5VbGrAjbaukprpJqt2wW7jnukrcStD38ZA9lfHMjQ7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=asIVw1YbKLPbvC5qZL7SRdw+p29BQEQHc+IPBG0zmXWz/KbJ69anTDHEP6PEtUaKKqlYDhJ+yhuGq8Ws8P6lS0Ek2rpnHurQCbIW/chCDiyJquL5SJsCY2SkGzxmFHDhMU1kOSMwdrLO53Ajb/A3684c/iW0w/5639Zk+/61BDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BLzIlbwn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jdUHcJfD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BLzIlbwn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jdUHcJfD"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63U59Kok2907559
	for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 09:21:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	o1WNaMKL0REcbyyi9G+CV0fM9H39t5QBIQfH9Xvc+Vg=; b=BLzIlbwnQ05OHk82
	LMkyessnHkjifiel+N3dItvb62jlZuUCmQ3jkSTwM2UtQm8OZ2QAnMtbIFdHYCKP
	J3oA+Ly273tzT1F9635jWua9o4VSh9wEiqu5gPYgWhSQVhcdYIde9Lz371Y7j63E
	tFa4XUHxVcxEqOt1mcVmNZ8zDrU/Bu4J+ztSje+nshOZ2fucjww6BZbdDx3h93RV
	p9M2sVminOXNt5vtO0guuJdVaIubZDnIbGK5CG9mz5GNwFnYIpy04CR0BXRewKUb
	/jSXm2E1bRFOm04Ikzw3MiGw25D6m/1DDxkrw5RMBV87+Yl6kI7MG50Q2d+tP5+/
	YNT1tg==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dv0pf8x2r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 09:21:37 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-2d889997495so2645539eec.0
        for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 02:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777540897; x=1778145697; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o1WNaMKL0REcbyyi9G+CV0fM9H39t5QBIQfH9Xvc+Vg=;
        b=jdUHcJfD5qTKsVClHam+vRFjO2+h2xfQT0TiTdXSSKsKyn9TBe6aSr0nO1gxr45l+T
         xMfcyQckDbI2voZdh4WI5BGKSEO78MFbiY+20gYJQYbxYEeVQlnb8d4Bqit+PUxF2Rv9
         WpzfsQvXtbqGSVA2TPUczEPui52MAVSbCUQUrwsJ6wuW3b4aE9Yl/pFD2/WUsDWDUfQS
         H4AyDuMBhMFmjBlrlHzTefLyhMBo/CjYaNX1yNFCzbz/PBKm4y1kqWljKw1FciWQRqQu
         13wP+BffasQhhpftvS7caE4MidPOg3/WFlHzLYeMiauUo7Bvg8dbFkbWqwTglvCG20p8
         +E9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777540897; x=1778145697;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o1WNaMKL0REcbyyi9G+CV0fM9H39t5QBIQfH9Xvc+Vg=;
        b=pfYxPzzpztGr6klb7aZd9Npu8uP+DyReyVFKymQ1ZWjYa6ZR6Xh/RgaZFo8CNlUgWE
         ZdCOQbtIXn/UEkhYplmeklcw/XNIckbs1aqeItZPpzabzMJLTCxpLMRKf9w4ShFq1lB3
         cXTqqm8zDRagx7jXISq2pJtL3rbD5Rw1CdW4NZzD0x9Sb4NTLb50RyGoVUNj4MEN4ZAq
         IJc5nKaSc1dp5sXmsFibOcvNRCTtwzpcN6RvegJBYTuSpY+WwNzMhVC5g9jFAKzLF3np
         CKPxIvht338v+uV+x473LhBrCApduMi+6IkfSQYNZ5jW31YRz8QYdLbAcQVaEoa8fV5k
         unNA==
X-Forwarded-Encrypted: i=1; AFNElJ8aJkf3WBZY3/XC9dJof2d3DgyrWzKqUgK87hUPsPa7MmlydQVMv2Snk82g8tvfgswTMFKlsN3zWg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxaeMTiL+0o0YqGaCNX7802yyHJ+vVvh14/50FilVpBC9p7ZXUq
	GB4PfEIWE7wOsnAXAtwakVnoXZ/JAFW1pRyofo3bqXuwo7VkWJCa7NEvcqYcMUpCLyf7EnPyzoT
	3oETFiN4QJuOJQqCAzg9vft17jMQM9IhJiPzLUkVAi7oVelvvLlf78sXVL74GqA==
X-Gm-Gg: AeBDieuZh1yHm2JgM0bQ0RiVMJQDhWTXbRTBTn6RdZnYZMVXWcmSej4D14J7+qG96qD
	EnIcUQSglCYKLl8iGAjtQmO9M6/q8irFHWJivOGyBa6V2eWusguSLFlr9SN6UESDCJpBb/fdQLV
	wsGJbLIz5BJMGiEq2/trP5nP/gaZEtRHxhuE6Z3xZEdjbdE3D8TxneuU9CaHsAl37zTjRaa0neA
	6p6/KpaAnmUMKVYJPwpTqrYRDcqv3/3ee4OMuYJC+6P78pV7SUgxHK3+F4qRw52b8ODckZNHdLv
	kTl698ojuZqo87FbGe/l5brrJkIUTi2f5ToapAL7m3BBHR9sAXdpdg/TGuj3JLW2VmdvLHzma7x
	FGQdmwnA31ttdy9oKvqTIGKd6MPOhC+eKpZYI/WPztrFTrzROCOzFIXky/5PtxDqIcCeTT/MK/c
	Ujul0Q3qQCBJglzg==
X-Received: by 2002:a05:7300:7b95:b0:2c5:b23e:48a9 with SMTP id 5a478bee46e88-2ed3e491075mr988856eec.25.1777540897195;
        Thu, 30 Apr 2026 02:21:37 -0700 (PDT)
X-Received: by 2002:a05:7300:7b95:b0:2c5:b23e:48a9 with SMTP id 5a478bee46e88-2ed3e491075mr988838eec.25.1777540896448;
        Thu, 30 Apr 2026 02:21:36 -0700 (PDT)
Received: from [10.110.45.159] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ed1c09c6e3sm5667943eec.25.2026.04.30.02.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 02:21:36 -0700 (PDT)
Message-ID: <effcf41f-c6a7-441d-85a5-b1d471611dfb@oss.qualcomm.com>
Date: Thu, 30 Apr 2026 17:21:31 +0800
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
 <7ab5cd97-30b7-42ca-80ce-6d9cd8c45b73@oss.qualcomm.com>
 <afIizQA9kVR_u_2j@redhat.com> <afIqszyKboCEmHDa@redhat.com>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <afIqszyKboCEmHDa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDA5MyBTYWx0ZWRfX54oe1UqHVXWI
 nb/8x5Ph2+xNy7KLmUhuYFdsXcr5LOoI6Uw4e4Qv8Zsx8kUenm/+DdwIzxDuoZ34y/a4ljOHxMg
 fpK1fGwkVXVhAYb8jkM1QDNnKou35mvi6lsOOJ2uk/64Y1LNbGoPKdAVYVEKe4gm/cj6H/EY1Jt
 qr9tCjucctLIRZkiW3ucd1t4PYnpjYEsGEbJB+ntk2F0QWwn6FeutK53WNyh0spcLQRq59IIADY
 5spmcxhcNwHK7ztDnu/rfknJ2wUJfZ4pQw2UCzmwr251xRDuV/FakzA0mUE4Yv4Q8QgdKgUL3lj
 sWmNUZD6ReKhCGHk3oN2Ai1rJzFyBzK4zj+hRGr0O+n8COTzn+i0INESRoE5JGm6Wth/+rRZ+V6
 ZDBIOu+k1fuY0mspbvlpMAxjdW+n7kTGnPMhSobID4htFgk0IUmLZoyIWyhtkZIq+vJZueB25l6
 bJ22WooCtx5aR/QDn0A==
X-Authority-Analysis: v=2.4 cv=Zrnd7d7G c=1 sm=1 tr=0 ts=69f31f21 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=lklvTEQ6XvIVcFA1PqMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: 6N0YOjbsrhToyrMI99TJ4TFfa7ERIRgL
X-Proofpoint-GUID: 6N0YOjbsrhToyrMI99TJ4TFfa7ERIRgL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_02,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 adultscore=0 phishscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604300093



On 4/29/2026 11:58 PM, Benjamin Marzinski wrote:
> On Wed, Apr 29, 2026 at 11:25:04AM -0400, Benjamin Marzinski wrote:
>> On Wed, Apr 29, 2026 at 08:34:00PM +0800, Linlin Zhang wrote:
> [...]
>>>
>>> Thanks for the suggestions.
>>>
>>> Adding a bool need_acct parameter to __blk_crypto_submit_bio() would require
>>> updating all existing callers, which feels rather intrusive given that the
>>> accounting issue only affects the blk‑crypto fallback write slow‑path. I’m a
>>> bit concerned that this would broaden the scope of the change more than
>>> necessary for the problem at hand.
>>
>> I get your concern, and I'd like a second opinion on how much we should
>> care about this, but it doesn't look like there are many other callers
>> that would be effected here. The only existing caller of
>> __blk_crypto_submit_bio() is blk_crypto_submit_bio(), which would just
>> call it with "need_acct=true". Looking at the code path below
>> __blk_crypto_submit_bio() that would need to change for submitting the
>> bios:
>>
>> __blk_crypto_submit_bio() is the only caller of
>> blk_crypto_fallback_bio_prep()
>>
>> blk_crypto_fallback_bio_prep() is the only caller of
>> blk_crypto_fallback_encrypt_bio().
>>
>> blk_crypto_fallback_encrypt_bio() is the only caller of
>> __blk_crypto_fallback_encrypt_bio(), which is the function that would
>> need to choose between submit_bio() and submit_bio_noacct().
>>
>> Doing this would change the crypto API (by necessity, since we're adding
>> a new argument to __blk_crypto_submit_bio() for stacking devices to
>> use), and it is adds a extra argument to a number of functions, just to
>> handle this corner case. But it is still a relatively contained change.
> 
> Having discussed this a bit, I'm fine with leaving this as a TODO for
> now. If anyone wants to chime in with an opinion on how acceptable it
> would be to add a new bio flag for skipping accounting, that would be
> great.

Thanks, Ben.

I’d appreciate it if someone else could chime in on these two approaches.

> 
> -Ben 
> 

