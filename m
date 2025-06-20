Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253AC28FD
	for <dm-devel@lists.linux.dev>; Fri, 20 Jun 2025 14:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750430045; cv=none; b=hvV0WqGdmh8feKeZEeEPaU0CLpdX28mOvoQW0vrXbBJ2QOMmQ/b2UqvaACIJE0/qmTwwLu2XOAXCJjjVfq6jZcPpSZxQOVWjKlij6IpBwJn1z8I4eD8gQxm99rcH2Z0MU7yFypYYGa/wdibvgU4LjUsHUxU4U5PCUyERjtszEZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750430045; c=relaxed/simple;
	bh=lzjskJuu7ksH1CFy3LasEcflxgPRL8gOIIZ6qJVcPoQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r3IwaJ1bG8D+rq1h2GfkzNvXz+ClywarncuJVCrj7KBmwvITNI2sZdFRhPeRWPkBL8KqWKs82/s81EMNdhs4ODl5KsmyvnlWdE++Gs72eggTkhUgx+SQiGS4uqXf6j/ds1vD91ikzjvxhaAUAOIHohZL3Z2RfR1wNo0n/sIT9BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DeAhNqRY; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DeAhNqRY"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55K6iL2C002720;
	Fri, 20 Jun 2025 14:33:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=vfYteA
	MXlJGzKlkEORfRB/OXSRRP+Xi2l+/4pMid+Qw=; b=DeAhNqRYVMJTPTfWVP+p1V
	uuhyKynIzKPEPYvpa4yifolSeT9nMApH5RcoRavIY3eUSx8waMZrh0KThf3Qd3Vd
	7byhPZL5qKZciX3bF2A9xqTZeDDqju10a33/gg2sX/EFRNdInJMqC/wWqzG3Byb8
	hHZgUynuBvIj4irt/LBFU4aSD6QuW3iJZoh8Hrj9gXzOrMtSJAgO+SkDPaHtdHoh
	BwvW3q8yVhHnU43y0gQK4zjRDzFNhElNOGX4txkix2vvQ3KNqY88g8vxamKxrNAS
	E73k4bs3SYFWPNKKnLvxjhxLxe3TgbRrQAqlwJt8Qphpl/yi/bhWYg5tSJK2EDbQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47beet9uh4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Jun 2025 14:33:58 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55KBROXr014275;
	Fri, 20 Jun 2025 14:33:57 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 479p42u7qq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Jun 2025 14:33:57 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55KEXu8d55771596
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 14:33:56 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9E9AB58055;
	Fri, 20 Jun 2025 14:33:56 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A50975804E;
	Fri, 20 Jun 2025 14:33:51 +0000 (GMT)
Received: from [9.61.191.218] (unknown [9.61.191.218])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Jun 2025 14:33:51 +0000 (GMT)
Message-ID: <ef5aceb9-a5ec-489c-88e3-f674d59299ad@linux.ibm.com>
Date: Fri, 20 Jun 2025 20:03:50 +0530
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] block: use chunk_sectors when evaluating stacked
 atomic write limits
To: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
        axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com
References: <20250618083737.4084373-1-john.g.garry@oracle.com>
 <20250618083737.4084373-6-john.g.garry@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250618083737.4084373-6-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XcNidTvOBNptHj57jYIgusGfoSy_ae7g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDA5OCBTYWx0ZWRfXwUA8Hpzlr1c4 4r4qpxnTQqI6C2HqvVrcBkxl2O8VW4+Htre7pSm5yXjlUxRm5Re671h++vl6Cz1VZ+eAHinNlm1 Q3xaao9GGxmtkNZuyB3+nd3FE3c0r+e7GMFKO4ksRna0s1Y3hZIitVWCgjwN3CJJNZa7uPW1Qf9
 uCag4T1mLFVWVxo1xs3OqdLBTP5ur2jlIG1ug6zVtSndKLJdHD/tU2GftGbOCXtMgP22xxuOUQ7 Wc33OIsA4plkJgHfxBdEy0VE1RpWOALjPgiNfpilvYmqHFwcja8jz+QPUS0O5pdPye7soNqA0Hp 0JfucHqVqiy4cn2/QwTzpZosPzUdWltR6EqY8f7UcwoHnzIrMcSWSBq63Jjd3JGFWRve0bnJQ9V
 nq8fr/T+IhqUbsCh/ARjeMxDs37M3qTNx9s2xGd8NHPn6FoSVPJnVw57EX3sPhvDijmyOw2a
X-Authority-Analysis: v=2.4 cv=PrSTbxM3 c=1 sm=1 tr=0 ts=68557156 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=fRhigxJsmYGPnd04RnMA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: XcNidTvOBNptHj57jYIgusGfoSy_ae7g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-20_05,2025-06-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 bulkscore=0 priorityscore=1501 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506200098



On 6/18/25 2:07 PM, John Garry wrote:
> The atomic write unit max value is limited by any stacked device stripe
> size.
> 
> It is required that the atomic write unit is a power-of-2 factor of the
> stripe size.
> 
> Currently we use io_min limit to hold the stripe size, and check for a
> io_min <= SECTOR_SIZE when deciding if we have a striped stacked device.
> 
> Nilay reports that this causes a problem when the physical block size is
> greater than SECTOR_SIZE [0].
> 
> Furthermore, io_min may be mutated when stacking devices, and this makes
> it a poor candidate to hold the stripe size. Such an example (of when
> io_min may change) would be when the io_min is less than the physical
> block size.
> 
> Use chunk_sectors to hold the stripe size, which is more appropriate.
> 
> [0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Looks good to me:
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
