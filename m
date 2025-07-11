Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBA6944F
	for <dm-devel@lists.linux.dev>; Fri, 11 Jul 2025 05:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752211859; cv=none; b=gvi7W2zIOZFiImsH0yTsw1ErWO620809vi88pmfKSFWG2LGkY2lLGSg9CJKOXIwXGo5MnUkiS9DZAgNjYMZhCf2ZCsN4SYQyubW8NdsxNXUrLPNcWiODk2hrzKH7+J6VGRUfXQOi74JVxcUF1bih+sujzNDt1ujIDzEqL/0Pm0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752211859; c=relaxed/simple;
	bh=bxhhsYwdnmaeDB2B9KaP+DVLndj+FDu2bBuVHV+YbN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ufhu36E91iYqxYNioURsNDR42zSCaEPRg5xpw8XtdXwfUBSBZyph1JNOu0D+gjG2kWE8m59sjjPt/opG/JbaQ1w4QOii8yezu0uKE68RPh+/+cl0g1YtbCEPBdvk8gka31sEAH9KHYddw3057Ai4LsT4aHf7nnHA85Tpyjck/hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=ZDk4x4WP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="ZDk4x4WP"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B1XUHC023233;
	Fri, 11 Jul 2025 05:30:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rK5U51orc+S23BlwipdLeLzAr4JgT/RfGpjhEpw0e7o=; b=ZDk4x4WPWPgatB+4
	TQde96VtzeZM54j8aDk3S1mnbxg+vliVnvJix7KA4Mm3OdVYGJCdInq2S0mxeU6a
	8C91XppvnsjPzaSJdKZMXE1jcwemW43NbEZilawFI8DDR2D92y7yTUZcKPaK4LbQ
	StPbTk8/BhwCv2BJ7QtEmpoRRZBCnwR3RCiEtrRkfIhAhxnqui4ZRtBT8bmXEDj8
	sQtRpx3iW3czoER9XdvAP7ikcaMf7AODrfLp2ATh55GamRVUSiLBs4MOpVzpHFAl
	wZjIXUYorGoDWD30ew9L5fm+N/5fPkFV42+yvTIeOSYbmO3U0WNuL8/eFrqV963a
	w9qaMg==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47r9b18bmn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Jul 2025 05:30:54 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 56B5UriR003652
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Jul 2025 05:30:53 GMT
Received: from [10.50.36.189] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10; Thu, 10 Jul
 2025 22:30:51 -0700
Message-ID: <ecbb7ea8-11f6-30c1-ad77-bd984c52ca33@quicinc.com>
Date: Fri, 11 Jul 2025 11:00:40 +0530
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v2 2/2] dm-inlinecrypt: add target for inline block
 device encryption
Content-Language: en-US
To: Adrian Vovk <adrianvovk@gmail.com>, Eric Biggers <ebiggers@kernel.org>,
        <dm-devel@lists.linux.dev>
CC: <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Israel
 Rukshin <israelr@nvidia.com>, Milan Broz <gmazyland@gmail.com>,
        Mikulas
 Patocka <mpatocka@redhat.com>
References: <20241016232748.134211-1-ebiggers@kernel.org>
 <20241016232748.134211-3-ebiggers@kernel.org>
 <681a6d2e-a80a-4e81-a049-841d7e8582ba@gmail.com>
From: Md Sadre Alam <quic_mdalam@quicinc.com>
In-Reply-To: <681a6d2e-a80a-4e81-a049-841d7e8582ba@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=dYuA3WXe c=1 sm=1 tr=0 ts=6870a18e cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=1XWaLZrsAAAA:8
 a=AcQ4Ai9qnt-bWPWtfq8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDAzNiBTYWx0ZWRfX88SA32wYyUgq
 gD6XQG2EzcG86bunBTsfNX+Y1AhAkU+CnImkOPWa5YpcxGaOcB1LfF1SAGSGkXpLRyXQIkcaxqy
 Lb0kK2uEcsMZopJBwlaFmnwsZPl8SbhtLtxNeNxUcXPr4FLnAZZIH0BO3FwLQ1Gy7wTGjtlAfBN
 qVJToqMqKnLW37xEE6LHQSkr9q7JTfht7GgYhRINE6rAz53pahWOpxWz/7RMGDF9+y8u21FX9JN
 bESFwWmYVj+cAjsmb1v54xJf9kJbwb6JofYTLTnPMkNERGN+eCQAu0qmJutvecOhH8stgX9GREF
 Iw41wQ5GBZu2zmd2QV6qL3rnP8lxWzgYZR/dKZASwDxos79Slaoz9Rr8Guw9Ou65tFrxM8FfJsU
 nQ+3Y/mNFbQbORmyGquWli2gzQ/XdwgR4lo1/nnHgLLsekXQdMirdUuLH0P2so7t0Hi2Ubuj
