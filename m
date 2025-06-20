Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFDA17BD3
	for <dm-devel@lists.linux.dev>; Fri, 20 Jun 2025 14:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750429809; cv=none; b=m/RyaarRPGMN72n2JY7vZ2HZfgRHdsjHtkC6iN6DuNdaVYzDUKLfUMUFGcBZVzSqSWcSdJ5b959tbimSMIsUfzPLY10jOgTBtCmcsB9esyWjq3UOWzjO3cWlz8Pdwg+yssj3EyiIvN8KIJsFuSpBjKBz6AP58i2Xdy1gG0UqaAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750429809; c=relaxed/simple;
	bh=NUsRp77AHscZ5ZmdPaaWoG/2rCFD5pZ1Nz4DNu2KDRY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p40e6kZ892Szt3H8lDuSKcI0UOa9+8ot0N/qvbMoPxd3Hz4mFVrK/EByDugbpSOj8ezvTq7tYTpjiSMQdevMTFxQWGLKrjBkZvj9WO2ibAQjePjqLJAXb56VOGwczMk9c/AGSWF4aX/im6scBHHu6GT8Sj+y1SAxE/80GMg/2t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eniCas3P; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eniCas3P"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55K6w2CG022979;
	Fri, 20 Jun 2025 14:29:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=znCNmZ
	4jnTTj6Cm3XcemyxfvdS+OuViyGShhtS2iYW4=; b=eniCas3P8CxkYeNEN5Zo47
	WeQB96A3hVRuRlBZpQ6lgPhevv7S/z+a/zkttBMOHq3xrWQWTmncn7hQFQe3rXZV
	/WTok2adjJdBd2GM550svG/Li1MlT+a3JIQ7cacCDdTsOmpoaWaVsW5q0HUGgUoS
	/5uFGQI0LFMtKpHYzYDEM7sNhbSfpRLd7iToyrh0cfiollF2C+QvUj7FBgXP8EBd
	SM+GuEDEgHkjLYKq3e8s/cra0v8Bc0wwW7kHu3dpJwwDS6gL6JkUnhBxNBtPpz+p
	uCcR44Hrx0Z0hafMBNupDpsXzS//D3BjrRbGPV8eCB3RmIhl1CHGI58+h+9zhM/Q
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4794qptv9h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Jun 2025 14:29:54 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55KDCU4L000762;
	Fri, 20 Jun 2025 14:29:54 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 479mdpkhuv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Jun 2025 14:29:54 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55KETrUs30605934
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 14:29:53 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2064658056;
	Fri, 20 Jun 2025 14:29:53 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D3A55803F;
	Fri, 20 Jun 2025 14:29:48 +0000 (GMT)
Received: from [9.61.191.218] (unknown [9.61.191.218])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Jun 2025 14:29:47 +0000 (GMT)
Message-ID: <01233a11-9f65-4851-ad7e-d0b61c496339@linux.ibm.com>
Date: Fri, 20 Jun 2025 19:59:46 +0530
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] block/md/dm: set chunk_sectors from stacked dev
 stripe size
To: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
        axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com
References: <20250618083737.4084373-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250618083737.4084373-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jfTHIC89fl23PLjz-izl2XKCT8PjgmOa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDEwMiBTYWx0ZWRfX61nMzrsxGyLh 2YUvaRf4wsSIUYGrYn9HoRKv1GZ+GzfRTqvG0bLpcl3CimyjMBbSVO0x/OCvHCI6IZpTzDfsKea DEVahN9h991URW4cb++J2TNjKNBQ4yPBUag0l55u367Lm/bchNCvmyEgN2pxw1ziziFYdMHT74s
 2MJNVvfF+h19phzFetzE4r8EzXW84B3keJS2rezuysNxoJBq3WkBFbP+Tjk/HhbqGVG0RicJwgV qSC6kL+F0E7wuxocvtATbGY2NhYnQx4+z0TppxgHp3F/6ZGxr1nCQeltElR/p5EB0n8EM0f2bbj 3TSx9PvwsjXbwT7nfwMM3DoMGmkiPKIJ0nJiqP/cRpwgjS6/rml0xU52X+5KIJJp8k7bPHu0GEn
 Uh4jzOntbbL3lGycKz35PxC9Buddi1DwUQBz/O6Fyi2jozbWeSA9Ja+7u1f/Ovf5x4++hSx5
X-Authority-Analysis: v=2.4 cv=NYfm13D4 c=1 sm=1 tr=0 ts=68557062 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=6PkHI8djJpZymbWUlqcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: jfTHIC89fl23PLjz-izl2XKCT8PjgmOa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-20_05,2025-06-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506200102



On 6/18/25 2:07 PM, John Garry wrote:
> This value in io_min is used to configure any atomic write limit for the
> stacked device. The idea is that the atomic write unit max is a
> power-of-2 factor of the stripe size, and the stripe size is available
> in io_min.
> 
> Using io_min causes issues, as:
> a. it may be mutated
> b. the check for io_min being set for determining if we are dealing with
> a striped device is hard to get right, as reported in [0].
> 
> This series now sets chunk_sectors limit to share stripe size.
> 
> [0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781
> 
> Based on v6.16-rc2

I have validated this patchset using an NVMe disk supporting atomic write and
native NVMe multipath. I have also validated dm-stripe and raid configuration.
Overall the patchset looks good to me and fixes the issue I posted[1] earlier 
with my NVMe disk.

[1]: https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781

Thanks,
--Nilay
