Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF7728FD
	for <dm-devel@lists.linux.dev>; Fri, 20 Jun 2025 14:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750429989; cv=none; b=reSxQ2F1fz/bTCCDgQExDc43yE4LMOMwHblfi8I/TOr3tlGnbFSOZXCi6r70KKfwzQCxCYu7kjLHnEEMMBUhJEIQ8z4qdvOpacX5k4xY2ufttnEGVcPSpMJj0djhhZTea92JYo9Eb0zQOFak7zDOfKMHSme7enPSHI1ixfyLYss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750429989; c=relaxed/simple;
	bh=kmGqoUhWtE4psQxZhHhKzF4AV1+Px0QT8+rN+wkF0jU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IxwPMW8ki1Ox9oSSdlGLGej3gIO10gjkJg978n3xLHeMcVGsC9JDWjpgDomkfP2hXWAEUwQzCbnY4cNFBHbwFfPAMhhyBSA9lvCp53VG9honpGFFnEZmiOgybMR9zjfQUOtxtEjNknjX1hOIJtkrrAR9vRekm7KrQJ5WO0gzxUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=C7ebA585; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="C7ebA585"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55KDNgTl003396;
	Fri, 20 Jun 2025 14:32:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=rvAiQ9
	5xnJ1I30rM2xFXRFFPpMO35rqYY6Wygaq2dqI=; b=C7ebA585K9qLsVjj/VkXV7
	WD9iNpGTZKalMvPBub93FLlnHNaynVNXpPKj73fzAE3dGeq91WicRsUAyT2bYcfs
	gpYkC6kbefaIESD3BR2YXrlc8nf3YEnKKOm6zjjnKUEkpNo6b39EoT5L7dG1tzs/
	2xgoF9sYygnI5PaGO9f5rKaSC1KknU1YqVxVKjJLf6Q1d6RpFCafzzxqtUkyFm/I
	nnTXSQP/hWTtOyMtOi6iVJuFel0HqEI4GQsRWKEg7GIv1SH9TBRvvOxzK10iqsrv
	156Us1soirf/wMD7XmgKgg4iizFwXXge+AvoWExbfUYlsNqfOBHbwQReRMB4Ji5w
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47cy4ju90k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Jun 2025 14:32:58 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55KE551t000725;
	Fri, 20 Jun 2025 14:32:57 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 479mdpkjfm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Jun 2025 14:32:57 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55KEWu3627001502
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 14:32:56 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3846858054;
	Fri, 20 Jun 2025 14:32:56 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4CFDD5803F;
	Fri, 20 Jun 2025 14:32:51 +0000 (GMT)
Received: from [9.61.191.218] (unknown [9.61.191.218])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Jun 2025 14:32:50 +0000 (GMT)
Message-ID: <e561da76-1437-46b0-b844-42dec9e4bc6b@linux.ibm.com>
Date: Fri, 20 Jun 2025 20:02:49 +0530
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] md/raid10: set chunk_sectors limit
To: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
        axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com
References: <20250618083737.4084373-1-john.g.garry@oracle.com>
 <20250618083737.4084373-4-john.g.garry@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250618083737.4084373-4-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5oXYYRMtYemrORCzmrFfAQyzxAUlkc_E
X-Authority-Analysis: v=2.4 cv=a7ww9VSF c=1 sm=1 tr=0 ts=6855711a cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=yPCof4ZbAAAA:8 a=VnNF1IyMAAAA:8 a=wbLohENRK3cqXJ1mymsA:9 a=QEXdDO2ut3YA:10
 a=6pWzAbgKvXYA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDEwMiBTYWx0ZWRfX//h0v0COeG/s G2WdliAELFrPw+nj7eKaChf5V3dZaDjeTnRQoZlhRqHetMLjg0G+Ikcf75uZcM/yPIUw2mI7h4d p/4TmUmtNBLpUg0MVPV4VqMYxs5oJ+vZaKTxYD9qjizSDymO8nMhiEQwo7G5ektG/9/57TZZ8JC
 tUNJTxkqqcCaX0s1wkLIjADZhPYh3MV8D1O0UogRFmeH1QFlZaMl4mWUCIUem3qx91YK8zdhcKx xNsiSCv/etshTGbl9fTX7O5vskAEpdv84dNqGxzvE2bA4a1BbBUdocxibP6ibUQ8qKaiNLCKk/P FGBjHO1BcvY6P7/Xj9bg2mxEHw+aBmdc+QMBwa/r0HhiX1/X7VLh/9KvVgYakkQfOlUcWoT/A5p
 i0a3fKHt0967q5Wz8gghBfsB3hksJ3JJxipguqk5WMIc9NY9q6faSYDFeC5JeJcyw/c2DDA7
X-Proofpoint-ORIG-GUID: 5oXYYRMtYemrORCzmrFfAQyzxAUlkc_E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-20_05,2025-06-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 phishscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506200102



On 6/18/25 2:07 PM, John Garry wrote:
> Same as done for raid0, set chunk_sectors limit to appropriately set the
> atomic write size limit.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Looks good to me:
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>