X-Proofpoint-GUID: 4FDLsZ_3FqT8GIpXPwDludjAVtljVtHj
X-Proofpoint-ORIG-GUID: 4FDLsZ_3FqT8GIpXPwDludjAVtljVtHj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_01,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 clxscore=1011 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507110036

Hi Eric,

On 10/18/2024 8:22 AM, Adrian Vovk wrote:
> Hello,
> 
> On 10/16/24 19:27, Eric Biggers wrote:
>> From: Eric Biggers <ebiggers@google.com>
>>
>> Add a new device-mapper target "dm-inlinecrypt" that is similar to
>> dm-crypt but uses the blk-crypto API instead of the regular crypto API.
>> This allows it to take advantage of inline encryption hardware such as
>> that commonly built into UFS host controllers.
> 
> Wow! Thank you for this patch! This is something we really want in 
> systemd and in GNOME, and I came across this patchset on accident while 
> trying to find a way to get someone to work on it for us.
> 
>> The table syntax matches dm-crypt's, but for now only a stripped-down
>> set of parameters is supported.  For example, for now AES-256-XTS is the
>> only supported cipher.
>>
>> dm-inlinecrypt is based on Android's dm-default-key with the
>> controversial passthrough support removed.
> 
> That's quite unfortunate. I'd say this passthrough support is probably 
> the most powerful thing about dm-default-key.
> 
> Could you elaborate on why you removed it? I think it's a necessary 
> feature. Enabling multiple layers of encryption stacked on top of each 
> other, without paying the cost of double (or more...) encryption, is 
> something we really want over in userspace. It'll enable us to stack 
> full-disk encryption with encrypted /home directories for each user and 
> then stack encrypted per-app data dirs on top of that. I'd say that the 
> passthrough support is more important for us than the performance 
> benefit of using inline encryption hardware.
> 
> Without a solution to layer encryption we can't do a lot of good things 
> we want to do in userspace.
> 
> As far as I understand, the passthrough support was controversial only 
> because previous upstreaming attempts tried to punch holes into dm-crypt 
> to make this work. I don't know of an attempt to upstream dm-default-key 
> as-is, with passthrough support. As far as I can tell, people even 
> seemed open to that idea...
> 
> Is there some context I'm missing? Information would be appreciated.
> 
>> Note that due to the removal
>> of passthrough support, use of dm-inlinecrypt in combination with
>> fscrypt causes double encryption of file contents (similar to dm-crypt +
>> fscrypt), with the fscrypt layer not being able to use the inline
>> encryption hardware.  This makes dm-inlinecrypt unusable on systems such
>> as Android that use fscrypt and where a more optimized approach is
>> needed.
> 
> Yeah, sadly you've removed the use-case we're very interested in. 
> Generic PC hardware doesn't have blk-crypto hardware as far as I can 
> tell, so we don't get the performance benefit of replacing dm-crypt with 
> dm-inlinecrypt. However, we do get the performance benefit of the 
> passthrough support (if we run this on top of the blk-crypto software 
> emulation mode, for instance)
> 
> 
> Best,
> 
> Adrian Vovk
> 
>> It is however suitable as a replacement for dm-crypt.
>>
>> Signed-off-by: Eric Biggers <ebiggers@google.com>
>>

Is there any plan to update this series ? IPQ9574 needs this 
dm-inlinecrypt driver for secure eMMC feature.

Thanks,
Alam.
