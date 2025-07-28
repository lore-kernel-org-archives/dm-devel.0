Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1B1221557
	for <dm-devel@lists.linux.dev>; Mon, 28 Jul 2025 10:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753697481; cv=none; b=Nko5qhxGIM67Ib5uOK3yQ+qhpiiYgmR74E9uRnjC0tW9A+LmX7xniE6v/1nBMBXbbsKanCsiQn+8jpBzXZ+dlZrPOM+5iRUDTU/UBeYxbLBNeNRmDrT+bCP9sUsY3Jrf+LJByG51s4H6DIDrpBS5rVaQe+zRz0QbblZ0DxJlANI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753697481; c=relaxed/simple;
	bh=2AHT2HrXCidfiMYyXCgWDganUiockFMnX41WbtEaC5A=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=D5Iklo9eSEpZQGxtR01V1Ta5xsTkX6P9pU1H1AvXjqXONMGCvSwHvk0J0W1MPbl2jRi3Rac6M/jdnOpnTB/LanrCIYh+rvxr3/bMFGjUmpamgGSB04l+/55jsw+Yq8qMkJfDjynl8wzKMs7PJSPDwjHjFVm080E3U1nBp9U6b48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DrbHBFNd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DrbHBFNd"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SAA33A017128;
	Mon, 28 Jul 2025 10:11:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=H1F2kzGZo9TRtbmeci8Fz7YLA9FgA/VxbaR20eVIzNg=; b=DrbHBFNdck76
	HRcjzEPBmtvfRAMNXoWfsxuYAEY64na5UK/jWLT0vvY5pXF/0d1p8m67CPJ+9xJ+
	XG51isuvEdwP554KbP6P6DeM10vzCI7YRLlaBBiWmMyo1KkvrwJOlniW378w/Zym
	l8ikc8pA5CZk9044wRyqigsbTgGnbHIJkTENLONEFM5mO0IYqjfq0CV8Vtk4wanq
	lzrhRmtONHymYkcgEJu2AWk2X6DfLemDZM4nElqQ+oNeLahvSDDb5HfWwlcdbFjS
	6Ikp6x5Rlvc4wa0ZlINy9LLazlIUdyPjXSlVGB89bnVJT/tMCscdk8q3c4Ss9UEr
	TAmBBLqlzA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qfqgbkp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jul 2025 10:11:08 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 56SAB7b1023636;
	Mon, 28 Jul 2025 10:11:07 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qfqgbkm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jul 2025 10:11:07 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56S69WCH015929;
	Mon, 28 Jul 2025 10:11:06 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 485aumd7af-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jul 2025 10:11:06 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56SAB5P230868170
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 10:11:05 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4AE8A5805A;
	Mon, 28 Jul 2025 10:11:05 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E3AC58054;
	Mon, 28 Jul 2025 10:11:04 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Jul 2025 10:11:04 +0000 (GMT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 28 Jul 2025 12:11:04 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, dengler@linux.ibm.com,
        linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
        herbert@gondor.apana.org.au, ifranzki@linux.ibm.com, agk@redhat.com,
        snitzer@kernel.org, gmazyland@gmail.com
Subject: Re: [PATCH v5 0/2] dm-integrity: Implement asynch digest support
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20250725173811.GA3642931@google.com>
References: <20250722133832.319226-1-freude@linux.ibm.com>
 <5fc734af-a2c1-b7bb-85fb-cba6b8722c13@redhat.com>
 <56aa9892c7825a443f8a6153e17b4c46@linux.ibm.com>
 <20250725173811.GA3642931@google.com>
Message-ID: <dbe165f661d11a4bed8d7c806a9eeb5e@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI4MDA3MiBTYWx0ZWRfXwqu73ZBGZUae
 DK9P0ZHGW9paO8KkpgZuQEUR9EQoMzrZHrwau372Db2xBceMS2OFSVxehL5YRZtEvh9vEmNAR5D
 KsVWRapLOboSdH+P4BoK33AQ3lkYTRqxF8TyDbWgxvwlLenXVAsTtdOGidbEYvnBUu3F3KEjYFV
 jRPvuaVU/zynVGVffDuzg5gy1yLVX2OBBROZsm5XlkAMdCiasOyGEY3fJEs5B3DxxN/fRFt2UvU
 Nh2raPXbJLDIRJtpMQRwr/UkD5Xr0nBO/bwNL2Hmg2hsskqYg9DRVJm7q2MmHhNPiQlu6A5Tgaq
 ssG7StPaOKqD8ikxiL6GXQUxdSDW/hzw3nTeML/PtvjkQwYjYWlAP819uQ0QMNa099AIs4j3EVG
 zpf8Dy5SRlYnuhsyo50q9C3n2ub+JaH7mlHw7jpwquQR8Usow3QfE5M7wnQvucwtNqLvuKJL
X-Authority-Analysis: v=2.4 cv=Je28rVKV c=1 sm=1 tr=0 ts=68874cbc cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=Oh2cFVv5AAAA:8 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=dOe7xV1rp7CYrx8qEOIA:9 a=CjuIK1q_8ugA:10
 a=7KeoIwV6GZqOttXkcoxL:22
X-Proofpoint-GUID: vdzAylm_eHkhCexEmjXY4_VXgCRBMkq0
X-Proofpoint-ORIG-GUID: 0J_ccrVgstyRVBDm6p183kwP9zFbtnc1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-28_03,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=965 clxscore=1015 lowpriorityscore=0 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 mlxscore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507280072

On 2025-07-25 19:38, Eric Biggers wrote:
> On Fri, Jul 25, 2025 at 10:14:30AM +0200, Harald Freudenberger wrote:
>> On 2025-07-24 16:40, Mikulas Patocka wrote:
>> > On Tue, 22 Jul 2025, Harald Freudenberger wrote:
>> >
>> > > Support for ahashes in dm-integrity.
>> > >
>> > > Changelog:
>> > >
>> > > v1: First implementation. Tested with crc32, sha256, hmac-sha256 and
>> > >     the s390 specific implementations for hmac-sha256 and protected
>> > >     key phmac-sha256. Also ran with some instrumented code (in the
>> > > digest
>> > >     implementation) to verify that in fact now the code runs
>> > > asynchronous.
>> > > v2: Support shash and ahash. Based on Mikulas' idea about implementing
>> > >     ahash support similar to dm-verity this version now adds support
>> > >     for ahash but does not replace the shash support. For more details
>> > >     see the text of the patch header.
>> > > v3: The line to store the digestsize into the new internal variable
>> > >     did not make it into the patch set which was sent out. So now
>> > >     this important code piece is also there. Also rebuilded, sparse
>> > >     checked and tested to make sure the patches are ok.
>> > > v4: Thanks to Mikulas a total new implementation of the ahash support
>> > >     for the dm-integrity layer :-)
>> > > v5: Slight rework around the allocation and comparing of ahash and
>> > >     shash algorithm.
>> > >     V5 has been tested with the new introduced ahash phmac which is a
>> > >     protected key ("hardware key") version of a hmac for s390. As of
>> > > now
>> > >     phmac is only available in Herbert Xu's cryptodev-2.6 kernel tree
>> > >     but will be merged into mainline with the next merge window for
>> > >     the 6.17 development kernel.
>> > >
>> > > Mikulas Patocka (2):
>> > >   dm-integrity: use internal variable for digestsize
>> > >   dm-integrity: introduce ahash support for the internal hash
>> > >
>> > >  drivers/md/dm-integrity.c | 370
>> > > +++++++++++++++++++++++++++-----------
>> > >  1 file changed, 265 insertions(+), 105 deletions(-)
>> > >
>> > >
>> > > base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
>> > > --
>> > > 2.43.0
>> > >
>> >
>> > Hi
>> >
>> > Eric Biggers recently removed ahash support from dm-verity - see this
>> > commit:
>> > https://kernel.googlesource.com/pub/scm/linux/kernel/git/device-mapper/linux-dm/+/f43309c6743257244f11f14d31c297ee6a410ded
>> >
>> > Should I revert Eric's patch? - would you need dm-verity with
>> > asynchronous
>> > hashes on zseries too?
>> >
>> > Is this patch series needed for performance (does it perform better than
>> > the in-cpu instructions)? Or is it need because of better security (the
>> > keys are hidden in the hardware)?
>> >
>> > Mikulas
>> 
>> I've seen this. Well as of now we don't need dm-verity. However, I'll 
>> check
>> our plans and let you know within the next days.
>> 
>> Thanks
> 
> Isn't your use case the "s390 specific protected key hash phmac"
> (https://lore.kernel.org/linux-crypto/20250617134440.48000-1-freude@linux.ibm.com/)?
> dm-verity uses an unkeyed hash, so that isn't applicable there.
> 

Yes, I've also found this out. For our purpose it is enough to have
dm-integrity with phmac support - dm-verity is fine with the 
(synchronous)
s390 sha implementations and so no need for asynchronous support.

> BTW, did you consider a lib/crypto/ API for phmac?  I suspect it could
> be much simpler than the asynchronous hash based version.

This is an option for the future. However, as of now I did not 
investigate
in how to exactly implement this as a lib. Maybe a work item for the 
next
months...

> 
> - Eric

Thanks for your feedback and hints
Harald Freudenberger
