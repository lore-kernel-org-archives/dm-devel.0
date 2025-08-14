Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9032FCBF1
	for <dm-devel@lists.linux.dev>; Thu, 14 Aug 2025 12:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755173640; cv=none; b=n3ZXqWg+IqRK8efZa2y9s2Uche3tDdrAqC75nfi5a06nDD/+0j09+ceQoZtsoye/6ZEZmwypkS4h7S2ADZniwcEIYxKpJn3lKjWubCuL5ulhmqhijj+K27rVUV75cRNO+rqrUxG6gCB3CcL4gLk1a3fA7gby9/HGgRcjlgpW020=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755173640; c=relaxed/simple;
	bh=7OkosJayZNyd7W5DiR51RlYCLyhyPj7uX5/qhYsgGg0=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=NhqLYhmIfPrIsirDBD/AlxAzPZy/2OuNdgfaUIxaIPhwASob5QtOxBOikPlK9EUFlFTq/UjJhQAvSvyxawsatcVZm1Iw+dkO/+MV/MA+YUvYiEzJpML+OvoWuaEPFFjhYVIgGVXofKISGI2eie+cW2U2Vc3mTPyWcpPm11mKlxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lLqfi9oA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lLqfi9oA"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57EBucNZ016034;
	Thu, 14 Aug 2025 12:13:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=uGPSRYSjdDS4rqIxYoZOyNbJWOeOb1F0KQFrZb9kQXo=; b=lLqfi9oA1pNo
	vLvE/9j57+c45781NxsAw/o5YoN7J8b/274ztkw99/j6iUnTjjpMDrcD1HTilwBe
	oU622CXJRq/ixpVWq/LCpYFp28XPM2A6ICccEqP6zO3FpIUUSqoNAIe3PIk77EFC
	uaiN3oNS1umM4qa84FgsKezlPKr2B0TlKCnZmD4DtsjRYxVdfeWKMhdYFDNp1zLj
	a10Qb/kl+gImyrRLeYdHDKECxpB6bzS/0OLy4UHWhD0Jjz2mvtccIm0uMlvw9UKd
	FJurrUIkbIQPajJvnJGRCSorCrwcY/jqvQFDGtj0iN+KciXJFQYfawVl7vY4FTYd
	pqRJK8j0Wg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dvrp9p23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Aug 2025 12:13:51 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57ECCH0c024167;
	Thu, 14 Aug 2025 12:13:50 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dvrp9p20-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Aug 2025 12:13:50 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57EA8rJW025654;
	Thu, 14 Aug 2025 12:13:49 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 48ejvmkuay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Aug 2025 12:13:49 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57ECDlDT29754032
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 12:13:48 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D3F2A58055;
	Thu, 14 Aug 2025 12:13:47 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E70935804B;
	Thu, 14 Aug 2025 12:13:46 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 14 Aug 2025 12:13:46 +0000 (GMT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 14 Aug 2025 14:13:46 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
 <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com,
        linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
        ifranzki@linux.ibm.com, agk@redhat.com, snitzer@kernel.org,
        gmazyland@gmail.com
Subject: Re: [PATCH v5 0/2] dm-integrity: Implement asynch digest support
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <51dc2ccd-c06d-e719-9568-35a8d3a1010f@redhat.com>
References: <20250722133832.319226-1-freude@linux.ibm.com>
 <5fc734af-a2c1-b7bb-85fb-cba6b8722c13@redhat.com>
 <56aa9892c7825a443f8a6153e17b4c46@linux.ibm.com>
 <20250725173811.GA3642931@google.com>
 <dbe165f661d11a4bed8d7c806a9eeb5e@linux.ibm.com>
 <51dc2ccd-c06d-e719-9568-35a8d3a1010f@redhat.com>
Message-ID: <7e1362bfc8180f3cef4dd9f8c0f0ff02@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIxOSBTYWx0ZWRfX+LjTisUBqMRb
 lsv/YadauX8ijJowIazwiKtWeQmcGeEAqTRJtUiBM+WnGhaWB8+HLl/T62sQtTyy4NHNIrVb6ES
 khIsrt0dRhYS6anxql+aEC/oOObQeebDZIvu+PuosIhZpJB5uGCyoICvpKzFhZ8+mmdYkRAMyg7
 WHegN+YHfhhQxuFr24iU/EZsk1Z51mYjyqf9ZV1EA1PDN6N2emjK9mZKbByCZF3QSMLGVdMjaiY
 hoacAquB5ItWNMXthbzYwxDvZrje8Koe544YRR1qoN/aZJ9rFbTrmLTnQvFe76tyxMjBgf52G9d
 iD0hLw+F07MlPxO4PbGOEYShTy7/o2XlwvGQI2Hi01PJTf23wokISTIs2gPjyGNF6RcskDfHo/5
 xumT1HxO
X-Authority-Analysis: v=2.4 cv=GrpC+l1C c=1 sm=1 tr=0 ts=689dd2ff cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=BOI0VzB9OPX81e2ss2MA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: H75zPy16D_vN9hgFvGugu6CVMqkYys4Z
X-Proofpoint-ORIG-GUID: 32SrjY7U50dA91TesE9FlJ2dWz5j-UHI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 adultscore=0 spamscore=0 impostorscore=0 suspectscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508120219

On 2025-07-28 23:24, Mikulas Patocka wrote:
> On Mon, 28 Jul 2025, Harald Freudenberger wrote:
> 
>> > > > > Mikulas Patocka (2):
>> > > > >   dm-integrity: use internal variable for digestsize
>> > > > >   dm-integrity: introduce ahash support for the internal hash
>> > > > >
>> > > > >  drivers/md/dm-integrity.c | 370
>> > > > > +++++++++++++++++++++++++++-----------
>> > > > >  1 file changed, 265 insertions(+), 105 deletions(-)
> 
> Hi
> 
> I reviewed the code and unfortunatelly I found out that it is buggy (I
> didn't notice the bugs before, when I was working on it).
> 
> integrity_ahash_sector_checksum uses sg_set_buf and sg_set_buf needs
> directly mapped memory. It doesn't work with vmalloc memory and it 
> doesn't
> work with memory obtained from kmap.
> 
> The result buffer may be vmallocated memory (if we have
> CONFIG_VMAP_STACK).
> 
> I'd like to ask the maintainers of crypto-api - Herbert or David - what 
> if
> I pass vmalloc-allocated memory (or possibly stack memory) as "result" 
> to
> ahash_request_set_crypt(req, sg, result, nbytes);? Is it legal or not?
> 
> Mikulas

Hi Mikulas, what is the state of the dm-itegrity asynch digest support?
If you have a newer version or maybe if you need some more code 
coverage,
I do offer some worktime for this and a s390 machine...

Thanks for your work
Harald
