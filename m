Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF7F81727
	for <dm-devel@lists.linux.dev>; Thu, 16 Jan 2025 07:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737012836; cv=none; b=rCAE5j5nNYLbT7WYYjZoWz7ym/DNQenGaZRSv2dvqrxvxj7yyGBGgu/U/RdR5tV4pbXwySXlB5+q7glDNIMsx5OI9OKeXTr/rUwCri2wJWX2k6J3sBfBWygBWnwb6MbLvEAKrEOX6fielFyMi/yRU7YYe9G2qxrk4v7SCrlNJEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737012836; c=relaxed/simple;
	bh=bzrrpsxfHfrjCCjiy/FGN+pxPj+Gw2SnYPnHv/C9k6s=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=WpNolG5GZnl+gr+GK5PPdaZL3ArAu+Cr0VPqOeZcymjANvtxNMKqMCwRuszFOS5wvpugT6WFHDvfzwIqHc5pKor7XpB6D4+yIGp56yEIoA3vatjJvRhDoiGKkMkHub8Sh8etxQQ6Ht8XgZD9gFe9Kf/v1mwQJgI12nQaGsQGCts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=C7Ojdzok; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="C7Ojdzok"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FNwRDf028564;
	Thu, 16 Jan 2025 07:33:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=FoLfyMxHKeQ4ucdVLXaxezyPfzdLipGidPcWREoEVWM=; b=C7OjdzokR1Df
	1QYKtsaKYJAU83LDyBlSLmIzkeO4ifEijUfqip3C0k3/C2iC6ef9J7tIPEhitvQ0
	SJuWyEy5lckxXBV5coMvUjmpJmsCUdDRaN9JZ+WNbdnEE4MwPFAZAqQlpWGdm4Cj
	a1oL7wtDK6zFgNtmJiWFKDdlJqT3eKOTT8j/YmbhgICknoFKNyVm5HZdj3OXljVR
	ZRz1BfKYfqittJY8dpKd0tY6AV0nnjnIukfa2vxSKqwglFfgdW0Ex/gkEJojmjcs
	uW7x5g1HeWMkiqp2rbSvJcn5noX4tEsNrOtD+Yngx8YR7dZwXG1+J8vxyQsO4N+h
	4kPo6XuGBw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446q5hskbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 07:33:49 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50G60BJm007519;
	Thu, 16 Jan 2025 07:33:48 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443yncn4d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 07:33:48 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50G7XlAL29098526
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 07:33:47 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28671583B7;
	Thu, 16 Jan 2025 07:33:47 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BEBBE58217;
	Thu, 16 Jan 2025 07:33:46 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jan 2025 07:33:46 +0000 (GMT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 16 Jan 2025 08:33:46 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>, mpatocka@redhat.com
Cc: agk@redhat.com, snitzer@kernel.org, ifranzki@linux.ibm.com,
        linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
        herbert@gondor.apana.org.au, dengler@linux.ibm.com
Subject: Re: [PATCH v1 1/1] dm-integrity: Implement asynch digest support
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20250115173736.GA3712753@google.com>
References: <20250115164657.84650-1-freude@linux.ibm.com>
 <20250115164657.84650-2-freude@linux.ibm.com>
 <20250115173736.GA3712753@google.com>
Message-ID: <85ea487d37ec320ec5707bd249352b02@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xIpjaGKIPT20ATyOc57Lx2xlZoly80hd
X-Proofpoint-GUID: xIpjaGKIPT20ATyOc57Lx2xlZoly80hd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_03,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=447 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501160053

On 2025-01-15 18:37, Eric Biggers wrote:
> On Wed, Jan 15, 2025 at 05:46:57PM +0100, Harald Freudenberger wrote:
>> Use the async digest in-kernel crypto API instead of the
>> synchronous digest API. This has the advantage of being able
>> to use synchronous as well as asynchronous digest implementations
>> as the in-kernel API has an automatic wrapping mechanism
>> to provide all synchronous digests via the asynch API.
>> 
>> Tested with crc32, sha256, hmac-sha256 and the s390 specific
>> implementations for hmac-sha256 and protected key phmac-sha256.
>> 
>> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> 
> As Mikulas mentioned, this reduces performance for everyone else, which 
> is not
> great.  It also makes the code more complicated.
> 
> I also see that you aren't actually using the algorithm in an async 
> manner, but
> rather waiting for it synchronously each time.  Thus the ability to 
> operate
> asynchronously provides no benefit in this case, and this change is 
> purely about
> allowing a particular driver to be used, presumably the s390 phmac one 
> from your
> recent patchset.  Since s390 phmac seems to be new code, and 
> furthermore it is
> CPU-based and thus uses virtual addresses (which makes the use of 
> scatterlists
> entirely pointless), wouldn't it be easier to just make it implement 
> shash
> instead of ahash, moving any wait that may be necessary into the driver 
> itself?
> 
> - Eric

Thanks for this feedback. I'll give it a try with some performance 
measurements.
And I totally agree that a synchronous implementation of phmac whould 
have solved
this also. But maybe you can see that this is not an option according to
Herbert Xu's feedback about my first posts with implementing phmac as an 
shash.
The thing is that we have to derive a hardware based key (pkey) from the
given key material and that may be a sleeping call which a shash must 
not invoke.
So finally the phmac implementation is now an ahash digest 
implementation
as suggested by Herbert.

You are right, my patch is not really asynchronous. Or at least waiting 
for
completion at the end of each function. However, opposed to the ahash 
invocation
where there have been some update() calls this is now done in just one 
digest()
giving the backing algorithm a chance to hash all this in one step (well 
it still
needs to walk the scatterlist).

Is there a way to have dm-integrity accept both, a ahash() or a shash() 
digest?



