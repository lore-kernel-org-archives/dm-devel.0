Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086B01CF5C6
	for <dm-devel@lists.linux.dev>; Fri, 25 Jul 2025 08:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753431282; cv=none; b=mKqsS7xtBc2ijUxiKgSjpfjFO/cR2NbGTFiqjoEKjRxR4kAfiLUp0Kk/7ymvO26b/uJW9LXbLGb/ETdeq+PDbLtb9C6FrtgKvEZrMHDsom7ixWca+mr1Y07hTRqR1q508ZhnABP611qz7qyfRnyKx98iFvwolzFCskv/cOsQwew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753431282; c=relaxed/simple;
	bh=1/YieQ3w9CW4KKXAVmYFbURXt6LqB3pVg7B5l3YIXUY=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=S6mU6Amij4niTde0CEuA7ECc4XjhplcCT7Ly3HOR/kToL5KLTKiUWoJgJNRMWQMMEfST2ZTVD0a+Pg+DJyjz4woDGKE2iXI6QP6vpDBfYJTTrF3k+w7tDtDY29uTzGmp+95v7IdQk0YitUcAb6g4pt82v24BNtjjZMhONlQ6p+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BnHC3R8V; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BnHC3R8V"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56ONKGs4024021;
	Fri, 25 Jul 2025 08:14:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=W2OrDHoFdAQc+UcHVvd4xci5m/YQ0T+i0AIpDqFDi0Q=; b=BnHC3R8VibaS
	Zum8IYf74TSc4I79YeDJDfb/1TciXpgHCnXRYmfVjy9EIwl7rf0nnJO094ea5shm
	EfSYfYLwm2RyWFBjuT2luUGC/s5GO6yG1o/zH8r1TD9sEG+fWQe0rNA+pKgyw1dG
	0kF8hLuaZ9YtdlCIl5DcisOG+KBDlOJGc5utMttbxYvctchiwVcOWbzkOWYCoFRq
	kA2LKzXY3VHihKo36sHaEiCzjp6WU3jPfU5Du11VOGGDEXPebrpFKLckjI4wlq6o
	xufvZ6hgwH50UXWe4HzgFN4fJcjIxgeX4sEZcTyMT3i/+E7W5dpznmAWP5NDuLLY
	onXcaJnUyQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 483wcjhwna-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 08:14:33 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 56P8EWo0005863;
	Fri, 25 Jul 2025 08:14:32 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 483wcjhwn8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 08:14:32 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56P7OTkG024951;
	Fri, 25 Jul 2025 08:14:31 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 480npu0tvq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 08:14:31 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56P8EUgd66912598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 08:14:31 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC76158058;
	Fri, 25 Jul 2025 08:14:30 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 54BBE58057;
	Fri, 25 Jul 2025 08:14:30 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 25 Jul 2025 08:14:30 +0000 (GMT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Fri, 25 Jul 2025 10:14:30 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dengler@linux.ibm.com, Eric Biggers <ebiggers@kernel.org>,
        linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
        herbert@gondor.apana.org.au, ifranzki@linux.ibm.com, agk@redhat.com,
        snitzer@kernel.org, gmazyland@gmail.com
Subject: Re: [PATCH v5 0/2] dm-integrity: Implement asynch digest support
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <5fc734af-a2c1-b7bb-85fb-cba6b8722c13@redhat.com>
References: <20250722133832.319226-1-freude@linux.ibm.com>
 <5fc734af-a2c1-b7bb-85fb-cba6b8722c13@redhat.com>
Message-ID: <56aa9892c7825a443f8a6153e17b4c46@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: v3YRfBAWf1ygaFIyphzEKDfEX1jBz7k8
X-Authority-Analysis: v=2.4 cv=OdWYDgTY c=1 sm=1 tr=0 ts=68833ce9 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=Oh2cFVv5AAAA:8 a=eJ9TAuoJC6q5qPzUUKsA:9
 a=CjuIK1q_8ugA:10 a=7KeoIwV6GZqOttXkcoxL:22
X-Proofpoint-ORIG-GUID: HtBIhEUobUHp6v5tVawX6IuFwsfOBAhv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDA2OCBTYWx0ZWRfX7I1wScNo0zhF
 d6zTFl9WilKm1MN7/RICiSd/zmiMYv8vBmgx8usuzqYJ1TRtQyTdXEO54Uul0pimxcgkY7QmCCX
 7UfWEBIEIi8gxF2cAbPwhk7rL1oFjOoDOTFM6SsPv8HiyWhjAj0MWvp390qYiwF7Pu6v25uI7UY
 JrteC5voa8MrNKWFyFQxuQdvaFOIEV9mQBVjig+y3PqZ1X6vNuVD2283iZGdrEcab6hftlpATOm
 67h8Dz1nQcX0luSiJZcO2pfLnqYZWbhR9X1IJG65UDOxkFqTLg9bS6+uJhOfSI1MOwtRlfAz+dw
 jKJs5OsSGX0EQeXBr/a4TXqV9DjdGf5BwoxcML3NcQaggrdEn2QqXWKocUnz4+e79Vvqd92x66D
 WgsfbA1wr4/aJ35uS82erqpw2cTPDAluorlm9FT+fgjUpwHhfHiWGYfLWf3thqtrg7ZdRS0q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_02,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 adultscore=0 impostorscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 spamscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507250068

On 2025-07-24 16:40, Mikulas Patocka wrote:
> On Tue, 22 Jul 2025, Harald Freudenberger wrote:
> 
>> Support for ahashes in dm-integrity.
>> 
>> Changelog:
>> 
>> v1: First implementation. Tested with crc32, sha256, hmac-sha256 and
>>     the s390 specific implementations for hmac-sha256 and protected
>>     key phmac-sha256. Also ran with some instrumented code (in the 
>> digest
>>     implementation) to verify that in fact now the code runs 
>> asynchronous.
>> v2: Support shash and ahash. Based on Mikulas' idea about implementing
>>     ahash support similar to dm-verity this version now adds support
>>     for ahash but does not replace the shash support. For more details
>>     see the text of the patch header.
>> v3: The line to store the digestsize into the new internal variable
>>     did not make it into the patch set which was sent out. So now
>>     this important code piece is also there. Also rebuilded, sparse
>>     checked and tested to make sure the patches are ok.
>> v4: Thanks to Mikulas a total new implementation of the ahash support
>>     for the dm-integrity layer :-)
>> v5: Slight rework around the allocation and comparing of ahash and
>>     shash algorithm.
>>     V5 has been tested with the new introduced ahash phmac which is a
>>     protected key ("hardware key") version of a hmac for s390. As of 
>> now
>>     phmac is only available in Herbert Xu's cryptodev-2.6 kernel tree
>>     but will be merged into mainline with the next merge window for
>>     the 6.17 development kernel.
>> 
>> Mikulas Patocka (2):
>>   dm-integrity: use internal variable for digestsize
>>   dm-integrity: introduce ahash support for the internal hash
>> 
>>  drivers/md/dm-integrity.c | 370 
>> +++++++++++++++++++++++++++-----------
>>  1 file changed, 265 insertions(+), 105 deletions(-)
>> 
>> 
>> base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
>> --
>> 2.43.0
>> 
> 
> Hi
> 
> Eric Biggers recently removed ahash support from dm-verity - see this
> commit:
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/device-mapper/linux-dm/+/f43309c6743257244f11f14d31c297ee6a410ded
> 
> Should I revert Eric's patch? - would you need dm-verity with 
> asynchronous
> hashes on zseries too?
> 
> Is this patch series needed for performance (does it perform better 
> than
> the in-cpu instructions)? Or is it need because of better security (the
> keys are hidden in the hardware)?
> 
> Mikulas

I've seen this. Well as of now we don't need dm-verity. However, I'll 
check
our plans and let you know within the next days.

Thanks
Harald Freudenberger
with
