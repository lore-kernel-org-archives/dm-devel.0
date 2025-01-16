Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613EE1D61A4
	for <dm-devel@lists.linux.dev>; Thu, 16 Jan 2025 09:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737018046; cv=none; b=k8PDbY4+GvEjXU6byQoA5R3pP9idoyW5YT//nS4Na1gfYI74ww9AxFPGNW2O2FPfHZTvOQUoDN3l9VBW7escoBVYc8STn6ktvqY4YCItjqH/Zj15tROwHs6sUJFsUI+1i5Oz51jRbKt2vhWT1iut5Ax6hj0XxxfMSVglr85TI1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737018046; c=relaxed/simple;
	bh=NOd/IfPd/eGmsngP1ZK3IWv3M69unWFCqtjaxgtLdhk=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=AQMZ8gTM971XUTRnncZRRlCh1AcAmv0/oYF8/w+BNiUZMwECdnreQeAu3ajg7ymc4+m8EvNoLllPCXaOwnFWw3LoiAY1Buv2SY19DeuFAmLK4OasoWhDpee5XhNuR1JnfKDF7mE+l0Fp3/7TQ0wDoN5emme/EO6f+JHeSa2ko3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=I9oiUzGE; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I9oiUzGE"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50G3qvQK004600;
	Thu, 16 Jan 2025 09:00:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=yjmHMauwXWH4lLbznRJSvrfRMOj1BJNgthvUq6LEl5o=; b=I9oiUzGEm/BF
	SszBnABdn7uM7ZuqtHgrB3xw0eXwZOHUdM+GmnYwxb0MHMm79B0WnZEjwQVUr0hI
	gARn29Si2SHR9/ReH1PDhWmTzcPgNCrcrFgVJcW624AEoK1HiJlR99EgnJ2Xj/ty
	ehJdyT774hruLyJrJERB89IE69FnxVwV2UrrnFBRDNg43ooKP1Eag5xpocAteicp
	PM3r/4EiURD4dmndwjraf7y7KeH4mMK6R9Pz9UU4IqsqYoLoo3uxnP1nE8pOFUbU
	X8qhEzdLfm9UulDp7GYnHNEktjPtZq+XSQ/fAJ4fzE8N4x1rKINo13lv4A3vhhT4
	MZ2d/Axo/A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446tkh97rk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:00:38 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50G8xWP1004526;
	Thu, 16 Jan 2025 09:00:37 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4442ysw41f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:00:37 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50G90bdP32506516
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 09:00:37 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 20C0758051;
	Thu, 16 Jan 2025 09:00:37 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1D805805E;
	Thu, 16 Jan 2025 09:00:36 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jan 2025 09:00:36 +0000 (GMT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 16 Jan 2025 10:00:36 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: mpatocka@redhat.com, agk@redhat.com, snitzer@kernel.org,
        ifranzki@linux.ibm.com, linux-s390@vger.kernel.org,
        dm-devel@lists.linux.dev, herbert@gondor.apana.org.au,
        dengler@linux.ibm.com
Subject: Re: [PATCH v1 1/1] dm-integrity: Implement asynch digest support
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20250116080324.GA3910@sol.localdomain>
References: <20250115164657.84650-1-freude@linux.ibm.com>
 <20250115164657.84650-2-freude@linux.ibm.com>
 <20250115173736.GA3712753@google.com>
 <85ea487d37ec320ec5707bd249352b02@linux.ibm.com>
 <20250116080324.GA3910@sol.localdomain>
Message-ID: <94e11912f1e1413ac2d13c7e5dc0ed35@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Gvt1leNG7TYjGbPg66VO02hr2NnC8gcA
X-Proofpoint-ORIG-GUID: Gvt1leNG7TYjGbPg66VO02hr2NnC8gcA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_03,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 lowpriorityscore=0 mlxlogscore=708 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501160065

On 2025-01-16 09:03, Eric Biggers wrote:
> On Thu, Jan 16, 2025 at 08:33:46AM +0100, Harald Freudenberger wrote:
>> On 2025-01-15 18:37, Eric Biggers wrote:
>> > On Wed, Jan 15, 2025 at 05:46:57PM +0100, Harald Freudenberger wrote:
>> > > Use the async digest in-kernel crypto API instead of the
>> > > synchronous digest API. This has the advantage of being able
>> > > to use synchronous as well as asynchronous digest implementations
>> > > as the in-kernel API has an automatic wrapping mechanism
>> > > to provide all synchronous digests via the asynch API.
>> > >
>> > > Tested with crc32, sha256, hmac-sha256 and the s390 specific
>> > > implementations for hmac-sha256 and protected key phmac-sha256.
>> > >
>> > > Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
>> >
>> > As Mikulas mentioned, this reduces performance for everyone else, which
>> > is not
>> > great.  It also makes the code more complicated.
>> >
>> > I also see that you aren't actually using the algorithm in an async
>> > manner, but
>> > rather waiting for it synchronously each time.  Thus the ability to
>> > operate
>> > asynchronously provides no benefit in this case, and this change is
>> > purely about
>> > allowing a particular driver to be used, presumably the s390 phmac one
>> > from your
>> > recent patchset.  Since s390 phmac seems to be new code, and furthermore
>> > it is
>> > CPU-based and thus uses virtual addresses (which makes the use of
>> > scatterlists
>> > entirely pointless), wouldn't it be easier to just make it implement
>> > shash
>> > instead of ahash, moving any wait that may be necessary into the driver
>> > itself?
>> >
>> > - Eric
>> 
>> Thanks for this feedback. I'll give it a try with some performance
>> measurements.
>> And I totally agree that a synchronous implementation of phmac whould 
>> have
>> solved
>> this also. But maybe you can see that this is not an option according 
>> to
>> Herbert Xu's feedback about my first posts with implementing phmac as 
>> an
>> shash.
>> The thing is that we have to derive a hardware based key (pkey) from 
>> the
>> given key material and that may be a sleeping call which a shash must 
>> not
>> invoke.
>> So finally the phmac implementation is now an ahash digest 
>> implementation
>> as suggested by Herbert.
>> 
>> You are right, my patch is not really asynchronous. Or at least 
>> waiting for
>> completion at the end of each function. However, opposed to the ahash
>> invocation
>> where there have been some update() calls this is now done in just one
>> digest()
>> giving the backing algorithm a chance to hash all this in one step 
>> (well it
>> still
>> needs to walk the scatterlist).
>> 
>> Is there a way to have dm-integrity accept both, a ahash() or a 
>> shash()
>> digest?
>> 
> 
> To properly support async algorithms, the users (e.g. dm-integrity and
> dm-verity) really would need to have separate code paths anyway.  The
> computation models are just too different.
> 
> But in this case, it seems you simply want it to be synchronous and use 
> virtual
> addresses.  The quirks of ahash, including its need for per-request 
> allocations
> and scatterlists, make it a poor match here.  The only thing you are 
> getting
> with it is, ironically, that it allows you to wait synchronously.  That 
> could be
> done with shash too if it was fixed to support algorithms that aren't 
> atomic.
> E.g. there could be a new CRYPTO_ALG_MAY_SLEEP flag that could be set 
> in struct
> shash_alg to indicate that the algorithm doesn't support atomic 
> context, and a
> flag could be passed to crypto_alloc_shash() to allow such an algorithm 
> to be
> selected (if the particular user never uses it in atomic context).
> 
> That would be faster and simpler than the proposed ahash based version.
> 
> - Eric

Eric your idea was whirling around in my head for at least 3 month now.
It would be great to have a way to offer an shash() implementation which
clearly states that it is not for use in atomic context. E.g. like as 
you
wrote with a new flag. I'll work out something in this direction and 
push
it onto the crypto mailing list :-)



